import { useState } from "react";

export default function Posts() {
  const [post, setPost] = useState({ tieuDe: "", nhom: "Tin tuyển sinh", truong: "", nam: new Date().getFullYear(), noiDung: "", linkNguon: ""});
  const onChange = (e) => setPost({ ...post, [e.target.name]: e.target.value });

  const submit = (e) => {
    e.preventDefault();
    alert("Đã tạo bản nháp tin (frontend placeholder). Bạn có thể nối API lưu tin sau.");
  };

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Đăng tin</h1>

      <form onSubmit={submit} className="card p-5 space-y-4">
        <div className="grid md:grid-cols-2 gap-4">
          <input name="tieuDe" className="input" placeholder="Tiêu đề" value={post.tieuDe} onChange={onChange} />
          <select name="nhom" className="input" value={post.nhom} onChange={onChange}>
            <option>Tin tuyển sinh</option>
            <option>Thông báo</option>
          </select>
          <input name="truong" className="input" placeholder="Trường (ví dụ: IUH)" value={post.truong} onChange={onChange} />
          <input name="nam" type="number" className="input" value={post.nam} onChange={onChange} />
          <input name="linkNguon" className="md:col-span-2 input" placeholder="Link nguồn (tuỳ chọn)" value={post.linkNguon} onChange={onChange} />
        </div>
        <textarea name="noiDung" className="input min-h-[160px]" placeholder="Nội dung chi tiết (chỉ tiêu, phương thức,...)" value={post.noiDung} onChange={onChange} />

        <div className="flex justify-end gap-3">
          <button type="button" className="btn-outline">Xem trước</button>
          <button className="btn-primary">Đăng tin</button>
        </div>
      </form>
    </div>
  );
}