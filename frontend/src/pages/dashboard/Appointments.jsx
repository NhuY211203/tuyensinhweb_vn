import { useState, useEffect, useRef } from "react";
import { 
  Calendar, 
  Clock, 
  Users, 
  MapPin, 
  Video, 
  Phone, 
  User,
  CheckCircle,
  Loader2,
  AlertCircle,
  Search,
  Filter,
  TrendingUp,
  Star,
  ArrowLeft,
  ChevronRight,
  Sparkles
} from "lucide-react";
import apiService from "../../services/api";
import PaymentModal from "../../components/PaymentModal";

export default function Appointments() {
  const [selectedCategory, setSelectedCategory] = useState(null);
  const [showBookingModal, setShowBookingModal] = useState(false);
  const [showPaymentModal, setShowPaymentModal] = useState(false);
  const [selectedConsultant, setSelectedConsultant] = useState(null);
  const [selectedSlot, setSelectedSlot] = useState(null);
  const [bookingData, setBookingData] = useState(null);
  // Drawer xem lịch tư vấn viên
  const [showScheduleDrawer, setShowScheduleDrawer] = useState(false);
  const [activeScheduleConsultant, setActiveScheduleConsultant] = useState(null);
  
  // Modal xem chi tiết đánh giá
  const [showRatingDetailModal, setShowRatingDetailModal] = useState(false);
  const [selectedConsultantForRating, setSelectedConsultantForRating] = useState(null);
  
  // State để quản lý việc hiển thị full bio cho từng consultant
  const [expandedBios, setExpandedBios] = useState({});

  // States cho API
  const [categories, setCategories] = useState([]);
  const [consultants, setConsultants] = useState([]);
  const [loading, setLoading] = useState(true);
  const [consultantsLoading, setConsultantsLoading] = useState(false);
  const [error, setError] = useState(null);
  // Lịch đã đặt của người dùng
  const [myAppointments, setMyAppointments] = useState([]);
  const [existingLoading, setExistingLoading] = useState(false);
  // Chat modal state
  const [showChatModal, setShowChatModal] = useState(false);
  const [chatSession, setChatSession] = useState(null); // { id, advisorId, advisorName, groupName, roomId }
  const [chatMessages, setChatMessages] = useState([]);
  const [chatInput, setChatInput] = useState('');
  const [uploading, setUploading] = useState(false);
  const [attachedFile, setAttachedFile] = useState(null);
  const fileInputRef = useRef(null);
  // Thông báo chat mới theo lịch (appointmentId -> boolean)
  const [newChatMap, setNewChatMap] = useState({});

  // Rating states
  const [ratingMap, setRatingMap] = useState({}); // { [scheduleId]: { iddanhgia, diemdanhgia, nhanxet, an_danh } }
  const [showRatingModal, setShowRatingModal] = useState(false);
  const [ratingMode, setRatingMode] = useState('create'); // 'create' | 'edit' | 'view'
  const [ratingSchedule, setRatingSchedule] = useState(null); // appt item
  const [ratingForm, setRatingForm] = useState({ diemdanhgia: 5, nhanxet: '', an_danh: 0, iddanhgia: null });
  
  // Consultation notes states
  const [showNotesModal, setShowNotesModal] = useState(false);
  const [notesData, setNotesData] = useState(null);
  const [notesLoading, setNotesLoading] = useState(false);
  const [selectedAppointmentForNotes, setSelectedAppointmentForNotes] = useState(null);
  
  // States cho tìm kiếm và lọc
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState('popularity'); // popularity, consultants, alphabetical
  const [showFeatured, setShowFeatured] = useState(true);
  // Chế độ xem: 'existing' (đã có lịch) | 'new' (đặt lịch mới)
  const [viewMode, setViewMode] = useState('existing');

  // Icon mapping cho các nhóm ngành - Cập nhật theo đề xuất mới
  const getCategoryIcon = (categoryName) => {
    // Kiểm tra null/undefined
    if (!categoryName || typeof categoryName !== 'string') {
      return '📚'; // Default icon
    }

    const iconMap = {
      // Công nghệ thông tin
      'Công nghệ thông tin': '💻',
      'Công nghệ': '💻',
      'Thông tin': '💻',
      'IT': '💻',
      
      // Kinh tế - Quản lý
      'Kinh tế': '📈',
      'Quản lý': '📈',
      'Quản trị': '📈',
      'Kinh doanh': '📈',
      
      // Kỹ thuật - Công nghệ
      'Kỹ thuật': '⚙️',
      'Công nghệ': '⚙️',
      'Kỹ thuật công nghệ': '⚙️',
      'Cơ khí': '⚙️',
      'Xây dựng': '⚙️',
      
      // Năng lượng - Bền vững
      'Năng lượng': '☀️',
      'Bền vững': '☀️',
      'Môi trường': '☀️',
      'Năng lượng bền vững': '☀️',
      
      // Ngoại ngữ - Quốc tế
      'Ngoại ngữ': '🌍',
      'Quốc tế': '🌍',
      'Ngôn ngữ': '🌍',
      'Văn học': '🌍',
      'Tiếng Anh': '🌍',
      
      // Sáng tạo - Truyền thông
      'Sáng tạo': '🎨',
      'Truyền thông': '🎨',
      'Nghệ thuật': '🎨',
      'Thiết kế': '🎨',
      'Media': '🎨',
      
      // Thương mại - Logistics
      'Thương mại': '🚚',
      'Logistics': '🚚',
      'Vận tải': '🚚',
      'Du lịch': '🚚',
      'Dịch vụ': '🚚',
      
      // Y tế - Sức khỏe
      'Y tế': '🩺',
      'Sức khỏe': '🩺',
      'Y học': '🩺',
      'Dược': '🩺',
      
      // Giáo dục - Đào tạo
      'Giáo dục': '📚',
      'Đào tạo': '📚',
      'Sư phạm': '📚'
    };
    
    // Tìm kiếm chính xác trước
    if (iconMap[categoryName]) {
      return iconMap[categoryName];
    }
    
    // Tìm kiếm theo từ khóa
    for (const [key, icon] of Object.entries(iconMap)) {
      if (categoryName.toLowerCase().includes(key.toLowerCase())) {
        return icon;
      }
    }
    
    return '📚'; // Default icon
  };

  // Color mapping cho các nhóm ngành - Tone màu riêng cho mỗi ngành với gradient
  const getCategoryColor = (categoryName) => {
    // Kiểm tra null/undefined
    if (!categoryName || typeof categoryName !== 'string') {
      return 'bg-gradient-to-br from-gray-50 to-slate-50 border-gray-300 hover:border-gray-400';
    }

    const colorMap = {
      // Công nghệ thông tin - Xanh dương gradient (tech)
      'Công nghệ thông tin': 'bg-gradient-to-br from-blue-50 to-cyan-50 border-blue-300 hover:border-blue-400',
      'Công nghệ': 'bg-gradient-to-br from-blue-50 to-cyan-50 border-blue-300 hover:border-blue-400',
      'Thông tin': 'bg-gradient-to-br from-blue-50 to-cyan-50 border-blue-300 hover:border-blue-400',
      'IT': 'bg-gradient-to-br from-blue-50 to-cyan-50 border-blue-300 hover:border-blue-400',
      
      // Kinh tế - Quản lý - Vàng gradient (kinh tế)
      'Kinh tế': 'bg-gradient-to-br from-yellow-50 to-amber-50 border-yellow-300 hover:border-yellow-400',
      'Quản lý': 'bg-gradient-to-br from-yellow-50 to-amber-50 border-yellow-300 hover:border-yellow-400',
      'Quản trị': 'bg-gradient-to-br from-yellow-50 to-amber-50 border-yellow-300 hover:border-yellow-400',
      'Kinh doanh': 'bg-gradient-to-br from-yellow-50 to-amber-50 border-yellow-300 hover:border-yellow-400',
      
      // Kỹ thuật - Công nghệ - Xám gradient (kỹ thuật)
      'Kỹ thuật': 'bg-gradient-to-br from-gray-50 to-slate-50 border-gray-300 hover:border-gray-400',
      'Kỹ thuật công nghệ': 'bg-gradient-to-br from-gray-50 to-slate-50 border-gray-300 hover:border-gray-400',
      'Cơ khí': 'bg-gradient-to-br from-gray-50 to-slate-50 border-gray-300 hover:border-gray-400',
      'Xây dựng': 'bg-gradient-to-br from-gray-50 to-slate-50 border-gray-300 hover:border-gray-400',
      
      // Năng lượng - Bền vững - Xanh lá gradient (xanh, bền vững)
      'Năng lượng': 'bg-gradient-to-br from-green-50 to-emerald-50 border-green-300 hover:border-green-400',
      'Bền vững': 'bg-gradient-to-br from-green-50 to-emerald-50 border-green-300 hover:border-green-400',
      'Môi trường': 'bg-gradient-to-br from-green-50 to-emerald-50 border-green-300 hover:border-green-400',
      'Năng lượng bền vững': 'bg-gradient-to-br from-green-50 to-emerald-50 border-green-300 hover:border-green-400',
      
      // Ngoại ngữ - Quốc tế - Tím gradient (quốc tế, đa văn hóa)
      'Ngoại ngữ': 'bg-gradient-to-br from-purple-50 to-violet-50 border-purple-300 hover:border-purple-400',
      'Quốc tế': 'bg-gradient-to-br from-purple-50 to-violet-50 border-purple-300 hover:border-purple-400',
      'Ngôn ngữ': 'bg-gradient-to-br from-purple-50 to-violet-50 border-purple-300 hover:border-purple-400',
      'Văn học': 'bg-gradient-to-br from-purple-50 to-violet-50 border-purple-300 hover:border-purple-400',
      'Tiếng Anh': 'bg-gradient-to-br from-purple-50 to-violet-50 border-purple-300 hover:border-purple-400',
      
      // Sáng tạo - Truyền thông - Hồng gradient (sáng tạo, nghệ thuật)
      'Sáng tạo': 'bg-gradient-to-br from-pink-50 to-rose-50 border-pink-300 hover:border-pink-400',
      'Truyền thông': 'bg-gradient-to-br from-pink-50 to-rose-50 border-pink-300 hover:border-pink-400',
      'Nghệ thuật': 'bg-gradient-to-br from-pink-50 to-rose-50 border-pink-300 hover:border-pink-400',
      'Thiết kế': 'bg-gradient-to-br from-pink-50 to-rose-50 border-pink-300 hover:border-pink-400',
      'Media': 'bg-gradient-to-br from-pink-50 to-rose-50 border-pink-300 hover:border-pink-400',
      
      // Thương mại - Logistics - Cam gradient (thương mại, năng động)
      'Thương mại': 'bg-gradient-to-br from-orange-50 to-red-50 border-orange-300 hover:border-orange-400',
      'Logistics': 'bg-gradient-to-br from-orange-50 to-red-50 border-orange-300 hover:border-orange-400',
      'Vận tải': 'bg-gradient-to-br from-orange-50 to-red-50 border-orange-300 hover:border-orange-400',
      'Du lịch': 'bg-gradient-to-br from-orange-50 to-red-50 border-orange-300 hover:border-orange-400',
      'Dịch vụ': 'bg-gradient-to-br from-orange-50 to-red-50 border-orange-300 hover:border-orange-400',
      
      // Y tế - Sức khỏe - Đỏ gradient (y tế, sức khỏe)
      'Y tế': 'bg-gradient-to-br from-red-50 to-pink-50 border-red-300 hover:border-red-400',
      'Sức khỏe': 'bg-gradient-to-br from-red-50 to-pink-50 border-red-300 hover:border-red-400',
      'Y học': 'bg-gradient-to-br from-red-50 to-pink-50 border-red-300 hover:border-red-400',
      'Dược': 'bg-gradient-to-br from-red-50 to-pink-50 border-red-300 hover:border-red-400',
      
      // Giáo dục - Đào tạo - Xanh cyan gradient (giáo dục, tri thức)
      'Giáo dục': 'bg-gradient-to-br from-cyan-50 to-teal-50 border-cyan-300 hover:border-cyan-400',
      'Đào tạo': 'bg-gradient-to-br from-cyan-50 to-teal-50 border-cyan-300 hover:border-cyan-400',
      'Sư phạm': 'bg-gradient-to-br from-cyan-50 to-teal-50 border-cyan-300 hover:border-cyan-400'
    };
    
    // Tìm kiếm chính xác trước
    if (colorMap[categoryName]) {
      return colorMap[categoryName];
    }
    
    // Tìm kiếm theo từ khóa
    for (const [key, color] of Object.entries(colorMap)) {
      if (categoryName.toLowerCase().includes(key.toLowerCase())) {
        return color;
      }
    }
    
    // Fallback colors nếu không tìm thấy
    const fallbackColors = [
      'bg-gradient-to-br from-indigo-50 to-blue-50 border-indigo-300 hover:border-indigo-400',
      'bg-gradient-to-br from-teal-50 to-green-50 border-teal-300 hover:border-teal-400',
      'bg-gradient-to-br from-amber-50 to-yellow-50 border-amber-300 hover:border-amber-400',
      'bg-gradient-to-br from-rose-50 to-pink-50 border-rose-300 hover:border-rose-400'
    ];
    return fallbackColors[Math.floor(Math.random() * fallbackColors.length)];
  };

  // Helper functions cho tìm kiếm và lọc
  const getFilteredCategories = () => {
    let filtered = categories;
    
    // Lọc theo từ khóa tìm kiếm
    if (searchTerm) {
      filtered = filtered.filter(category => 
        category.name.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }
    
    // Sắp xếp theo tiêu chí
    switch (sortBy) {
      case 'consultants':
        filtered = filtered.sort((a, b) => b.consultants - a.consultants);
        break;
      case 'alphabetical':
        filtered = filtered.sort((a, b) => a.name.localeCompare(b.name));
        break;
      case 'popularity':
      default:
        // Giả lập độ phổ biến dựa trên số lượng tư vấn viên
        filtered = filtered.sort((a, b) => b.consultants - a.consultants);
        break;
    }
    
    return filtered;
  };

  const getCategoryTrend = (categoryName) => {
    // Kiểm tra null/undefined
    if (!categoryName || typeof categoryName !== 'string') {
      return { trend: 'Ổn định', icon: '📊', color: 'text-gray-500' };
    }

    const trendMap = {
      'Công nghệ thông tin': { trend: 'Hot 2025', icon: '🔥', color: 'text-red-500' },
      'Kinh tế': { trend: 'Xu hướng', icon: '📈', color: 'text-green-500' },
      'Y tế': { trend: 'Nhu cầu cao', icon: '🩺', color: 'text-blue-500' },
      'Sáng tạo': { trend: 'Mới nổi', icon: '✨', color: 'text-purple-500' },
      'Ngoại ngữ': { trend: 'Toàn cầu', icon: '🌍', color: 'text-indigo-500' }
    };
    
    for (const [key, value] of Object.entries(trendMap)) {
      if (categoryName.toLowerCase().includes(key.toLowerCase())) {
        return value;
      }
    }
    
    return { trend: 'Ổn định', icon: '📊', color: 'text-gray-500' };
  };

  // Load danh sách nhóm ngành
  useEffect(() => {
    const loadCategories = async () => {
      try {
        setLoading(true);
        setError(null);
        const response = await apiService.getMajorGroups();
        
        if (response.success && response.data && Array.isArray(response.data)) {
          const formattedCategories = response.data
            .filter(category => category && category.tennhom) // Lọc bỏ các category không hợp lệ
            .map((category) => ({
              id: category.id || Math.random().toString(36).substr(2, 9),
              name: category.tennhom || 'Nhóm ngành không xác định',
              icon: getCategoryIcon(category.tennhom),
              consultants: category.so_tu_van_vien || 0,
              color: getCategoryColor(category.tennhom)
            }));
          setCategories(formattedCategories);
        } else {
          setError('Dữ liệu nhóm ngành không hợp lệ');
        }
      } catch (err) {
        setError('Không thể tải danh sách nhóm ngành');
        console.error('Error loading categories:', err);
      } finally {
        setLoading(false);
      }
    };

    loadCategories();
  }, []);

  // Load danh sách lịch theo chế độ xem
  useEffect(() => {
    if (viewMode === 'existing' || viewMode === 'completed') {
      const loadMyAppointments = async () => {
        try {
          setExistingLoading(true);
          setError(null);
          const params = viewMode === 'completed' ? { status: 'completed' } : {};
          const res = await apiService.getMyAppointments(params);
          if (res.success) {
            setMyAppointments(Array.isArray(res.data) ? res.data : []);
          } else {
            setMyAppointments([]);
          }
        } catch (e) {
          console.error('Error loading my appointments:', e);
          setError('Không thể tải danh sách lịch đã đặt');
        } finally {
          setExistingLoading(false);
        }
      };
      loadMyAppointments();
    }
  }, [viewMode]);

  // Load rating for each completed appointment
  useEffect(() => {
    const loadRatings = async () => {
      if (viewMode !== 'completed' || myAppointments.length === 0) return;
      try {
        const entries = await Promise.all(
          myAppointments.map(async (appt) => {
            try {
              const res = await apiService.getScheduleRating(appt.id);
              if (res.success && res.data) {
                return [appt.id, res.data];
              }
            } catch {}
            return [appt.id, null];
          })
        );
        const map = {};
        entries.forEach(([id, r]) => { if (r) map[id] = r; });
        setRatingMap(map);
      } catch (e) {
        console.error('Không thể tải đánh giá:', e);
      }
    };
    loadRatings();
  }, [viewMode, myAppointments]);

  // Helpers: chat storage by appointment id using localStorage
  const loadChat = (appointmentId) => {
    try {
      const raw = localStorage.getItem(`chat_${appointmentId}`);
      return raw ? JSON.parse(raw) : [];
    } catch (e) {
      return [];
    }
  };

  const saveChat = (appointmentId, messages) => {
    localStorage.setItem(`chat_${appointmentId}`, JSON.stringify(messages));
  };

  const openChat = async (appt) => {
    try {
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const userId = user.idnguoidung || user.id;
      const advisorId = appt.advisorId || appt.advisor_id;
      // Lấy hoặc tạo room
      const roomRes = await apiService.getOrCreateChatRoom(advisorId, userId, appt.id);
      const roomId = roomRes?.data?.roomId;
      const session = {
        id: appt.id,
        advisorId,
        advisorName: appt.advisorName,
        groupName: appt.groupName,
        roomId,
      };
      setChatSession(session);
      // Tải lịch sử tin nhắn từ server
      if (roomId) {
        const msgsRes = await apiService.getChatMessagesByRoom(roomId, { limit: 50 });
        const rows = Array.isArray(msgsRes?.data) ? msgsRes.data : [];
        const msgs = rows.map(r => {
          // Parse file/ảnh từ noi_dung
          let text = r.noi_dung || '';
          let file = null;
          
          const imageMatch = text.match(/\[IMAGE:([^\]]+)\]/);
          const fileMatch = text.match(/\[FILE:([^\]]+):([^\]]+)\]/);
          
          if (imageMatch) {
            file = { url: imageMatch[1], filename: null };
          } else if (fileMatch) {
            file = { url: fileMatch[1], filename: fileMatch[2] };
          }
          
          return {
            id: r.idtinnhan,
            sender: r.idnguoigui === userId ? (user.hoten || 'Bạn') : appt.advisorName,
            senderType: r.idnguoigui === userId ? 'user' : 'advisor',
            text: text,
            at: r.ngay_tao,
            file: file,
          };
        });
        setChatMessages(msgs);
      } else {
        setChatMessages([]);
      }
      setShowChatModal(true);
      setChatInput('');
      // Đánh dấu đã xem: lưu mốc thời gian/id cuối cùng
      if (roomId) {
        localStorage.setItem(`chat_last_seen_${roomId}`, String(Date.now()));
        setNewChatMap(prev => ({ ...prev, [appt.id]: false }));
      }
    } catch (e) {
      console.error('Open chat error:', e);
    }
  };

  const uploadFile = async (file) => {
    try {
      setUploading(true);
      const formData = new FormData();
      formData.append('file', file);

      const response = await fetch('http://localhost:8000/api/chat-support/upload-file', {
        method: 'POST',
        body: formData,
      });

      const data = await response.json();
      
      if (data.success) {
        return {
          url: data.data.url,
          filename: data.data.original_filename || file.name
        };
      } else {
        alert(data.message || 'Không thể upload file');
        return null;
      }
    } catch (error) {
      console.error('Error uploading file:', error);
      alert('Lỗi kết nối khi upload file: ' + error.message);
      return null;
    } finally {
      setUploading(false);
    }
  };

  const handleFileSelect = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    // Kiểm tra kích thước (max 10MB)
    if (file.size > 10 * 1024 * 1024) {
      alert('File quá lớn. Kích thước tối đa là 10MB');
      return;
    }

    // Kiểm tra loại file
    const allowedTypes = [
      'image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp',
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'text/plain', 'text/csv'
    ];
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'txt', 'csv'];
    const fileExtension = file.name.split('.').pop()?.toLowerCase();
    
    if (!allowedTypes.includes(file.type) && !allowedExtensions.includes(fileExtension)) {
      alert('Loại file không được hỗ trợ. Chỉ chấp nhận: ảnh (JPEG, PNG, GIF, WebP) và tài liệu (PDF, DOC, DOCX, XLS, XLSX, TXT, CSV)');
      return;
    }

    const fileResult = await uploadFile(file);
    if (fileResult && fileResult.url) {
      setAttachedFile({
        url: fileResult.url,
        filename: fileResult.filename || file.name
      });
    }
    
    // Reset file input
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };

  const sendChatMessage = async () => {
    if ((!chatInput.trim() && !attachedFile) || !chatSession?.roomId) return;
    const user = JSON.parse(localStorage.getItem('user') || '{}');
    const userId = user.idnguoidung || user.id;
    
    // Tạo nội dung tin nhắn
    let content = chatInput.trim();
    if (attachedFile) {
      const fileUrl = attachedFile.url;
      const fileName = attachedFile.filename || 'file';
      // Nếu là ảnh, thêm vào content với format đặc biệt
      if (fileUrl.match(/\.(jpg|jpeg|png|gif|webp)$/i)) {
        content = content ? `${content}\n[IMAGE:${fileUrl}]` : `[IMAGE:${fileUrl}]`;
      } else {
        content = content ? `${content}\n[FILE:${fileUrl}:${fileName}]` : `[FILE:${fileUrl}:${fileName}]`;
      }
    }
    
    const fileToSend = attachedFile;
    setChatInput('');
    setAttachedFile(null);
    
    try {
      const res = await apiService.sendChatMessageByRoom({ roomId: chatSession.roomId, senderId: userId, content });
      const r = res?.data;
      if (r) {
        const newMsg = {
          id: r.idtinnhan,
          sender: user.hoten || 'Bạn',
          senderType: 'user',
          text: r.noi_dung || content,
          at: r.ngay_tao || new Date().toISOString(),
          file: fileToSend ? { url: fileToSend.url, filename: fileToSend.filename } : null,
        };
        setChatMessages(prev => [...prev, newMsg]);
      }
    } catch (e) {
      console.error('Send chat error:', e);
      setChatInput(content.replace(/\[(IMAGE|FILE):[^\]]+\]/g, '').trim());
      setAttachedFile(fileToSend);
    }
  };

  // Polling khi modal chat đang mở
  useEffect(() => {
    if (!showChatModal || !chatSession?.roomId) return;
    const timer = setInterval(async () => {
      try {
        const res = await apiService.getChatMessagesByRoom(chatSession.roomId, { limit: 50 });
        const rows = Array.isArray(res?.data) ? res.data : [];
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const userId = user.idnguoidung || user.id;
        const msgs = rows.map(r => {
          // Parse file/ảnh từ noi_dung
          let text = r.noi_dung || '';
          let file = null;
          
          const imageMatch = text.match(/\[IMAGE:([^\]]+)\]/);
          const fileMatch = text.match(/\[FILE:([^\]]+):([^\]]+)\]/);
          
          if (imageMatch) {
            file = { url: imageMatch[1], filename: null };
          } else if (fileMatch) {
            file = { url: fileMatch[1], filename: fileMatch[2] };
          }
          
          return {
            id: r.idtinnhan,
            sender: r.idnguoigui === userId ? (user.hoten || 'Bạn') : chatSession.advisorName,
            senderType: r.idnguoigui === userId ? 'user' : 'advisor',
            text: text,
            at: r.ngay_tao,
            file: file,
          };
        });
        // Chỉ cập nhật nếu có thay đổi về id cuối
        const lastId = chatMessages[chatMessages.length - 1]?.id;
        const newLastId = msgs[msgs.length - 1]?.id;
        if (msgs.length !== chatMessages.length || lastId !== newLastId) {
          setChatMessages(msgs);
        }
      } catch (e) {}
    }, 3000);
    return () => clearInterval(timer);
  }, [showChatModal, chatSession?.roomId, chatMessages]);

  // Poll nhẹ khi ở tab "Đã có lịch" để cảnh báo có tin nhắn mới
  useEffect(() => {
    if (viewMode !== 'existing' || myAppointments.length === 0) return;
    let stop = false;
    const check = async () => {
      try {
        const user = JSON.parse(localStorage.getItem('user') || '{}');
        const userId = user.idnguoidung || user.id;
        // Tạo/lấy room và lấy tin cuối cùng cho từng lịch
        const results = await Promise.all(
          myAppointments.map(async (appt) => {
            try {
              const roomRes = await apiService.getOrCreateChatRoom(appt.advisorId || appt.advisor_id, userId, appt.id);
              const roomId = roomRes?.data?.roomId;
              if (!roomId) return [appt.id, false];
              const msgsRes = await apiService.getChatMessagesByRoom(roomId, { limit: 1 });
              const rows = Array.isArray(msgsRes?.data) ? msgsRes.data : [];
              const last = rows[rows.length - 1];
              const lastSeen = Number(localStorage.getItem(`chat_last_seen_${roomId}`) || 0);
              const hasNew = !!last && last.idnguoigui !== userId && new Date(last.ngay_tao).getTime() > lastSeen;
              return [appt.id, hasNew];
            } catch { return [appt.id, false]; }
          })
        );
        if (stop) return;
        const map = {};
        results.forEach(([id, flag]) => { map[id] = flag; });
        setNewChatMap(map);
      } catch {}
    };
    check();
    const timer = setInterval(check, 5000);
    return () => { stop = true; clearInterval(timer); };
  }, [viewMode, myAppointments]);

  // Load tư vấn viên khi chọn nhóm ngành
  useEffect(() => {
    if (selectedCategory) {
      const loadConsultants = async () => {
        try {
          setConsultantsLoading(true);
          setError(null);
          const response = await apiService.getConsultantsByMajorGroup(selectedCategory.id);
          
          if (response.success) {
            // Load available slots và ratings cho từng tư vấn viên
            const consultantsWithSlots = await Promise.all(
              response.data.map(async (consultant) => {
                try {
                  // Chỉ lấy lịch đã duyệt, còn trống và sau NGÀY hiện tại
                  const tomorrow = new Date();
                  tomorrow.setDate(tomorrow.getDate() + 1);
                  const tomorrowStr = tomorrow.toISOString().split('T')[0];
                  const slotsResponse = await apiService.getAvailableSlots(consultant.id, { duyetlich: 2, status: 1, start_date: tomorrowStr });
                  let availableSlots = [];
                  
                  if (slotsResponse.success && slotsResponse.data) {
                    // Chỉ lấy các lịch đã được duyệt (duyetlich = 2)
                    const approved = (Array.isArray(slotsResponse.data) ? slotsResponse.data : [])
                      .filter(slot => String(slot.duyetlich ?? slot.duyet) === '2' && String(slot.status ?? slot.trangthai) === '1');
                    // Format thời gian từ lịch tư vấn
                    availableSlots = approved.map(slot => {
                      const date = new Date(slot.ngayhen);
                      const time = slot.giobatdau;
                      return {
                        date: date.toISOString().split('T')[0],
                        time: time,
                        id: slot.idlichtuvan,
                        platform: slot.molavande || 'Google Meet',
                        meeting_link: slot.danhdanhgiadem || '',
                        notes: slot.noidung || ''
                      };
                    });
                  }
                  
                  // Load ratings cho tư vấn viên
                  let ratingData = { average_rating: 0, total_ratings: 0, reviews: [] };
                  try {
                    const ratingResponse = await apiService.getConsultantRating(consultant.id);
                    if (ratingResponse.success && ratingResponse.data) {
                      ratingData = ratingResponse.data;
                    }
                  } catch (ratingError) {
                    console.error(`Error loading ratings for consultant ${consultant.id}:`, ratingError);
                  }
                  
                  const fallbackAvatar = `https://ui-avatars.com/api/?name=${encodeURIComponent(consultant.hoten || consultant.name || 'TV')}&background=random`;
                  const avatarUrl = (consultant.avatar && typeof consultant.avatar === 'string' && consultant.avatar.trim()) ? consultant.avatar : fallbackAvatar;
                  
                  return {
                    id: consultant.id,
                    name: consultant.hoten,
                    avatar: avatarUrl,
                    bio: consultant.bio || '',
                    workplace: "Trường Đại học",
                    skills: ["Tư vấn", "Định hướng", "Học bổng"],
                    methods: ["Google Meet", "Zoom", "Trực tiếp"],
                    availableSlots: availableSlots,
                    averageRating: ratingData.average_rating || 0,
                    totalRatings: ratingData.total_ratings || 0,
                    reviews: ratingData.reviews || []
                  };
                } catch (slotError) {
                  console.error(`Error loading slots for consultant ${consultant.id}:`, slotError);
                  return {
              id: consultant.id,
              name: consultant.hoten,
              avatar: `https://ui-avatars.com/api/?name=${encodeURIComponent(consultant.hoten)}&background=random`,
                    workplace: "Trường Đại học",
                    skills: ["Tư vấn", "Định hướng", "Học bổng"],
                    methods: ["Google Meet", "Zoom", "Trực tiếp"],
                    availableSlots: [],
                    averageRating: 0,
                    totalRatings: 0,
                    reviews: []
                  };
                }
              })
            );
            
            setConsultants(consultantsWithSlots);
          }
        } catch (err) {
          setError('Không thể tải danh sách tư vấn viên');
          console.error('Error loading consultants:', err);
        } finally {
          setConsultantsLoading(false);
        }
      };

      loadConsultants();
    }
  }, [selectedCategory]);

  const handleCategorySelect = (category) => {
    setSelectedCategory(category);
  };

  const handleBookConsultant = (consultant) => {
    setSelectedConsultant(consultant);
    setSelectedSlot(null); // Reset selected slot when opening modal
    setShowBookingModal(true);
  };

  // Sắp xếp slot tăng dần theo ngày + giờ
  const sortSlotsAsc = (slots) => {
    return [...(slots || [])].sort((a, b) => {
      const aKey = `${a.date} ${a.time}`;
      const bKey = `${b.date} ${b.time}`;
      return new Date(aKey) - new Date(bKey);
    });
  };

  // Mở drawer xem lịch của tư vấn viên
  const openScheduleDrawer = (consultant) => {
    setActiveScheduleConsultant({
      ...consultant,
      availableSlots: sortSlotsAsc(consultant.availableSlots)
    });
    setShowScheduleDrawer(true);
  };

  const handleBackToCategories = () => {
    setSelectedCategory(null);
  };

  // Rating helpers
  const openCreateRating = (appt) => {
    setRatingMode('create');
    setRatingSchedule(appt);
    setRatingForm({ diemdanhgia: 5, nhanxet: '', an_danh: 0, iddanhgia: null });
    setShowRatingModal(true);
  };

  const openViewRating = (appt, r) => {
    setRatingMode('view');
    setRatingSchedule(appt);
    setRatingForm({ diemdanhgia: r.diemdanhgia || 5, nhanxet: r.nhanxet || '', an_danh: r.an_danh || 0, iddanhgia: r.iddanhgia });
    setShowRatingModal(true);
  };

  const openEditRating = (appt, r) => {
    setRatingMode('edit');
    setRatingSchedule(appt);
    setRatingForm({ diemdanhgia: r.diemdanhgia || 5, nhanxet: r.nhanxet || '', an_danh: r.an_danh || 0, iddanhgia: r.iddanhgia });
    setShowRatingModal(true);
  };

  const submitCreateRating = async () => {
    try {
      if (!ratingSchedule) return;
      const user = JSON.parse(localStorage.getItem('user') || '{}');
      const userId = user.idnguoidung || user.id;
      const payload = {
        idlichtuvan: ratingSchedule.id,
        idnguoidat: userId,
        diemdanhgia: Number(ratingForm.diemdanhgia),
        nhanxet: ratingForm.nhanxet,
        an_danh: Number(ratingForm.an_danh) || 0,
      };
      const res = await apiService.createScheduleRating(payload);
      if (res.success) {
        setRatingMap(prev => ({ ...prev, [ratingSchedule.id]: res.data }));
        setShowRatingModal(false);
      }
    } catch (e) {
      alert('Không thể lưu đánh giá: ' + (e.message || 'Lỗi không xác định'));
    }
  };

  const submitUpdateRating = async () => {
    try {
      if (!ratingForm.iddanhgia) return;
      const res = await apiService.updateScheduleRating(ratingForm.iddanhgia, {
        diemdanhgia: Number(ratingForm.diemdanhgia),
        nhanxet: ratingForm.nhanxet,
        an_danh: Number(ratingForm.an_danh) || 0,
      });
      if (res.success) {
        setRatingMap(prev => ({ ...prev, [ratingSchedule.id]: res.data }));
        setShowRatingModal(false);
      }
    } catch (e) {
      alert('Không thể cập nhật đánh giá: ' + (e.message || 'Lỗi không xác định'));
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-cyan-50">
      {/* Background Pattern */}
      <div className="absolute inset-0 opacity-30" style={{
        backgroundImage: `url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%239C92AC' fill-opacity='0.05'%3E%3Ccircle cx='30' cy='30' r='2'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E")`
      }}></div>
      
      <div className="relative max-w-7xl mx-auto p-6">
        {/* Enhanced Header */}
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-2xl shadow-lg">
              <Calendar className="w-8 h-8 text-white" />
            </div>
            <div>
              <h1 className="text-5xl font-bold bg-gradient-to-r from-gray-900 to-gray-700 bg-clip-text text-transparent">
                Đặt lịch tư vấn
              </h1>
              <p className="text-lg text-gray-600 mt-1">
                Tìm kiếm chuyên gia phù hợp với định hướng của bạn
              </p>
            </div>
          </div>
          
          {/* Chuyển đổi chế độ xem */}
          <div className="mb-4">
            <div className="inline-flex rounded-xl border border-gray-200 bg-white shadow-sm overflow-hidden">
              <button
                onClick={() => setViewMode('existing')}
                className={`px-4 py-2 text-sm font-semibold ${viewMode === 'existing' ? 'bg-blue-600 text-white' : 'text-gray-700 hover:bg-gray-50'}`}
              >
                Đã có lịch
              </button>
              <button
                onClick={() => setViewMode('completed')}
                className={`px-4 py-2 text-sm font-semibold border-l border-gray-200 ${viewMode === 'completed' ? 'bg-blue-600 text-white' : 'text-gray-700 hover:bg-gray-50'}`}
              >
                Đã tư vấn
              </button>
              <button
                onClick={() => setViewMode('new')}
                className={`px-4 py-2 text-sm font-semibold border-l border-gray-200 ${viewMode === 'new' ? 'bg-blue-600 text-white' : 'text-gray-700 hover:bg-gray-50'}`}
              >
                Chưa có lịch
              </button>
            </div>
          </div>

          {/* Progress Steps - chỉ hiện khi đặt lịch mới */}
          {viewMode === 'new' && (
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 shadow-lg border border-white/20">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className={`flex items-center gap-2 px-4 py-2 rounded-full ${
                  !selectedCategory ? 'bg-blue-100 text-blue-700 border-2 border-blue-300' : 'bg-gray-100 text-gray-500'
                }`}>
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold ${
                    !selectedCategory ? 'bg-blue-500 text-white' : 'bg-gray-300 text-gray-600'
                  }`}>
                    1
                  </div>
                  <span className="font-semibold">Chọn nhóm ngành</span>
                </div>
                
                <ChevronRight className="w-5 h-5 text-gray-400" />
                
                <div className={`flex items-center gap-2 px-4 py-2 rounded-full ${
                  selectedCategory ? 'bg-blue-100 text-blue-700 border-2 border-blue-300' : 'bg-gray-100 text-gray-500'
                }`}>
                  <div className={`w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold ${
                    selectedCategory ? 'bg-blue-500 text-white' : 'bg-gray-300 text-gray-600'
                  }`}>
                    2
                  </div>
                  <span className="font-semibold">Chọn tư vấn viên</span>
                </div>
                
                <ChevronRight className="w-5 h-5 text-gray-400" />
                
                <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-gray-100 text-gray-500">
                  <div className="w-6 h-6 rounded-full flex items-center justify-center text-sm font-bold bg-gray-300 text-gray-600">
                    3
                  </div>
                  <span className="font-semibold">Chọn thời gian</span>
                </div>
              </div>
              
              {/* Stats */}
              <div className="text-right">
                <div className="text-2xl font-bold text-gray-900">
                  {categories.reduce((sum, cat) => sum + cat.consultants, 0)}
                </div>
                <div className="text-sm text-gray-600">Tư vấn viên</div>
              </div>
            </div>
          </div>
          )}
        </div>

        {viewMode === 'existing' ? (
          /* Trang: Đã có lịch (sắp/đang tới) */
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 shadow-lg border border-white/20">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-2xl font-semibold text-gray-800">Lịch tư vấn của bạn</h2>
            </div>
            {existingLoading ? (
              <div className="flex items-center justify-center py-12">
                <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
                <span className="ml-2 text-gray-600">Đang tải...</span>
              </div>
            ) : myAppointments.length > 0 ? (
              <div className="space-y-3">
                {myAppointments.map((item) => (
                  <div key={item.id} className="flex items-center justify-between p-4 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-4">
                      <div className="p-2 bg-blue-50 rounded-lg">
                        <Calendar className="w-5 h-5 text-blue-600" />
                      </div>
                      <div>
                        <div className="font-semibold text-gray-800">{item.groupName}</div>
                        <div className="text-sm text-gray-600">{item.advisorName}</div>
                      </div>
                    </div>
                    <div className="flex items-center gap-4">
                      <div className="grid grid-cols-4 gap-6 text-sm text-gray-700">
                        <div className="flex items-center gap-2"><Clock className="w-4 h-4" />{new Date(item.date).toLocaleDateString('vi-VN')}</div>
                        <div className="flex items-center gap-2"><Clock className="w-4 h-4" />{item.start} - {item.end}</div>
                        <div className="flex items-center gap-2"><Video className="w-4 h-4" />{item.method || 'Trực tiếp'}</div>
                        <div className="flex items-center gap-2 truncate max-w-[260px]">
                          {item.joinLink ? (
                            <a href={item.joinLink} target="_blank" rel="noreferrer" className="text-blue-600 hover:underline truncate">Tham gia</a>
                          ) : (
                            <span className="text-gray-400">Chưa có link</span>
                          )}
                        </div>
                      </div>
                      <button
                        onClick={() => openChat(item)}
                        className="relative px-3 py-2 rounded-lg bg-green-600 text-white hover:bg-green-700 text-sm"
                      >
                        Trò chuyện cùng chuyên gia
                        {newChatMap[item.id] && (
                          <span className="absolute -top-1 -right-1 inline-flex items-center justify-center w-4 h-4 text-[10px] bg-red-500 text-white rounded-full">•</span>
                        )}
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-gray-600">
                Hiện bạn chưa có lịch tư vấn nào.
                <button
                  onClick={() => setViewMode('new')}
                  className="ml-2 inline-flex items-center px-3 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
                >
                  Đặt lịch ngay
                </button>
              </div>
            )}
          </div>
        ) : viewMode === 'completed' ? (
          /* Trang: Đã tư vấn (đã hoàn thành) */
          <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 shadow-lg border border-white/20">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-2xl font-semibold text-gray-800">Lịch đã tư vấn của bạn</h2>
            </div>
            {existingLoading ? (
              <div className="flex items-center justify-center py-12">
                <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
                <span className="ml-2 text-gray-600">Đang tải...</span>
              </div>
            ) : myAppointments.length > 0 ? (
              <div className="space-y-3">
                {myAppointments.map((item) => {
                  const r = ratingMap[item.id];
                  return (
                  <div key={item.id} className="flex items-center justify-between p-4 border border-gray-200 rounded-xl">
                    <div className="flex items-center gap-4">
                      <div className="p-2 bg-green-50 rounded-lg">
                        <CheckCircle className="w-5 h-5 text-green-600" />
                      </div>
                      <div>
                        <div className="font-semibold text-gray-800">{item.groupName}</div>
                        <div className="text-sm text-gray-600">{item.advisorName}</div>
                      </div>
                    </div>
                    <div className="flex items-center gap-4">
                      {/* Căn hàng theo độ rộng cố định để không bị lệch */}
                      <div className="flex items-center gap-6 text-sm text-gray-700">
                        <div className="flex items-center gap-2 w-28"><Clock className="w-4 h-4" />{new Date(item.date).toLocaleDateString('vi-VN')}</div>
                        <div className="flex items-center gap-2 w-28"><Clock className="w-4 h-4" />{item.start} - {item.end}</div>
                        <div className="flex items-center gap-2 w-36"><Video className="w-4 h-4" /><span className="truncate max-w-[120px]" title={item.method || 'Trực tiếp'}>{item.method || 'Trực tiếp'}</span></div>
                        <div className="flex items-center gap-2 text-green-700 w-24"><CheckCircle className="w-4 h-4" />Đã tư vấn</div>
                      </div>
                      {/* Nút đánh giá và xem nhận xét */}
                      <div className="flex items-center gap-2">
                        <button
                          onClick={async () => {
                            setSelectedAppointmentForNotes(item);
                            setShowNotesModal(true);
                            setNotesLoading(true);
                            try {
                              const res = await apiService.getConsultationNoteBySession(item.id);
                              if (res.success) {
                                setNotesData(res.data);
                              } else {
                                setNotesData(null);
                              }
                            } catch (e) {
                              console.error('Error loading notes:', e);
                              setNotesData(null);
                            } finally {
                              setNotesLoading(false);
                            }
                          }}
                          className="px-3 py-2 rounded-lg bg-teal-600 text-white hover:bg-teal-700 text-sm"
                        >
                          Xem nhận xét
                        </button>
                        {!r ? (
                          <button
                            onClick={() => { setRatingMode('create'); setRatingSchedule(item); setRatingForm({ diemdanhgia: 5, nhanxet: '', an_danh: 0, iddanhgia: null }); setShowRatingModal(true); }}
                            className="px-3 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 text-sm"
                          >
                            Đánh giá buổi tư vấn
                          </button>
                        ) : (
                          <div className="flex items-center gap-2">
                            <button
                              onClick={() => { setRatingMode('view'); setRatingSchedule(item); setRatingForm({ diemdanhgia: r.diemdanhgia, nhanxet: r.nhanxet, an_danh: r.an_danh, iddanhgia: r.iddanhgia }); setShowRatingModal(true); }}
                              className="px-3 py-2 rounded-lg bg-gray-100 hover:bg-gray-200 text-sm"
                            >
                              Xem đánh giá
                            </button>
                            <button
                              onClick={() => { setRatingMode('edit'); setRatingSchedule(item); setRatingForm({ diemdanhgia: r.diemdanhgia, nhanxet: r.nhanxet, an_danh: r.an_danh, iddanhgia: r.iddanhgia }); setShowRatingModal(true); }}
                              className="px-3 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 text-sm"
                            >
                              Sửa đánh giá
                            </button>
                          </div>
                        )}
                      </div>
                    </div>
                  </div>
                );})}
              </div>
            ) : (
              <div className="text-gray-600">
                Chưa có buổi tư vấn nào đã hoàn thành.
              </div>
            )}
          </div>
        ) : !selectedCategory ? (
          /* Bước 1: Chọn nhóm ngành */
          <div>
            {/* Featured Banner */}
            {showFeatured && (
              <div className="mb-8 bg-gradient-to-r from-purple-500 to-pink-500 rounded-2xl p-6 text-white shadow-xl">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-4">
                    <div className="p-3 bg-white/20 rounded-xl">
                      <Sparkles className="w-6 h-6" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold">Tư vấn viên nổi bật tuần này</h3>
                      <p className="text-purple-100">Công nghệ thông tin đang là xu hướng hot 2025!</p>
                    </div>
                  </div>
                  <button
                    onClick={() => setShowFeatured(false)}
                    className="text-white/80 hover:text-white"
                  >
                    ✕
                  </button>
                </div>
              </div>
            )}
            
            {/* Search and Filter */}
            <div className="bg-white/80 backdrop-blur-sm rounded-2xl p-6 shadow-lg border border-white/20 mb-8">
              <div className="flex flex-col lg:flex-row gap-4">
                {/* Search */}
                <div className="flex-1">
                  <div className="relative">
                    <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                    <input
                      type="text"
                      placeholder="🔍 Tìm nhanh nhóm ngành (CNTT, Kinh tế, Y tế...)"
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white/50"
                    />
                  </div>
                </div>
                
                {/* Sort Filter */}
                <div className="flex gap-2">
                  <select
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value)}
                    className="px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-blue-500 focus:border-transparent bg-white/50"
                  >
                    <option value="popularity">📈 Phổ biến</option>
                    <option value="consultants">👥 Nhiều tư vấn viên</option>
                    <option value="alphabetical">🔤 A-Z</option>
                  </select>
                  
                  <button className="px-4 py-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 transition-colors flex items-center gap-2">
                    <Filter className="w-4 h-4" />
                    Lọc
                  </button>
                </div>
              </div>
            </div>
            
            <h2 className="text-3xl font-bold text-gray-800 mb-6 flex items-center gap-3">
              <div className="p-2 bg-blue-100 rounded-lg">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
              Chọn nhóm ngành quan tâm
            </h2>
            
            {loading ? (
              <div className="flex items-center justify-center py-12">
                <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
                <span className="ml-2 text-gray-600">Đang tải danh sách nhóm ngành...</span>
              </div>
            ) : error ? (
              <div className="flex items-center justify-center py-12">
                <div className="text-center">
                  <AlertCircle className="w-12 h-12 text-red-500 mx-auto mb-4" />
                  <p className="text-red-600 mb-4">{error}</p>
                  <button
                    onClick={() => window.location.reload()}
                    className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                  >
                    Thử lại
                  </button>
                </div>
              </div>
            ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
              {getFilteredCategories().map((category) => {
                const trend = getCategoryTrend(category.name);
                return (
                  <div
                    key={category.id}
                    onClick={() => handleCategorySelect(category)}
                    className={`
                      ${category.color} border-2 rounded-2xl p-6 cursor-pointer
                      hover:shadow-xl hover:scale-105 transition-all duration-300
                      group relative overflow-hidden
                    `}
                  >
                    {/* Trend Badge */}
                    <div className={`absolute top-3 right-3 px-2 py-1 rounded-full text-xs font-semibold ${trend.color} bg-white/80 backdrop-blur-sm`}>
                      <span className="flex items-center gap-1">
                        {trend.icon} {trend.trend}
                      </span>
                    </div>
                    
                    <div className="text-center">
                      <div className="text-5xl mb-4 group-hover:scale-110 transition-transform duration-300">
                        {category.icon}
                      </div>
                      <h3 className="font-bold text-gray-800 mb-2 text-lg">{category.name}</h3>
                      <div className="space-y-2">
                        <p className="text-sm text-gray-600 flex items-center justify-center gap-1">
                          <Users className="w-4 h-4" />
                          {category.consultants} tư vấn viên
                        </p>
                        <div className="text-xs text-gray-500">
                          Nhấn để xem chi tiết
                        </div>
                      </div>
                    </div>
                    
                    {/* Hover Effect */}
                    <div className="absolute inset-0 bg-gradient-to-br from-white/0 to-white/10 opacity-0 group-hover:opacity-100 transition-opacity duration-300 rounded-2xl"></div>
                  </div>
                );
              })}
            </div>
            )}
            
            {/* No Results */}
            {getFilteredCategories().length === 0 && !loading && (
              <div className="text-center py-12">
                <div className="text-6xl mb-4">🔍</div>
                <h3 className="text-xl font-semibold text-gray-700 mb-2">
                  Không tìm thấy nhóm ngành
                </h3>
                <p className="text-gray-500 mb-4">
                  Thử tìm kiếm với từ khóa khác hoặc xóa bộ lọc
                </p>
                <button
                  onClick={() => {
                    setSearchTerm('');
                    setSortBy('popularity');
                  }}
                  className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                >
                  Xóa bộ lọc
                </button>
              </div>
            )}
          </div>
    ) : (
          /* Bước 2: Danh sách tư vấn viên */
          <div>
            <div className="flex items-center justify-between mb-8">
              <div className="flex items-center gap-4">
                <button
                  onClick={handleBackToCategories}
                  className="flex items-center gap-2 px-6 py-3 bg-white rounded-xl border border-gray-200 hover:bg-gray-50 transition-all duration-300 shadow-lg hover:shadow-xl"
                >
                  <ArrowLeft className="w-5 h-5" />
                  <span className="font-semibold">Quay lại</span>
                </button>
                <div>
                  <h2 className="text-3xl font-bold text-gray-800 flex items-center gap-3">
                    <div className="p-2 bg-gradient-to-r from-blue-100 to-purple-100 rounded-lg">
                      <Users className="w-6 h-6 text-blue-600" />
                    </div>
                    Tư vấn viên - {selectedCategory.name}
                  </h2>
                  <p className="text-gray-600 mt-1">
                    {consultants.length} chuyên gia có sẵn • Chọn tư vấn viên phù hợp
                  </p>
                </div>
              </div>
              
              {/* Quick Stats */}
              <div className="text-right">
                <div className="text-2xl font-bold text-gray-900">
                  {consultants.reduce((sum, consultant) => sum + consultant.availableSlots.length, 0)}
                </div>
                <div className="text-sm text-gray-600">Lịch trống</div>
              </div>
            </div>

            {consultantsLoading ? (
              <div className="flex items-center justify-center py-12">
                <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
                <span className="ml-2 text-gray-600">Đang tải danh sách tư vấn viên...</span>
              </div>
            ) : error ? (
              <div className="flex items-center justify-center py-12">
                <div className="text-center">
                  <AlertCircle className="w-12 h-12 text-red-500 mx-auto mb-4" />
                  <p className="text-red-600 mb-4">{error}</p>
                  <button
                    onClick={() => window.location.reload()}
                    className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 transition-colors"
                  >
                    Thử lại
                  </button>
                </div>
              </div>
            ) : (
              <>
            <div className="space-y-4">
              {consultants.map((consultant) => {
                const isBioExpanded = expandedBios[consultant.id] || false;
                const bioDisplay = consultant.bio && consultant.bio.length > 120 
                  ? (isBioExpanded ? consultant.bio : `${consultant.bio.slice(0, 120)}...`)
                  : consultant.bio;
                
                // Màu sắc cho các tag dịch vụ
                const skillColors = [
                  { bg: 'bg-blue-50', text: 'text-blue-700', border: 'border-blue-200' },
                  { bg: 'bg-purple-50', text: 'text-purple-700', border: 'border-purple-200' },
                  { bg: 'bg-emerald-50', text: 'text-emerald-700', border: 'border-emerald-200' },
                ];
                
                return (
                <div
                  key={consultant.id}
                  className="bg-white rounded-2xl p-6 shadow-lg hover:shadow-2xl transition-all duration-300 border border-gray-100"
                >
                  <div className="flex gap-6">
                    {/* Khu vực 1: Avatar */}
                    <div className="flex-shrink-0">
                      <img
                        src={consultant.avatar}
                        alt={consultant.name}
                        className="w-20 h-20 rounded-full object-cover border-3 border-teal-100 shadow-md"
                      />
                    </div>

                    {/* Khu vực 2: Nội dung chính */}
                    <div className="flex-1 min-w-0">
                      {/* Header: Tên, Nơi làm việc & Đánh giá */}
                      <div className="mb-4">
                        <div className="flex items-start justify-between gap-4 mb-2">
                          <div className="flex-1">
                            <h3 className="text-xl font-bold text-teal-700 mb-1.5">
                              {consultant.name}
                            </h3>
                            <div className="flex items-center gap-2 text-sm text-gray-600">
                              <MapPin className="w-4 h-4 text-teal-500 flex-shrink-0" />
                              <span>{consultant.workplace}</span>
                            </div>
                          </div>
                          
                          {/* Đánh giá - Đặt cùng hàng với tên */}
                          {consultant.averageRating > 0 ? (
                            <div className="flex items-center gap-2 bg-amber-50 rounded-lg px-3 py-2 border border-amber-200">
                              <div className="flex items-center gap-0.5">
                                {[1, 2, 3, 4, 5].map((star) => (
                                  <Star
                                    key={star}
                                    className={`w-3.5 h-3.5 ${
                                      star <= Math.round(consultant.averageRating)
                                        ? 'fill-amber-400 text-amber-400'
                                        : 'text-gray-300'
                                    }`}
                                  />
                                ))}
                              </div>
                              <div className="flex items-baseline gap-1">
                                <span className="text-base font-bold text-amber-600">
                                  {consultant.averageRating.toFixed(1)}
                                </span>
                                <span className="text-xs text-gray-500">/5</span>
                              </div>
                              <span className="text-xs text-gray-600">
                                ({consultant.totalRatings})
                              </span>
                              <button
                                onClick={() => {
                                  setSelectedConsultantForRating(consultant);
                                  setShowRatingDetailModal(true);
                                }}
                                className="text-xs text-teal-600 hover:text-teal-700 hover:underline ml-1"
                              >
                                Chi tiết
                              </button>
                            </div>
                          ) : (
                            <div className="text-xs text-gray-500 bg-gray-50 rounded-lg px-3 py-2 border border-gray-200">
                              Chưa có đánh giá
                            </div>
                          )}
                        </div>
                      </div>

                      {/* Mô tả */}
                      {consultant.bio && (
                        <div className="mb-4">
                          <p className="text-sm text-gray-700 leading-relaxed line-clamp-2">
                            {bioDisplay}
                          </p>
                          {consultant.bio && consultant.bio.length > 120 && (
                            <button
                              onClick={() => setExpandedBios(prev => ({
                                ...prev,
                                [consultant.id]: !prev[consultant.id]
                              }))}
                              className="text-xs text-teal-600 hover:text-teal-700 hover:underline mt-1"
                            >
                              {isBioExpanded ? 'Thu gọn' : 'Xem thêm'}
                            </button>
                          )}
                        </div>
                      )}

                      {/* Skills Tags */}
                      <div className="flex flex-wrap gap-2 mb-4">
                        {consultant.skills.map((skill, index) => {
                          const color = skillColors[index % skillColors.length];
                          return (
                            <span
                              key={index}
                              className={`px-3 py-1.5 ${color.bg} ${color.text} ${color.border} border rounded-full text-xs font-semibold`}
                            >
                              {skill}
                            </span>
                          );
                        })}
                      </div>

                      {/* Hình thức & Lịch hẹn */}
                      <div className="flex gap-4">
                        <div className="flex items-center gap-2 text-sm text-gray-700">
                          <Video className="w-4 h-4 text-teal-600 flex-shrink-0" />
                          <span className="font-medium">Hình thức:</span>
                          <span className="text-gray-600">{consultant.methods.join(", ")}</span>
                        </div>
                        <div className="flex items-center gap-2 text-sm">
                          <Clock className="w-4 h-4 text-blue-600 flex-shrink-0" />
                          <span className="font-medium text-blue-900">Lịch hẹn:</span>
                          <span className="text-blue-700">
                            {consultant.availableSlots.length > 0 
                              ? `${consultant.availableSlots.length} khung giờ`
                              : 'Đang cập nhật'}
                          </span>
                        </div>
                      </div>
                    </div>

                    {/* Khu vực 3: CTA Buttons */}
                    <div className="flex-shrink-0 flex flex-col gap-3 w-48">
                      <button
                        onClick={() => openScheduleDrawer(consultant)}
                        className="w-full py-2.5 rounded-xl font-bold text-white bg-gradient-to-r from-teal-500 to-teal-600 hover:from-teal-600 hover:to-teal-700 shadow-md hover:shadow-lg transition-all duration-300 text-sm"
                      >
                        Xem lịch
                      </button>
                      {consultant.availableSlots.length > 0 ? (
                        <button
                          onClick={() => {
                            const sorted = sortSlotsAsc(consultant.availableSlots);
                            setSelectedConsultant(consultant);
                            setSelectedSlot(sorted[0]);
                            setShowBookingModal(true);
                          }}
                          className="w-full py-2.5 rounded-xl font-semibold border-2 border-teal-500 text-teal-600 hover:bg-teal-50 transition-all duration-300 text-sm"
                        >
                          Đặt nhanh
                        </button>
                      ) : (
                        <button
                          disabled
                          className="w-full py-2.5 rounded-xl font-semibold border border-gray-300 text-gray-400 cursor-not-allowed bg-gray-50 text-sm"
                        >
                          Yêu cầu tư vấn
                        </button>
                      )}
                    </div>
                  </div>
                </div>
              )})}
            </div>

            {consultants.length === 0 && !consultantsLoading && !error && (
              <div className="text-center py-12">
                <div className="text-6xl mb-4">📭</div>
                <h3 className="text-xl font-semibold text-gray-700 mb-2">
                  Hiện chưa có tư vấn viên
                </h3>
                <p className="text-gray-500">
                  Cho nhóm ngành "{selectedCategory.name}". Vui lòng chọn nhóm ngành khác.
                </p>
              </div>
            )}
              </>
            )}
        </div>
      )}

      {/* Drawer xem lịch tư vấn viên (Agenda) */}
      {showScheduleDrawer && activeScheduleConsultant && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-start justify-end z-50">
          <div className="bg-white w-full max-w-3xl h-full rounded-l-2xl shadow-xl p-6 overflow-y-auto">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <img src={activeScheduleConsultant.avatar} alt={activeScheduleConsultant.name} className="w-10 h-10 rounded-full" />
                <div>
                  <div className="font-semibold text-gray-800">{activeScheduleConsultant.name}</div>
                  <div className="text-sm text-gray-500">Lịch trống theo quý (Agenda)</div>
                </div>
              </div>
              <button onClick={() => setShowScheduleDrawer(false)} className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200">✕</button>
            </div>

            {(() => {
              const byDate = (activeScheduleConsultant.availableSlots || []).reduce((acc, slot) => {
                const key = slot.date;
                acc[key] = acc[key] || [];
                acc[key].push(slot);
                return acc;
              }, {});
              const dates = Object.keys(byDate).sort((a,b) => new Date(a) - new Date(b));
              if (dates.length === 0) return <div className="text-gray-500">Chưa có lịch trống</div>;
              return (
                <div className="space-y-4">
                  {dates.map(date => (
                    <div key={date} className="border border-gray-200 rounded-lg">
                      <div className="sticky top-0 bg-gray-50 px-4 py-2 font-semibold text-gray-700 border-b">
                        {new Date(date).toLocaleDateString('vi-VN', { weekday: 'short', day: '2-digit', month: '2-digit', year: 'numeric' })}
                      </div>
                      <div className="p-4 flex flex-wrap gap-2">
                        {sortSlotsAsc(byDate[date]).map((slot) => (
                          <button
                            key={slot.id}
                            onClick={() => {
                              setSelectedConsultant(activeScheduleConsultant);
                              setSelectedSlot(slot);
                              setShowScheduleDrawer(false);
                              setShowBookingModal(true);
                            }}
                            className="px-3 py-1 rounded-full bg-green-100 text-green-700 text-sm hover:bg-green-200"
                          >
                            {slot.time}
                          </button>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              );
            })()}
          </div>
        </div>
      )}

        {/* Booking Modal */}
        {showBookingModal && (
          <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl p-6 w-full max-w-md">
              <div className="flex items-center justify-between mb-6">
                <h3 className="text-xl font-semibold text-gray-800">Đặt lịch tư vấn</h3>
                <button
                  onClick={() => setShowBookingModal(false)}
                  className="text-gray-400 hover:text-gray-600"
                >
                  ✕
                </button>
              </div>

              <div className="mb-4">
                <div className="flex items-center gap-3">
                  <img
                    src={selectedConsultant?.avatar}
                    alt={selectedConsultant?.name}
                    className="w-12 h-12 rounded-full object-cover"
                  />
                  <div>
                    <p className="font-semibold text-gray-800">{selectedConsultant?.name}</p>
                    <p className="text-sm text-gray-600">{selectedConsultant?.workplace}</p>
                  </div>
                </div>
              </div>

              <div className="space-y-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Chọn khung giờ có sẵn
                  </label>
                  {selectedConsultant?.availableSlots.length > 0 ? (
                    <div className="grid grid-cols-1 gap-2 max-h-40 overflow-y-auto">
                      {selectedConsultant.availableSlots.map((slot, index) => (
                      <button
                        key={index}
                          onClick={() => setSelectedSlot(slot)}
                          className={`px-3 py-2 border rounded-lg transition-colors text-left ${
                            selectedSlot?.id === slot.id
                              ? 'border-blue-500 bg-blue-50 text-blue-700'
                              : 'border-gray-300 hover:bg-blue-50 hover:border-blue-300'
                          }`}
                        >
                          <div className="font-medium">
                            {new Date(slot.date).toLocaleDateString('vi-VN')}
                          </div>
                          <div className="text-sm text-gray-600">
                            {slot.time}
                          </div>
                      </button>
                    ))}
                  </div>
                  ) : (
                    <div className="text-center py-4 text-gray-500">
                      <p>Hiện chưa có lịch trống</p>
                      <p className="text-sm">Vui lòng chọn tư vấn viên khác</p>
                    </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Hình thức tư vấn
                  </label>
                  {selectedSlot ? (
                    <div className="p-3 bg-blue-50 border border-blue-200 rounded-lg">
                      <div className="flex items-center gap-2">
                        <Video className="w-4 h-4 text-blue-600" />
                        <span className="text-sm font-medium text-blue-800">
                          {selectedSlot.platform || 'Google Meet'}
                        </span>
                      </div>
                    </div>
                  ) : (
                    <div className="text-sm text-gray-500 italic">
                      Vui lòng chọn khung giờ để xem hình thức tư vấn
                  </div>
                  )}
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Ghi chú (tùy chọn)
                  </label>
                  <textarea
                    rows={3}
                    className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                    placeholder="Mô tả ngắn về vấn đề cần tư vấn..."
                  />
                </div>
              </div>

              <div className="flex gap-3 mt-6">
                <button
                  onClick={() => setShowBookingModal(false)}
                  className="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg hover:bg-gray-50 transition-colors"
                >
                  Hủy
                </button>
                <button
                  onClick={() => {
                    if (selectedSlot) {
                      // Lưu thông tin đặt lịch
                      const bookingData = {
                        consultant: selectedConsultant,
                        slot: selectedSlot,
                        timestamp: new Date().toISOString()
                      };
                      setBookingData(bookingData);
                      
                      // Đóng modal đặt lịch và mở modal thanh toán
                    setShowBookingModal(false);
                      setShowPaymentModal(true);
                    }
                  }}
                  disabled={!selectedSlot}
                  className={`flex-1 px-4 py-2 rounded-lg font-semibold transition-all duration-300 ${
                    selectedSlot
                      ? 'bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:from-blue-600 hover:to-blue-700'
                      : 'bg-gray-300 text-gray-500 cursor-not-allowed'
                  }`}
                >
                  {selectedSlot ? 'Xác nhận đặt lịch' : 'Vui lòng chọn khung giờ'}
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Payment Modal */}
        <PaymentModal
          isOpen={showPaymentModal}
          onClose={() => setShowPaymentModal(false)}
          bookingData={bookingData}
        />

        {/* Rating Modal */}
        {showRatingModal && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl w-full max-w-md p-6">
              <div className="flex items-center justify-between mb-4">
                <div>
                  <div className="font-semibold text-gray-800">
                    {ratingMode === 'create' && 'Đánh giá buổi tư vấn'}
                    {ratingMode === 'edit' && 'Sửa đánh giá buổi tư vấn'}
                    {ratingMode === 'view' && 'Xem đánh giá buổi tư vấn'}
                  </div>
                  {ratingSchedule && (
                    <div className="text-sm text-gray-600">{ratingSchedule.advisorName} • {new Date(ratingSchedule.date).toLocaleDateString('vi-VN')} ({ratingSchedule.start}-{ratingSchedule.end})</div>
                  )}
                </div>
                <button onClick={() => setShowRatingModal(false)} className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200">✕</button>
              </div>

              {/* Stars */}
              <div className="mb-4">
                <div className="text-sm text-gray-700 mb-2">Điểm đánh giá</div>
                <div className="flex items-center gap-2">
                  {[1,2,3,4,5].map(n => (
                    <button
                      key={n}
                      type="button"
                      onClick={() => ratingMode !== 'view' && setRatingForm(prev => ({ ...prev, diemdanhgia: n }))}
                      className={`w-8 h-8 rounded-full flex items-center justify-center border ${ratingForm.diemdanhgia >= n ? 'bg-yellow-400 text-white border-yellow-400' : 'bg-white text-gray-500 border-gray-300'} ${ratingMode==='view' ? 'cursor-default' : 'hover:border-yellow-400'}`}
                    >
                      ★
                    </button>
                  ))}
                  <span className="ml-2 text-sm text-gray-600">{Number(ratingForm.diemdanhgia).toFixed(1)}/5.0</span>
                </div>
              </div>

              {/* Comment */}
              <div className="mb-4">
                <div className="text-sm text-gray-700 mb-2">Nhận xét</div>
                <textarea
                  rows={4}
                  value={ratingForm.nhanxet}
                  onChange={(e) => setRatingForm(prev => ({ ...prev, nhanxet: e.target.value }))}
                  disabled={ratingMode === 'view'}
                  className="w-full px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100"
                  placeholder="Chia sẻ cảm nhận của bạn về buổi tư vấn..."
                />
              </div>

              {/* Anonymous */}
              <div className="mb-6 flex items-center gap-2">
                <input
                  id="chk_an_danh"
                  type="checkbox"
                  checked={!!ratingForm.an_danh}
                  onChange={(e) => setRatingForm(prev => ({ ...prev, an_danh: e.target.checked ? 1 : 0 }))}
                  disabled={ratingMode === 'view'}
                />
                <label htmlFor="chk_an_danh" className="text-sm text-gray-700">Ẩn danh khi hiển thị đánh giá</label>
              </div>

              <div className="flex gap-3 justify-end">
                <button
                  onClick={() => setShowRatingModal(false)}
                  className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
                >
                  Đóng
                </button>
                {ratingMode === 'create' && (
                  <button
                    onClick={submitCreateRating}
                    className="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
                  >
                    Gửi đánh giá
                  </button>
                )}
                {ratingMode === 'edit' && (
                  <button
                    onClick={submitUpdateRating}
                    className="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700"
                  >
                    Lưu thay đổi
                  </button>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Rating Detail Modal */}
        {showRatingDetailModal && selectedConsultantForRating && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl w-full max-w-2xl max-h-[80vh] overflow-hidden flex flex-col">
              <div className="p-6 border-b flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-800">
                    Đánh giá của {selectedConsultantForRating.name}
                  </h3>
                  {selectedConsultantForRating.averageRating > 0 && (
                    <div className="flex items-center gap-2 mt-2">
                      <div className="flex items-center gap-1">
                        {[1, 2, 3, 4, 5].map((star) => (
                          <Star
                            key={star}
                            className={`w-5 h-5 ${
                              star <= Math.round(selectedConsultantForRating.averageRating)
                                ? 'fill-yellow-400 text-yellow-400'
                                : 'text-gray-300'
                            }`}
                          />
                        ))}
                      </div>
                      <span className="text-lg font-bold text-gray-700">
                        {selectedConsultantForRating.averageRating.toFixed(1)}
                      </span>
                      <span className="text-sm text-gray-500">
                        ({selectedConsultantForRating.totalRatings} đánh giá)
                      </span>
                    </div>
                  )}
                </div>
                <button
                  onClick={() => {
                    setShowRatingDetailModal(false);
                    setSelectedConsultantForRating(null);
                  }}
                  className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200"
                >
                  ✕
                </button>
              </div>
              
              <div className="flex-1 overflow-y-auto p-6">
                {selectedConsultantForRating.reviews && selectedConsultantForRating.reviews.length > 0 ? (
                  <div className="space-y-4">
                    {selectedConsultantForRating.reviews.map((review, idx) => (
                      <div key={idx} className="border border-gray-200 rounded-lg p-4">
                        <div className="flex items-center justify-between mb-2">
                          <div className="flex items-center gap-2">
                            {[1, 2, 3, 4, 5].map((star) => (
                              <Star
                                key={star}
                                className={`w-4 h-4 ${
                                  star <= review.diemdanhgia
                                    ? 'fill-yellow-400 text-yellow-400'
                                    : 'text-gray-300'
                                }`}
                              />
                            ))}
                            <span className="text-sm font-semibold text-gray-700">
                              {review.diemdanhgia.toFixed(1)}/5.0
                            </span>
                          </div>
                          <span className="text-xs text-gray-500">
                            {new Date(review.ngaydanhgia).toLocaleDateString('vi-VN')}
                          </span>
                        </div>
                        {review.nhanxet && (
                          <p className="text-sm text-gray-700 mb-2 whitespace-pre-wrap">
                            {review.nhanxet}
                          </p>
                        )}
                        <p className="text-xs text-gray-500">
                          - {review.nguoi_danh_gia}
                        </p>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-8 text-gray-500">
                    <p>Chưa có đánh giá nào</p>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Consultation Notes Modal */}
        {showNotesModal && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col">
              <div className="p-6 border-b flex items-center justify-between">
                <div>
                  <h3 className="text-xl font-semibold text-gray-800">Nhận xét của tư vấn viên</h3>
                  {selectedAppointmentForNotes && (
                    <div className="text-sm text-gray-600 mt-1">
                      {selectedAppointmentForNotes.advisorName} • {new Date(selectedAppointmentForNotes.date).toLocaleDateString('vi-VN')} ({selectedAppointmentForNotes.start}-{selectedAppointmentForNotes.end})
                    </div>
                  )}
                </div>
                <button
                  onClick={() => {
                    setShowNotesModal(false);
                    setNotesData(null);
                    setSelectedAppointmentForNotes(null);
                  }}
                  className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200"
                >
                  ✕
                </button>
              </div>
              
              <div className="flex-1 overflow-y-auto p-6">
                {notesLoading ? (
                  <div className="flex items-center justify-center py-12">
                    <Loader2 className="w-8 h-8 animate-spin text-blue-500" />
                    <span className="ml-2 text-gray-600">Đang tải nhận xét...</span>
                  </div>
                ) : notesData ? (
                  (() => {
                    const ghiChu = notesData.ghi_chu_chot || notesData.ghi_chu_nhap;
                    const evidenceFiles = notesData.minh_chung || [];
                    
                    if (!ghiChu) {
                      return (
                        <div className="text-center py-8 text-gray-500">
                          <p>Tư vấn viên chưa cập nhật nhận xét cho buổi tư vấn này.</p>
                        </div>
                      );
                    }
                    
                    return (
                      <div className="space-y-6">
                        {/* Ghi chú */}
                        <div>
                          <h4 className="text-lg font-semibold mb-3 text-gray-800">Ghi chú buổi tư vấn</h4>
                          <div className="space-y-4">
                            {ghiChu.noi_dung && (
                              <div>
                                <p className="text-sm font-medium text-gray-700 mb-1">Nội dung:</p>
                                <div className="bg-gray-50 p-3 rounded-lg">
                                  <p className="text-sm whitespace-pre-wrap">{ghiChu.noi_dung}</p>
                                </div>
                              </div>
                            )}
                            
                            <div className="grid grid-cols-2 gap-4">
                              {ghiChu.ket_luan_nganh && (
                                <div>
                                  <p className="text-sm font-medium text-gray-700 mb-1">Kết luận ngành:</p>
                                  <p className="text-sm">{ghiChu.ket_luan_nganh}</p>
                                </div>
                              )}
                              {ghiChu.muc_quan_tam && (
                                <div>
                                  <p className="text-sm font-medium text-gray-700 mb-1">Mức quan tâm:</p>
                                  <p className="text-sm">{ghiChu.muc_quan_tam}/5</p>
                                </div>
                              )}
                              {ghiChu.diem_du_kien && (
                                <div>
                                  <p className="text-sm font-medium text-gray-700 mb-1">Điểm dự kiến:</p>
                                  <p className="text-sm">{ghiChu.diem_du_kien}</p>
                                </div>
                              )}
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
                                <p className="text-sm font-medium text-gray-700 mb-1">Tóm tắt:</p>
                                <div className="bg-gray-50 p-3 rounded-lg">
                                  <p className="text-sm whitespace-pre-wrap">{ghiChu.tom_tat}</p>
                                </div>
                              </div>
                            )}
                          </div>
                        </div>
                        
                        {/* Minh chứng */}
                        {evidenceFiles.length > 0 && (
                          <div>
                            <h4 className="text-lg font-semibold mb-3 text-gray-800">
                              Minh chứng ({evidenceFiles.length} {evidenceFiles.length === 1 ? 'mục' : 'mục'})
                            </h4>
                            <div className="space-y-3">
                              {evidenceFiles.map((file) => {
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
                                    {isImage && fileUrl && (
                                      <div className="mt-3">
                                        <img
                                          src={fileUrl}
                                          alt={file.ten_file || file.tenFile || 'Preview'}
                                          className="max-w-full h-auto max-h-64 rounded border border-gray-200"
                                          onError={(e) => {
                                            e.target.style.display = 'none';
                                          }}
                                        />
                                      </div>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          </div>
                        )}
                      </div>
                    );
                  })()
                ) : (
                  <div className="text-center py-8 text-gray-500">
                    <p>Tư vấn viên chưa cập nhật nhận xét cho buổi tư vấn này.</p>
                  </div>
                )}
              </div>
            </div>
          </div>
        )}

        {/* Chat Modal */}
        {showChatModal && chatSession && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center p-4 z-50">
            <div className="bg-white rounded-2xl w-full max-w-2xl h-[70vh] flex flex-col">
              <div className="p-4 border-b flex items-center justify-between">
                <div>
                  <div className="font-semibold text-gray-800">Trò chuyện cùng chuyên gia</div>
                  <div className="text-sm text-gray-600">{chatSession.advisorName} • {chatSession.groupName}</div>
                </div>
                <button 
                  onClick={() => {
                    setShowChatModal(false);
                    setAttachedFile(null);
                    setChatInput('');
                  }} 
                  className="px-3 py-1 rounded-lg bg-gray-100 hover:bg-gray-200"
                >
                  ✕
                </button>
              </div>
              <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-gray-50">
                {chatMessages.length === 0 && (
                  <div className="text-center text-gray-500 text-sm">Hãy bắt đầu cuộc trò chuyện với chuyên gia của bạn.</div>
                )}
                {chatMessages.map(msg => {
                  // Parse file/ảnh từ text
                  let displayText = msg.text || '';
                  let imageUrl = null;
                  let fileInfo = null;
                  
                  // Tìm [IMAGE:url] hoặc [FILE:url:filename]
                  const imageMatch = displayText.match(/\[IMAGE:([^\]]+)\]/);
                  const fileMatch = displayText.match(/\[FILE:([^\]]+):([^\]]+)\]/);
                  
                  if (imageMatch) {
                    imageUrl = imageMatch[1];
                    displayText = displayText.replace(/\[IMAGE:[^\]]+\]/g, '').trim();
                  }
                  if (fileMatch) {
                    fileInfo = { url: fileMatch[1], filename: fileMatch[2] };
                    displayText = displayText.replace(/\[FILE:[^\]]+\]/g, '').trim();
                  }
                  
                  // Ưu tiên file từ object nếu có
                  if (msg.file) {
                    if (msg.file.url.match(/\.(jpg|jpeg|png|gif|webp)$/i)) {
                      imageUrl = msg.file.url;
                    } else {
                      fileInfo = msg.file;
                    }
                  }
                  
                  return (
                    <div key={msg.id} className={`max-w-[75%] ${msg.senderType === 'user' ? 'ml-auto text-right' : ''}`}>
                      <div className={`inline-block px-3 py-2 rounded-xl ${msg.senderType === 'user' ? 'bg-blue-600 text-white' : 'bg-white border'}`}>
                        {displayText && <div className="text-sm whitespace-pre-wrap break-words">{displayText}</div>}
                        
                        {/* Hiển thị ảnh */}
                        {imageUrl && (
                          <div className="mt-2">
                            <a href={imageUrl} target="_blank" rel="noopener noreferrer" className="block">
                              <img
                                src={imageUrl}
                                alt="Hình ảnh đính kèm"
                                className="max-w-full max-h-64 rounded-lg cursor-pointer hover:opacity-90"
                              />
                            </a>
                          </div>
                        )}
                        
                        {/* Hiển thị file */}
                        {fileInfo && !imageUrl && (
                          <div className="mt-2">
                            <a
                              href={`http://localhost:8000/api/chat-support/download-file?url=${encodeURIComponent(fileInfo.url)}&filename=${encodeURIComponent(fileInfo.filename || 'file')}`}
                              target="_blank"
                              rel="noopener noreferrer"
                              className={`inline-flex items-center gap-2 px-3 py-2 rounded-lg ${
                                msg.senderType === 'user'
                                  ? 'bg-blue-500 text-white hover:bg-blue-400'
                                  : 'bg-gray-200 text-gray-800 hover:bg-gray-300'
                              } transition-colors`}
                            >
                              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                              </svg>
                              <span className="text-sm">{fileInfo.filename || 'Tải file đính kèm'}</span>
                            </a>
                          </div>
                        )}
                        
                        <div className={`text-[10px] mt-1 ${msg.senderType === 'user' ? 'text-blue-100' : 'text-gray-400'}`}>
                          {new Date(msg.at).toLocaleTimeString('vi-VN')}
                        </div>
                      </div>
                    </div>
                  );
                })}
              </div>
              <div className="p-3 border-t bg-white">
                {/* Hiển thị file đã chọn */}
                {attachedFile && (
                  <div className="mb-2 flex items-center gap-2 p-2 bg-gray-50 rounded-lg">
                    {attachedFile.url.match(/\.(jpg|jpeg|png|gif|webp)$/i) ? (
                      <img src={attachedFile.url} alt="Preview" className="w-12 h-12 object-cover rounded" />
                    ) : (
                      <div className="w-12 h-12 bg-gray-300 rounded flex items-center justify-center">
                        <svg className="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                        </svg>
                      </div>
                    )}
                    <div className="flex-1 min-w-0">
                      <p className="text-xs text-gray-600 truncate">
                        {attachedFile.filename || 'File đã chọn'}
                      </p>
                    </div>
                    <button
                      type="button"
                      onClick={() => setAttachedFile(null)}
                      className="text-gray-500 hover:text-gray-700"
                    >
                      <svg className="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
                      </svg>
                    </button>
                  </div>
                )}
                
                <form
                  onSubmit={(e) => {
                    e.preventDefault();
                    sendChatMessage();
                  }}
                  className="flex items-center gap-2"
                >
                  <input
                    ref={fileInputRef}
                    type="file"
                    accept="image/*,.pdf,.doc,.docx,.xls,.xlsx,.txt,.csv"
                    onChange={handleFileSelect}
                    className="hidden"
                  />
                  <button
                    type="button"
                    onClick={() => fileInputRef.current?.click()}
                    disabled={uploading}
                    className="px-3 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors disabled:bg-gray-200 disabled:cursor-not-allowed"
                    title="Đính kèm file"
                  >
                    {uploading ? (
                      <svg className="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                    ) : (
                      <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15.172 7l-6.586 6.586a2 2 0 102.828 2.828l6.414-6.414a2 2 0 00-2.828-2.828L9 10.172 7.586 8.586a2 2 0 10-2.828 2.828l1.414 1.414a4 4 0 105.657 5.657l6.414-6.414a4 4 0 00-5.657-5.657L9 10.172l-1.414-1.414a4 4 0 10-5.657 5.657l1.414 1.414" />
                      </svg>
                    )}
                  </button>
                  <input
                    type="text"
                    value={chatInput}
                    onChange={(e) => setChatInput(e.target.value)}
                    onKeyDown={(e) => { if (e.key === 'Enter' && !e.shiftKey) { e.preventDefault(); sendChatMessage(); } }}
                    placeholder={attachedFile ? "Nhập tin nhắn (tùy chọn)..." : "Nhập tin nhắn..."}
                    disabled={uploading}
                    className="flex-1 px-3 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 disabled:bg-gray-100"
                    autoComplete="off"
                  />
                  <button
                    type="submit"
                    disabled={(!chatInput.trim() && !attachedFile) || uploading}
                    className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition-colors disabled:bg-gray-400 disabled:cursor-not-allowed"
                  >
                    {uploading ? (
                      <svg className="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                      </svg>
                    ) : (
                      'Gửi'
                    )}
                  </button>
                </form>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}