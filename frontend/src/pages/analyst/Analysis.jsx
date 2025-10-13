import { useState } from "react";

export default function Analysis() {
  const [filters, setFilters] = useState({ nam: new Date().getFullYear(), khuVuc: "Tất cả", phuongThuc: "Tất cả", nganh: "" });
  const onChange = (e) => setFilters({ ...filters, [e.target.name]: e.target.value });

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Phân tích dữ liệu</h1>

      <div className="card p-5 grid md:grid-cols-4 gap-4">
        <input name="nganh" className="input" placeholder="Ngành (ví dụ: CNTT)" value={filters.nganh} onChange={onChange} />
        <select name="nam" className="input" value={filters.nam} onChange={onChange}>
          {Array.from({ length: 6 }, (_, i) => new Date().getFullYear() - i).map(y => <option key={y}>{y}</option>)}
        </select>
        <select name="khuVuc" className="input" value={filters.khuVuc} onChange={onChange}>
          <option>Tất cả</option><option>Miền Bắc</option><option>Miền Trung</option><option>Miền Nam</option>
        </select>
        <select name="phuongThuc" className="input" value={filters.phuongThuc} onChange={onChange}>
          <option>Tất cả</option><option>Thi THPT</option><option>Học bạ</option><option>ĐGNL</option><option>ĐGTD</option>
        </select>
      </div>

      <div className="grid lg:grid-cols-3 gap-6">
        <div className="card p-4">
          <div className="font-semibold mb-2">Phổ điểm</div>
          <div className="h-64 grid place-items-center text-gray-400">[Biểu đồ phổ điểm]</div>
        </div>
        <div className="card p-4">
          <div className="font-semibold mb-2">Xu hướng điểm theo năm</div>
          <div className="h-64 grid place-items-center text-gray-400">[Biểu đồ đường theo năm]</div>
        </div>
        <div className="card p-4">
          <div className="font-semibold mb-2">Phân bố theo phương thức</div>
          <div className="h-64 grid place-items-center text-gray-400">[Biểu đồ tròn phương thức]</div>
        </div>
      </div>
    </div>
  );
}