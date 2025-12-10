import { useState, useEffect } from "react";
import Modal from "../../components/Modal";
import Toast from "../../components/Toast";
import apiService from "../../services/api";

export default function Posts() {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [searchTerm, setSearchTerm] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [deleteId, setDeleteId] = useState(null);
  const [toast, setToast] = useState({ show: false, message: "", type: "success" });

  // Filter states
  const [filterUniversity, setFilterUniversity] = useState("");
  const [filterLoaiTin, setFilterLoaiTin] = useState("");
  const [filterTrangThai, setFilterTrangThai] = useState("");

  // Dropdown data
  const [universities, setUniversities] = useState([]);

  // Form data
  const [formData, setFormData] = useState({
    id_truong: "",
    tieu_de: "",
    tom_tat: "",
    hinh_anh_dai_dien: "",
    nguon_bai_viet: "",
    loai_tin: "Tin tuyển sinh",
    trang_thai: "Chờ duyệt",
    ma_nguon: ""
  });
  const [fileHinhAnh, setFileHinhAnh] = useState(null);
  const [formErrors, setFormErrors] = useState({});

  const showToast = (message, type = "success") => {
    setToast({ show: true, message, type });
    setTimeout(() => setToast({ show: false, message: "", type: "success" }), 3000);
  };

  // Load universities for dropdown
  const loadUniversities = async () => {
    try {
      const data = await apiService.get("/admin/truongdaihoc", { per_page: 1000, page: 1 });
      if (data.success) setUniversities(data.data || []);
    } catch (error) {
      console.error("Error loading universities:", error);
    }
  };

  // Load posts data
  const loadPosts = async (page = 1, keyword = "", id_truong = "", loai_tin = "", trang_thai = "") => {
    setLoading(true);
    try {
      const params = {
        page,
        per_page: 20,
        ...(keyword && { keyword }),
        ...(id_truong && { id_truong }),
        ...(loai_tin && { loai_tin }),
        ...(trang_thai && { trang_thai }),
      };

      const data = await apiService.get("/admin/tin-tuyen-sinh", params);

      if (data.success) {
        setPosts(data.data || []);
        setTotalPages(data.pagination?.last_page || 1);
        setTotalRecords(data.pagination?.total || 0);
        setCurrentPage(data.pagination?.current_page || 1);
      } else {
        showToast(data.message || "Lỗi khi tải dữ liệu", "error");
      }
    } catch (error) {
      showToast("Lỗi kết nối", "error");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadUniversities();
    loadPosts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  useEffect(() => {
    const timeoutId = setTimeout(() => {
      loadPosts(1, searchTerm, filterUniversity, filterLoaiTin, filterTrangThai);
    }, searchTerm ? 500 : 0);
    return () => clearTimeout(timeoutId);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [searchTerm, filterUniversity, filterLoaiTin, filterTrangThai]);

  const handleOpenModal = (item = null) => {
    if (item) {
      setEditingItem(item);
      setFormData({
        id_truong: item.id_truong || "",
        tieu_de: item.tieu_de || "",
        tom_tat: item.tom_tat || "",
        hinh_anh_dai_dien: item.hinh_anh_dai_dien || "",
        nguon_bai_viet: item.nguon_bai_viet || "",
        loai_tin: item.loai_tin || "Tin tuyển sinh",
        trang_thai: item.trang_thai || "Chờ duyệt",
        ma_nguon: item.ma_nguon || ""
      });
      setFileHinhAnh(null);
    } else {
      setEditingItem(null);
      setFormData({
        id_truong: "",
        tieu_de: "",
        tom_tat: "",
        hinh_anh_dai_dien: "",
        nguon_bai_viet: "",
        loai_tin: "Tin tuyển sinh",
        trang_thai: "Chờ duyệt",
        ma_nguon: ""
      });
      setFileHinhAnh(null);
    }
    setFormErrors({});
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setEditingItem(null);
    setFormErrors({});
  };

  // Thêm/Sửa bài viết (multipart/form-data)
  const handleSubmit = async (e) => {
    e.preventDefault();
    setFormErrors({});

    try {
      const url = editingItem
        ? `${apiService.baseURL}/admin/tin-tuyen-sinh/${editingItem.id_tin}`
        : `${apiService.baseURL}/admin/tin-tuyen-sinh`;
      const method = editingItem ? "PUT" : "POST";

      const fd = new FormData();
      fd.append("id_truong", formData.id_truong || "");
      fd.append("tieu_de", formData.tieu_de || "");
      fd.append("tom_tat", formData.tom_tat || "");
      fd.append("nguon_bai_viet", formData.nguon_bai_viet || "");
      fd.append("loai_tin", formData.loai_tin || "Tin tuyển sinh");
      fd.append("trang_thai", formData.trang_thai || "Chờ duyệt");
      fd.append("ma_nguon", formData.ma_nguon || "");

      if (fileHinhAnh) {
        fd.append("file_hinh_anh", fileHinhAnh);
      } else if (formData.hinh_anh_dai_dien) {
        fd.append("hinh_anh_dai_dien", formData.hinh_anh_dai_dien);
      }

      const token = localStorage.getItem("token");
      const resp = await fetch(url, {
        method,
        body: fd,
        headers: {
          Accept: "application/json",
          ...(token && { Authorization: `Bearer ${token}` }),
          // KHÔNG set Content-Type để trình duyệt tự thêm boundary cho FormData
        },
      });
      const data = await resp.json();

      if (data.success) {
        showToast(editingItem ? "Cập nhật tin thành công" : "Thêm tin thành công", "success");
        handleCloseModal();
        loadPosts(currentPage, searchTerm, filterUniversity, filterLoaiTin, filterTrangThai);
      } else {
        if (data.errors) setFormErrors(data.errors);
        showToast(data.message || "Có lỗi xảy ra", "error");
      }
    } catch (error) {
      showToast("Lỗi kết nối", "error");
    }
  };

  // Xóa bài viết
  const handleDelete = async () => {
    try {
      const data = await apiService.delete(`/admin/tin-tuyen-sinh/${deleteId}`);
      if (data.success) {
        showToast("Xóa tin thành công", "success");
        setShowDeleteModal(false);
        setDeleteId(null);
        loadPosts(currentPage, searchTerm, filterUniversity, filterLoaiTin, filterTrangThai);
      } else {
        showToast(data.message || "Có lỗi xảy ra", "error");
      }
    } catch (error) {
      showToast("Lỗi kết nối", "error");
    }
  };

  const formatDate = (dateString) => {
    if (!dateString) return "-";
    const date = new Date(dateString);
    return date.toLocaleDateString("vi-VN");
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8FFF6] via-white to-[#E3F2FD] -mx-6 -my-4 px-6 py-4">
      <div className="max-w-6xl mx-auto space-y-6">
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <p className="text-xs uppercase tracking-widest text-[#0F8B6E] font-semibold">
              Trung tâm nội dung
            </p>
            <h1 className="text-3xl font-bold text-gray-900">Quản lý tin tức tuyển sinh</h1>
            <p className="text-sm text-gray-500 mt-1">
              Chủ động theo dõi, lọc và cập nhật các bài viết mới nhất.
            </p>
          </div>
          <button
            onClick={() => handleOpenModal()}
            className="px-4 py-2 rounded-full bg-gradient-to-r from-[#34D399] to-[#0D9488] text-white font-semibold shadow hover:opacity-90 transition"
          >
            + Đăng tin mới
          </button>
        </div>

        {toast.show && (
          <div
            className={`rounded-2xl border px-4 py-3 text-sm font-semibold shadow-sm ${
              toast.type === "success"
                ? "bg-[#ECFDF5] border-[#A7F3D0] text-[#047857]"
                : toast.type === "error"
                ? "bg-[#FEF2F2] border-[#FECACA] text-[#B91C1C]"
                : "bg-[#EFF6FF] border-[#BFDBFE] text-[#1D4ED8]"
            }`}
          >
            {toast.message}
          </div>
        )}

        {/* Filters */}
        <div className="bg-white rounded-2xl shadow-sm border border-[#D7F2E8] p-5 space-y-4">
          <div className="grid lg:grid-cols-4 gap-4">
            <div className="col-span-2">
              <label className="block text-xs font-semibold text-gray-500 uppercase mb-2">
                Từ khóa
              </label>
              <input
                type="text"
                placeholder="Tìm theo tiêu đề, mô tả..."
                className="input w-full"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-500 uppercase mb-2">
                Trường
              </label>
              <select
                className="input w-full"
                value={filterUniversity}
                onChange={(e) => setFilterUniversity(e.target.value)}
              >
                <option value="">Tất cả trường</option>
                {universities.map((u) => (
                  <option key={u.idtruong} value={u.idtruong}>
                    {u.tentruong}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-500 uppercase mb-2">
                Loại tin
              </label>
              <select
                className="input w-full"
                value={filterLoaiTin}
                onChange={(e) => setFilterLoaiTin(e.target.value)}
              >
                <option value="">Tất cả loại tin</option>
                <option value="Tin tuyển sinh">Tin tuyển sinh</option>
                <option value="Thông báo">Thông báo</option>
                <option value="Học bổng">Học bổng</option>
                <option value="Sự kiện">Sự kiện</option>
                <option value="Khác">Khác</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-gray-500 uppercase mb-2">
                Trạng thái
              </label>
              <select
                className="input w-full"
                value={filterTrangThai}
                onChange={(e) => setFilterTrangThai(e.target.value)}
              >
                <option value="">Tất cả trạng thái</option>
                <option value="Chờ duyệt">Chờ duyệt</option>
                <option value="Đã duyệt">Đã duyệt</option>
                <option value="Ẩn">Ẩn</option>
                <option value="Đã gỡ">Đã gỡ</option>
              </select>
            </div>
          </div>

          <div className="flex flex-wrap justify-between items-center gap-4">
            <p className="text-sm text-gray-500">
              {totalRecords ? `Hiện có ${totalRecords} bài viết trong hệ thống` : "Không có dữ liệu"}
            </p>
            <div className="flex gap-3">
              <button
                className="px-4 py-2 rounded-full border border-gray-200 text-gray-600 hover:text-[#0F8B6E] hover:border-[#0F8B6E]"
                onClick={() => {
                  setSearchTerm("");
                  setFilterUniversity("");
                  setFilterLoaiTin("");
                  setFilterTrangThai("");
                  loadPosts(1);
                }}
              >
                Làm mới
              </button>
            </div>
          </div>
        </div>

        {/* Table */}
        <div className="bg-white rounded-2xl shadow-sm border border-[#E2E8F0]">
          {loading ? (
            <div className="p-10 text-center">Đang tải dữ liệu...</div>
          ) : (
            <>
              <table className="w-full">
                <thead className="bg-[#F4F9FF] text-xs text-gray-500 uppercase tracking-wide">
                  <tr>
                    <th className="px-4 py-3 text-left font-semibold w-14">ID</th>
                    <th className="px-4 py-3 text-left font-semibold">Tiêu đề</th>
                    <th className="px-4 py-3 text-left font-semibold w-48">Trường</th>
                    <th className="px-4 py-3 text-center font-semibold w-32">Loại tin</th>
                    <th className="px-4 py-3 text-center font-semibold w-32">Trạng thái</th>
                    <th className="px-4 py-3 text-left font-semibold w-28">Ngày đăng</th>
                    <th className="px-4 py-3 text-left font-semibold w-28">Thao tác</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-[#F0F4F8]">
                  {posts.length === 0 ? (
                    <tr>
                      <td colSpan="7" className="px-4 py-12 text-center text-gray-500">
                        Chưa có bài viết nào phù hợp
                      </td>
                    </tr>
                  ) : (
                    posts.map((post) => (
                      <tr key={post.id_tin} className="hover:bg-[#F9FFFC] transition">
                        <td className="px-4 py-3 text-sm text-gray-600">{post.id_tin}</td>
                        <td className="px-4 py-3">
                          <div className="font-semibold text-gray-900 line-clamp-1">{post.tieu_de}</div>
                          {post.tom_tat && (
                            <div className="text-sm text-gray-500 line-clamp-1">{post.tom_tat}</div>
                          )}
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-600">{post.tentruong || "-"}</td>
                        <td className="px-4 py-3 text-center">
                          <span className="inline-block min-w-[90px] px-2.5 py-1 text-xs rounded-full bg-[#E3F5EE] text-[#0F8B6E] font-semibold">
                            {post.loai_tin}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-center">
                          <span
                            className={`inline-block min-w-[90px] px-2.5 py-1 text-xs rounded-full font-semibold ${
                              post.trang_thai === "Đã duyệt"
                                ? "bg-[#ECFDF5] text-[#047857]"
                                : post.trang_thai === "Chờ duyệt"
                                ? "bg-[#FEF3C7] text-[#92400E]"
                                : post.trang_thai === "Ẩn"
                                ? "bg-gray-100 text-gray-600"
                                : "bg-[#FFE4E6] text-[#BE123C]"
                            }`}
                          >
                            {post.trang_thai}
                          </span>
                        </td>
                        <td className="px-4 py-3 text-sm text-gray-600">{formatDate(post.ngay_dang)}</td>
                        <td className="px-4 py-3">
                          <div className="flex gap-2">
                            <button
                              onClick={() => handleOpenModal(post)}
                              className="text-[#0F8B6E] hover:underline text-sm font-semibold"
                            >
                              Sửa
                            </button>
                            {post.trang_thai !== "Đã duyệt" && (
                              <>
                                <span className="text-gray-300">|</span>
                                <button
                                  onClick={() => {
                                    setDeleteId(post.id_tin);
                                    setShowDeleteModal(true);
                                  }}
                                  className="text-[#D9463E] hover:underline text-sm font-semibold"
                                >
                                  Xóa
                                </button>
                              </>
                            )}
                          </div>
                        </td>
                      </tr>
                    ))
                  )}
                </tbody>
              </table>

              {/* Pagination */}
              {totalPages > 1 && (
                <div className="px-4 py-4 border-t flex flex-wrap gap-3 items-center justify-between text-sm text-gray-600">
                  <div>
                    Hiển thị {((currentPage - 1) * 20) + 1} - {Math.min(currentPage * 20, totalRecords)} / {totalRecords} bài
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() =>
                        loadPosts(currentPage - 1, searchTerm, filterUniversity, filterLoaiTin, filterTrangThai)
                      }
                      disabled={currentPage === 1}
                      className="px-4 py-2 rounded-full border border-gray-200 disabled:opacity-40"
                    >
                      Trước
                    </button>
                    <span className="px-4 py-2 rounded-full bg-[#E3F5EE] text-[#0F8B6E] font-semibold">
                      {currentPage} / {totalPages}
                    </span>
                    <button
                      onClick={() =>
                        loadPosts(currentPage + 1, searchTerm, filterUniversity, filterLoaiTin, filterTrangThai)
                      }
                      disabled={currentPage === totalPages}
                      className="px-4 py-2 rounded-full border border-gray-200 disabled:opacity-40"
                    >
                      Sau
                    </button>
                  </div>
                </div>
              )}
            </>
          )}
        </div>
      </div>

      {/* Add/Edit Modal */}
      <Modal open={showModal} onClose={handleCloseModal} title={editingItem ? "Cập nhật tin" : "Thêm tin mới"}>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium mb-1">Tiêu đề *</label>
            <input
              type="text"
              className={`input ${formErrors.tieu_de ? "border-red-500" : ""}`}
              value={formData.tieu_de}
              onChange={(e) => setFormData({ ...formData, tieu_de: e.target.value })}
              required
            />
            {formErrors.tieu_de && <p className="text-red-500 text-xs mt-1">{formErrors.tieu_de[0]}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium mb-1">Mô tả ngắn</label>
            <textarea
              className="input min-h-[100px]"
              value={formData.tom_tat}
              onChange={(e) => setFormData({ ...formData, tom_tat: e.target.value })}
            />
          </div>

          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Trường</label>
              <select
                className="input"
                value={formData.id_truong}
                onChange={(e) => setFormData({ ...formData, id_truong: e.target.value })}
              >
                <option value="">Chọn trường</option>
                {universities.map((u) => (
                  <option key={u.idtruong} value={u.idtruong}>
                    {u.tentruong}
                  </option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">Loại tin *</label>
              <select
                className="input"
                value={formData.loai_tin}
                onChange={(e) => setFormData({ ...formData, loai_tin: e.target.value })}
                required
              >
                <option value="Tin tuyển sinh">Tin tuyển sinh</option>
                <option value="Thông báo">Thông báo</option>
                <option value="Học bổng">Học bổng</option>
                <option value="Sự kiện">Sự kiện</option>
                <option value="Khác">Khác</option>
              </select>
            </div>
          </div>

          <div className="grid md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium mb-1">Link nguồn bài viết</label>
              <input
                type="url"
                className="input"
                placeholder="https://..."
                value={formData.nguon_bai_viet}
                onChange={(e) => setFormData({ ...formData, nguon_bai_viet: e.target.value })}
              />
            </div>

            <div>
              <label className="block text-sm font-medium mb-1">Hình ảnh đại diện</label>
              <div className="space-y-2">
                <input
                  type="file"
                  accept="image/*"
                  className="input"
                  onChange={(e) => setFileHinhAnh(e.target.files?.[0] || null)}
                />
                <input
                  type="url"
                  className="input"
                  placeholder="https://... (nếu không chọn file)"
                  value={formData.hinh_anh_dai_dien}
                  onChange={(e) => setFormData({ ...formData, hinh_anh_dai_dien: e.target.value })}
                />
                {fileHinhAnh && (
                  <img
                    src={URL.createObjectURL(fileHinhAnh)}
                    alt="preview"
                    style={{ width: 160, height: 120, objectFit: "cover", borderRadius: 8 }}
                  />
                )}
              </div>
            </div>
          </div>

          <input type="hidden" value={formData.trang_thai} readOnly />

          <div>
            <label className="block text-sm font-medium mb-1">Mã nguồn</label>
            <input
              type="text"
              className="input"
              placeholder="VD: DNU, FPT-HN, UEH"
              value={formData.ma_nguon}
              onChange={(e) => setFormData({ ...formData, ma_nguon: e.target.value })}
            />
          </div>

          <div className="flex justify-end gap-3 pt-4">
            <button type="button" onClick={handleCloseModal} className="btn-outline">
              Hủy
            </button>
            <button type="submit" className="btn-primary">
              {editingItem ? "Cập nhật" : "Thêm mới"}
            </button>
          </div>
        </form>
      </Modal>

      {/* Delete Confirmation Modal */}
      <Modal
        open={showDeleteModal}
        onClose={() => {
          setShowDeleteModal(false);
          setDeleteId(null);
        }}
        title="Xác nhận xóa"
      >
        <p className="mb-4">Bạn có chắc chắn muốn xóa tin này không?</p>
        <div className="flex justify-end gap-3">
          <button
            onClick={() => {
              setShowDeleteModal(false);
              setDeleteId(null);
            }}
            className="btn-outline"
          >
            Hủy
          </button>
          <button onClick={handleDelete} className="btn-primary bg-red-600 hover:bg-red-700">
            Xóa
          </button>
        </div>
      </Modal>

      {toast.show && <Toast message={toast.message} type={toast.type} />}
    </div>
  );
}