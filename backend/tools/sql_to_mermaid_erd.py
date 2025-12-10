#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SQL DDL (CREATE TABLE/ALTER TABLE) -> Mermaid ER diagram (erDiagram)
- Hỗ trợ phổ biến: MySQL/PostgreSQL style
- Trích: bảng, cột, PK, FK (kể cả ALTER TABLE ... ADD CONSTRAINT/FOREIGN KEY)
- Xuất: erDiagram cho draw.io (Insert -> Advanced -> Mermaid) hoặc mermaid-cli

Cách dùng:
  python backend/tools/sql_to_mermaid_erd.py path\to\schema.sql -o backend/erd_all.mmd [--infer]
  --infer: tự suy diễn FK theo quy ước tên cột (ví dụ cột idnguoidung ở bảng khác nối tới PK idnguoidung của bảng nguoidung)
"""

import re
import argparse
from collections import defaultdict


def mquote(name: str) -> str:
    name = name.strip().strip("`\"[]")
    return f'"{name}"'


def split_definitions(body: str):
    # Tách các mục trong ngoặc CREATE TABLE (...) theo dấu phẩy nhưng không cắt khi bên trong () hoặc trong chuỗi
    items = []
    buf = []
    level = 0
    in_squote = False
    in_dquote = False
    in_btick = False
    i = 0
    while i < len(body):
        ch = body[i]
        if ch == "'" and not in_dquote and not in_btick:
            in_squote = not in_squote
            buf.append(ch)
        elif ch == '"' and not in_squote and not in_btick:
            in_dquote = not in_dquote
            buf.append(ch)
        elif ch == '`' and not in_squote and not in_dquote:
            in_btick = not in_btick
            buf.append(ch)
        elif ch == '(' and not in_squote and not in_dquote and not in_btick:
            level += 1
            buf.append(ch)
        elif ch == ')' and not in_squote and not in_dquote and not in_btick:
            if level > 0:
                level -= 1
            buf.append(ch)
        elif ch == ',' and level == 0 and not in_squote and not in_dquote and not in_btick:
            items.append(''.join(buf).strip())
            buf = []
        else:
            buf.append(ch)
        i += 1
    if buf:
        items.append(''.join(buf).strip())
    return [x for x in items if x]


col_type_re = re.compile(r'^\s*[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s+([A-Za-z]+(?:\s*\(\s*\d+(?:\s*,\s*\d+)?\s*\))?)', re.IGNORECASE)


def parse_create_table_blocks(sql: str):
    # Bắt các khối CREATE TABLE ... (...); (đoạn engine/options phía sau )
    pattern = re.compile(
        r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s*\((.*?)\)\s*(?:ENGINE|WITHOUT|TABLESPACE|;|$)[^;]*;',
        re.IGNORECASE | re.DOTALL
    )
    return pattern.findall(sql)


def parse_alter_table_fks(sql: str):
    # Hỗ trợ 2 dạng:
    # ALTER TABLE child ADD CONSTRAINT fk_name FOREIGN KEY (col) REFERENCES parent (id) ...
    # ALTER TABLE child ADD FOREIGN KEY (col) REFERENCES parent (id) ...
    alters = []

    p1 = re.compile(
        r'ALTER\s+TABLE\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s+ADD\s+CONSTRAINT\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s+FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s*\(([^)]+)\)',
        re.IGNORECASE | re.DOTALL
    )
    p2 = re.compile(
        r'ALTER\s+TABLE\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s+ADD\s+FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s*\(([^)]+)\)',
        re.IGNORECASE | re.DOTALL
    )

    for m in p1.finditer(sql):
        child, fkname, childcols, parent, parentcols = m.groups()
        child_cols = [c.strip().strip('`"[]') for c in childcols.split(',')]
        parent_cols = [c.strip().strip('`"[]') for c in parentcols.split(',')]
        alters.append((child.strip(), parent.strip(), list(zip(child_cols, parent_cols)), fkname.strip()))
    for m in p2.finditer(sql):
        child, childcols, parent, parentcols = m.groups()
        child_cols = [c.strip().strip('`"[]') for c in childcols.split(',')]
        parent_cols = [c.strip().strip('`"[]') for c in parentcols.split(',')]
        alters.append((child.strip(), parent.strip(), list(zip(child_cols, parent_cols)), None))
    return alters


def parse_sql(sql_text: str):
    tables = {}  # table -> dict(columns=[(name,type)], pks=set(), fks=[(child_col, parent_table, parent_col, fkname)])
    fks_extra = []  # from ALTER TABLE

    # 1) CREATE TABLE blocks
    for tbl, body in parse_create_table_blocks(sql_text):
        table = tbl.strip().strip('`"[]')
        cols = []
        pks = set()
        fks = []

        items = split_definitions(body)
        for item in items:
            up = item.upper()
            # PRIMARY KEY (col1, col2)
            if up.startswith('PRIMARY KEY'):
                m = re.search(r'\(([^)]+)\)', item, flags=re.IGNORECASE | re.DOTALL)
                if m:
                    pkcols = [c.strip().strip('`"[]') for c in m.group(1).split(',')]
                    pks.update(pkcols)
                continue
            # FOREIGN KEY (col) REFERENCES parent(col)
            if up.startswith('FOREIGN KEY') or ('FOREIGN KEY' in up and 'REFERENCES' in up):
                m1 = re.search(r'FOREIGN\s+KEY\s*\(([^)]+)\)\s+REFERENCES\s+[`"\[]?([A-Za-z0-9_]+)[`"\]]?\s*\(([^)]+)\)', item, flags=re.IGNORECASE | re.DOTALL)
                if m1:
                    childcols = [c.strip().strip('`"[]') for c in m1.group(1).split(',')]
                    parent = m1.group(2).strip().strip('`"[]')
                    parentcols = [c.strip().strip('`"[]') for c in m1.group(3).split(',')]
                    for ch, pa in zip(childcols, parentcols):
                        fks.append((ch, parent, pa, None))
                continue
            # Column definition
            m = col_type_re.match(item)
            if m:
                cname = m.group(1).strip()
                ctype = m.group(2).strip()
                is_pk_inline = 'PRIMARY KEY' in item.upper()
                if is_pk_inline:
                    pks.add(cname)
                cols.append((cname, ctype))
            # else: other constraints (UNIQUE, KEY, CHECK, etc.) -> skip

        tables[table] = {'columns': cols, 'pks': pks, 'fks': fks}

    # 2) ALTER TABLE ... ADD (CONSTRAINT) FOREIGN KEY ...
    for child, parent, pairs, fkname in parse_alter_table_fks(sql_text):
        fks_extra.append((child, parent, pairs, fkname))

    # Merge extra FKs into table dict
    for child, parent, pairs, fkname in fks_extra:
        if child not in tables:
            tables[child] = {'columns': [], 'pks': set(), 'fks': []}
        for ch, pa in pairs:
            tables[child]['fks'].append((ch, parent, pa, fkname))

    return tables


def infer_fks(tables: dict) -> None:
    """Suy diễn quan hệ FK dựa trên quy ước tên cột:
    - Nếu bảng P có PK duy nhất tên pk_name khác 'id', và bảng C có cột trùng tên pk_name -> suy diễn C.pk_name tham chiếu P.pk_name
    - Bỏ qua nếu đã có FK rõ ràng hoặc nếu pk_name = 'id' (tránh nối bừa giữa nhiều bảng có id)
    """
    # Map pk_name -> list of parent tables sở hữu pk đó
    pk_to_parents = defaultdict(list)
    for tname, t in tables.items():
        if len(t['pks']) == 1:
            pk_name = next(iter(t['pks']))
            if pk_name.lower() != 'id':  # tránh gây nhiễu
                pk_to_parents[pk_name].append(tname)

    # Tập hợp FK đã có để tránh nhân đôi
    existing_pairs = set()
    for child, t in tables.items():
        for (ch_col, parent, pa_col, _fkname) in t['fks']:
            existing_pairs.add((child, ch_col, parent, pa_col))

    # Duyệt từng bảng con và các cột, nếu trùng tên pk của bảng khác -> thêm FK suy diễn
    for child, t in tables.items():
        child_cols = [c for c, _ in t['columns']]
        for c in child_cols:
            parents = pk_to_parents.get(c)
            if not parents:
                continue
            for parent in parents:
                if parent == child:
                    continue
                if (child, c, parent, c) in existing_pairs:
                    continue
                # Thêm FK suy diễn
                t['fks'].append((c, parent, c, 'inferred'))
                existing_pairs.add((child, c, parent, c))


def generate_mermaid(tables: dict) -> str:
    lines = []
    lines.append("erDiagram")
    # Entities
    for tname, t in tables.items():
        lines.append(f"  {mquote(tname)} {{")
        pkset = set(t['pks'])
        for cname, ctype in t['columns']:
            mark = " PK" if cname in pkset else ""
            dtype = ctype.replace(" ", "")
            lines.append(f"    {dtype} {cname}{mark}")
        lines.append("  }")
        lines.append("")

    # Relationships (FK -> 1:N)
    rels = set()
    for child, t in tables.items():
        for (ch_col, parent, pa_col, fkname) in t['fks']:
            k = (parent, child)
            label = fkname or f"{child}.{ch_col}->{parent}.{pa_col}"
            if k not in rels:
                lines.append(f"  {mquote(parent)} ||--o{{ {mquote(child)} : \"{label}\"")
                rels.add(k)
    return "\n".join(lines)


essential_fk_warning = """
Lưu ý: Nếu file .sql không định nghĩa FOREIGN KEY rõ ràng (FK), sơ đồ sẽ không có 'nối dây' giữa các bảng.
Bạn có thể thêm cờ --infer để suy diễn kết nối dựa trên quy ước tên cột (ví dụ: idnguoidung, idkythi, ...).
"""


def main():
    ap = argparse.ArgumentParser(description="Convert SQL DDL to Mermaid ER diagram")
    ap.add_argument("sql_file", help="Path to .sql file containing CREATE TABLE/ALTER TABLE DDL")
    ap.add_argument("-o", "--output", default="backend/erd_all.mmd", help="Output Mermaid file (default: backend/erd_all.mmd)")
    ap.add_argument("--infer", action="store_true", help="Infer FKs by matching child columns to parent PK names (excluding generic 'id')")
    args = ap.parse_args()

    with open(args.sql_file, "r", encoding="utf-8", errors="ignore") as f:
        sql = f.read()

    tables = parse_sql(sql)

    if args.infer:
        infer_fks(tables)

    mermaid = generate_mermaid(tables)

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(mermaid)

    print(f"Generated Mermaid ERD -> {args.output}")
    print(essential_fk_warning)
    print("Tip: Open diagrams.net (draw.io) -> Insert -> Advanced -> Mermaid and paste the file content.")


if __name__ == "__main__":
    main()
