import { NavLink } from "react-router-dom";

const link =
  "block px-4 py-2 rounded-lg transition hover:bg-[#1bb6a2]/20 text-white hover:text-white";
const active = "bg-white/80 text-[#168886] font-semibold";

export default function SidebarAnalyst() {
  return (
    <aside className="w-72 bg-primary-700 text-white min-h-screen p-4 sticky top-0">
      <h2 className="text-lg font-semibold mb-4">Phân tích dữ liệu</h2>
      <nav className="space-y-2">
        <NavLink to="/analyst/reports" className={({isActive})=>`${link} ${isActive?active:""}`}>
          Tạo báo cáo tuyển sinh
        </NavLink>
        <NavLink to="/analyst/data" className={({isActive})=>`${link} ${isActive?active:""}`}>
          Quản lý dữ liệu
        </NavLink>
        <NavLink to="/analyst/analysis" className={({isActive})=>`${link} ${isActive?active:""}`}>
          Phân tích dữ liệu
        </NavLink>
        <NavLink to="/analyst/posts" className={({isActive})=>`${link} ${isActive?active:""}`}>
          Đăng tin
        </NavLink>
      </nav>
    </aside>
  );
}