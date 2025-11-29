import { useState, useEffect } from "react";
import { useToast } from "../../components/Toast";

function Modal({ open, onClose, children }) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/30">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-4xl p-5 max-h-[90vh] overflow-y-auto">
        {children}
        <div className="mt-4 text-right">
          <button onClick={onClose} className="px-4 py-2 rounded-lg bg-gray-100 hover:bg-gray-200">
            Đóng
          </button>
        </div>
      </div>
    </div>
  );
}

export default function ConsultationSchedules() {
  const [schedules, setSchedules] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [consultants, setConsultants] = useState([]);
  const [detailOpen, setDetailOpen] = useState(false);
  const [currentSchedule, setCurrentSchedule] = useState(null);
  const [notesData, setNotesData] = useState(null);
  const [evidenceData, setEvidenceData] = useState(null);
  const [detailLoading, setDetailLoading] = useState(false);
  const [requestingUpdate, setRequestingUpdate] = useState({}); // Track which schedule is being requested
  
  // Load requested schedules from localStorage on mount
  const [requestedSchedules, setRequestedSchedules] = useState(() => {
    try {
      const saved = localStorage.getItem('requestedSchedules');
      if (saved) {
        const parsed = JSON.parse(saved);
        return new Set(parsed);
      }
    } catch (e) {
      console.error('Error loading requested schedules from localStorage:', e);
    }
    return new Set();
  });
  
  const toast = useToast();
  
  // Save requested schedules to localStorage whenever it changes
  useEffect(() => {
    try {
      localStorage.setItem('requestedSchedules', JSON.stringify(Array.from(requestedSchedules)));
    } catch (e) {
      console.error('Error saving requested schedules to localStorage:', e);
    }
  }, [requestedSchedules]);

  // Filters
  const [filters, setFilters] = useState({
    search: "",
    timeFilter: "all", // all, past, upcoming
    status: "", // 1=Trống, 2=Đã đặt, 3=Đã hủy, 4=Hoàn thành
    consultantId: "",
    dateFrom: "",
    dateTo: "",
  });

  const [pagination, setPagination] = useState({
    current_page: 1,
    last_page: 1,
    per_page: 20,
    total: 0,
  });

  useEffect(() => {
    fetchConsultants();
  }, []);

  useEffect(() => {
    fetchSchedules();
  }, [filters, pagination.current_page]);

  const fetchConsultants = async () => {
    try {
      // Lấy tất cả tư vấn viên (không phân trang)
      const response = await fetch("http://localhost:8000/api/staff/consultants?perPage=1000&page=1");
      const data = await response.json();
      if (data.success) {
        // API trả về data là array hoặc paginated data
        const consultantsList = Array.isArray(data.data) ? data.data : (data.data?.data || data.data || []);
        setConsultants(consultantsList);
      } else {
        console.error("Failed to load consultants:", data.message);
      }
    } catch (err) {
      console.error("Error loading consultants:", err);
    }
  };

  const fetchSchedules = async () => {
    try {
      setLoading(true);
      const params = new URLSearchParams({
        page: pagination.current_page,
        per_page: pagination.per_page,
      });

      if (filters.search) params.append("search", filters.search);
      if (filters.timeFilter !== "all") params.append("time_filter", filters.timeFilter);
      if (filters.status) params.append("status", filters.status);
      if (filters.consultantId) params.append("consultant_id", filters.consultantId);
      if (filters.dateFrom) params.append("date_from", filters.dateFrom);
      if (filters.dateTo) params.append("date_to", filters.dateTo);

      const response = await fetch(`http://localhost:8000/api/consultation-schedules/all?${params}`);
      const data = await response.json();

      if (data.success) {
        setSchedules(data.data || []);
        if (data.pagination) {
          setPagination(data.pagination);
        }
      } else {
        setError(data.message || "Không thể tải danh sách lịch tư vấn");
        toast.push({ type: "error", title: data.message || "Không thể tải danh sách lịch tư vấn" });
      }
    } catch (err) {
      console.error("Error loading schedules:", err);
      setError("Lỗi kết nối");
      toast.push({ type: "error", title: "Lỗi kết nối" });
    } finally {
      setLoading(false);
    }
  };

  const handleFilterChange = (key, value) => {
    setFilters((prev) => ({ ...prev, [key]: value }));
    setPagination((prev) => ({ ...prev, current_page: 1 }));
  };

  const handlePageChange = (page) => {
    setPagination((prev) => ({ ...prev, current_page: page }));
  };

  const getStatusText = (status) => {
    const statusMap = {
      1: "Trống",
      2: "Đã đặt",
      3: "Đã hủy",
      4: "Hoàn thành",
    };
    return statusMap[status] || "Không xác định";
  };

  const getStatusColor = (status) => {
    const colorMap = {
      1: "bg-gray-100 text-gray-800",
      2: "bg-blue-100 text-blue-800",
      3: "bg-red-100 text-red-800",
      4: "bg-green-100 text-green-800",
    };
    return colorMap[status] || "bg-gray-100 text-gray-800";
  };

  const getDuyetLichText = (duyetlich) => {
    const map = {
      1: "Chờ duyệt",
      2: "Đã duyệt",
      3: "Từ chối",
    };
    return map[duyetlich] || "Chưa duyệt";
  };

  const getDuyetLichColor = (duyetlich) => {
    const colorMap = {
      1: "bg-yellow-100 text-yellow-800",
      2: "bg-green-100 text-green-800",
      3: "bg-red-100 text-red-800",
    };
    return colorMap[duyetlich] || "bg-gray-100 text-gray-800";
  };

  const isPast = (date) => {
    if (!date) return false;
    const scheduleDate = new Date(date);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return scheduleDate < today;
  };

  const requestUpdateNotes = async (schedule) => {
    console.log('🔔 ===== REQUEST UPDATE NOTES CALLED =====');
    console.log('🔔 Schedule object:', schedule);
    
    // Lấy ID tư vấn viên từ nhiều nguồn có thể
    // Ưu tiên: idnguoidung của schedule (consultant tạo lịch) > nguoiDung.idnguoidung > các field khác
    const consultantId = schedule.idnguoidung ||  // ID của consultant tạo lịch
                         schedule.consultant_id ||
                         schedule.nguoiDung?.idnguoidung || 
                         schedule.nguoiDung?.id || 
                         schedule.consultantId;
    
    console.log('🔔 Request update notes - Schedule:', schedule);
    console.log('🔔 Schedule.idnguoidung:', schedule.idnguoidung);
    console.log('🔔 Schedule.consultant_id:', schedule.consultant_id);
    console.log('🔔 Schedule.nguoiDung:', schedule.nguoiDung);
    console.log('🔔 Consultant ID extracted:', consultantId);
    
    if (!consultantId) {
      console.error('❌ No consultant ID found in schedule:', schedule);
      toast.push({ type: "error", title: "Không tìm thấy thông tin tư vấn viên" });
      setRequestingUpdate(prev => ({ ...prev, [schedule.idlichtuvan]: false }));
      return;
    }
    
    console.log('🔔 Consultant ID is valid:', consultantId);
    const scheduleDate = schedule.ngayhen 
      ? new Date(schedule.ngayhen).toLocaleDateString("vi-VN")
      : "ngày chưa xác định";
    const scheduleTime = schedule.giobatdau && schedule.ketthuc
      ? `${schedule.giobatdau} - ${schedule.ketthuc}`
      : "";

    console.log('🔔 Setting requesting state to true');
    setRequestingUpdate(prev => ({ ...prev, [schedule.idlichtuvan]: true }));

    try {
      console.log('🔔 Starting notification send process...');
      
      // Lấy user ID từ nhiều nguồn
      let currentUserId = localStorage.getItem("userId");
      console.log('🔔 Current user ID from localStorage (userId):', currentUserId);
      
      if (!currentUserId) {
        const userStr = localStorage.getItem("user");
        console.log('🔔 User string from localStorage:', userStr);
        if (userStr) {
          try {
            const user = JSON.parse(userStr);
            currentUserId = user.idnguoidung || user.id || null;
            console.log('🔔 Current user ID from user object:', currentUserId);
          } catch (e) {
            console.error("Error parsing user object:", e);
          }
        }
      }
      
      const token = localStorage.getItem("token");
      console.log('🔔 Token exists:', !!token);
      
      const headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      
      // Thêm Authorization header nếu có token
      if (token) {
        headers["Authorization"] = `Bearer ${token}`;
        console.log('🔔 Token added to headers');
      } else {
        console.log('⚠️ No token found, but proceeding without token (backend may use user_id from body)');
      }
      
      const consultantIdInt = parseInt(consultantId);
      if (isNaN(consultantIdInt)) {
        console.error('❌ Invalid consultant ID:', consultantId);
        toast.push({ type: "error", title: "ID tư vấn viên không hợp lệ" });
        setRequestingUpdate(prev => ({ ...prev, [schedule.idlichtuvan]: false }));
        return;
      }
      
      const requestBody = {
        title: "Yêu cầu cập nhật ghi chú buổi tư vấn",
        body: `Bạn được yêu cầu cập nhật ghi chú và minh chứng cho buổi tư vấn vào ${scheduleDate}${scheduleTime ? ` (${scheduleTime})` : ""}. Vui lòng truy cập trang quản lý lịch tư vấn để cập nhật.`,
        recipients: {
          allUsers: false,
          roles: [],
          userIds: [consultantIdInt]
        }
      };
      
      // Thêm user_id vào body nếu có
      if (currentUserId) {
        requestBody.user_id = parseInt(currentUserId);
      }
      
      console.log('🔔 Sending notification request:', {
        url: "http://localhost:8000/api/notifications/send",
        method: "POST",
        headers: headers,
        body: requestBody
      });
      
      const response = await fetch("http://localhost:8000/api/notifications/send", {
        method: "POST",
        headers: headers,
        body: JSON.stringify(requestBody)
      });
      
      console.log('🔔 Notification response status:', response.status);
      console.log('🔔 Notification response headers:', Object.fromEntries(response.headers.entries()));
      
      // Kiểm tra status code trước khi parse JSON
      if (!response.ok) {
        const errorText = await response.text();
        console.error('❌ HTTP Error:', response.status, errorText);
        let errorData;
        try {
          errorData = JSON.parse(errorText);
        } catch (e) {
          errorData = { message: errorText };
        }
        toast.push({ 
          type: "error", 
          title: `Lỗi ${response.status}: ${errorData.message || "Không thể gửi thông báo"}`,
          message: errorData.errors ? JSON.stringify(errorData.errors) : undefined
        });
        setRequestingUpdate(prev => ({ ...prev, [schedule.idlichtuvan]: false }));
        return;
      }
      
      const data = await response.json();
      console.log('🔔 Notification response data:', data);

      if (data.success) {
        console.log('✅ Notification sent successfully to consultant:', consultantIdInt);
        console.log('✅ Notification ID:', data.data?.id);
        console.log('✅ Recipient count:', data.data?.recipientCount);
        if (!data.data?.id) {
          console.warn('⚠️ Warning: Notification created but no ID returned');
        }
        
        // Đánh dấu schedule này đã được yêu cầu cập nhật
        setRequestedSchedules(prev => new Set([...prev, schedule.idlichtuvan]));
        
        toast.push({ 
          type: "success", 
          title: `Đã gửi yêu cầu cập nhật ghi chú đến tư vấn viên (ID: ${consultantIdInt})` 
        });
      } else {
        console.error('❌ Failed to send notification:', data);
        console.error('❌ Error details:', data.errors || data.message);
        toast.push({ 
          type: "error", 
          title: data.message || "Không thể gửi thông báo",
          message: data.errors ? JSON.stringify(data.errors) : undefined
        });
      }
    } catch (err) {
      console.error("Error sending notification:", err);
      toast.push({ type: "error", title: "Lỗi kết nối khi gửi thông báo" });
    } finally {
      setRequestingUpdate(prev => ({ ...prev, [schedule.idlichtuvan]: false }));
    }
  };

  const openDetail = async (schedule) => {
    setCurrentSchedule(schedule);
    setNotesData(null);
    setEvidenceData(null);
    setDetailLoading(true);
    setDetailOpen(true);

    try {
      // Lấy cả ghi chú và minh chứng cùng lúc
      const [notesResponse, evidenceResponse] = await Promise.all([
        fetch(`http://localhost:8000/api/consultation-notes/${schedule.idlichtuvan}?view_mode=view`),
        fetch(`http://localhost:8000/api/consultation-notes/${schedule.idlichtuvan}/evidence`)
      ]);

      const notesResult = await notesResponse.json();
      const evidenceResult = await evidenceResponse.json();

      if (notesResult.success) {
        console.log('📋 Notes data received:', notesResult.data);
        console.log('📋 Has ghi_chu_nhap:', !!notesResult.data?.ghi_chu_nhap);
        console.log('📋 Has ghi_chu_chot:', !!notesResult.data?.ghi_chu_chot);
        if (notesResult.data?.ghi_chu_nhap) {
          console.log('📋 ghi_chu_nhap data:', {
            noi_dung: notesResult.data.ghi_chu_nhap.noi_dung,
            ket_luan_nganh: notesResult.data.ghi_chu_nhap.ket_luan_nganh,
            muc_quan_tam: notesResult.data.ghi_chu_nhap.muc_quan_tam,
            diem_du_kien: notesResult.data.ghi_chu_nhap.diem_du_kien,
            trang_thai: notesResult.data.ghi_chu_nhap.trang_thai,
            yeu_cau_bo_sung: notesResult.data.ghi_chu_nhap.yeu_cau_bo_sung,
            tom_tat: notesResult.data.ghi_chu_nhap.tom_tat,
            chia_se_voi_thisinh: notesResult.data.ghi_chu_nhap.chia_se_voi_thisinh,
          });
        }
        setNotesData(notesResult.data);
      } else {
        toast.push({ type: "error", title: notesResult.message || "Không thể tải ghi chú" });
      }

      if (evidenceResult.success) {
        setEvidenceData(evidenceResult.data || []);
      } else {
        toast.push({ type: "error", title: evidenceResult.message || "Không thể tải minh chứng" });
      }
    } catch (err) {
      console.error("Error loading detail:", err);
      toast.push({ type: "error", title: "Lỗi kết nối" });
    } finally {
      setDetailLoading(false);
    }
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold">Quản lý lịch tư vấn</h1>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-4 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
          {/* Search */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Tìm kiếm</label>
            <input
              type="text"
              value={filters.search}
              onChange={(e) => handleFilterChange("search", e.target.value)}
              placeholder="Tìm theo tên, email, tiêu đề..."
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Time Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Thời gian</label>
            <select
              value={filters.timeFilter}
              onChange={(e) => handleFilterChange("timeFilter", e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="all">Tất cả</option>
              <option value="past">Đã qua</option>
              <option value="upcoming">Sắp tới</option>
            </select>
          </div>

          {/* Status Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
            <select
              value={filters.status}
              onChange={(e) => handleFilterChange("status", e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Tất cả trạng thái</option>
              <option value="1">Trống</option>
              <option value="2">Đã đặt</option>
              <option value="3">Đã hủy</option>
              <option value="4">Hoàn thành</option>
            </select>
          </div>

          {/* Consultant Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Tư vấn viên</label>
            <select
              value={filters.consultantId}
              onChange={(e) => handleFilterChange("consultantId", e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">Tất cả tư vấn viên</option>
              {consultants.map((consultant) => (
                <option key={consultant.id || consultant.idnguoidung} value={consultant.id || consultant.idnguoidung}>
                  {consultant.name || consultant.hoten}
                </option>
              ))}
            </select>
          </div>

          {/* Date From */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Từ ngày</label>
            <input
              type="date"
              value={filters.dateFrom}
              onChange={(e) => handleFilterChange("dateFrom", e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Date To */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Đến ngày</label>
            <input
              type="date"
              value={filters.dateTo}
              onChange={(e) => handleFilterChange("dateTo", e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Clear Filters */}
          <div className="flex items-end">
            <button
              onClick={() => {
                setFilters({
                  search: "",
                  timeFilter: "all",
                  status: "",
                  consultantId: "",
                  dateFrom: "",
                  dateTo: "",
                });
                setPagination((prev) => ({ ...prev, current_page: 1 }));
              }}
              className="w-full px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
            >
              Xóa bộ lọc
            </button>
          </div>
        </div>
      </div>

      {/* Table */}
      {loading ? (
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8">
          <div className="animate-pulse space-y-4">
            {[1, 2, 3].map((i) => (
              <div key={i} className="flex space-x-4">
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
                <div className="h-4 bg-gray-200 rounded w-1/6"></div>
              </div>
            ))}
          </div>
        </div>
      ) : error ? (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          {error}
        </div>
      ) : schedules.length === 0 ? (
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-8 text-center text-gray-500">
          Không có lịch tư vấn nào
        </div>
      ) : (
        <>
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">ID</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Tiêu đề</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Ngày</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Thời gian</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Tư vấn viên</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Người đặt</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Trạng thái</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Duyệt lịch</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Phương thức</th>
                    <th className="px-4 py-3 text-left font-semibold text-gray-700">Thao tác</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {schedules.map((schedule) => {
                    const past = isPast(schedule.ngayhen);
                    return (
                      <tr
                        key={schedule.idlichtuvan}
                        className={`hover:bg-gray-50 ${past ? "opacity-75" : ""}`}
                      >
                        <td className="px-4 py-3">#{schedule.idlichtuvan}</td>
                        <td className="px-4 py-3">
                          <div className="max-w-xs truncate" title={schedule.tieude}>
                            {schedule.tieude || "-"}
                          </div>
                        </td>
                        <td className="px-4 py-3">
                          {schedule.ngayhen
                            ? new Date(schedule.ngayhen).toLocaleDateString("vi-VN")
                            : "-"}
                        </td>
                        <td className="px-4 py-3">
                          {schedule.giobatdau && schedule.ketthuc
                            ? `${schedule.giobatdau} - ${schedule.ketthuc}`
                            : "-"}
                        </td>
                        <td className="px-4 py-3">
                          {schedule.nguoiDung ? (
                            <div>
                              <div className="font-medium">{schedule.nguoiDung.hoten}</div>
                              <div className="text-xs text-gray-500">{schedule.nguoiDung.email}</div>
                            </div>
                          ) : (
                            "-"
                          )}
                        </td>
                        <td className="px-4 py-3">
                          {schedule.nguoiDat ? (
                            <div>
                              <div className="font-medium">{schedule.nguoiDat.hoten}</div>
                              <div className="text-xs text-gray-500">{schedule.nguoiDat.email}</div>
                            </div>
                          ) : (
                            "-"
                          )}
                        </td>
                        <td className="px-4 py-3">
                          <span
                            className={`px-2 py-1 rounded-full text-xs ${getStatusColor(
                              schedule.trangthai
                            )}`}
                          >
                            {getStatusText(schedule.trangthai)}
                          </span>
                        </td>
                        <td className="px-4 py-3">
                          {schedule.duyetlich ? (
                            <span
                              className={`px-2 py-1 rounded-full text-xs ${getDuyetLichColor(
                                schedule.duyetlich
                              )}`}
                            >
                              {getDuyetLichText(schedule.duyetlich)}
                            </span>
                          ) : (
                            "-"
                          )}
                        </td>
                        <td className="px-4 py-3">{schedule.molavande || "-"}</td>
                        <td className="px-4 py-3">
                          {past ? (
                            schedule.hasGhiChu || schedule.hasMinhChung ? (
                              <button
                                onClick={() => openDetail(schedule)}
                                className="inline-flex items-center justify-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 active:bg-blue-800 transition-all duration-200 shadow-sm hover:shadow"
                              >
                                Xem chi tiết
                              </button>
                            ) : requestedSchedules.has(schedule.idlichtuvan) ? (
                              <div className="inline-flex items-center gap-1.5 px-4 py-2 bg-amber-50 text-amber-700 text-sm font-medium rounded-md border border-amber-200 shadow-sm">
                                <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                <span>Chờ phản hồi</span>
                              </div>
                            ) : (
                              <button
                                onClick={() => requestUpdateNotes(schedule)}
                                disabled={requestingUpdate[schedule.idlichtuvan]}
                                className="inline-flex items-center justify-center gap-1.5 px-4 py-2 bg-orange-600 text-white text-sm font-medium rounded-md hover:bg-orange-700 active:bg-orange-800 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:bg-orange-600 shadow-sm hover:shadow"
                              >
                                {requestingUpdate[schedule.idlichtuvan] ? (
                                  <>
                                    <svg className="animate-spin h-4 w-4 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                      <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                      <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                    </svg>
                                    <span>Đang gửi...</span>
                                  </>
                                ) : (
                                  <>
                                    <svg className="w-4 h-4 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
                                    </svg>
                                    <span>Yêu cầu cập nhật</span>
                                  </>
                                )}
                              </button>
                            )
                          ) : (
                            <span className="text-sm text-gray-400">-</span>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>

          {/* Pagination */}
          {pagination.last_page > 1 && (
            <div className="mt-4 flex justify-center items-center gap-2">
              <button
                onClick={() => handlePageChange(pagination.current_page - 1)}
                disabled={pagination.current_page === 1}
                className="px-3 py-2 border border-gray-300 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
              >
                Trước
              </button>
              <span className="px-4 py-2 text-sm text-gray-700">
                Trang {pagination.current_page} / {pagination.last_page} (Tổng: {pagination.total})
              </span>
              <button
                onClick={() => handlePageChange(pagination.current_page + 1)}
                disabled={pagination.current_page === pagination.last_page}
                className="px-3 py-2 border border-gray-300 rounded-lg disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
              >
                Sau
              </button>
            </div>
          )}
        </>
      )}

      {/* Modal chi tiết */}
      <Modal
        open={detailOpen}
        onClose={() => {
          setDetailOpen(false);
          setCurrentSchedule(null);
          setNotesData(null);
          setEvidenceData(null);
        }}
      >
        {detailLoading ? (
          <div className="p-8 text-center">Đang tải...</div>
        ) : (
          <div className="space-y-6">
            <h2 className="text-xl font-bold">Chi tiết buổi tư vấn</h2>

            {/* Thông tin session */}
            {currentSchedule && (
              <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5 mb-4">
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <h3 className="text-lg font-semibold">
                      {currentSchedule.ngayhen
                        ? new Date(currentSchedule.ngayhen).toLocaleDateString('vi-VN', { 
                            weekday: 'long', 
                            year: 'numeric', 
                            month: 'long', 
                            day: 'numeric' 
                          })
                        : 'Chưa có ngày'} — {currentSchedule.nguoiDat?.hoten || 'Chưa có thí sinh'}
                    </h3>
                  </div>
                  <div className="flex gap-2 items-center">
                    {currentSchedule.tinhtrang && (
                      <span className={`px-3 py-1 rounded-full text-xs ${
                        currentSchedule.tinhtrang === 'Đã đặt lịch' ? 'bg-blue-100 text-blue-800' :
                        currentSchedule.tinhtrang === 'Chờ xử lý' ? 'bg-yellow-100 text-yellow-800' :
                        currentSchedule.tinhtrang === 'Đã kết thúc' ? 'bg-green-100 text-green-800' :
                        'bg-gray-100 text-gray-800'
                      }`}>
                        {currentSchedule.tinhtrang}
                      </span>
                    )}
                    {currentSchedule.duyetlich && (
                      <span className={`px-3 py-1 rounded-full text-xs ${getDuyetLichColor(currentSchedule.duyetlich)}`}>
                        {getDuyetLichText(currentSchedule.duyetlich)}
                      </span>
                    )}
                  </div>
                </div>
                <div className="flex flex-wrap gap-2 mb-3">
                  {currentSchedule.chudetuvan && (
                    <span className="px-2 py-1 bg-gray-100 rounded text-sm">
                      {currentSchedule.chudetuvan}
                    </span>
                  )}
                  {currentSchedule.molavande && (
                    <span className="px-2 py-1 bg-gray-100 rounded text-sm">
                      {currentSchedule.molavande}
                    </span>
                  )}
                  {currentSchedule.giobatdau && currentSchedule.ketthuc && (
                    <span className="px-2 py-1 bg-gray-100 rounded text-sm">
                      {currentSchedule.giobatdau} - {currentSchedule.ketthuc}
                    </span>
                  )}
                  {currentSchedule.danhdanhgiadem && (
                    <a
                      href={currentSchedule.danhdanhgiadem}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="px-2 py-1 bg-blue-50 text-blue-600 rounded text-sm hover:underline"
                    >
                      Phòng/Link
                    </a>
                  )}
                </div>
                {notesData?.session?.nhanxet && (
                  <div className="text-sm text-gray-600 bg-gray-50 p-2 rounded mb-2">
                    <strong>Tóm tắt:</strong> {notesData.session.nhanxet}
                  </div>
                )}
              </div>
            )}

            {/* Phần Ghi chú */}
            <div>
              <h3 className="text-lg font-semibold mb-3">Ghi chú</h3>
              {notesData ? (
                (() => {
                  // Ưu tiên hiển thị ghi chú chốt, nếu không có thì hiển thị nháp
                  const ghiChu = notesData.ghi_chu_chot || notesData.ghi_chu_nhap;
                  const isNhap = !notesData.ghi_chu_chot && notesData.ghi_chu_nhap;
                  const hasBoth = notesData.ghi_chu_chot && notesData.ghi_chu_nhap;
                  
                  if (!ghiChu) {
                    return <div className="text-center text-gray-500 py-4">Chưa có ghi chú</div>;
                  }
                  
                  return (
                    <div className="space-y-4">
                      {/* Hiển thị đầy đủ thông tin */}
                      <div>
                        <p className="text-sm font-medium text-gray-700 mb-1">Nội dung:</p>
                        <div className="bg-gray-50 p-3 rounded-lg">
                          <p className="text-sm whitespace-pre-wrap">{ghiChu.noi_dung || "-"}</p>
                        </div>
                      </div>
                      
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Kết luận ngành:</p>
                          <p className="text-sm">{ghiChu.ket_luan_nganh || "-"}</p>
                        </div>
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Mức quan tâm:</p>
                          <p className="text-sm">{ghiChu.muc_quan_tam || "-"}</p>
                        </div>
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Điểm dự kiến:</p>
                          <p className="text-sm">{ghiChu.diem_du_kien || "-"}</p>
                        </div>
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Trạng thái:</p>
                          <p className="text-sm">{ghiChu.trang_thai || (isNhap ? "NHAP" : "CHOT")}</p>
                        </div>
                      </div>
                      
                      {ghiChu.yeu_cau_bo_sung && (
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Yêu cầu bổ sung:</p>
                          <div className="bg-gray-50 p-3 rounded-lg">
                            <p className="text-sm whitespace-pre-wrap">{ghiChu.yeu_cau_bo_sung}</p>
                          </div>
                        </div>
                      )}
                      
                      {ghiChu.tom_tat && (
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">Tóm tắt hiển thị ở danh sách:</p>
                          <div className="bg-gray-50 p-3 rounded-lg">
                            <p className="text-sm whitespace-pre-wrap">{ghiChu.tom_tat}</p>
                          </div>
                        </div>
                      )}
                    </div>
                  );
                })()
              ) : (
                <div className="text-center text-gray-500 py-4">Chưa có ghi chú</div>
              )}
            </div>

            {/* Phần Minh chứng */}
            <div>
              <h3 className="text-lg font-semibold mb-3">
                Tệp đính kèm / Minh chứng
                <span className="ml-2 text-xs text-gray-500 font-normal">
                  ({evidenceData && Array.isArray(evidenceData) ? evidenceData.length : 0} {evidenceData && Array.isArray(evidenceData) && evidenceData.length === 1 ? 'mục' : 'mục'})
                </span>
              </h3>
              {evidenceData && Array.isArray(evidenceData) && evidenceData.length > 0 ? (
                <div className="space-y-3">
                  {evidenceData.map((file) => {
                    const isImage = (file.loai_file || file.loaiFile || '').toLowerCase() === 'hinh_anh' || 
                                   (file.ten_file || file.tenFile || '').match(/\.(jpg|jpeg|png|gif|bmp|webp|svg)$/i);
                    const fileUrl = file.duong_dan || file.duongDan || file.url;
                    
                    return (
                      <div key={file.id_file || file.id} className="border border-gray-200 rounded-lg p-4 bg-gray-50">
                        <div className="flex items-start justify-between mb-2">
                          <div className="flex-1">
                            <p className="text-sm font-medium text-gray-700">{file.ten_file || file.tenFile || "Không có tên"}</p>
                            <p className="text-xs text-gray-500 mt-1">
                              {file.loai_file || file.loaiFile || "-"}
                              {file.la_minh_chung && ' • Minh chứng'}
                            </p>
                            {(file.mo_ta || file.moTa) && (
                              <p className="text-xs text-gray-600 mt-1">{file.mo_ta || file.moTa}</p>
                            )}
                          </div>
                          {fileUrl && (
                            <a
                              href={fileUrl}
                              target="_blank"
                              rel="noopener noreferrer"
                              className="text-sm text-blue-600 hover:underline ml-2"
                            >
                              Xem file →
                            </a>
                          )}
                        </div>
                        {/* Hiển thị preview hình ảnh nếu là file hình ảnh */}
                        {isImage && fileUrl && (
                          <div className="mt-3">
                            <img
                              src={fileUrl}
                              alt={file.ten_file || file.tenFile || 'Preview'}
                              className="max-w-full h-auto max-h-64 rounded border border-gray-200"
                              onError={(e) => {
                                // Ẩn hình ảnh nếu không load được
                                e.target.style.display = 'none';
                              }}
                            />
                          </div>
                        )}
                      </div>
                    );
                  })}
                </div>
              ) : (
                <div className="text-center text-gray-500 py-4">Chưa có minh chứng</div>
              )}
            </div>
          </div>
        )}
      </Modal>
    </div>
  );
}

