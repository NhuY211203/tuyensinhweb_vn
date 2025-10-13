import { useState } from "react";

const empty = {
  truong: "",
  nganh: "",
  nam: new Date().getFullYear(),
  phuongThuc: "Thi THPT",
  toHop: "A00",
  diemChuan: "",
  chiTieu: "",
  khuVuc: "Miền Bắc",
  tinh: "",
  nguon: ""
};

export default function DataManagement() {
  const [form, setForm] = useState(empty);
  const [items, setItems] = useState([]);

  const onChange = (e) => setForm({ ...form, [e.target.name]: e.target.value });
  const add = (e) => {
    e.preventDefault();
    setItems((s) => [{ id: crypto.randomUUID(), ...form }, ...s]);
    setForm(empty);
  };

  const importCSV = (e) => {
    const file = e.target.files?.[0];
    if (!file) return;
    // Placeholder: đọc file, parse CSV (bạn có thể bổ sung sau)
    alert(`Đã chọn tệp: ${file.name}. Bạn có thể triển khai parse CSV sau.`);
  };

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Quản lý dữ liệu tuyển sinh</h1>

      <div className="card p-5 space-y-4">
        <div className="flex flex-wrap gap-3 items-center">
          <label className="btn-secondary cursor-pointer">
            <input type="file" accept=".csv" onChange={importCSV} className="hidden" />
            Nhập từ CSV
          </label>
          <button className="btn-outline">Tải mẫu CSV</button>
        </div>

        <form onSubmit={add} className="grid md:grid-cols-3 gap-4">
          <input name="truong" value={form.truong} onChange={onChange} className="input" placeholder="Trường đại học" />
          <input name="nganh" value={form.nganh} onChange={onChange} className="input" placeholder="Ngành học" />
          <input name="nam" type="number" value={form.nam} onChange={onChange} className="input" placeholder="Năm" />

          <select name="phuongThuc" value={form.phuongThuc} onChange={onChange} className="input">
            <option>Thi THPT</option>
            <option>Học bạ</option>
            <option>ĐGNL</option>
            <option>ĐGTD</option>
            <option>Chứng chỉ quốc tế</option>
            <option>Tuyển thẳng/Ưu tiên</option>
          </select>
          <input name="toHop" value={form.toHop} onChange={onChange} className="input" placeholder="Tổ hợp (A00, D01,...)" />
          <input name="diemChuan" value={form.diemChuan} onChange={onChange} className="input" placeholder="Điểm chuẩn" />

          <input name="chiTieu" value={form.chiTieu} onChange={onChange} className="input" placeholder="Chỉ tiêu" />
          <select name="khuVuc" value={form.khuVuc} onChange={onChange} className="input">
            <option>Miền Bắc</option><option>Miền Trung</option><option>Miền Nam</option>
          </select>
          <input name="tinh" value={form.tinh} onChange={onChange} className="input" placeholder="Tỉnh/TP" />

          <input name="nguon" value={form.nguon} onChange={onChange} className="md:col-span-3 input" placeholder="Nguồn (URL)" />
          <div className="md:col-span-3 flex justify-end">
            <button className="btn-primary">Lưu bản ghi</button>
          </div>
        </form>
      </div>

      <div className="card p-5">
        <div className="flex items-center justify-between mb-3">
          <h2 className="font-semibold">Bảng dữ liệu</h2>
          <div className="text-sm text-gray-500">Tổng: {items.length}</div>
        </div>
        <div className="border rounded-lg overflow-hidden">
          <div className="max-h-[60vh] overflow-auto">
            <table className="w-full text-sm">
              <thead className="bg-gray-50 sticky top-0">
                <tr>
                  <th className="px-3 py-2 text-left">Trường</th>
                  <th className="px-3 py-2 text-left">Ngành</th>
                  <th className="px-3 py-2">Năm</th>
                  <th className="px-3 py-2">PT</th>
                  <th className="px-3 py-2">Tổ hợp</th>
                  <th className="px-3 py-2">Điểm</th>
                  <th className="px-3 py-2">Chỉ tiêu</th>
                  <th className="px-3 py-2">KV</th>
                  <th className="px-3 py-2">Tỉnh</th>
                  <th className="px-3 py-2">Nguồn</th>
                </tr>
              </thead>
              <tbody>
                {items.map((r) => (
                  <tr key={r.id} className="border-t">
                    <td className="px-3 py-2">{r.truong}</td>
                    <td className="px-3 py-2">{r.nganh}</td>
                    <td className="px-3 py-2 text-center">{r.nam}</td>
                    <td className="px-3 py-2 text-center">{r.phuongThuc}</td>
                    <td className="px-3 py-2 text-center">{r.toHop}</td>
                    <td className="px-3 py-2 text-center">{r.diemChuan}</td>
                    <td className="px-3 py-2 text-center">{r.chiTieu}</td>
                    <td className="px-3 py-2 text-center">{r.khuVuc}</td>
                    <td className="px-3 py-2">{r.tinh}</td>
                    <td className="px-3 py-2 truncate max-w-[220px]">
                      <a className="text-primary-600 underline" href={r.nguon} target="_blank" rel="noreferrer">{r.nguon}</a>
                    </td>
                  </tr>
                ))}
                {items.length === 0 && (
                  <tr>
                    <td colSpan={10} className="px-3 py-6 text-center text-gray-500">
                      Chưa có dữ liệu. Hãy thêm bản ghi hoặc nhập từ CSV.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}