import { useState, useEffect } from 'react';
import CalendarGrid from './CalendarGrid';
import { useToast } from './Toast';
import api from '../services/api';

export default function QuarterScheduleSelector() {
  const [currentYear, setCurrentYear] = useState(new Date().getFullYear());
  const [selectedQuarter, setSelectedQuarter] = useState(1);
  const [selectedDates, setSelectedDates] = useState([]);
  const [selectedSlotsByDateMap, setSelectedSlotsByDateMap] = useState({});
  const [scheduleDetails, setScheduleDetails] = useState({
    meeting_platform: '',
    meeting_link: '',
    notes: ''
  });
  const [submitting, setSubmitting] = useState(false);
  const [existingSchedules, setExistingSchedules] = useState({});
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [showSuccessNotification, setShowSuccessNotification] = useState(false);
  const toast = useToast();

  const fetchExistingSchedules = async () => {
    try {
      const consultantId = localStorage.getItem('userId') || '5';
      console.log('Fetching schedules for consultant:', consultantId);
      const months = getQuarterMonths(selectedQuarter);
      const schedules = {};
      
      for (const month of months) {
        const res = await api.get('/consultation-schedules', { 
          year: currentYear, 
          month, 
          consultant_id: consultantId 
        });

        if (res.success) {
          const list = Array.isArray(res.data) ? res.data : [];
          list.forEach(schedule => {
            const dateStr = schedule.ngayhen || schedule.date;
            if (!dateStr) return;

            const rawSlots = schedule.khunggio ? (() => { try { return JSON.parse(schedule.khunggio); } catch { return []; } })() : (schedule.timeSlots || []);
            const normalizedSlots = (rawSlots || []).map((slot) => {
              const start = slot.start || slot.giobatdau || slot.start_time;
              const end = slot.end || slot.gioketthuc || slot.end_time;
              const approvalStatus = slot.duyetlich ?? schedule.duyetlich ?? slot.approvalStatus ?? null;
              return { start, end, duyetlich: approvalStatus };
            });

            if (normalizedSlots.length === 0 && (schedule.giobatdau || schedule.start_time)) {
              const start = schedule.giobatdau || schedule.start_time;
              const end = schedule.gioketthuc || schedule.end_time;
              normalizedSlots.push({ start, end, duyetlich: schedule.duyetlich ?? null });
            }

            const existing = schedules[dateStr];
            schedules[dateStr] = {
              hasSchedule: true,
              status: schedule.trangthai || schedule.status,
              timeSlots: (() => {
                const merged = [...(existing?.timeSlots || []), ...normalizedSlots];
                const uniqueByKey = new Map();
                merged.forEach((s) => {
                  const key = `${s.start}-${s.end}`;
                  if (!uniqueByKey.has(key) || (s?.duyetlich ?? null) != null) {
                    uniqueByKey.set(key, s);
                  }
                });
                return Array.from(uniqueByKey.values());
              })(),
            };
          });
        }
      }
      setExistingSchedules(schedules);
    } catch (error) {
      console.error('Error fetching existing schedules:', error);
    }
  };

  useEffect(() => {
    fetchExistingSchedules();
  }, [selectedQuarter, currentYear]);

  const timeSlots = [
    { id: 1, name: 'Ca 1', start: '07:00', end: '09:00', label: '07:00 - 09:00' },
    { id: 2, name: 'Ca 2', start: '09:05', end: '11:05', label: '09:05 - 11:05' },
    { id: 3, name: 'Ca 3', start: '13:05', end: '15:05', label: '13:05 - 15:05' },
    { id: 4, name: 'Ca 4', start: '15:10', end: '17:10', label: '15:10 - 17:10' },
    { id: 5, name: 'Ca 5', start: '17:15', end: '19:15', label: '17:15 - 19:15' }
  ];

  const getQuarterMonths = (quarter) => {
    const monthMap = { 1: [1, 2, 3], 2: [4, 5, 6], 3: [7, 8, 9], 4: [10, 11, 12] };
    return monthMap[quarter] || [1, 2, 3];
  };

  const getQuarterName = (quarter) => {
    const quarterNames = { 1: 'Quý 1 (Tháng 1-3)', 2: 'Quý 2 (Tháng 4-6)', 3: 'Quý 3 (Tháng 7-9)', 4: 'Quý 4 (Tháng 10-12)' };
    return quarterNames[quarter] || 'Quý 1';
  };

  const handleDateSelect = (date) => {
    const dateStr = date.toISOString().split('T')[0];
    setSelectedDates(prev => prev.includes(dateStr) ? prev.filter(d => d !== dateStr) : [...prev, dateStr]);
    const bookedSlots = getBookedTimeSlots();
    setSelectedSlotsByDateMap(prev => {
      const newMap = { ...prev };
      Object.keys(newMap).forEach(dateStr => {
        newMap[dateStr] = newMap[dateStr].filter(slotId => !bookedSlots.includes(slotId));
        if (newMap[dateStr].length === 0) delete newMap[dateStr];
      });
      return newMap;
    });
  };

  const getBookedTimeSlots = () => {
    const bookedSlots = new Set();
    selectedDates.forEach(dateStr => {
      const existingSchedule = existingSchedules[dateStr];
      if (existingSchedule?.timeSlots) {
        existingSchedule.timeSlots.forEach(slot => {
          const matchingSlot = timeSlots.find(ts => ts.start === slot.start && ts.end === slot.end);
          if (matchingSlot) bookedSlots.add(matchingSlot.id);
        });
      }
    });
    return Array.from(bookedSlots);
  };

  const handleShowConfirmModal = () => {
    if (selectedDates.length === 0) { toast.push({ type: 'error', title: 'Vui lòng chọn ít nhất một ngày' }); return; }
    const totalSelectedSlots = Object.values(selectedSlotsByDateMap).flat().length;
    if (totalSelectedSlots === 0) { toast.push({ type: 'error', title: 'Vui lòng chọn ít nhất một ca học' }); return; }
    if (!scheduleDetails.meeting_platform) { toast.push({ type: 'error', title: 'Vui lòng chọn nền tảng họp' }); return; }
    if (!scheduleDetails.meeting_link) { toast.push({ type: 'error', title: 'Vui lòng nhập link phòng họp' }); return; }
    setShowConfirmModal(true);
  };

  const handleCloseConfirmModal = () => setShowConfirmModal(false);

  const handleSubmit = async () => {
    if (selectedDates.length === 0 || Object.values(selectedSlotsByDateMap).flat().length === 0 || !scheduleDetails.meeting_platform || !scheduleDetails.meeting_link) {
      toast.push({ type: 'error', title: 'Vui lòng điền đủ thông tin' });
      return;
    }
    setSubmitting(true);

    try {
      const currentUserId = localStorage.getItem('userId') || '5';
      const schedules = [];
      const resolveSlot = (slotId) => {
        if (typeof slotId === 'string' && slotId.startsWith('slot')) {
          const idx = parseInt(slotId.replace('slot', ''), 10);
          return timeSlots.find(s => s.id === idx);
        }
        return timeSlots.find(s => s.id === slotId);
      };

      Object.entries(selectedSlotsByDateMap).forEach(([dateStr, slotIds]) => {
        slotIds.forEach(slotId => {
          const slot = resolveSlot(slotId);
          if (slot) schedules.push({ consultant_id: currentUserId, date: dateStr, start_time: slot.start, end_time: slot.end, meeting_platform: scheduleDetails.meeting_platform, meeting_link: scheduleDetails.meeting_link, notes: scheduleDetails.notes || `Lịch trống - ${getQuarterName(selectedQuarter)} ${currentYear}` });
        });
      });

      let successCount = 0, errorCount = 0;
      const failedItems = [];

      for (const schedule of schedules) {
        try {
          const data = await api.post('/consultation-schedules', schedule);
          if (data?.success) {
            successCount++;
          } else {
            errorCount++;
            const firstError = data?.errors ? Object.values(data.errors)[0]?.[0] : data?.message;
            failedItems.push({ date: schedule.date, start: schedule.start_time, end: schedule.end_time, reason: firstError || 'Lỗi không xác định' });
          }
        } catch (error) {
          errorCount++;
          failedItems.push({ date: schedule.date, start: schedule.start_time, end: schedule.end_time, reason: 'Lỗi mạng' });
        }
      }

      if (successCount > 0) {
        toast.push({ type: 'success', title: `Đăng ký thành công ${successCount} lịch trống` });
        setShowSuccessNotification(true);
        setTimeout(() => setShowSuccessNotification(false), 5000);
        await fetchExistingSchedules();
        handleReset();
      }

      setShowConfirmModal(false);
      if (errorCount > 0) {
        const preview = failedItems.slice(0, 3).map(i => `• ${i.date} ${i.start}-${i.end}: ${i.reason}`).join('\n');
        toast.push({ type: 'warning', title: `${errorCount} lịch không thể đăng ký`, message: preview || undefined });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Có lỗi xảy ra khi đăng ký lịch' });
    } finally {
      setSubmitting(false);
    }
  };

  const handleReset = () => {
    setSelectedDates([]);
    setSelectedSlotsByDateMap({});
    setScheduleDetails({ meeting_platform: '', meeting_link: '', notes: '' });
  };

  return (
    <div className="min-h-screen bg-white">
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-[1800px] mx-auto px-8 py-4">
          <div className="flex justify-between items-center">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 bg-orange-500 rounded-lg flex items-center justify-center"><span className="text-white text-lg">📅</span></div>
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Đăng Ký Lịch Trống Theo Quý</h1>
                <p className="text-sm text-gray-600">Đăng ký lịch trống cho cả quý với các ca học cố định</p>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <div className="flex items-center gap-2 bg-gray-50 rounded-lg px-3 py-2">
                <span className="text-orange-500 font-semibold text-lg px-2">{currentYear}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-[1800px] mx-auto px-8 py-6">
        <div className="bg-white border border-gray-200 rounded-lg p-6">
          <h2 className="text-lg font-semibold text-gray-800 mb-4">Chọn Quý</h2>
          <div className="flex gap-3">
            {[1, 2, 3, 4].map(q => (
              <button key={q} onClick={() => setSelectedQuarter(q)} className={`px-4 py-3 rounded-lg border font-medium ${selectedQuarter === q ? 'border-orange-500 bg-orange-500 text-white' : 'border-gray-300 hover:bg-gray-50'}`}>{getQuarterName(q)}</button>
            ))}
          </div>
        </div>
      </div>

      <div className="max-w-[1800px] mx-auto px-8 pb-8 space-y-6">
        <div className="bg-white border border-gray-200 rounded-lg p-6">
          <div className="flex justify-between items-center mb-4">
            <h3 className="text-lg font-semibold text-gray-800">Lịch Theo Quý</h3>
            <div className="text-sm text-gray-600">💡 <strong>Tip:</strong> Click vào ngày để chọn, ngày được chọn sẽ có màu cam</div>
          </div>
          <CalendarGrid year={currentYear} months={getQuarterMonths(selectedQuarter)} selectedDates={selectedDates} onDateSelect={handleDateSelect} existingSchedules={existingSchedules} onSlotToggle={({ selectedSlotsByDateMap: newMap }) => { setSelectedSlotsByDateMap(newMap); const dates = Object.keys(newMap).filter(d => newMap[d]?.length > 0); setSelectedDates(dates); }} />
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div className="bg-white border border-gray-200 rounded-lg p-6">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-gray-800">Thông Tin Chi Tiết</h3>
              <div className="text-sm text-gray-600">⚠️ <strong>Bắt buộc:</strong> Nền tảng và Link phòng họp</div>
            </div>
            <div className="mb-4 p-3 bg-gray-50 border rounded-lg">
              <h4 className="text-sm font-medium text-gray-700 mb-2">Tóm tắt đăng ký</h4>
              {selectedDates.length > 0 ? (
                <div className="text-sm text-gray-600 space-y-1">
                  <div>📅 <strong>{selectedDates.length} ngày</strong> × 🕐 <strong>{Object.values(selectedSlotsByDateMap).flat().length} ca</strong></div>
                  {selectedDates.map(dateStr => {
                    const slotIds = selectedSlotsByDateMap[dateStr] || [];
                    if (slotIds.length === 0) return null;
                    const formattedDate = new Date(dateStr).toLocaleDateString('vi-VN', { day: 'numeric', month: 'numeric' });
                    return <div key={dateStr}>• Ngày {formattedDate}: {slotIds.length} ca</div>;
                  })}
                </div>
              ) : <div className="text-sm text-gray-500">Chưa chọn ngày hoặc ca</div>}
            </div>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1 text-gray-700">Nền tảng <span className="text-red-500">*</span></label>
                <select value={scheduleDetails.meeting_platform} onChange={(e) => setScheduleDetails({ ...scheduleDetails, meeting_platform: e.target.value })} className={`w-full px-3 py-2 border rounded-lg ${!scheduleDetails.meeting_platform ? 'border-red-300' : 'border-gray-300'}`}>
                  <option value="">Chọn nền tảng</option>
                  <option value="Google Meet">Google Meet</option>
                  <option value="Zoom">Zoom</option>
                  <option value="Microsoft Teams">Microsoft Teams</option>
                  <option value="Khác">Khác</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1 text-gray-700">Link phòng họp <span className="text-red-500">*</span></label>
                <input type="url" value={scheduleDetails.meeting_link} onChange={(e) => setScheduleDetails({ ...scheduleDetails, meeting_link: e.target.value })} className={`w-full px-3 py-2 border rounded-lg ${!scheduleDetails.meeting_link ? 'border-red-300' : 'border-gray-300'}`} placeholder="https://..." />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1 text-gray-700">Ghi chú <span className="text-gray-400 text-xs">(Tùy chọn)</span></label>
                <textarea value={scheduleDetails.notes} onChange={(e) => setScheduleDetails({ ...scheduleDetails, notes: e.target.value })} className="w-full px-3 py-2 border rounded-lg resize-none" rows="4" placeholder="Nhập ghi chú..." maxLength="500" />
              </div>
            </div>
          </div>

          <div className="bg-white border border-gray-200 rounded-lg p-6">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-lg font-semibold text-gray-800">Hành Động</h3>
            </div>
            <div className="space-y-3">
              <button onClick={handleShowConfirmModal} disabled={submitting || selectedDates.length === 0 || Object.values(selectedSlotsByDateMap).flat().length === 0 || !scheduleDetails.meeting_platform || !scheduleDetails.meeting_link} className={`w-full py-3 px-4 rounded-lg font-semibold ${submitting || selectedDates.length === 0 || Object.values(selectedSlotsByDateMap).flat().length === 0 || !scheduleDetails.meeting_platform || !scheduleDetails.meeting_link ? 'bg-gray-300 cursor-not-allowed' : 'bg-orange-500 text-white hover:bg-orange-600'}`}>
                {submitting ? 'Đang đăng ký...' : '📝 Đăng Ký Lịch Trống'}
              </button>
              <button onClick={handleReset} className="w-full py-2 px-4 border rounded-lg hover:bg-gray-50">Đặt Lại</button>
            </div>
          </div>
        </div>
      </div>

      {showConfirmModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
            <h3 className="text-lg font-semibold mb-4">Xác nhận đăng ký</h3>
            <div className="bg-gray-50 border p-4 mb-4 rounded-lg">
              <div className="text-sm space-y-1">
                <div>📅 <strong>{selectedDates.length} ngày</strong>, 🕐 <strong>{Object.values(selectedSlotsByDateMap).flat().length} ca</strong></div>
                <div>💻 <strong>Nền tảng:</strong> {scheduleDetails.meeting_platform}</div>
                <div>🔗 <strong>Link:</strong> {scheduleDetails.meeting_link}</div>
              </div>
            </div>
            <div className="flex gap-3">
              <button onClick={handleCloseConfirmModal} className="flex-1 py-2 px-4 border rounded-lg hover:bg-gray-50">Hủy</button>
              <button onClick={() => { setShowConfirmModal(false); handleSubmit(); }} className="flex-1 py-2 px-4 bg-orange-500 text-white rounded-lg hover:bg-orange-600">Xác nhận</button>
            </div>
          </div>
        </div>
      )}

      {showSuccessNotification && (
        <div className="fixed top-4 right-4 z-50">
          <div className="bg-green-500 text-white px-6 py-4 rounded-lg shadow-lg flex items-center gap-3">
            <div>✅</div>
            <div>
              <div className="font-semibold">Thành công!</div>
              <div className="text-sm">Lịch trống đã được đăng ký.</div>
            </div>
            <button onClick={() => setShowSuccessNotification(false)} className="text-green-200 hover:text-white">✕</button>
          </div>
        </div>
      )}
    </div>
  );
}
