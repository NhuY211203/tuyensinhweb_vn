import { useState, useEffect } from "react";
import Modal from "../../components/Modal";
import Toast from "../../components/Toast";
import api from "../../services/api";

export default function NewsApproval() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  const [showModal, setShowModal] = useState(false);
  const [selectedPost, setSelectedPost] = useState(null);
  const [toast, setToast] = useState({ show: false, message: "", type: "success" });
  
  // Filter states
  const [filterLoaiTin, setFilterLoaiTin] = useState("");
  const [filterTrangThai, setFilterTrangThai] = useState("");
  
  // Selected items for bulk actions
  const [selectedItems, setSelectedItems] = useState([]);
  const [bulkLoading, setBulkLoading] = useState(false);
  
  // Confirmation modal states
  const [showConfirmModal, setShowConfirmModal] = useState(false);
  const [confirmAction, setConfirmAction] = useState(null);
  const [confirmItem, setConfirmItem] = useState(null);

  // Load posts data
  const loadPosts = async (page = 1, keyword = "", loai_tin = "", trang_thai = "") => {
    setLoading(true);
    try {
      const params = {
        page: page,
        per_page: 20,
      };
      
      if (keyword) params.keyword = keyword;
      // Map "Thông tin" to "Thông báo" for backend
      if (loai_tin) {
        params.loai_tin = loai_tin === "Thông tin" ? "Thông báo" : loai_tin;
      }
      if (trang_thai) params.trang_thai = trang_thai;
      
      const response = await api.getNewsList(params);
      
      if (response.success) {
        const postsData = response.data || [];
        setPosts(postsData);
        setTotalPages(response.pagination?.last_page || 1);
        setTotalRecords(response.pagination?.total || 0);
        setCurrentPage(response.pagination?.current_page || 1);
      } else {
        showToast(response.message || "Lỗi khi tải dữ liệu", "error");
      }
    } catch (error) {
      showToast("Lỗi kết nối", "error");
    } finally {
      setLoading(false);
    }
  };

  const showToast = (message, type = "success") => {
    setToast({ show: true, message, type });
    setTimeout(() => setToast({ show: false, message: "", type: "success" }), 3000);
  };

  useEffect(() => {
    loadPosts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  // Auto search when filters change
  useEffect(() => {
    const timeoutId = setTimeout(() => {
      loadPosts(1, searchTerm, filterLoaiTin, filterTrangThai);
      setCurrentPage(1);
    }, searchTerm ? 500 : 0);
    
    return () => clearTimeout(timeoutId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchTerm, filterLoaiTin, filterTrangThai]);

  // Handle approve
  const handleApprove = async (post, isBulk = false) => {
    try {
      // Lấy ID và đảm bảo là số nguyên
      const postId = parseInt(post.id_tin || post.idtintuyensinh || post.id || post.idTin || post.idtin, 10);
      if (isNaN(postId)) {
        showToast("Không tìm thấy ID tin tức hợp lệ", "error");
        return;
      }
      
      // Chuẩn bị dữ liệu với các field đúng tên và bắt buộc
      const tieuDe = post.tieu_de || post.tieude || post.tieuDe;
      const loaiTin = post.loai_tin || post.loaiTin || 'Tin tuyển sinh';
      
      if (!tieuDe || tieuDe.trim() === '') {
        showToast("Tiêu đề không được để trống", "error");
        return;
      }
      
      const updateData = {
        tieu_de: tieuDe,
        loai_tin: loaiTin,
        trang_thai: "Đã duyệt"
      };
      
      // Thêm các field optional nếu có
      if (post.tom_tat || post.tomtat || post.tomTat) {
        updateData.tom_tat = post.tom_tat || post.tomtat || post.tomTat;
      }
      if (post.hinh_anh_dai_dien || post.hinhAnhDaiDien) {
        const imageUrl = post.hinh_anh_dai_dien || post.hinhAnhDaiDien;
        // Chỉ thêm nếu là URL hợp lệ hoặc empty (nullable)
        if (imageUrl && imageUrl.trim() !== '') {
          updateData.hinh_anh_dai_dien = imageUrl;
        }
      }
      if (post.nguon_bai_viet || post.nguonBaiViet) {
        const sourceUrl = post.nguon_bai_viet || post.nguonBaiViet;
        // Chỉ thêm nếu là URL hợp lệ (validation yêu cầu url)
        if (sourceUrl && sourceUrl.trim() !== '') {
          // Kiểm tra nếu là URL hợp lệ
          try {
            new URL(sourceUrl);
            updateData.nguon_bai_viet = sourceUrl;
          } catch (e) {
            // Không phải URL hợp lệ, bỏ qua field này
            console.warn('⚠️ Invalid URL for nguon_bai_viet:', sourceUrl);
          }
        }
      }
      if (post.id_truong || post.idTruong) {
        const idTruong = post.id_truong || post.idTruong;
        if (idTruong) {
          updateData.id_truong = parseInt(idTruong, 10);
        }
      }
      if (post.ma_nguon || post.maNguon) {
        updateData.ma_nguon = post.ma_nguon || post.maNguon;
      }
      
      const response = await api.approveNews(postId, updateData);
      
      if (response.success) {
        showToast(
          isBulk 
            ? `Đã duyệt ${isBulk === true ? selectedItems.length : 1} tin tức thành công`
            : "Đã duyệt tin tức thành công",
          "success"
        );
        loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
        if (isBulk) {
          setSelectedItems([]);
        }
      } else {
        const errorMsg = response.errors 
          ? Object.values(response.errors).flat().join(', ')
          : response.message || "Lỗi khi duyệt tin tức";
        console.error('❌ Approve error:', response);
        showToast(errorMsg, "error");
      }
    } catch (error) {
      console.error('❌ Approve exception:', error);
      showToast(error.message || "Lỗi kết nối khi duyệt tin tức", "error");
    }
  };

  // Handle show (unhide - change status to "Đã duyệt")
  const handleShow = async (post, isBulk = false) => {
    try {
      // Lấy ID và đảm bảo là số nguyên
      const postId = parseInt(post.id_tin || post.idtintuyensinh || post.id || post.idTin || post.idtin, 10);
      if (isNaN(postId)) {
        showToast("Không tìm thấy ID tin tức hợp lệ", "error");
        return;
      }
      
      // Chuẩn bị dữ liệu với các field đúng tên và bắt buộc
      const tieuDe = post.tieu_de || post.tieude || post.tieuDe;
      const loaiTin = post.loai_tin || post.loaiTin || 'Tin tuyển sinh';
      
      if (!tieuDe || tieuDe.trim() === '') {
        showToast("Tiêu đề không được để trống", "error");
        return;
      }
      
      const updateData = {
        tieu_de: tieuDe,
        loai_tin: loaiTin,
        trang_thai: "Đã duyệt"
      };
      
      // Thêm các field optional nếu có
      if (post.tom_tat || post.tomtat || post.tomTat) {
        updateData.tom_tat = post.tom_tat || post.tomtat || post.tomTat;
      }
      if (post.hinh_anh_dai_dien || post.hinhAnhDaiDien) {
        const imageUrl = post.hinh_anh_dai_dien || post.hinhAnhDaiDien;
        if (imageUrl && imageUrl.trim() !== '') {
          updateData.hinh_anh_dai_dien = imageUrl;
        }
      }
      if (post.nguon_bai_viet || post.nguonBaiViet) {
        const sourceUrl = post.nguon_bai_viet || post.nguonBaiViet;
        if (sourceUrl && sourceUrl.trim() !== '') {
          try {
            new URL(sourceUrl);
            updateData.nguon_bai_viet = sourceUrl;
          } catch (e) {
            console.warn('⚠️ Invalid URL for nguon_bai_viet:', sourceUrl);
          }
        }
      }
      if (post.id_truong || post.idTruong) {
        const idTruong = post.id_truong || post.idTruong;
        if (idTruong) {
          updateData.id_truong = parseInt(idTruong, 10);
        }
      }
      if (post.ma_nguon || post.maNguon) {
        updateData.ma_nguon = post.ma_nguon || post.maNguon;
      }
      
      const response = await api.approveNews(postId, updateData);
      
      if (response.success) {
        showToast(
          isBulk 
            ? `Đã hiện ${isBulk === true ? selectedItems.length : 1} tin tức thành công`
            : "Đã hiện tin tức thành công",
          "success"
        );
        loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
        if (isBulk) {
          setSelectedItems([]);
        }
      } else {
        const errorMsg = response.errors 
          ? Object.values(response.errors).flat().join(', ')
          : response.message || "Lỗi khi hiện tin tức";
        console.error('❌ Show error:', response);
        showToast(errorMsg, "error");
      }
    } catch (error) {
      console.error('❌ Show exception:', error);
      showToast(error.message || "Lỗi kết nối khi hiện tin tức", "error");
    }
  };

  // Handle hide
  const handleHide = async (post, isBulk = false) => {
    try {
      // Lấy ID và đảm bảo là số nguyên
      const postId = parseInt(post.id_tin || post.idtintuyensinh || post.id || post.idTin || post.idtin, 10);
      if (isNaN(postId)) {
        showToast("Không tìm thấy ID tin tức hợp lệ", "error");
        return;
      }
      
      // Chuẩn bị dữ liệu với các field đúng tên và bắt buộc
      const tieuDe = post.tieu_de || post.tieude || post.tieuDe;
      const loaiTin = post.loai_tin || post.loaiTin || 'Tin tuyển sinh';
      
      if (!tieuDe || tieuDe.trim() === '') {
        showToast("Tiêu đề không được để trống", "error");
        return;
      }
      
      const updateData = {
        tieu_de: tieuDe,
        loai_tin: loaiTin,
        trang_thai: "Ẩn"
      };
      
      // Thêm các field optional nếu có
      if (post.tom_tat || post.tomtat || post.tomTat) {
        updateData.tom_tat = post.tom_tat || post.tomtat || post.tomTat;
      }
      if (post.hinh_anh_dai_dien || post.hinhAnhDaiDien) {
        const imageUrl = post.hinh_anh_dai_dien || post.hinhAnhDaiDien;
        if (imageUrl && imageUrl.trim() !== '') {
          updateData.hinh_anh_dai_dien = imageUrl;
        }
      }
      if (post.nguon_bai_viet || post.nguonBaiViet) {
        const sourceUrl = post.nguon_bai_viet || post.nguonBaiViet;
        if (sourceUrl && sourceUrl.trim() !== '') {
          try {
            new URL(sourceUrl);
            updateData.nguon_bai_viet = sourceUrl;
          } catch (e) {
            console.warn('⚠️ Invalid URL for nguon_bai_viet:', sourceUrl);
          }
        }
      }
      if (post.id_truong || post.idTruong) {
        const idTruong = post.id_truong || post.idTruong;
        if (idTruong) {
          updateData.id_truong = parseInt(idTruong, 10);
        }
      }
      if (post.ma_nguon || post.maNguon) {
        updateData.ma_nguon = post.ma_nguon || post.maNguon;
      }
      
      const response = await api.hideNews(postId, updateData);
      
      if (response.success) {
        showToast(
          isBulk 
            ? `Đã ẩn ${isBulk === true ? selectedItems.length : 1} tin tức thành công`
            : "Đã ẩn tin tức thành công",
          "success"
        );
        loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
        if (isBulk) {
          setSelectedItems([]);
        }
      } else {
        const errorMsg = response.errors 
          ? Object.values(response.errors).flat().join(', ')
          : response.message || "Lỗi khi ẩn tin tức";
        console.error('❌ Hide error:', response);
        showToast(errorMsg, "error");
      }
    } catch (error) {
      console.error('❌ Hide exception:', error);
      showToast(error.message || "Lỗi kết nối khi ẩn tin tức", "error");
    }
  };

  // Handle reject
  const handleReject = async (post, isBulk = false) => {
    try {
      // Lấy ID và đảm bảo là số nguyên
      const postId = parseInt(post.id_tin || post.idtintuyensinh || post.id || post.idTin || post.idtin, 10);
      if (isNaN(postId)) {
        showToast("Không tìm thấy ID tin tức hợp lệ", "error");
        return;
      }
      
      // Chuẩn bị dữ liệu với các field đúng tên và bắt buộc
      const tieuDe = post.tieu_de || post.tieude || post.tieuDe;
      const loaiTin = post.loai_tin || post.loaiTin || 'Tin tuyển sinh';
      
      if (!tieuDe || tieuDe.trim() === '') {
        showToast("Tiêu đề không được để trống", "error");
        return;
      }
      
      const updateData = {
        tieu_de: tieuDe,
        loai_tin: loaiTin,
        trang_thai: "Đã gỡ"
      };
      
      // Thêm các field optional nếu có
      if (post.tom_tat || post.tomtat || post.tomTat) {
        updateData.tom_tat = post.tom_tat || post.tomtat || post.tomTat;
      }
      if (post.hinh_anh_dai_dien || post.hinhAnhDaiDien) {
        const imageUrl = post.hinh_anh_dai_dien || post.hinhAnhDaiDien;
        // Chỉ thêm nếu là URL hợp lệ hoặc empty (nullable)
        if (imageUrl && imageUrl.trim() !== '') {
          updateData.hinh_anh_dai_dien = imageUrl;
        }
      }
      if (post.nguon_bai_viet || post.nguonBaiViet) {
        const sourceUrl = post.nguon_bai_viet || post.nguonBaiViet;
        // Chỉ thêm nếu là URL hợp lệ (validation yêu cầu url)
        if (sourceUrl && sourceUrl.trim() !== '') {
          // Kiểm tra nếu là URL hợp lệ
          try {
            new URL(sourceUrl);
            updateData.nguon_bai_viet = sourceUrl;
          } catch (e) {
            // Không phải URL hợp lệ, bỏ qua field này
            console.warn('⚠️ Invalid URL for nguon_bai_viet:', sourceUrl);
          }
        }
      }
      if (post.id_truong || post.idTruong) {
        const idTruong = post.id_truong || post.idTruong;
        if (idTruong) {
          updateData.id_truong = parseInt(idTruong, 10);
        }
      }
      if (post.ma_nguon || post.maNguon) {
        updateData.ma_nguon = post.ma_nguon || post.maNguon;
      }
      
      const response = await api.rejectNews(postId, updateData);
      
      if (response.success) {
        showToast(
          isBulk 
            ? `Đã từ chối ${isBulk === true ? selectedItems.length : 1} tin tức thành công`
            : "Đã từ chối tin tức thành công",
          "success"
        );
        loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
        if (isBulk) {
          setSelectedItems([]);
        }
      } else {
        const errorMsg = response.errors 
          ? Object.values(response.errors).flat().join(', ')
          : response.message || "Lỗi khi từ chối tin tức";
        console.error('❌ Reject error:', response);
        showToast(errorMsg, "error");
      }
    } catch (error) {
      console.error('❌ Reject exception:', error);
      showToast(error.message || "Lỗi kết nối khi từ chối tin tức", "error");
    }
  };

  // Handle bulk approve
  const handleBulkApprove = async () => {
    if (selectedItems.length === 0) {
      showToast("Vui lòng chọn ít nhất một tin tức", "error");
      return;
    }
    
    setBulkLoading(true);
    let successCount = 0;
    let errorCount = 0;
    
    for (const itemId of selectedItems) {
      const post = posts.find(p => {
        const pid = p.id_tin || p.idtintuyensinh || p.id || p.idTin || p.idtin;
        return pid == itemId; // Use == for type coercion
      });
      if (post) {
        try {
          await handleApprove(post, false);
          successCount++;
        } catch (error) {
          errorCount++;
        }
      }
    }
    
    setBulkLoading(false);
    setSelectedItems([]);
    
    if (errorCount > 0) {
      showToast(`Đã duyệt ${successCount} tin, ${errorCount} tin lỗi`, "warning");
    } else {
      showToast(`Đã duyệt ${successCount} tin tức thành công`, "success");
    }
    
    loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
  };

  // Handle bulk reject
  const handleBulkReject = async () => {
    if (selectedItems.length === 0) {
      showToast("Vui lòng chọn ít nhất một tin tức", "error");
      return;
    }
    
    setBulkLoading(true);
    let successCount = 0;
    let errorCount = 0;
    
    for (const itemId of selectedItems) {
      const post = posts.find(p => {
        const pid = p.id_tin || p.idtintuyensinh || p.id || p.idTin || p.idtin;
        return pid == itemId; // Use == for type coercion
      });
      if (post) {
        try {
          await handleReject(post, false);
          successCount++;
        } catch (error) {
          errorCount++;
        }
      }
    }
    
    setBulkLoading(false);
    setSelectedItems([]);
    
    if (errorCount > 0) {
      showToast(`Đã từ chối ${successCount} tin, ${errorCount} tin lỗi`, "warning");
    } else {
      showToast(`Đã từ chối ${successCount} tin tức thành công`, "success");
    }
    
    loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
  };

  // Handle bulk hide
  const handleBulkHide = async () => {
    if (selectedItems.length === 0) {
      showToast("Vui lòng chọn ít nhất một tin tức", "error");
      return;
    }
    
    setBulkLoading(true);
    let successCount = 0;
    let errorCount = 0;
    
    for (const itemId of selectedItems) {
      const post = posts.find(p => {
        const pid = p.id_tin || p.idtintuyensinh || p.id || p.idTin || p.idtin;
        return pid == itemId; // Use == for type coercion
      });
      if (post) {
        try {
          await handleHide(post, false);
          successCount++;
        } catch (error) {
          errorCount++;
        }
      }
    }
    
    setBulkLoading(false);
    setSelectedItems([]);
    
    if (errorCount > 0) {
      showToast(`Đã ẩn ${successCount} tin, ${errorCount} tin lỗi`, "warning");
    } else {
      showToast(`Đã ẩn ${successCount} tin tức thành công`, "success");
    }
    
    loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
  };

  // Handle bulk show
  const handleBulkShow = async () => {
    if (selectedItems.length === 0) {
      showToast("Vui lòng chọn ít nhất một tin tức", "error");
      return;
    }
    
    setBulkLoading(true);
    let successCount = 0;
    let errorCount = 0;
    
    for (const itemId of selectedItems) {
      const post = posts.find(p => {
        const pid = p.id_tin || p.idtintuyensinh || p.id || p.idTin || p.idtin;
        return pid == itemId; // Use == for type coercion
      });
      if (post) {
        try {
          await handleShow(post, false);
          successCount++;
        } catch (error) {
          errorCount++;
        }
      }
    }
    
    setBulkLoading(false);
    setSelectedItems([]);
    
    if (errorCount > 0) {
      showToast(`Đã hiện ${successCount} tin, ${errorCount} tin lỗi`, "warning");
    } else {
      showToast(`Đã hiện ${successCount} tin tức thành công`, "success");
    }
    
    loadPosts(currentPage, searchTerm, filterLoaiTin, filterTrangThai);
  };

  // Toggle select item
  const toggleSelectItem = (itemId) => {
    setSelectedItems(prev => 
      prev.includes(itemId) 
        ? prev.filter(id => id !== itemId)
        : [...prev, itemId]
    );
  };

  // Toggle select all
  const toggleSelectAll = () => {
    if (selectedItems.length === posts.length) {
      setSelectedItems([]);
    } else {
      setSelectedItems(posts.map(p => {
        return p.id_tin || p.idtintuyensinh || p.id || p.idTin || p.idtin;
      }));
    }
  };

  // Open detail modal
  const openDetailModal = async (post) => {
    // Thử nhiều cách lấy ID - kiểm tra tất cả các field có thể chứa ID
    const postId = post.id_tin ||           // Field từ database
                   post.idtintuyensinh || 
                   post.id || 
                   post.idtin_tuyen_sinh ||
                   post.id_tin_tuyen_sinh ||
                   post.idTin ||
                   post.idtin;
    
    if (!postId) {
      // Thử dùng dữ liệu từ post object trực tiếp nếu không có ID
      if (post.tieu_de || post.tieude) {
        setSelectedPost(post);
        setShowModal(true);
        return;
      }
      showToast("Không tìm thấy ID tin tức", "error");
      return;
    }
    
    try {
      const response = await api.getNewsById(postId);
      
      if (response.success) {
        setSelectedPost(response.data);
        setShowModal(true);
      } else {
        showToast("Không thể tải chi tiết tin tức", "error");
      }
    } catch (error) {
      console.error('❌ Error loading news detail:', error);
      showToast("Lỗi kết nối khi tải chi tiết", "error");
    }
  };

  // Show confirmation modal
  const showConfirmation = (action, item) => {
    setConfirmAction(action);
    setConfirmItem(item);
    setShowConfirmModal(true);
  };

  // Execute confirmed action
  const executeConfirmedAction = () => {
    if (confirmAction === "approve") {
      if (confirmItem === "bulk") {
        handleBulkApprove();
      } else {
        handleApprove(confirmItem);
      }
    } else if (confirmAction === "reject") {
      if (confirmItem === "bulk") {
        handleBulkReject();
      } else {
        handleReject(confirmItem);
      }
    } else if (confirmAction === "hide") {
      if (confirmItem === "bulk") {
        handleBulkHide();
      } else {
        handleHide(confirmItem);
      }
    } else if (confirmAction === "show") {
      if (confirmItem === "bulk") {
        handleBulkShow();
      } else {
        handleShow(confirmItem);
      }
    }
    setShowConfirmModal(false);
    setConfirmAction(null);
    setConfirmItem(null);
  };

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900">Phê duyệt tin tuyển sinh</h1>
        <p className="text-gray-600 mt-1">Duyệt và quản lý các tin tức đang chờ phê duyệt</p>
      </div>

      {/* Filters */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-4 mb-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Tìm kiếm</label>
            <input
              type="text"
              placeholder="Tìm theo tiêu đề..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            />
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Loại tin</label>
            <select
              value={filterLoaiTin}
              onChange={(e) => setFilterLoaiTin(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">Tất cả</option>
              <option value="Tin tuyển sinh">Tin tuyển sinh</option>
              <option value="Thông báo">Thông tin</option>
            </select>
          </div>
          
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Trạng thái</label>
            <select
              value={filterTrangThai}
              onChange={(e) => setFilterTrangThai(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            >
              <option value="">Tất cả</option>
              <option value="Chờ duyệt">Chờ duyệt</option>
              <option value="Đã duyệt">Đã duyệt</option>
              <option value="Đã gỡ">Đã gỡ</option>
            </select>
          </div>
        </div>
      </div>

      {/* Bulk Actions */}
      {selectedItems.length > 0 && (
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-6 flex items-center justify-between">
          <span className="text-blue-800 font-medium">
            Đã chọn {selectedItems.length} tin tức
          </span>
          <div className="flex gap-2">
            <button
              onClick={() => showConfirmation("approve", "bulk")}
              disabled={bulkLoading}
              className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {bulkLoading ? "Đang xử lý..." : "Duyệt tất cả"}
            </button>
            <button
              onClick={() => showConfirmation("reject", "bulk")}
              disabled={bulkLoading}
              className="px-4 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {bulkLoading ? "Đang xử lý..." : "Từ chối tất cả"}
            </button>
            <button
              onClick={() => setSelectedItems([])}
              className="px-4 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400"
            >
              Bỏ chọn
            </button>
          </div>
        </div>
      )}

      {/* Posts Table */}
      <div className="bg-white rounded-lg shadow-sm border border-gray-200 overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left">
                  <input
                    type="checkbox"
                    checked={selectedItems.length === posts.length && posts.length > 0}
                    onChange={toggleSelectAll}
                    className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                  />
                </th>
                <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Tiêu đề</th>
                <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Loại tin</th>
                <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Trạng thái</th>
                <th className="px-4 py-3 text-left text-sm font-semibold text-gray-700">Thao tác</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200">
              {loading ? (
                <tr>
                  <td colSpan="5" className="px-4 py-8 text-center text-gray-500">
                    Đang tải...
                  </td>
                </tr>
              ) : posts.length === 0 ? (
                <tr>
                  <td colSpan="5" className="px-4 py-8 text-center text-gray-500">
                    Không có tin tức nào
                  </td>
                </tr>
              ) : (
                posts.map((post) => {
                  // Lấy ID từ nhiều nguồn có thể
                  const postId = post.id_tin || 
                                 post.idtintuyensinh || 
                                 post.id || 
                                 post.idtin_tuyen_sinh ||
                                 post.id_tin_tuyen_sinh ||
                                 post.idTin ||
                                 post.idtin;
                  const isSelected = selectedItems.includes(postId);
                  
                  return (
                    <tr 
                      key={postId || `post-${Date.now()}-${Math.random()}`} 
                      className={isSelected ? "bg-blue-50" : "hover:bg-gray-50"}
                    >
                      <td className="px-4 py-3">
                        <input
                          type="checkbox"
                          checked={isSelected}
                          onChange={() => toggleSelectItem(postId)}
                          className="rounded border-gray-300 text-blue-600 focus:ring-blue-500"
                        />
                      </td>
                      <td className="px-4 py-3">
                        <div className="max-w-md">
                          <p className="text-sm font-medium text-gray-900 truncate">
                            {post.tieu_de || post.tieude || "Không có tiêu đề"}
                          </p>
                        </div>
                      </td>
                      <td className="px-4 py-3">
                        <span className="text-sm text-gray-600">
                          {post.loai_tin || "N/A"}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <span className={`px-2 py-1 text-xs font-medium rounded-full ${
                          post.trang_thai === "Đã duyệt" 
                            ? "bg-green-100 text-green-800"
                            : post.trang_thai === "Đã gỡ"
                            ? "bg-red-100 text-red-800"
                            : post.trang_thai === "Ẩn"
                            ? "bg-gray-100 text-gray-800"
                            : "bg-yellow-100 text-yellow-800"
                        }`}>
                          {post.trang_thai || "Chờ duyệt"}
                        </span>
                      </td>
                      <td className="px-4 py-3">
                        <div className="flex flex-wrap items-center">
                          <span className="mr-2">
                          <button
                            onClick={() => openDetailModal(post)}
                              className="px-3 py-1.5 text-sm text-blue-600 hover:text-blue-800 hover:bg-blue-50 rounded whitespace-nowrap"
                          >
                            Xem
                          </button>
                          </span>
                          {post.trang_thai === "Chờ duyệt" && (
                            <>
                              <span className="mr-2">
                              <button
                                onClick={() => showConfirmation("approve", post)}
                                  className="px-3 py-1.5 text-sm text-green-600 hover:text-green-800 hover:bg-green-50 rounded whitespace-nowrap"
                              >
                                Duyệt
                              </button>
                              </span>
                              <span className="mr-2">
                              <button
                                onClick={() => showConfirmation("reject", post)}
                                  className="px-3 py-1.5 text-sm text-red-600 hover:text-red-800 hover:bg-red-50 rounded whitespace-nowrap"
                              >
                                Từ chối
                              </button>
                              </span>
                            </>
                          )}
                          {post.trang_thai === "Ẩn" && (
                            <span>
                              <button
                                onClick={() => showConfirmation("show", post)}
                                className="px-3 py-1.5 text-sm text-blue-600 hover:text-blue-800 hover:bg-blue-50 rounded whitespace-nowrap"
                              >
                                Hiện
                              </button>
                            </span>
                          )}
                          {post.trang_thai !== "Ẩn" && post.trang_thai !== "Chờ duyệt" && (
                            <span>
                              <button
                                onClick={() => showConfirmation("hide", post)}
                                className="px-3 py-1.5 text-sm text-gray-600 hover:text-gray-800 hover:bg-gray-50 rounded whitespace-nowrap"
                              >
                                Ẩn
                              </button>
                            </span>
                          )}
                        </div>
                      </td>
                    </tr>
                  );
                })
              )}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="px-4 py-3 border-t border-gray-200 flex items-center justify-between">
            <div className="text-sm text-gray-600">
              Hiển thị {((currentPage - 1) * 20) + 1} - {Math.min(currentPage * 20, totalRecords)} trong tổng số {totalRecords} tin tức
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => loadPosts(currentPage - 1, searchTerm, filterLoaiTin, filterTrangThai)}
                disabled={currentPage === 1 || loading}
                className="px-3 py-1 border border-gray-300 rounded-lg text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
              >
                Trước
              </button>
              <span className="px-3 py-1 text-sm text-gray-700">
                Trang {currentPage} / {totalPages}
              </span>
              <button
                onClick={() => loadPosts(currentPage + 1, searchTerm, filterLoaiTin, filterTrangThai)}
                disabled={currentPage === totalPages || loading}
                className="px-3 py-1 border border-gray-300 rounded-lg text-sm disabled:opacity-50 disabled:cursor-not-allowed hover:bg-gray-50"
              >
                Sau
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Detail Modal */}
      {showModal && selectedPost && (
        <Modal
          open={showModal}
          onClose={() => {
            setShowModal(false);
            setSelectedPost(null);
          }}
          title=""
        >
          {(() => {
            const title = selectedPost.tieu_de || selectedPost.tieude || selectedPost.tieuDe || "N/A";
            const summary = selectedPost.tom_tat || selectedPost.tomtat || selectedPost.tomTat || "N/A";
            const newsType = selectedPost.loai_tin || selectedPost.loaiTin || "N/A";
            const status = selectedPost.trang_thai || selectedPost.trangThai || "N/A";
            const source = selectedPost.nguon_bai_viet || selectedPost.nguonBaiViet;
            const image = selectedPost.hinh_anh_dai_dien || selectedPost.hinhAnhDaiDien;
            const school = selectedPost.tentruong;
            const postDate = selectedPost.ngay_dang || selectedPost.ngayDang;
            const updateDate = selectedPost.ngay_cap_nhat || selectedPost.ngayCapNhat;
            const postId = selectedPost.id_tin || selectedPost.idTin || selectedPost.idtintuyensinh || selectedPost.id || "N/A";
            
            // Format date
            const formatDate = (dateStr) => {
              if (!dateStr) return null;
              try {
                const date = new Date(dateStr);
                return date.toLocaleDateString('vi-VN', {
                  weekday: 'long',
                  year: 'numeric',
                  month: 'long',
                  day: 'numeric'
                });
              } catch {
                return dateStr;
              }
            };
            
            const formatDateTime = (dateStr) => {
              if (!dateStr) return null;
              try {
                const date = new Date(dateStr);
                return date.toLocaleString('vi-VN', {
                  hour: '2-digit',
                  minute: '2-digit',
                  day: 'numeric',
                  month: 'numeric',
                  year: 'numeric'
                });
              } catch {
                return dateStr;
              }
            };
            
            // Status badge color
            const getStatusColor = (status) => {
              switch(status) {
                case 'Đã duyệt':
                  return 'bg-green-100 text-green-800 border-green-200';
                case 'Chờ duyệt':
                  return 'bg-yellow-100 text-yellow-800 border-yellow-200';
                case 'Ẩn':
                  return 'bg-gray-100 text-gray-800 border-gray-200';
                case 'Đã gỡ':
                  return 'bg-red-100 text-red-800 border-red-200';
                default:
                  return 'bg-gray-100 text-gray-800 border-gray-200';
              }
            };
            
            return (
              <div className="max-h-[90vh] overflow-y-auto">
                {/* Header Section */}
                <div className="mb-6 pb-4 border-b border-gray-200">
                  <div className="flex items-start justify-between mb-3">
                    <div className="flex-1">
                      {postDate && (
                        <p className="text-sm text-gray-600 mb-2">
                          {formatDate(postDate)}
                        </p>
                      )}
                      <h2 className="text-xl font-bold text-gray-900 mb-2">{title}</h2>
                      <div className="flex flex-wrap gap-2 items-center">
                        <span className="text-sm text-gray-600">{newsType}</span>
                        {school && (
                          <>
                            <span className="text-gray-400">•</span>
                            <span className="text-sm text-gray-600">{school}</span>
                          </>
                        )}
                      </div>
                    </div>
                    <div className="flex gap-2 ml-4">
                      <span className={`px-3 py-1 rounded-lg text-sm font-medium border ${getStatusColor(status)}`}>
                        {status}
                      </span>
                    </div>
                  </div>
                </div>

                {/* Main Content Card */}
                <div className="bg-white rounded-lg border border-gray-200 p-6 mb-6">
                  {/* Summary Section */}
                  <div className="mb-6">
                    <label className="block text-sm font-semibold text-gray-700 mb-2">
                      Tóm tắt
                    </label>
                    <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                      <p className="text-sm text-gray-900 whitespace-pre-wrap leading-relaxed">
                        {summary}
                      </p>
                    </div>
                  </div>

                  {/* Image Section */}
                  {image && (
                    <div className="mb-6">
                      <label className="block text-sm font-semibold text-gray-700 mb-2">
                        Hình ảnh đại diện
                      </label>
                      <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                        <img 
                          src={image} 
                          alt={title}
                          className="w-full h-auto rounded-lg object-contain max-h-96 mx-auto"
                          onError={(e) => {
                            console.error('❌ Error loading image:', e);
                            e.target.parentElement.innerHTML = '<p class="text-sm text-gray-500 text-center py-4">Không thể tải hình ảnh</p>';
                          }}
                        />
                      </div>
                    </div>
                  )}

                  {/* Additional Information */}
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                      <label className="block text-sm font-semibold text-gray-700 mb-1">
                        Loại tin
                      </label>
                      <p className="text-sm text-gray-900 bg-gray-50 rounded-lg px-3 py-2 border border-gray-200">
                        {newsType}
                      </p>
            </div>
                    
                    {source && (
            <div>
                        <label className="block text-sm font-semibold text-gray-700 mb-1">
                          Nguồn bài viết
                        </label>
                        <a 
                          href={source} 
                          target="_blank" 
                          rel="noopener noreferrer"
                          className="text-sm text-blue-600 hover:text-blue-800 hover:underline break-all bg-gray-50 rounded-lg px-3 py-2 border border-gray-200 block"
                        >
                          {source}
                        </a>
            </div>
                    )}
                  </div>
            </div>

                {/* Footer Information */}
                <div className="bg-gray-50 rounded-lg p-4 border border-gray-200">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs text-gray-600">
            <div>
                      <span className="font-medium">ID tin tức:</span> {postId}
            </div>
                    {postDate && (
            <div>
                        <span className="font-medium">Ngày đăng:</span> {formatDateTime(postDate)}
            </div>
                    )}
                    {updateDate && (
              <div>
                        <span className="font-medium">Ngày cập nhật:</span> {formatDateTime(updateDate)}
              </div>
            )}
          </div>
                </div>
              </div>
            );
          })()}
        </Modal>
      )}

      {/* Confirmation Modal */}
      {showConfirmModal && (
        <Modal
          open={showConfirmModal}
          onClose={() => {
            setShowConfirmModal(false);
            setConfirmAction(null);
            setConfirmItem(null);
          }}
          title={
            confirmAction === "approve" 
              ? "Xác nhận duyệt" 
              : confirmAction === "reject"
              ? "Xác nhận từ chối"
              : confirmAction === "hide"
              ? "Xác nhận ẩn tin tức"
              : "Xác nhận hiện tin tức"
          }
        >
          <div className="space-y-4">
            <div className="text-gray-700">
              {confirmAction === "approve" 
                ? confirmItem === "bulk"
                  ? <p>Bạn có chắc chắn muốn duyệt {selectedItems.length} tin tức đã chọn?</p>
                  : <p>Bạn có chắc chắn muốn duyệt tin tức này?</p>
                : confirmAction === "reject"
                ? confirmItem === "bulk"
                  ? <p>Bạn có chắc chắn muốn từ chối {selectedItems.length} tin tức đã chọn?</p>
                  : <p>Bạn có chắc chắn muốn từ chối tin tức này?</p>
                : confirmAction === "hide"
                ? confirmItem === "bulk"
                  ? <p>Bạn có chắc chắn muốn ẩn {selectedItems.length} tin tức đã chọn?</p>
                  : <p>Bạn có chắc chắn muốn ẩn tin tức này?</p>
                : confirmItem === "bulk"
                ? <p>Bạn có chắc chắn muốn hiện {selectedItems.length} tin tức đã chọn? (Trạng thái sẽ đổi thành 'Đã duyệt')</p>
                : (
                  <>
                    <p>Bạn có chắc chắn muốn hiện tin tức này?</p>
                    <p className="text-sm text-gray-600 mt-1">Trạng thái sẽ đổi thành 'Đã duyệt'</p>
                  </>
                )}
            </div>
            <div className="flex gap-2 justify-end">
              <button
                onClick={() => {
                  setShowConfirmModal(false);
                  setConfirmAction(null);
                  setConfirmItem(null);
                }}
                className="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50"
              >
                Hủy
              </button>
              <button
                onClick={executeConfirmedAction}
                className={`px-4 py-2 rounded-lg text-white ${
                  confirmAction === "approve" 
                    ? "bg-green-600 hover:bg-green-700"
                    : confirmAction === "reject"
                    ? "bg-red-600 hover:bg-red-700"
                    : confirmAction === "show"
                    ? "bg-blue-600 hover:bg-blue-700"
                    : "bg-gray-600 hover:bg-gray-700"
                }`}
              >
                Xác nhận
              </button>
            </div>
          </div>
        </Modal>
      )}

      {/* Toast */}
      {toast.show && (
        <Toast
          message={toast.message}
          type={toast.type}
          onClose={() => setToast({ show: false, message: "", type: "success" })}
        />
      )}
    </div>
  );
}
