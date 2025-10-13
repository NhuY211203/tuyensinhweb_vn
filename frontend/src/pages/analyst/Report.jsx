import { useState } from "react";

export default function Reports() {
  const [opt, setOpt] = useState({ dinhDang: "PDF", nam: new Date().getFullYear(), khuVuc: "Tất cả", noiDung: { phoDiem: true, xuHuong: true, phuongThuc: false }});
  const onCheck = (k) => setOpt(prev => ({ ...prev, noiDung: { ...prev.noiDung, [k]: !prev.noiDung[k] }}));

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Tạo báo cáo tuyển sinh</h1>

      <div className="card p-5 space-y-4">
        <div className="grid md:grid-cols-4 gap-4">
          <select className="input" value={opt.nam} onChange={e=>setOpt({...opt, nam: e.target.value})}>
            {Array.from({ length: 6 }, (_, i) => new Date().getFullYear() - i).map(y => <option key={y}>{y}</option>)}
          </select>
          <select className="input" value={opt.khuVuc} onChange={e=>setOpt({...opt, khuVuc: e.target.value})}>
            <option>Tất cả</option><option>Miền Bắc</option><option>Miền Trung</option><option>Miền Nam</option>
          </select>
          <select className="input" value={opt.dinhDang} onChange={e=>setOpt({...opt, dinhDang: e.target.value})}>
            <option>PDF</option><option>XLSX</option>
          </select>
          <input className="input" placeholder="Tên báo cáo (tùy chọn)" />
        </div>

        <div className="grid md:grid-cols-3 gap-3">
          <label className="flex items-center gap-2"><input type="checkbox" checked={opt.noiDung.phoDiem} onChange={()=>onCheck("phoDiem")} /> Phổ điểm</label>
          <label className="flex items-center gap-2"><input type="checkbox" checked={opt.noiDung.xuHuong} onChange={()=>onCheck("xuHuong")} /> Xu hướng theo năm</label>
          <label className="flex items-center gap-2"><input type="checkbox" checked={opt.noiDung.phuongThuc} onChange={()=>onCheck("phuongThuc")} /> Phương thức xét tuyển</label>
        </div>

        <div className="flex gap-3 justify-end">
          <button className="btn-outline">Xem thử</button>
          <button className="btn-primary">Xuất báo cáo</button>
        </div>
      </div>
    </div>
  );
}