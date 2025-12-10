import { useState, useEffect } from 'react';
import { useToast } from '../../components/Toast';
import api from '../../services/api';

// Helpers: chuẩn hóa URL (tránh localhost, mixed-content)
const publicBase = api.baseURL.replace(/\/api$/, ''); // https://hoahoctro.42web.io/laravel/public
const normalizeUrl = (u) => (u ? u.replace(/^http:\/\/localhost:8000/, publicBase) : u);

export default function ConsultantNotes() {
  const [sessions, setSessions] = useState([]);
  const [selectedSession, setSelectedSession] = useState(null);
  const [sessionDetail, setSessionDetail] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [dateFilter, setDateFilter] = useState(''); // '' = tất cả
  const [viewMode, setViewMode] = useState('input'); // 'input' hoặc 'view'
  const [showFormAfterSubmit, setShowFormAfterSubmit] = useState(true);

  // Giao diện: chuyển sang tông emerald
  const primaryBtn = 'bg-emerald-600 hover:bg-emerald-700 text-white';
  const primaryRing = 'focus:ring-emerald-500 focus:border-emerald-500';
  const pillActive = 'bg-emerald-600 text-white border-emerald-600 shadow-sm';
  const pill = 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50 hover:border-gray-400';
  
  const [formData, setFormData] = useState({
    noi_dung: '',
    ket_luan_nganh: '',
    muc_quan_tam: 3,
    diem_du_kien: '',
    yeu_cau_bo_sung: '',
    chia_se_voi_thisinh: true,
    tom_tat: '',
  });

  const [currentGhiChuId, setCurrentGhiChuId] = useState(null);

  const [evidenceFiles, setEvidenceFiles] = useState([]); // {clientId, mode:'new'|'existing', ten_file, loai_file, mo_ta, la_minh_chung, duong_dan, file}
  const [evidencesToDelete, setEvidencesToDelete] = useState([]);
  const [showEvidenceForm, setShowEvidenceForm] = useState(true);
  const [evidenceForm, setEvidenceForm] = useState({
    duong_dan: '',
    ten_file: '',
    loai_file: 'link',
    mo_ta: '',
    la_minh_chung: true,
    file: null,
  });

  // Nhóm ngành (khôi phục trường đã mất)
  const [majorGroups, setMajorGroups] = useState([]); // {id, code, name}
  const [selectedGroupId, setSelectedGroupId] = useState('');

  const toast = useToast();

  // Get current user
  const currentUser = JSON.parse(localStorage.getItem('user') || '{}');
  const consultantId = currentUser.idnguoidung || currentUser.id || '5';

  useEffect(() => {
    fetchSessions();
  }, [dateFilter, viewMode]);

  useEffect(() => {
    if (selectedSession) {
      fetchSessionDetail(selectedSession);
      setShowFormAfterSubmit(true);
    }
  }, [selectedSession]);

  useEffect(() => {
    setShowFormAfterSubmit(true);
    setSelectedSession(null);
    setSessionDetail(null);
    if (viewMode === 'view') setDateFilter('');
  }, [viewMode]);

  useEffect(() => {
    // tải nhóm ngành cho dropdown
    (async () => {
      try {
        const res = await api.get('/major-groups');
        const list = (res?.data || []).map((g) => ({ id: g.id || g.idnhomnganh || g.code, name: g.name || g.tennhom || g.code }));
        setMajorGroups(list);
      } catch (_) {
        setMajorGroups([]);
      }
    })();
  }, []);

  const fetchSessions = async () => {
    try {
      setLoading(true);
      const params = {
        consultant_id: consultantId,
        view_mode: viewMode,
        ...(dateFilter ? { date_filter: dateFilter } : {}),
      };

      const data = await api.get('/consultation-notes', params);
      if (data?.success) {
        const list = data.data || [];
        setSessions(list);
        if (list.length > 0 && !selectedSession) setSelectedSession(list[0].id);
        if (list.length === 0) { setSelectedSession(null); setSessionDetail(null); }
      } else {
        toast.push({ type: 'error', title: data?.message || 'Không thể tải danh sách buổi tư vấn' });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    } finally {
      setLoading(false);
    }
  };

  const fetchSessionDetail = async (sessionId) => {
    try {
      const data = await api.get(`/consultation-notes/${sessionId}`);
      if (data?.success) {
        setSessionDetail(data.data);
        const session = data.data.session;
        const ghiChu = data.data.ghi_chu_nhap || data.data.ghi_chu_chot;
        // Đoán id nhóm ngành từ dữ liệu ghi chú (nếu backend có)
        const idNhom = ghiChu?.idnhomnganh || ghiChu?.nhom_nganh || '';
        if (idNhom) setSelectedGroupId(String(idNhom));
        
        if (ghiChu) {
          setFormData({
            noi_dung: ghiChu.noi_dung || '',
            ket_luan_nganh: ghiChu.ket_luan_nganh || '',
            muc_quan_tam: ghiChu.muc_quan_tam || 3,
            diem_du_kien: ghiChu.diem_du_kien || '',
            yeu_cau_bo_sung: ghiChu.yeu_cau_bo_sung || '',
            chia_se_voi_thisinh: true,
            tom_tat: session.nhanxet || '',
          });
          setCurrentGhiChuId(ghiChu.id || null);
        } else {
          setFormData((prev) => ({
            ...prev,
            noi_dung: '', ket_luan_nganh: '', muc_quan_tam: 3, diem_du_kien: '', yeu_cau_bo_sung: '',
            chia_se_voi_thisinh: true, tom_tat: session.nhanxet || '',
          }));
          setCurrentGhiChuId(null);
        }

        const existingEvidence = (data.data.minh_chung || []).map((file) => ({
          clientId: `existing-${file.id_file}`,
          mode: 'existing',
          id_file: file.id_file,
          ten_file: file.ten_file,
          loai_file: file.loai_file,
          mo_ta: file.mo_ta,
          la_minh_chung: !!file.la_minh_chung,
          duong_dan: normalizeUrl(file.duong_dan),
          file: null,
        }));
        setEvidenceFiles(existingEvidence);
        setEvidencesToDelete([]);
        setShowEvidenceForm(true);
      } else {
        toast.push({ type: 'error', title: data?.message || 'Không thể tải chi tiết buổi tư vấn' });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Lỗi kết nối' });
    }
  };

  const handleSaveDraft = async () => {
    if (!selectedSession) return;

    try {
      setSaving(true);
      const formDataToSend = new FormData();
      formDataToSend.append('id_lichtuvan', String(selectedSession));
      formDataToSend.append('id_tuvanvien', String(consultantId));
      if (formData.noi_dung !== undefined && formData.noi_dung !== null) formDataToSend.append('noi_dung', formData.noi_dung);
      if (formData.ket_luan_nganh !== undefined && formData.ket_luan_nganh !== null) formDataToSend.append('ket_luan_nganh', formData.ket_luan_nganh);
      if (formData.muc_quan_tam !== undefined && formData.muc_quan_tam !== null) formDataToSend.append('muc_quan_tam', String(formData.muc_quan_tam));
      if (formData.diem_du_kien !== undefined && formData.diem_du_kien !== null && formData.diem_du_kien !== '') formDataToSend.append('diem_du_kien', String(formData.diem_du_kien));
      if (formData.yeu_cau_bo_sung) formDataToSend.append('yeu_cau_bo_sung', formData.yeu_cau_bo_sung);
      if (formData.tom_tat) formDataToSend.append('tom_tat', formData.tom_tat);
      formDataToSend.append('chia_se_voi_thisinh', formData.chia_se_voi_thisinh ? '1' : '0');
      if (selectedGroupId) formDataToSend.append('idnhomnganh', String(selectedGroupId)); // gửi kèm nhóm ngành (nếu BE hỗ trợ)

      let newEvidences = evidenceFiles.filter((ev) => ev.mode === 'new');
      const hasFormEvidence = evidenceForm.ten_file && evidenceForm.ten_file.trim() !== '' && 
                              (evidenceForm.file || (evidenceForm.duong_dan && evidenceForm.duong_dan.trim() !== '' && evidenceForm.duong_dan !== 'https://...'));
      if (hasFormEvidence) {
        newEvidences.push({
          clientId: `form-${Date.now()}`,
          mode: 'new', ten_file: evidenceForm.ten_file, loai_file: evidenceForm.loai_file, mo_ta: evidenceForm.mo_ta,
          la_minh_chung: evidenceForm.la_minh_chung,
          duong_dan: evidenceForm.file ? '' : evidenceForm.duong_dan,
          file: evidenceForm.file || null,
        });
      }
      
      newEvidences.forEach((ev, index) => {
        formDataToSend.append(`new_evidences[${index}][ten_file]`, ev.ten_file || '');
        formDataToSend.append(`new_evidences[${index}][loai_file]`, ev.loai_file || 'link');
        formDataToSend.append(`new_evidences[${index}][la_minh_chung]`, ev.la_minh_chung ? '1' : '0');
        formDataToSend.append(`new_evidences[${index}][mo_ta]`, ev.mo_ta || '');
        if (ev.file) formDataToSend.append(`new_evidences[${index}][file]`, ev.file);
        else if (ev.duong_dan && ev.duong_dan.trim() !== '' && ev.duong_dan !== 'https://...' && !ev.duong_dan.includes('https://...'))
          formDataToSend.append(`new_evidences[${index}][duong_dan]`, ev.duong_dan);
      });

      evidencesToDelete.forEach((id, index) => {
        formDataToSend.append(`remove_evidence_ids[${index}]`, String(id));
      });

      const token = localStorage.getItem('token');
      const response = await fetch(`${api.baseURL}/consultation-notes/draft`, {
        method: 'POST',
        headers: {
          Accept: 'application/json',
          ...(token && { Authorization: `Bearer ${token}` }),
        },
        body: formDataToSend,
      });

      if (!response.ok) {
        const errorText = await response.text();
        try {
          const errorData = JSON.parse(errorText);
          toast.push({ type: 'error', title: errorData.message || `Lỗi ${response.status}: Gửi thất bại` });
        } catch {
          toast.push({ type: 'error', title: `Lỗi ${response.status}: ${errorText || 'Không thể gửi'}` });
        }
        return;
      }

      const data = await response.json();
      if (data.success) {
        toast.push({ type: 'success', title: 'Gửi thành công' });
        setEvidencesToDelete([]);
        setShowFormAfterSubmit(false);
        if (data.data && data.data.id_ghichu) setCurrentGhiChuId(data.data.id_ghichu);
        if (hasFormEvidence) setEvidenceForm({ duong_dan: '', ten_file: '', loai_file: 'link', mo_ta: '', la_minh_chung: true, file: null });
        await fetchSessionDetail(selectedSession);
        await fetchSessions();
      } else {
        toast.push({ type: 'error', title: data.message || 'Gửi thất bại' });
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Lỗi kết nối: ' + error.message });
    } finally {
      setSaving(false);
    }
  };

  const handleAddEvidence = () => {
    if (!selectedSession) return;
    if (!evidenceForm.file && !evidenceForm.duong_dan) { toast.push({ type: 'error', title: 'Vui lòng chọn file hoặc nhập URL' }); return; }
    if (!evidenceForm.ten_file) { toast.push({ type: 'error', title: 'Vui lòng nhập tên file' }); return; }
    const newEvidence = {
      clientId: `new-${Date.now()}`,
      mode: 'new', ten_file: evidenceForm.ten_file, loai_file: evidenceForm.loai_file, mo_ta: evidenceForm.mo_ta,
      la_minh_chung: evidenceForm.la_minh_chung,
      duong_dan: evidenceForm.file ? '' : evidenceForm.duong_dan,
      file: evidenceForm.file || null,
    };
    setEvidenceFiles((prev) => [...prev, newEvidence]);
    setEvidenceForm({ duong_dan: '', ten_file: '', loai_file: 'link', mo_ta: '', la_minh_chung: true, file: null });
    toast.push({ type: 'success', title: 'Minh chứng đã được thêm. Nhấn "Gửi ngay" để lưu.' });
  };

  const handleDeleteEvidence = (evidence) => {
    if (!confirm('Bạn có chắc chắn muốn xóa minh chứng này?')) return;
    setEvidenceFiles((prev) => prev.filter((item) => item.clientId !== evidence.clientId));
    if (evidence.mode === 'existing' && evidence.id_file) setEvidencesToDelete((prev) => [...prev, evidence.id_file]);
  };

  const formatDate = (dateStr) => {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('vi-VN', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
  };

  const getStatusColor = (status) => ({
    'Chờ xử lý': 'bg-amber-100 text-amber-800',
      'Đã đặt lịch': 'bg-blue-100 text-blue-800',
      'Đã kết thúc': 'bg-green-100 text-green-800',
  }[status] || 'bg-gray-100 text-gray-800');

  const getApprovalInfo = (value) => ({
    '1': { text: 'Chờ duyệt', className: 'bg-amber-100 text-amber-700' },
    '2': { text: 'Đã duyệt', className: 'bg-emerald-100 text-emerald-700' },
    '3': { text: 'Từ chối', className: 'bg-rose-100 text-rose-700' },
  }[String(value)] || { text: 'Không xác định', className: 'bg-gray-100 text-gray-600' });

  const isImageFile = (file) => {
    if (!file) return false;
    const fileName = file.ten_file || file.name || '';
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.svg'];
    const lower = fileName.toLowerCase();
    if (imageExtensions.some((ext) => lower.endsWith(ext))) return true;
    if (file.loai_file === 'hinh_anh' || file.type?.startsWith('image/')) return true;
    return false;
  };

  const getImagePreviewUrl = (file) => {
    if (!file) return null;
    if (file.file && file.file instanceof File) return URL.createObjectURL(file.file);
    if (file.duong_dan) return normalizeUrl(file.duong_dan);
    return null;
  };

  const selectedSessionData = sessions.find((s) => s.id === selectedSession);
  const isApproved = sessionDetail?.session?.duyetlich === 2;
  const isChot = !!sessionDetail?.ghi_chu_chot;
  let canEditAfterChot = true;
  if (isChot && sessionDetail?.ghi_chu_chot?.thoi_han_sua_den) {
    const thoiHan = new Date(sessionDetail.ghi_chu_chot.thoi_han_sua_den);
    const now = new Date();
    canEditAfterChot = now < thoiHan;
  }
  const isReadOnly = viewMode === 'view' || (isChot && !canEditAfterChot);
  const shouldHideForm = !showFormAfterSubmit;
  const canEditForm = viewMode === 'input' && isApproved && !isReadOnly && showFormAfterSubmit;
  
  useEffect(() => { setShowEvidenceForm(!isReadOnly); }, [isReadOnly]);

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-emerald-600"></div>
      </div>
    );
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 mb-6">
        <h1 className="text-2xl font-bold text-gray-900">Ghi chú sau buổi</h1>
        <div className="flex gap-2">
          <button onClick={() => setViewMode('input')} className={`px-4 py-2 rounded-lg font-medium transition-colors text-sm ${viewMode === 'input' ? primaryBtn : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}`}>Nhập ghi chú</button>
          <button onClick={() => setViewMode('view')} className={`px-4 py-2 rounded-lg font-medium transition-colors text-sm ${viewMode === 'view' ? primaryBtn : 'bg-gray-200 text-gray-700 hover:bg-gray-300'}`}>Xem ghi chú đã gửi</button>
        </div>
      </div>

      {/* Filter */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 mb-6">
        <div className="flex items-center justify-between gap-4">
          <h2 className="font-semibold text-gray-900 text-base">Danh sách buổi</h2>
            <div className="flex flex-wrap gap-1.5">
              {[
                { value: '', label: 'Tất cả' },
                { value: 'today', label: 'Hôm nay' },
                { value: 'week', label: 'Tuần này' },
                { value: 'month', label: 'Tháng này' },
                { value: 'past', label: 'Đã qua' },
                { value: 'future', label: 'Sắp tới' },
            ].map((opt) => (
              <button key={opt.value} onClick={() => setDateFilter(opt.value)} className={`px-3 py-1.5 rounded-lg border text-sm ${dateFilter === opt.value ? pillActive : pill}`}>{opt.label}</button>
            ))}
          </div>
        </div>
      </div>

      <div className="grid lg:grid-cols-4 gap-6">
        {/* Sidebar */}
        <div className="lg:col-span-1">
          <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-4 sticky top-4">
            <div className="space-y-2 max-h-[calc(100vh-280px)] overflow-y-auto pr-1">
              {sessions.length === 0 ? (
                <p className="text-xs text-gray-500 text-center py-4">{viewMode === 'view' ? 'Không có ghi chú đã gửi.' : 'Không có buổi phù hợp bộ lọc.'}</p>
              ) : (
                sessions.map((s) => (
                  <button key={s.id} onClick={() => setSelectedSession(s.id)} className={`w-full text-left p-2.5 rounded-lg border text-xs ${selectedSession === s.id ? 'bg-emerald-50 border-emerald-500' : 'bg-white border-gray-200 hover:bg-gray-50 hover:border-gray-300'}`}>
                    <div className="text-xs font-semibold text-gray-900">{s.ngayhen ? new Date(s.ngayhen).toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' }) : 'Chưa có ngày'}</div>
                    <div className="text-xs text-gray-600 mt-1">{s.thisinhten || 'Chưa có thí sinh'}</div>
                  </button>
                ))
              )}
            </div>
          </div>
        </div>

        {/* Main content */}
        <div className="lg:col-span-3">
          {!selectedSession || !sessionDetail ? (
            <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-12 text-center text-gray-500">Chọn một buổi tư vấn</div>
          ) : (
            <div className="space-y-4">
              {/* Session header */}
              <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5">
                <div className="flex justify-between items-start mb-3">
                  <h2 className="text-lg font-semibold">{sessionDetail.session.ngayhen ? formatDate(sessionDetail.session.ngayhen) : 'Chưa có ngày'} — {sessionDetail.session.thisinhten || 'Chưa có thí sinh'}</h2>
                  <div className="flex gap-2 items-center">
                    <span className={`px-3 py-1 rounded-full text-xs ${getStatusColor(sessionDetail.session.tinhtrang)}`}>{sessionDetail.session.tinhtrang}</span>
                    <span className={`px-3 py-1 rounded-full text-xs ${getApprovalInfo(sessionDetail.session.duyetlich).className}`}>{getApprovalInfo(sessionDetail.session.duyetlich).text}</span>
                    {sessionDetail.ghi_chu_chot && <span className="px-3 py-1 rounded-full text-xs bg-green-100 text-green-800">ĐÃ CHỐT</span>}
                  </div>
                </div>
              </div>

              {/* Form */}
              {!(!showFormAfterSubmit) && (
              <div className="bg-white rounded-xl shadow-sm border border-gray-200 p-5">
                  <h3 className="font-semibold text-lg text-gray-900 mb-4">Ghi chú buổi họp và minh chứng</h3>

                  <div className="mb-4">
                    <label className="block text-sm font-medium mb-2 text-gray-700">Nội dung ghi chú *</label>
                    <textarea rows={5} className={`w-full px-3 py-2 border rounded-lg ${primaryRing}`} placeholder="Nhập nội dung ghi chú..." value={formData.noi_dung} onChange={(e) => setFormData({ ...formData, noi_dung: e.target.value })} disabled={!canEditForm} />
                </div>
                
                  <div className="grid md:grid-cols-2 gap-4 mb-4">
                    {/* Nhóm ngành */}
                  <div>
                      <label className="block text-sm font-medium mb-2 text-gray-700">Nhóm ngành</label>
                      <select value={selectedGroupId} onChange={(e) => setSelectedGroupId(e.target.value)} className={`w-full px-3 py-2 border rounded-lg ${primaryRing}`} disabled={!canEditForm}>
                        <option value="">Chọn nhóm ngành</option>
                        {majorGroups.map((g) => (
                          <option key={g.id} value={g.id}>{g.name}</option>
                        ))}
                      </select>
                    </div>
                    {/* Định hướng ngành */}
                      <div>
                        <label className="block text-sm font-medium mb-2 text-gray-700">Định hướng ngành *</label>
                      <input type="text" className={`w-full px-3 py-2 border rounded-lg ${primaryRing}`} placeholder="Ví dụ: Công nghệ Thông tin" value={formData.ket_luan_nganh} onChange={(e) => setFormData({ ...formData, ket_luan_nganh: e.target.value })} disabled={!canEditForm} />
                      </div>
                      <div>
                      <label className="block text-sm font-medium mb-2 text-gray-700">Mức quan tâm: {formData.muc_quan_tam}/5</label>
                      <input type="range" min="1" max="5" value={formData.muc_quan_tam} onChange={(e) => setFormData({ ...formData, muc_quan_tam: parseInt(e.target.value) })} className="w-full accent-emerald-600" disabled={!canEditForm} />
                      </div>
                      <div>
                        <label className="block text-sm font-medium mb-2 text-gray-700">Điểm dự kiến</label>
                      <input type="number" step="0.01" min="0" max="30" className={`w-full px-3 py-2 border rounded-lg ${primaryRing}`} value={formData.diem_du_kien} onChange={(e) => setFormData({ ...formData, diem_du_kien: e.target.value })} disabled={!canEditForm} />
                    </div>
                    <div>
                      <label className="block text-sm font-medium mb-2 text-gray-700">Yêu cầu bổ sung</label>
                      <input type="text" className={`w-full px-3 py-2 border rounded-lg ${primaryRing}`} value={formData.yeu_cau_bo_sung} onChange={(e) => setFormData({ ...formData, yeu_cau_bo_sung: e.target.value })} disabled={!canEditForm} />
                    </div>
                  </div>

                  {/* Minh chứng */}
                  <div className="border-t border-gray-200 pt-4">
                    <h4 className="text-sm font-semibold text-gray-700 mb-3">Tệp đính kèm / Minh chứng</h4>

                    {showEvidenceForm && (
                      <div className="mb-4 p-4 bg-gray-50 rounded-lg space-y-3 border border-gray-200">
                        <input type="file" accept="image/*,video/*,.pdf" onChange={(e) => {
                          const file = e.target.files?.[0];
                              if (file) {
                            setEvidenceForm({ ...evidenceForm, file, ten_file: file.name, loai_file: file.type.startsWith('image/') ? 'hinh_anh' : file.type.startsWith('video/') ? 'video' : file.type === 'application/pdf' ? 'pdf' : 'link', duong_dan: '' });
                          }
                        }} className={`w-full px-3 py-2 border rounded-lg text-sm ${primaryRing}`} />
                        <input type="text" placeholder="Hoặc nhập URL (https://...)" className={`w-full px-3 py-2 border rounded-lg text-sm ${primaryRing}`} value={evidenceForm.duong_dan} onChange={(e) => setEvidenceForm({ ...evidenceForm, duong_dan: e.target.value, file: null })} />
                        <input type="text" placeholder="Tên file *" className={`w-full px-3 py-2 border rounded-lg text-sm ${primaryRing}`} value={evidenceForm.ten_file} onChange={(e) => setEvidenceForm({ ...evidenceForm, ten_file: e.target.value })} />
                        <div className="grid md:grid-cols-2 gap-3">
                          <select className={`w-full px-3 py-2 border rounded-lg text-sm ${primaryRing}`} value={evidenceForm.loai_file} onChange={(e) => setEvidenceForm({ ...evidenceForm, loai_file: e.target.value })}>
                              <option value="link">Link</option>
                              <option value="hinh_anh">Hình ảnh</option>
                              <option value="video">Video</option>
                              <option value="pdf">PDF</option>
                            </select>
                          <input type="text" placeholder="Mô tả" className={`w-full px-3 py-2 border rounded-lg text-sm ${primaryRing}`} value={evidenceForm.mo_ta} onChange={(e) => setEvidenceForm({ ...evidenceForm, mo_ta: e.target.value })} />
                        </div>
                        <label className="text-sm inline-flex items-center gap-2">
                          <input type="checkbox" checked={evidenceForm.la_minh_chung} onChange={(e) => setEvidenceForm({ ...evidenceForm, la_minh_chung: e.target.checked })} />
                          Là minh chứng
                        </label>
                        <div className="flex justify-end">
                          <button type="button" onClick={handleAddEvidence} className={`px-4 py-2 rounded-lg ${primaryBtn}`}>Thêm vào danh sách</button>
                      </div>
                    </div>
                    )}

                    {/* Danh sách minh chứng */}
                    <div className="space-y-2">
                      {evidenceFiles.length === 0 ? (
                        <p className="text-sm text-gray-500">Chưa có minh chứng nào</p>
                      ) : (
                        evidenceFiles.map((file) => {
                          const isImg = isImageFile(file);
                          const imageUrl = isImg ? getImagePreviewUrl(file) : null;
                          return (
                            <div key={file.clientId} className={`p-3 bg-gray-50 rounded-lg ${isImg ? 'space-y-2' : ''}`}>
                              <div className="flex items-center justify-between">
                                <div className="flex-1">
                                  {file.duong_dan ? (
                                    <a href={normalizeUrl(file.duong_dan)} target="_blank" rel="noopener noreferrer" className="text-sm font-medium text-emerald-600 hover:underline">{file.ten_file}</a>
                                  ) : (
                                    <span className="text-sm font-medium text-gray-700">{file.ten_file}</span>
                                  )}
                                  {file.mode === 'new' && (<span className="ml-2 text-[11px] px-2 py-0.5 rounded-full bg-amber-100 text-amber-700">⏳ Chưa lưu</span>)}
                                  {file.mo_ta && <div className="text-xs text-gray-500 mt-1">{file.mo_ta}</div>}
                                  <div className="text-xs text-gray-400 mt-1">{file.loai_file} {file.la_minh_chung && '• Minh chứng'}</div>
                                </div>
                                {canEditForm && (
                                  <button onClick={() => handleDeleteEvidence(file)} className="text-rose-600 hover:text-rose-800 text-sm ml-2">Xóa</button>
                                )}
                              </div>
                              {isImg && imageUrl && (
                                <div className="mt-2">
                                  <img src={imageUrl} alt={file.ten_file || 'Preview'} className="max-w-full h-auto max-h-64 rounded border" onError={(e) => { e.currentTarget.style.display = 'none'; }} />
                                </div>
                              )}
                            </div>
                          );
                        })
                      )}
                    </div>
                  </div>

                  {/* Nút gửi */}
                  <div className="flex gap-3 justify-end items-center border-t border-gray-200 pt-4">
                    {evidenceFiles.filter((ev) => ev.mode === 'new').length > 0 && (
                      <span className="text-xs text-emerald-700 mr-auto">📎 Có {evidenceFiles.filter((ev) => ev.mode === 'new').length} minh chứng mới chưa lưu</span>
                    )}
                    {canEditForm ? (
                      <button onClick={handleSaveDraft} disabled={saving} className={`px-6 py-2.5 rounded-lg ${primaryBtn} disabled:bg-gray-400`}>{saving ? 'Đang gửi...' : 'Gửi ngay'}</button>
                    ) : (
                      <div className="text-sm text-gray-500 italic">Biên bản đã khóa hoặc chưa đủ điều kiện chỉnh sửa.</div>
                    )}
                </div>
              </div>
              )}
      </div>
          )}
        </div>
      </div>
    </div>
  );
}
