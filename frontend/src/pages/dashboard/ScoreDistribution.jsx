import { useEffect, useState } from "react";

export default function ScoreDistribution() {
  const [data, setData] = useState([]);
  const [schools, setSchools] = useState([]);
  const [majors, setMajors] = useState([]);
  const [years, setYears] = useState([]);
  const [filter, setFilter] = useState({
    truong: "",
    nganh: "",
    nam: ""
  });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Gọi API backend để lấy dữ liệu điểm
    fetch("/api/diem-chuan")
      .then(res => res.json())
      .then(res => {
        setData(res);
        setSchools([...new Set(res.map(d => d.truong))]);
        setMajors([...new Set(res.map(d => d.nganh))]);
        setYears([...new Set(res.map(d => d.nam))].sort((a, b) => b - a));
        setFilter(f => ({ ...f, nam: res.length ? res[0].nam : new Date().getFullYear() }));
      })
      .catch(() => setData([]))
      .finally(() => setLoading(false));
  }, []);

  const handleChange = e => setFilter({ ...filter, [e.target.name]: e.target.value });

  const filtered = data.filter(d =>
    (!filter.truong || d.truong === filter.truong) &&
    (!filter.nganh || d.nganh === filter.nganh) &&
    (!filter.nam || d.nam === Number(filter.nam))
  );

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Xem phổ điểm</h1>
      <div className="card p-5 flex flex-wrap gap-4">
        <select name="truong" className="input" value={filter.truong} onChange={handleChange}>
          <option value="">-- Chọn trường --</option>
          {schools.map(s => <option key={s}>{s}</option>)}
        </select>
        <select name="nganh" className="input" value={filter.nganh} onChange={handleChange}>
          <option value="">-- Chọn ngành --</option>
          {majors.map(m => <option key={m}>{m}</option>)}
        </select>
        <select name="nam" className="input" value={filter.nam} onChange={handleChange}>
          {years.map(y => <option key={y}>{y}</option>)}
        </select>
      </div>
      <div className="card p-5">
        <h2 className="font-semibold mb-2">Kết quả phổ điểm</h2>
        {loading ? (
          <div className="text-center py-8 text-gray-500">Đang tải dữ liệu...</div>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr>
                <th className="px-3 py-2">Trường</th>
                <th className="px-3 py-2">Ngành</th>
                <th className="px-3 py-2">Năm</th>
                <th className="px-3 py-2">Điểm chuẩn</th>
                <th className="px-3 py-2">Chỉ tiêu</th>
                <th className="px-3 py-2">Phương thức</th>
                <th className="px-3 py-2">Tổ hợp</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((d, i) => (
                <tr key={i} className="border-t">
                  <td className="px-3 py-2">{d.truong}</td>
                  <td className="px-3 py-2">{d.nganh}</td>
                  <td className="px-3 py-2">{d.nam}</td>
                  <td className="px-3 py-2">{d.diemChuan}</td>
                  <td className="px-3 py-2">{d.chiTieu}</td>
                  <td className="px-3 py-2">{d.phuongThuc}</td>
                  <td className="px-3 py-2">{d.toHop}</td>
                </tr>
              ))}
              {filtered.length === 0 && (
                <tr>
                  <td colSpan={7} className="px-3 py-6 text-center text-gray-500">
                    Không có dữ liệu phù hợp.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

// import { useMemo } from "react";
// import { useData } from "../../context/DataContext.jsx";

// export default function Trends() {
//   const { programs } = useData();
//   const topMajors = useMemo(() => {
//     const map = new Map();
//     programs.forEach(p => map.set(p.major, (map.get(p.major) || 0) + 1));
//     return [...map.entries()].sort((a,b)=>b[1]-a[1]).slice(0,6);
//   }, [programs]);
//   const maxVal = Math.max(...topMajors.map(m=>m[1]), 1);
//   return (
//     <div>
//       <h1 className="text-2xl font-bold mb-2">Xu hướng ngành học</h1>
//       <p className="text-gray-600 mb-6 text-sm">Top ngành xuất hiện nhiều trong dữ liệu (mẫu).</p>
//       <div className="space-y-3">
//         {topMajors.map(([name, count]) => (
//           <div key={name}>
//             <div className="flex justify-between text-sm mb-1">
//               <span className="font-medium">{name}</span>
//               <span className="text-gray-500">{count}</span>
//             </div>
//             <div className="h-3 rounded-full bg-gray-100 overflow-hidden">
//               <div className="h-full bg-primary-500" style={{width: `${(count/maxVal)*100}%`}} />
//             </div>
//           </div>
//         ))}
//       </div>
//     </div>
//   );
// }
