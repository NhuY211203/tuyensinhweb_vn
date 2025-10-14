import { useState } from "react";

export default function ApplicationForm() {
  const [showForm, setShowForm] = useState(false);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold mb-4">Mẫu phiếu đăng ký xét tuyển</h1>
      {!showForm ? (
        <>
          <div className="card p-5">
            <iframe
              src="/phieu-dang-ky-du-thi-tot-nghiep-THPT.pdf"
              title="Mẫu phiếu đăng ký"
              className="w-full min-h-[600px] border rounded"
            />
          </div>
          <div className="flex justify-end gap-3">
            <button className="btn-primary" onClick={() => setShowForm(true)}>
              Đăng ký hồ sơ xét tuyển
            </button>
          </div>
        </>
      ) : (
        <FormDangKy />
      )}
    </div>
  );
}

// Form đăng ký giống mẫu PDF (ví dụ, bạn cần bổ sung đủ trường cho giống mẫu PDF)
function FormDangKy() {
  const [form, setForm] = useState({
    hoTen: "",
    ngaySinh: "",
    gioiTinh: "",
    danToc: "",
    soCMND: "",
    email: "",
    dienThoai: "",
    // ... các trường khác theo mẫu PDF
  });
  const [isDraft, setIsDraft] = useState(false);

  const handleChange = e => setForm({ ...form, [e.target.name]: e.target.value });

  // Kiểm tra đã nhập đủ thông tin chưa
  const isFilled = Object.values(form).every(v => v);

  return (
    <form className="card p-5 space-y-4">
      <div className="grid md:grid-cols-2 gap-4">
        <input name="hoTen" className="input" placeholder="Họ và tên" value={form.hoTen} onChange={handleChange} />
        <input name="ngaySinh" className="input" placeholder="Ngày sinh" value={form.ngaySinh} onChange={handleChange} />
        <input name="gioiTinh" className="input" placeholder="Giới tính" value={form.gioiTinh} onChange={handleChange} />
        <input name="danToc" className="input" placeholder="Dân tộc" value={form.danToc} onChange={handleChange} />
        <input name="soCMND" className="input" placeholder="Số CMND" value={form.soCMND} onChange={handleChange} />
        <input name="email" className="input" placeholder="Email" value={form.email} onChange={handleChange} />
        <input name="dienThoai" className="input" placeholder="Điện thoại" value={form.dienThoai} onChange={handleChange} />
        {/* ... các trường khác */}
      </div>
      <div className="flex gap-3 justify-end mt-4">
        <button
          type="button"
          className="btn-outline"
          onClick={() => setIsDraft(true)}
        >
          Lưu nháp
        </button>
        <button
          type="submit"
          className={`btn-primary ${!isFilled ? "opacity-50 cursor-not-allowed" : ""}`}
          disabled={!isFilled}
        >
          Nộp hồ sơ
        </button>
        <button
          type="button"
          className="btn-outline"
          onClick={() => window.location.reload()}
        >
          Hủy
        </button>
      </div>
    </form>
  );
}