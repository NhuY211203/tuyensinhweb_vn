import { useState } from "react";

export default function EditContact() {
  const [form, setForm] = useState({
    email: "bgmtinhanhem369@gmail.com",
    dienThoai: "0379496371"
  });

  const handleChange = e => setForm({ ...form, [e.target.name]: e.target.value });

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold mb-4">Sửa email và số điện thoại</h1>
      <form className="card p-5 space-y-4 max-w-xl">
        <label className="block mb-2 font-medium">Địa chỉ Email:</label>
        <input
          name="email"
          className="input"
          value={form.email}
          onChange={handleChange}
          placeholder="Nhập email"
        />
        <label className="block mb-2 font-medium mt-4">Điện thoại:</label>
        <input
          name="dienThoai"
          className="input"
          value={form.dienThoai}
          onChange={handleChange}
          placeholder="Nhập số điện thoại"
        />
        <div className="flex justify-end mt-4">
          <button className="btn-primary">Lưu thông tin</button>
        </div>
      </form>
    </div>
  );
}