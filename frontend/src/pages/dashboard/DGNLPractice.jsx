import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { 
  FileText, 
  Clock, 
  BookOpen, 
  Building2, 
  Hash,
  Loader2,
  AlertCircle,
  PlayCircle,
  Award
} from "lucide-react";

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
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50">
      {/* Hero Section */}
      <div className="bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 text-white rounded-2xl p-8 mb-8 shadow-xl">
        <div className="flex items-center gap-4 mb-4">
          <div className="p-4 bg-white/20 rounded-2xl backdrop-blur-sm">
            <FileText className="w-10 h-10" />
          </div>
          <div>
            <h1 className="text-4xl font-bold mb-2">Thi thử đánh giá năng lực</h1>
            <p className="text-lg text-white/90">
              Danh sách các bài thi thử ĐGNL hiện có. Chọn đề và làm bài trực tuyến để đánh giá năng lực của bạn.
            </p>
          </div>
        </div>
      </div>

      {/* Stats Cards */}
      {!loading && !error && exams.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
          <div className="bg-white rounded-xl p-6 shadow-lg border-l-4 border-blue-500">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Tổng số bài thi thử</p>
                <p className="text-3xl font-bold text-blue-600">{exams.length}</p>
              </div>
              <div className="p-3 bg-blue-100 rounded-lg">
                <FileText className="w-8 h-8 text-blue-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-6 shadow-lg border-l-4 border-purple-500">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Tổng số câu hỏi</p>
                <p className="text-3xl font-bold text-purple-600">
                  {exams.reduce((sum, e) => sum + (e.so_cau || 0), 0)}
                </p>
              </div>
              <div className="p-3 bg-purple-100 rounded-lg">
                <BookOpen className="w-8 h-8 text-purple-600" />
              </div>
            </div>
          </div>
          <div className="bg-white rounded-xl p-6 shadow-lg border-l-4 border-pink-500">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm text-gray-600 mb-1">Tổng thời lượng</p>
                <p className="text-3xl font-bold text-pink-600">
                  {exams.reduce((sum, e) => sum + (e.thoi_luong_phut || 0), 0)} phút
                </p>
              </div>
              <div className="p-3 bg-pink-100 rounded-lg">
                <Clock className="w-8 h-8 text-pink-600" />
              </div>
            </div>
          </div>
        </div>
      )}

      {/* Loading State */}
      {loading && (
        <div className="bg-white rounded-2xl p-12 shadow-lg text-center">
          <Loader2 className="w-12 h-12 animate-spin text-indigo-600 mx-auto mb-4" />
          <p className="text-lg text-gray-600">Đang tải danh sách bài thi thử...</p>
        </div>
      )}

      {/* Error State */}
      {error && (
        <div className="bg-white rounded-2xl p-8 shadow-lg border-2 border-red-200">
          <div className="flex items-center gap-4 text-red-600">
            <AlertCircle className="w-8 h-8 flex-shrink-0" />
            <div>
              <p className="font-semibold text-lg mb-1">Có lỗi xảy ra</p>
              <p className="text-sm">{error}</p>
            </div>
          </div>
        </div>
      )}

      {/* Exams Table/Cards */}
      {!loading && !error && (
        <div className="bg-white rounded-2xl shadow-xl overflow-hidden border border-gray-100">
          {/* Table Header */}
          <div className="bg-gradient-to-r from-indigo-600 to-purple-600 px-6 py-4">
            <h2 className="text-xl font-bold text-white flex items-center gap-2">
              <Award className="w-6 h-6" />
              Danh sách bài thi thử
            </h2>
          </div>

          {/* Desktop Table View */}
          <div className="hidden md:block overflow-x-auto">
            <table className="min-w-full">
              <thead className="bg-gradient-to-r from-indigo-50 to-purple-50">
                <tr>
                  <th className="px-6 py-4 text-left text-sm font-bold text-gray-700">
                    <div className="flex items-center gap-2">
                      <Hash className="w-4 h-4 text-indigo-600" />
                      Mã kỳ thi
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-gray-700">
                    <div className="flex items-center gap-2">
                      <FileText className="w-4 h-4 text-indigo-600" />
                      Tên kỳ thi
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-gray-700">
                    <div className="flex items-center gap-2">
                      <Building2 className="w-4 h-4 text-indigo-600" />
                      Tổ chức
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-gray-700">
                    <div className="flex items-center gap-2">
                      <BookOpen className="w-4 h-4 text-indigo-600" />
                      Số câu
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-sm font-bold text-gray-700">
                    <div className="flex items-center gap-2">
                      <Clock className="w-4 h-4 text-indigo-600" />
                      Thời lượng
                    </div>
                  </th>
                  <th className="px-6 py-4 text-center text-sm font-bold text-gray-700">
                    Thao tác
                  </th>
              </tr>
            </thead>
              <tbody className="divide-y divide-gray-100">
                {exams.map((e, index) => (
                <tr
                  key={e.idkythi}
                    className="hover:bg-gradient-to-r hover:from-indigo-50 hover:to-purple-50 transition-all duration-200 cursor-pointer group"
                  onClick={() => navigate(`/dashboard/dgnl-practice/${e.idkythi}`)}
                >
                    <td className="px-6 py-4">
                      <span className="font-bold text-indigo-600 text-base">{e.makythi}</span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="font-semibold text-gray-800 text-base">{e.tenkythi}</span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="text-gray-700 text-base">{e.to_chuc}</span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex items-center px-3 py-1 rounded-full bg-blue-100 text-blue-700 font-semibold text-base">
                        {e.so_cau} câu
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="inline-flex items-center px-3 py-1 rounded-full bg-purple-100 text-purple-700 font-semibold text-base">
                        <Clock className="w-4 h-4 mr-1" />
                        {e.thoi_luong_phut} phút
                      </span>
                    </td>
                    <td className="px-6 py-4 text-center">
                      <button
                        onClick={(event) => {
                          event.stopPropagation();
                          navigate(`/dashboard/dgnl-practice/${e.idkythi}`);
                        }}
                        className="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-lg hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 shadow-md hover:shadow-lg transform hover:scale-105 font-semibold"
                      >
                        <PlayCircle className="w-4 h-4" />
                        Bắt đầu
                      </button>
                    </td>
                </tr>
              ))}
              {exams.length === 0 && (
                <tr>
                    <td className="px-6 py-12 text-center text-gray-500" colSpan={6}>
                      <FileText className="w-16 h-16 mx-auto mb-4 text-gray-300" />
                      <p className="text-lg font-semibold">Chưa có bài thi thử nào</p>
                      <p className="text-sm mt-2">Vui lòng quay lại sau để xem các bài thi thử mới.</p>
                  </td>
                </tr>
              )}
            </tbody>
          </table>
          </div>

          {/* Mobile Card View */}
          <div className="md:hidden p-4 space-y-4">
            {exams.map((e) => (
              <div
                key={e.idkythi}
                onClick={() => navigate(`/dashboard/dgnl-practice/${e.idkythi}`)}
                className="bg-gradient-to-br from-indigo-50 to-purple-50 rounded-xl p-5 border-2 border-indigo-200 hover:border-indigo-400 hover:shadow-lg transition-all duration-200 cursor-pointer"
              >
                <div className="flex items-start justify-between mb-3">
                  <div className="flex-1">
                    <div className="flex items-center gap-2 mb-2">
                      <Hash className="w-5 h-5 text-indigo-600" />
                      <span className="font-bold text-indigo-600 text-lg">{e.makythi}</span>
                    </div>
                    <h3 className="font-bold text-gray-800 text-lg mb-2">{e.tenkythi}</h3>
                    <div className="flex items-center gap-2 text-gray-600 mb-3">
                      <Building2 className="w-4 h-4" />
                      <span>{e.to_chuc}</span>
                    </div>
                  </div>
                </div>
                <div className="flex flex-wrap gap-2 mb-4">
                  <span className="inline-flex items-center px-3 py-1.5 rounded-full bg-blue-100 text-blue-700 font-semibold text-sm">
                    <BookOpen className="w-4 h-4 mr-1" />
                    {e.so_cau} câu
                  </span>
                  <span className="inline-flex items-center px-3 py-1.5 rounded-full bg-purple-100 text-purple-700 font-semibold text-sm">
                    <Clock className="w-4 h-4 mr-1" />
                    {e.thoi_luong_phut} phút
                  </span>
                </div>
                <button
                  onClick={(event) => {
                    event.stopPropagation();
                    navigate(`/dashboard/dgnl-practice/${e.idkythi}`);
                  }}
                  className="w-full inline-flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-lg hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 shadow-md hover:shadow-lg font-semibold"
                >
                  <PlayCircle className="w-5 h-5" />
                  Bắt đầu thi
                </button>
              </div>
            ))}
            {exams.length === 0 && (
              <div className="text-center py-12">
                <FileText className="w-16 h-16 mx-auto mb-4 text-gray-300" />
                <p className="text-lg font-semibold text-gray-500">Chưa có bài thi thử nào</p>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}


