import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import Input from "../components/Input.jsx";

export default function Login() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: "",
    matkhau: ""
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    const emailPattern =
      /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i;
    if (!emailPattern.test(formData.email.trim())) {
      setError("Email không hợp lệ. Vui lòng kiểm tra lại.");
      return;
    }

    setLoading(true);

    try {
      const requestOptions = {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(formData)
      };

      let res;
      try {
        res = await fetch("/api/login", requestOptions);
      } catch {
        res = await fetch("http://127.0.0.1:8000/api/login", requestOptions);
      }

      let data = null;
      try {
        data = await res.json();
      } catch {
        // Nếu không parse được JSON, để data là null
      }

      if (!res.ok || !data?.success) {
        const invalidCredentialsStatuses = [400, 401, 404, 422];
        const invalidCredentials = invalidCredentialsStatuses.includes(res?.status);
        const message =
          data?.message ||
          (invalidCredentials
            ? "Email hoặc mật khẩu không đúng"
            : "Không thể đăng nhập. Vui lòng thử lại.");
        setError(message);
        return;
      }

      if (data.success) {
        // Lưu thông tin user vào localStorage
        localStorage.setItem('user', JSON.stringify(data.data));
        
        // Phân quyền theo vai trò (ưu tiên id vai trò nếu có)
        const roleId = data.data.idvaitro;
        const userRole = data.data.vaitro;
        if (roleId === 6) {
          navigate('/analyst');
        } else {
          switch (userRole) {
            case 'Thành viên':
              navigate('/dashboard/news');
              break;
            case 'Tư vấn viên':
              navigate('/consultant');
              break;
            case 'Người phụ trách':
              navigate('/staff/assign');
              break;
            case 'Admin':
              navigate('/manager');
              break;
            default:
              // Nếu không có vai trò phù hợp, chuyển về trang chủ
              navigate('/');
          }
        }
      } else {
        setError(data.message || "Email hoặc mật khẩu không đúng");
      }
    } catch (err) {
      setError("Không thể kết nối đến server");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-4 lg:px-6 py-12 grid md:grid-cols-2 gap-10 items-center">
      <div className="card p-0 overflow-hidden">
        <div className="h-64 md:h-96 w-full overflow-hidden flex items-center justify-center bg-gray-100">
          <img
            src="https://media.tapchigiaoduc.edu.vn/uploads/2025/02/17/222222-1739762936.jpg"
            alt="University Admission"
            className="object-cover w-full h-full"
          />
        </div>
      </div>
      <div className="card p-8">
        <h2 className="text-xl font-semibold mb-2">Đăng nhập</h2>
        <p className="text-sm text-gray-600 mb-6">Sử dụng email để tiếp tục.</p>
        
        {error && (
          <div className="mb-4 p-3 bg-red-50 border border-red-200 text-red-700 rounded">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit} className="space-y-4">
          <Input 
            label="Email" 
            type="email" 
            name="email"
            value={formData.email}
            onChange={handleChange}
            placeholder="nhapemail@vd.com" 
            required
          />
          <Input 
            label="Mật khẩu" 
            type="password" 
            name="matkhau"
            value={formData.matkhau}
            onChange={handleChange}
            placeholder="••••••••" 
            required
          />
          <div className="flex items-center justify-between text-sm">
            <label className="inline-flex items-center gap-2">
              <input type="checkbox" className="accent-primary-600" /> Ghi nhớ tôi
            </label>
            <button type="button" className="text-primary-100 hover:underline">Quên mật khẩu?</button>
          </div>
          <button 
            type="submit" 
            disabled={loading}
            className="btn-primary w-full disabled:opacity-50"
          >
            {loading ? "Đang đăng nhập..." : "Đăng nhập"}
          </button>
        </form>
        <p className="text-sm text-gray-600 mt-6">
          Chưa có tài khoản? <Link to="/register" className="text-primary-600 font-medium">Đăng ký</Link>
        </p>
      </div>
    </div>
  );
}
