import { useState, useEffect } from 'react';
import { useToast } from '../../components/Toast';
import QuarterScheduleSelector from '../../components/QuarterScheduleSelector';
import api from '../../services/api';

export default function ConsultantSchedule() {
  const [schedules, setSchedules] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingSchedule, setEditingSchedule] = useState(null);
  // Tab lọc theo trạng thái duyệt lịch (1=Chờ duyệt, 2=Đã duyệt, 3=Từ chối) hoặc 'booked' (Đã đăng ký)
  const [approvalFilter, setApprovalFilter] = useState('1');
  // Bộ lọc theo thời gian: 'all', 'today', 'week', 'month', 'past', 'future', 'range'
  const [dateFilter, setDateFilter] = useState('all');
  const [startDate, setStartDate] = useState('');
  const [endDate, setEndDate] = useState('');
  const [formData, setFormData] = useState({
    date: '',
    start_time: '',
    end_time: '',
    meeting_link: '',
    meeting_platform: '',
    notes: ''
  });
  const [timeError, setTimeError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [showQuarterSelector, setShowQuarterSelector] = useState(false);
  const [showChangeRequestModal, setShowChangeRequestModal] = useState(false);
  const [selectedScheduleForChange, setSelectedScheduleForChange] = useState(null);
  const [changeRequestData, setChangeRequestData] = useState({
    ngaymoi: '',
    giomoi: '',
    lydo_doilich: ''
  });
  const [showViewChangeRequestModal, setShowViewChangeRequestModal] = useState(false);
  const [selectedScheduleForView, setSelectedScheduleForView] = useState(null);
  const [changeRequests, setChangeRequests] = useState([]);
  const [loadingChangeRequests, setLoadingChangeRequests] = useState(false);
  const [scheduleRegistrationStatus, setScheduleRegistrationStatus] = useState({
    isOpen: false,
    endDate: null,
    endDateFormatted: null
  });
  const [checkingStatus, setCheckingStatus] = useState(true);

  // Danh sách 4 ca học cố định
  const timeSlots = [
    { start: '07:00', end: '09:00', label: '07:00 - 09:00' },
    { start: '09:05', end: '11:05', label: '09:05 - 11:05' },
    { start: '13:05', end: '15:05', label: '13:05 - 15:05' },
    { start: '15:10', end: '17:10', label: '15:10 - 17:10' },
  ];

  const toast = useToast();

  // Get current user ID (you might need to adjust this based on your auth system)
  const currentUserId = localStorage.getItem('userId') || '5'; // Sử dụng user ID có sẵn

  const validateTime = (startTime, endTime) => {
    if (!startTime) return 'Vui lòng chọn giờ bắt đầu';
    if (!endTime) return 'Giờ kết thúc chưa được tính toán';
    
    const startHour = parseInt(startTime.split(':')[0]);
    const endHour = parseInt(endTime.split(':')[0]);
    
    if (startHour < 7 || startHour >= 19) {
      return 'Giờ bắt đầu phải từ 7:00 đến 18:30';
    }
    
    if (endHour < 7 || endHour >= 19) {
      return 'Giờ kết thúc phải từ 7:00 đến 18:30';
    }
    
    if (startTime >= endTime) {
      return 'Giờ kết thúc phải sau giờ bắt đầu';
    }
    
    return '';
  };

  // Tạo danh sách giờ từ 7:00 đến 18:59
  const generateTimeOptions = () => {
    const options = [];
    for (let hour = 7; hour < 19; hour++) {
      for (let minute = 0; minute < 60; minute += 30) {
        const timeString = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
        options.push(timeString);
      }
    }
    return options;
  };

  // Tính giờ kết thúc = giờ bắt đầu + 1 tiếng
  const calculateEndTime = (startTime) => {
    if (!startTime) return '';
    
    const [hours, minutes] = startTime.split(':').map(Number);
    let endHour = hours + 1;
    let endMinute = minutes;
    
    // Nếu giờ kết thúc vượt quá 19:00, giới hạn ở 18:30
    if (endHour >= 19) {
      return '18:30';
    }
    
    return `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}`;
  };

  // Kiểm tra xem có thể hiển thị nút "Yêu cầu thay đổi lịch" không
  const canShowChangeRequestButton = (schedule) => {
    // Không hiển thị nếu đã có yêu cầu thay đổi đang chờ
    if (schedule.hasPendingChangeRequest) {
      return false;
    }

    // Kiểm tra nếu lịch đã qua ngày
    if (!schedule.ngayhen) {
      return false;
    }

    const scheduleDate = new Date(schedule.ngayhen);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    scheduleDate.setHours(0, 0, 0, 0);

    // Không hiển thị nếu lịch đã qua ngày
    if (scheduleDate < today) {
      return false;
    }

    // Kiểm tra nếu còn ít hơn 3 ngày trước lịch tư vấn
    const daysUntilSchedule = Math.floor((scheduleDate - today) / (1000 * 60 * 60 * 24));
    
    // Chỉ hiển thị nếu còn ít nhất 3 ngày
    return daysUntilSchedule >= 3;
  };

  useEffect(() => {
    fetchSchedules();
    checkScheduleRegistrationStatus();
  }, [approvalFilter, dateFilter, startDate, endDate]); // Fetch lại khi filter thay đổi và khi đổi khoảng ngày

  const checkScheduleRegistrationStatus = async () => {
    try {
      setCheckingStatus(true);
      const response = await api.checkScheduleRegistrationStatus();
      if (response.success) {
        setScheduleRegistrationStatus(response.data);
      }
    } catch (error) {
      console.error('Error checking schedule registration status:', error);
    } finally {
      setCheckingStatus(false);
    }
  };

  const fetchSchedules = async () => {
    try {
      setLoading(true);
      // Xây dựng URL với các tham số filter
      let url = `http://localhost:8000/api/consultation-schedules?consultant_id=${currentUserId}`;
      
      // Nếu là filter "Đã đăng ký", gửi booked_only=true
      if (approvalFilter === 'booked') {
        url += '&booked_only=true';
      } else {
        // Các filter khác gửi duyetlich
        url += `&duyetlich=${approvalFilter}`;
      }
      
      // Thêm bộ lọc ngày
      if (dateFilter === 'range') {
        if (startDate) url += `&start_date=${startDate}`;
        if (endDate) url += `&end_date=${endDate}`;
      } else if (dateFilter && dateFilter !== 'all') {
        url += `&date_filter=${dateFilter}`;
      }
      
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.success) {
        // Không giới hạn khung giờ → hiển thị tất cả
        const items = Array.isArray(data.data) ? data.data : [];
        setSchedules(items);
      } else {
        toast.push({ type: 'error', title: 'Không thể tải lịch tư vấn' });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    } finally {
      setLoading(false);
    }
  };


  const handleEditSchedule = (schedule) => {
    setEditingSchedule(schedule);
    setFormData({
      date: schedule.ngayhen,
      start_time: schedule.giobatdau,
      end_time: schedule.ketthuc,
      meeting_link: schedule.danhdanhgiadem || '',
      meeting_platform: schedule.molavande || '',
      notes: schedule.noidung || ''
    });
    setTimeError('');
    setShowModal(true);
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    
    // Validate required fields
    if (!formData.date) {
      toast.push({ type: 'error', title: 'Vui lòng chọn ngày' });
      return;
    }
    
    if (!formData.start_time) {
      toast.push({ type: 'error', title: 'Vui lòng chọn giờ bắt đầu' });
      return;
    }
    
    if (!formData.end_time) {
      toast.push({ type: 'error', title: 'Giờ kết thúc chưa được tính toán' });
      return;
    }
    
    // Validate time range (7 AM to 7 PM)
    const timeValidationError = validateTime(formData.start_time, formData.end_time);
    if (timeValidationError) {
      toast.push({ type: 'error', title: timeValidationError });
      return;
    }
    
    console.log('Submitting form data:', formData);
    console.log('Current user ID:', currentUserId);
    
    setSubmitting(true);
    
    try {
      const url = editingSchedule 
        ? `http://localhost:8000/api/consultation-schedules/${editingSchedule.idlichtuvan}`
        : 'http://localhost:8000/api/consultation-schedules';
      
      const method = editingSchedule ? 'PUT' : 'POST';
      
      const requestData = {
        ...formData,
        consultant_id: currentUserId
      };
      
      console.log('Request URL:', url);
      console.log('Request method:', method);
      console.log('Request data:', requestData);
      
      const response = await fetch(url, {
        method,
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(requestData)
      });
      
      console.log('Response status:', response.status);
      const data = await response.json();
      console.log('Response data:', data);
      
      if (data.success) {
        toast.push({ type: 'success', title: editingSchedule ? 'Cập nhật lịch thành công' : 'Tạo lịch thành công' });
        setShowModal(false);
        fetchSchedules();
      } else {
        console.error('API Error:', data.errors || data.message);
        
        // Xử lý lỗi trùng lịch (409 Conflict)
        if (response.status === 409) {
          console.log('Showing conflict error toast');
          const errorMsg = 'Khung giờ này đã bị trùng với lịch khác. Vui lòng chọn thời gian khác.';
          toast.push({ 
            type: 'error', 
            title: errorMsg
          });
          // Backup: hiển thị alert nếu toast không hoạt động
          alert(errorMsg);
        } else {
          // Hiển thị thông báo lỗi cụ thể từ API
          const errorMessage = data.message || data.errors || 'Có lỗi xảy ra';
          console.log('Showing API error toast:', errorMessage);
          toast.push({ type: 'error', title: errorMessage });
          // Backup: hiển thị alert nếu toast không hoạt động
          alert(errorMessage);
        }
      }
    } catch (error) {
      console.error('Network error:', error);
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    } finally {
      setSubmitting(false);
    }
  };

  const handleDeleteSchedule = async (id) => {
    if (!confirm('Bạn có chắc chắn muốn xóa lịch này?')) return;
    
    try {
      const response = await fetch(`http://localhost:8000/api/consultation-schedules/${id}`, {
        method: 'DELETE'
      });
      
      const data = await response.json();
      
      if (data.success) {
        toast.push({ type: 'success', title: 'Xóa lịch thành công' });
        fetchSchedules();
      } else {
        toast.push({ type: 'error', title: data.message || 'Không thể xóa lịch' });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    }
  };

  const handleRequestChangeSchedule = async () => {
    if (!changeRequestData.ngaymoi || !changeRequestData.giomoi || !changeRequestData.lydo_doilich.trim()) {
      toast.push({ type: 'error', title: 'Vui lòng điền đầy đủ thông tin' });
      return;
    }

    if (!selectedScheduleForChange) {
      toast.push({ type: 'error', title: 'Không tìm thấy lịch được chọn' });
      return;
    }

    setSubmitting(true);
    
    try {
      const response = await fetch(`http://localhost:8000/api/consultation-schedules/${selectedScheduleForChange.idlichtuvan}/request-change`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          ngaymoi: changeRequestData.ngaymoi,
          giomoi: changeRequestData.giomoi,
          lydo_doilich: changeRequestData.lydo_doilich.trim(),
          idnguoidung: currentUserId
        })
      });
      
      const data = await response.json();
      
      if (data.success) {
        toast.push({ type: 'success', title: 'Yêu cầu thay đổi lịch đã được gửi thành công' });
        setShowChangeRequestModal(false);
        setSelectedScheduleForChange(null);
        setChangeRequestData({ ngaymoi: '', giomoi: '', lydo_doilich: '' });
        fetchSchedules();
      } else {
        // Xử lý lỗi trùng lịch (409 Conflict) hoặc các lỗi khác
        const errorMessage = data.message || 'Không thể gửi yêu cầu thay đổi lịch';
        console.error('API Error:', errorMessage);
        toast.push({ type: 'error', title: errorMessage });
        // Backup: hiển thị alert nếu toast không hoạt động
        alert(errorMessage);
      }
    } catch (error) {
      console.error('Error requesting schedule change:', error);
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
      alert('Lỗi kết nối. Vui lòng thử lại.');
    } finally {
      setSubmitting(false);
    }
  };

  const fetchChangeRequests = async (scheduleId) => {
    try {
      setLoadingChangeRequests(true);
      const response = await fetch(`http://localhost:8000/api/consultation-schedules/${scheduleId}/change-requests`);
      const data = await response.json();
      
      if (data.success) {
        setChangeRequests(data.data);
      } else {
        toast.push({ type: 'error', title: 'Không thể tải yêu cầu thay đổi lịch' });
      }
    } catch (error) {
      console.error('Error fetching change requests:', error);
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    } finally {
      setLoadingChangeRequests(false);
    }
  };

  const getChangeRequestStatusText = (status) => {
    const statusMap = {
      1: 'Chờ duyệt',
      2: 'Đã duyệt',
      3: 'Bị từ chối'
    };
    return statusMap[status] || 'Không xác định';
  };

  const getChangeRequestStatusColor = (status) => {
    const colorMap = {
      1: 'bg-yellow-100 text-yellow-800',
      2: 'bg-green-100 text-green-800',
      3: 'bg-red-100 text-red-800'
    };
    return colorMap[status] || 'bg-gray-100 text-gray-800';
  };

  const getStatusText = (status) => {
    const statusMap = {
      '1': 'Trống',
      '2': 'Đã đặt',
      '3': 'Đã hủy',
      '4': 'Hoàn thành'
    };
    return statusMap[status] || status;
  };

  const getStatusColor = (status) => {
    const colorMap = {
      '1': 'text-green-600 bg-green-50',
      '2': 'text-blue-600 bg-blue-50',
      '3': 'text-red-600 bg-red-50',
      '4': 'text-gray-600 bg-gray-50'
    };
    return colorMap[status] || 'text-gray-600 bg-gray-50';
  };

  // Hiển thị text và màu cho trạng thái duyệt lịch
  const getApprovalText = (s) => ({ '1': 'Chờ duyệt', '2': 'Đã duyệt', '3': 'Từ chối' }[String(s)] || 'Khác');
  const getApprovalColor = (s) => ({ '1': 'bg-yellow-100 text-yellow-800', '2': 'bg-green-100 text-green-800', '3': 'bg-red-100 text-red-700' }[String(s)] || 'bg-gray-100 text-gray-700');

  // Dữ liệu đã được filter ở backend, không cần filter lại ở frontend
  // Nhưng vẫn giữ lại để đảm bảo an toàn nếu có trường hợp đặc biệt
  const visibleSchedules = approvalFilter === 'booked' 
    ? schedules // Tab "Đã đăng ký" đã được filter ở backend
    : schedules.filter(s => String(s.duyetlich) === String(approvalFilter));

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-600"></div>
      </div>
    );
  }

  // Nếu đang hiển thị QuarterScheduleSelector
  if (showQuarterSelector) {
    return (
      <div>
        <div className="flex justify-between items-center mb-4">
          <div>
            <h1 className="text-2xl font-bold">Đăng Ký Lịch Trống Theo Quý</h1>
            <p className="text-sm text-gray-600 mt-1">
              Đăng ký lịch trống cho cả quý với các ca học cố định
            </p>
          </div>
          <button 
            onClick={() => setShowQuarterSelector(false)}
            className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
          >
            ← Quay lại
          </button>
        </div>
        
        <QuarterScheduleSelector />
      </div>
    );
  }

  return (
    <div>
      <div className="flex justify-between items-center mb-4">
        <div>
          <h1 className="text-2xl font-bold">Lịch của tôi</h1>
          <p className="text-sm text-gray-600 mt-1">
            Tổng số: {visibleSchedules.length} lịch
          </p>
        </div>
        <div className="flex gap-3">
          {scheduleRegistrationStatus.isOpen ? (
            <button 
              onClick={() => setShowQuarterSelector(true)}
              className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
            >
              📅 Đăng ký theo quý
            </button>
          ) : (
            <div className="px-4 py-2 bg-gray-300 text-gray-600 rounded-lg cursor-not-allowed" title="Đăng ký lịch chưa được mở">
              📅 Đăng ký theo quý (Chưa mở)
            </div>
          )}
          {scheduleRegistrationStatus.isOpen && scheduleRegistrationStatus.endDateFormatted && (
            <div className="px-4 py-2 bg-blue-50 text-blue-700 rounded-lg text-sm flex items-center">
              <span className="mr-2">ℹ️</span>
              Đăng ký mở đến ngày {scheduleRegistrationStatus.endDateFormatted}
            </div>
          )}
        </div>
      </div>

      {/* Tabs lọc theo duyetlich và đã đăng ký */}
      <div className="mb-4 flex gap-2 flex-wrap">
        {[
          { key: '1', label: 'Chờ duyệt', bgColor: 'bg-yellow-50', borderColor: 'border-yellow-300', textColor: 'text-yellow-800', hoverColor: 'hover:bg-yellow-100' },
          { key: '2', label: 'Đã duyệt', bgColor: 'bg-green-50', borderColor: 'border-green-300', textColor: 'text-green-800', hoverColor: 'hover:bg-green-100' },
          { key: '3', label: 'Từ chối', bgColor: 'bg-red-50', borderColor: 'border-red-300', textColor: 'text-red-800', hoverColor: 'hover:bg-red-100' },
          { key: 'booked', label: 'Đã đăng ký', bgColor: 'bg-blue-50', borderColor: 'border-blue-300', textColor: 'text-blue-800', hoverColor: 'hover:bg-blue-100' },
        ].map(tab => (
          <button
            key={tab.key}
            onClick={() => setApprovalFilter(tab.key)}
            className={`px-5 py-2.5 rounded-lg font-semibold text-base shadow-md transition-all ${
              approvalFilter === tab.key
                ? 'bg-gradient-to-r from-blue-600 to-indigo-600 text-white border-2 border-blue-500 shadow-lg transform scale-105'
                : `${tab.bgColor} ${tab.textColor} border-2 ${tab.borderColor} ${tab.hoverColor}`
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Bộ lọc theo thời gian */}
      <div className="mb-4 flex gap-2 flex-wrap items-center">
        <span className="text-xs text-gray-600 mr-2">Thời gian:</span>
        {[
          { value: 'all', label: 'Tất cả' },
          { value: 'today', label: 'Hôm nay' },
          { value: 'week', label: 'Tuần này' },
          { value: 'month', label: 'Tháng này' },
          { value: 'past', label: 'Ngày đã qua' },
          { value: 'future', label: 'Ngày sắp tới' },
        ].map(option => (
          <button
            key={option.value}
            onClick={() => {
              setDateFilter(option.value);
              if (option.value !== 'range') { setStartDate(''); setEndDate(''); }
            }}
            className={`px-3 py-1.5 rounded-lg border text-sm font-medium transition-all ${
              dateFilter === option.value
                ? 'bg-blue-500 text-white border-blue-600 shadow-md'
                : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50 hover:border-gray-400'
            }`}
          >
            {option.label}
          </button>
        ))}
        {/* Dải ngày */}
        <div className="flex items-center gap-2 ml-2">
          <input
            type="date"
            value={startDate}
            onChange={(e) => setStartDate(e.target.value)}
            className="px-2 py-1 border border-gray-300 rounded"
          />
          <span>-</span>
          <input
            type="date"
            value={endDate}
            onChange={(e) => setEndDate(e.target.value)}
            className="px-2 py-1 border border-gray-300 rounded"
          />
          <button
            onClick={() => setDateFilter('range')}
            className={`px-3 py-1.5 rounded-lg border text-sm font-medium ${
              dateFilter === 'range' ? 'bg-blue-500 text-white border-blue-600 shadow-md' : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50'
            }`}
          >
            Áp dụng
          </button>
          {(startDate || endDate) && (
            <button
              onClick={() => { setStartDate(''); setEndDate(''); setDateFilter('all'); }}
              className="px-3 py-1.5 rounded-lg border text-sm font-medium bg-white text-gray-700 border-gray-300 hover:bg-gray-50"
            >
              Xóa
            </button>
          )}
        </div>
      </div>

      <div className="card p-5">
        {visibleSchedules.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            Chưa có lịch tư vấn nào
          </div>
        ) : (
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-gray-50">
                {(approvalFilter === '2' || approvalFilter === '3') && (
                  <>
                    <th className="p-3 text-left">Tên người duyệt</th>
                    <th className="p-3 text-left">Email người duyệt</th>
                  </>
                )}
                {approvalFilter === 'booked' && (
                  <>
                    <th className="p-3 text-left">Tên người đặt</th>
                    <th className="p-3 text-left">Email người đặt</th>
                  </>
                )}
                <th className="p-3 text-left">Ngày</th>
                <th className="p-3 text-left">Thời gian bắt đầu</th>
                <th className="p-3 text-left">Thời gian kết thúc</th>
                {approvalFilter === 'booked' && (
                  <>
                    <th className="p-3 text-left">Mô tả vấn đề</th>
                    <th className="p-3 text-left">Ghi chú</th>
                  </>
                )}
                <th className="p-3 text-left">Trạng thái</th>
                <th className="p-3 text-left">Nền tảng</th>
                {approvalFilter === 'booked' && (
                  <th className="p-3 text-left">Thao tác</th>
                )}
              </tr>
            </thead>
            <tbody>
              {visibleSchedules.map((schedule) => (
                <tr key={schedule.idlichtuvan} className="border-t hover:bg-gray-50">
                  {(approvalFilter === '2' || approvalFilter === '3') && (
                    <>
                      <td className="p-3">{schedule.nguoiDuyet?.hoten || schedule.nguoi_duyet?.hoten || '-'}</td>
                      <td className="p-3">{schedule.nguoiDuyet?.email || schedule.nguoi_duyet?.email || '-'}</td>
                    </>
                  )}
                  {approvalFilter === 'booked' && (
                    <>
                      <td className="p-3">{schedule.nguoiDat?.hoten || schedule.nguoi_dat?.hoten || '-'}</td>
                      <td className="p-3">{schedule.nguoiDat?.email || schedule.nguoi_dat?.email || '-'}</td>
                    </>
                  )}
                  <td className="p-3">{new Date(schedule.ngayhen).toLocaleDateString('vi-VN')}</td>
                  <td className="p-3">
                    {schedule.giobatdau 
                      ? (typeof schedule.giobatdau === 'string' 
                          ? schedule.giobatdau.split(' ')[0] 
                          : schedule.giobatdau)
                      : '-'}
                  </td>
                  <td className="p-3">
                    {schedule.ketthuc 
                      ? (typeof schedule.ketthuc === 'string' 
                          ? schedule.ketthuc.split(' ')[0] 
                          : schedule.ketthuc)
                      : '-'}
                  </td>
                  {approvalFilter === 'booked' && (
                    <>
                      <td className="p-3">
                        <div className="max-w-xs">
                          {schedule.chudetuvan || schedule.noidung || '-'}
                        </div>
                      </td>
                      <td className="p-3">
                        <div className="max-w-xs">
                          {schedule.ghichu || '-'}
                        </div>
                      </td>
                    </>
                  )}
                  <td className="p-3">
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className={`px-2 py-1 rounded-full text-xs ${getStatusColor(schedule.trangthai)}`}>
                        {getStatusText(schedule.trangthai)}
                      </span>
                      {approvalFilter !== 'booked' && (
                        <span className={`px-2 py-1 rounded-full text-xs ${getApprovalColor(schedule.duyetlich)}`}>
                          {getApprovalText(schedule.duyetlich)}
                        </span>
                      )}
                      {schedule.hasPendingChangeRequest && (
                        <span className="px-2 py-1 rounded-full text-xs bg-orange-100 text-orange-800">
                          Đang chờ thay đổi
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="p-3">{schedule.molavande || '-'}</td>
                  {approvalFilter === 'booked' && (
                    <td className="p-3">
                      <div className="flex gap-2">
                        {schedule.hasPendingChangeRequest ? (
                          <button
                            onClick={() => {
                              setSelectedScheduleForView(schedule);
                              fetchChangeRequests(schedule.idlichtuvan);
                              setShowViewChangeRequestModal(true);
                            }}
                            className="px-3 py-1.5 bg-green-600 text-white text-sm rounded-lg hover:bg-green-700 transition-colors"
                          >
                            Xem yêu cầu đổi lịch
                          </button>
                        ) : canShowChangeRequestButton(schedule) ? (
                          <button
                            onClick={() => {
                              setSelectedScheduleForChange(schedule);
                              // Format ngày cho input
                              const ngayHen = schedule.ngayhen ? new Date(schedule.ngayhen).toISOString().split('T')[0] : '';
                              setChangeRequestData({
                                ngaymoi: ngayHen,
                                giomoi: '', // Không set mặc định, để người dùng chọn
                                lydo_doilich: ''
                              });
                              setShowChangeRequestModal(true);
                            }}
                            className="px-3 py-1.5 bg-blue-600 text-white text-sm rounded-lg hover:bg-blue-700 transition-colors"
                          >
                            Yêu cầu thay đổi lịch
                          </button>
                        ) : (
                          <span className="text-sm text-gray-400 italic">
                            {(() => {
                              if (!schedule.ngayhen) return 'Không có ngày';
                              const scheduleDate = new Date(schedule.ngayhen);
                              const today = new Date();
                              today.setHours(0, 0, 0, 0);
                              scheduleDate.setHours(0, 0, 0, 0);
                              if (scheduleDate < today) return 'Đã qua ngày';
                              const daysUntilSchedule = Math.floor((scheduleDate - today) / (1000 * 60 * 60 * 24));
                              if (daysUntilSchedule < 3) return 'Còn ít hơn 3 ngày';
                              return '-';
                            })()}
                          </span>
                        )}
                      </div>
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        )}
      </div>

      {/* Modal yêu cầu thay đổi lịch */}
      {showChangeRequestModal && selectedScheduleForChange && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-md">
            <h2 className="text-xl font-bold mb-4">Yêu cầu thay đổi lịch</h2>
            <div className="mb-4">
              <p className="text-sm text-gray-600 mb-2">
                <strong>Lịch hiện tại:</strong>
              </p>
              <p className="text-sm text-gray-600 mb-1">
                <strong>Ngày:</strong> {new Date(selectedScheduleForChange.ngayhen).toLocaleDateString('vi-VN')}
              </p>
              <p className="text-sm text-gray-600 mb-1">
                <strong>Thời gian:</strong> {selectedScheduleForChange.giobatdau} - {selectedScheduleForChange.ketthuc}
              </p>
              <p className="text-sm text-gray-600 mb-4">
                <strong>Người đặt:</strong> {selectedScheduleForChange.nguoiDat?.hoten || selectedScheduleForChange.nguoi_dat?.hoten || '-'}
              </p>
            </div>

            {/* Lưu ý về phí thay đổi lịch */}
            <div className="mb-4 p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
              <div className="flex items-start">
                <svg className="w-5 h-5 text-yellow-600 mt-0.5 mr-2 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clipRule="evenodd" />
                </svg>
                <div>
                  <p className="text-sm font-medium text-yellow-800 mb-1">
                    Lưu ý quan trọng
                  </p>
                  <p className="text-sm text-yellow-700">
                    Nếu thay đổi lịch, bạn sẽ bị trừ <strong>50% số tiền</strong> của buổi tư vấn. Vui lòng cân nhắc kỹ trước khi gửi yêu cầu.
                  </p>
                </div>
              </div>
            </div>
            
            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Ngày mới <span className="text-red-500">*</span>
              </label>
              <input
                type="date"
                value={changeRequestData.ngaymoi}
                onChange={(e) => setChangeRequestData({...changeRequestData, ngaymoi: e.target.value})}
                min={new Date().toISOString().split('T')[0]}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                required
              />
            </div>

            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Ca học mới <span className="text-red-500">*</span>
              </label>
              <div className="space-y-2">
                {timeSlots.map((slot, index) => (
                  <label
                    key={index}
                    className={`flex items-center p-3 border rounded-lg cursor-pointer transition-colors ${
                      changeRequestData.giomoi === slot.start
                        ? 'border-blue-500 bg-blue-50'
                        : 'border-gray-300 hover:bg-gray-50'
                    }`}
                  >
                    <input
                      type="radio"
                      name="giomoi"
                      value={slot.start}
                      checked={changeRequestData.giomoi === slot.start}
                      onChange={(e) => setChangeRequestData({...changeRequestData, giomoi: e.target.value})}
                      className="mr-3"
                    />
                    <span className="text-sm">{slot.label}</span>
                  </label>
                ))}
              </div>
            </div>

            <div className="mb-4">
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Lý do thay đổi lịch <span className="text-red-500">*</span>
              </label>
              <textarea
                value={changeRequestData.lydo_doilich}
                onChange={(e) => setChangeRequestData({...changeRequestData, lydo_doilich: e.target.value})}
                placeholder="Nhập lý do yêu cầu thay đổi lịch..."
                className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
                rows={4}
                required
              />
            </div>
            
            <div className="flex gap-3 justify-end">
              <button
                onClick={() => {
                  setShowChangeRequestModal(false);
                  setSelectedScheduleForChange(null);
                  setChangeRequestData({ ngaymoi: '', giomoi: '', lydo_doilich: '' });
                }}
                className="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50"
              >
                Hủy
              </button>
              <button
                onClick={handleRequestChangeSchedule}
                disabled={!changeRequestData.ngaymoi || !changeRequestData.giomoi || !changeRequestData.lydo_doilich.trim() || submitting}
                className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 disabled:bg-gray-400 disabled:cursor-not-allowed"
              >
                {submitting ? 'Đang gửi...' : 'Gửi yêu cầu'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Modal xem yêu cầu thay đổi lịch */}
      {showViewChangeRequestModal && selectedScheduleForView && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">Yêu cầu thay đổi lịch</h2>
            
            <div className="mb-4">
              <p className="text-sm text-gray-600 mb-2">
                <strong>Lịch hiện tại:</strong>
              </p>
              <p className="text-sm text-gray-600 mb-1">
                <strong>Ngày:</strong> {new Date(selectedScheduleForView.ngayhen).toLocaleDateString('vi-VN')}
              </p>
              <p className="text-sm text-gray-600 mb-1">
                <strong>Thời gian:</strong> {selectedScheduleForView.giobatdau} - {selectedScheduleForView.ketthuc}
              </p>
              <p className="text-sm text-gray-600 mb-4">
                <strong>Người đặt:</strong> {selectedScheduleForView.nguoiDat?.hoten || selectedScheduleForView.nguoi_dat?.hoten || '-'}
              </p>
            </div>

            {loadingChangeRequests ? (
              <div className="flex justify-center items-center py-8">
                <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
              </div>
            ) : changeRequests.length === 0 ? (
              <div className="text-center py-8 text-gray-500">
                Chưa có yêu cầu thay đổi lịch nào
              </div>
            ) : (
              <div className="space-y-4">
                {changeRequests.map((request, index) => {
                  const timeSlot = timeSlots.find(slot => slot.start === request.giomoi);
                  return (
                    <div key={request.iddoilich || index} className="border rounded-lg p-4">
                      <div className="flex justify-between items-start mb-3">
                        <div>
                          <p className="text-sm font-medium text-gray-700 mb-1">
                            Yêu cầu #{index + 1}
                          </p>
                          <p className="text-xs text-gray-500">
                            Gửi lúc: {request.thoigian_gui ? new Date(request.thoigian_gui).toLocaleString('vi-VN') : '-'}
                          </p>
                        </div>
                        <span className={`px-2 py-1 rounded-full text-xs ${getChangeRequestStatusColor(request.trangthai_duyet)}`}>
                          {getChangeRequestStatusText(request.trangthai_duyet)}
                        </span>
                      </div>

                      <div className="grid grid-cols-2 gap-4 mb-3">
                        <div>
                          <p className="text-xs text-gray-500 mb-1">Ngày mới:</p>
                          <p className="text-sm font-medium">
                            {request.ngaymoi ? new Date(request.ngaymoi).toLocaleDateString('vi-VN') : '-'}
                          </p>
                        </div>
                        <div>
                          <p className="text-xs text-gray-500 mb-1">Ca học mới:</p>
                          <p className="text-sm font-medium">
                            {timeSlot ? timeSlot.label : request.giomoi || '-'}
                          </p>
                        </div>
                      </div>

                      <div className="mb-3">
                        <p className="text-xs text-gray-500 mb-1">Lý do:</p>
                        <p className="text-sm bg-gray-50 p-2 rounded">
                          {request.lydo_doilich || '-'}
                        </p>
                      </div>

                      {request.trangthai_duyet !== 1 && (
                        <div className="mt-3 pt-3 border-t">
                          <div className="grid grid-cols-2 gap-4 mb-2">
                            <div>
                              <p className="text-xs text-gray-500 mb-1">Người duyệt:</p>
                              <p className="text-sm">
                                {request.nguoiDuyet?.hoten || request.nguoi_duyet?.hoten || '-'}
                              </p>
                            </div>
                            <div>
                              <p className="text-xs text-gray-500 mb-1">Thời gian duyệt:</p>
                              <p className="text-sm">
                                {request.thoigian_duyet ? new Date(request.thoigian_duyet).toLocaleString('vi-VN') : '-'}
                              </p>
                            </div>
                          </div>
                          {request.ghichu_duyet && (
                            <div>
                              <p className="text-xs text-gray-500 mb-1">Ghi chú duyệt:</p>
                              <p className="text-sm bg-gray-50 p-2 rounded">
                                {request.ghichu_duyet}
                              </p>
                            </div>
                          )}
                        </div>
                      )}
                    </div>
                  );
                })}
              </div>
            )}

            <div className="mt-6 flex justify-end">
              <button
                onClick={() => {
                  setShowViewChangeRequestModal(false);
                  setSelectedScheduleForView(null);
                  setChangeRequests([]);
                }}
                className="px-4 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700"
              >
                Đóng
              </button>
            </div>
          </div>
        </div>
      )}

    </div>
  );
}
