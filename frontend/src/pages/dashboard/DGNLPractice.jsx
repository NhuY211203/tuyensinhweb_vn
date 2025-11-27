import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

export default function DGNLPractice() {
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  const [exams, setExams] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const fetchExams = async () => {
      setLoading(true);
      setError("");
      try {
        const res = await fetch("/api/kythi-dgnl/exams");
        const data = await res.json();
        if (!res.ok || !data.success) {
          throw new Error(data.message || "Không thể tải danh sách kỳ thi");
        }
        setExams(data.data || []);
      } catch (err) {
        setError(err.message || "Có lỗi xảy ra khi tải dữ liệu");
      } finally {
        setLoading(false);
      }
    };
    fetchExams();
  }, []);

  return (
    <div className="space-y-4">
      <h1 className="text-xl font-semibold">Thi thử đánh giá năng lực</h1>
      <p className="text-sm text-gray-600">
        Danh sách các kỳ thi ĐGNL hiện có. Sau này có thể chọn đề và làm bài trực tuyến.
      </p>

      {loading && <p>Đang tải dữ liệu...</p>}
      {error && <p className="text-red-600 text-sm">{error}</p>}

      {!loading && !error && (
        <div className="bg-white rounded-lg shadow-sm overflow-hidden">
          <table className="min-w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-2 text-left">Mã kỳ thi</th>
                <th className="px-4 py-2 text-left">Tên kỳ thi</th>
                <th className="px-4 py-2 text-left">Tổ chức</th>
                <th className="px-4 py-2 text-left">Số câu</th>
                <th className="px-4 py-2 text-left">Thời lượng (phút)</th>
              </tr>
            </thead>
            <tbody>
              {exams.map((e) => (
                <tr
                  key={e.idkythi}
                  className="border-t hover:bg-gray-50 cursor-pointer"
                  onClick={() => navigate(`/dashboard/dgnl-practice/${e.idkythi}`)}
                >
                  <td className="px-4 py-2">{e.makythi}</td>
                  <td className="px-4 py-2">{e.tenkythi}</td>
                  <td className="px-4 py-2">{e.to_chuc}</td>
                  <td className="px-4 py-2">{e.so_cau}</td>
                  <td className="px-4 py-2">{e.thoi_luong_phut}</td>
                </tr>
              ))}
              {exams.length === 0 && (
                <tr>
                  <td className="px-4 py-4 text-center text-gray-500" colSpan={5}>
                    Chưa có kỳ thi nào.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}


