import { NavLink } from "react-router-dom";
import { useState } from "react";

const Item = ({ to, children }) => (
  <NavLink
    to={to}
    className={({ isActive }) =>
      `flex items-center gap-3 px-4 py-2 rounded-xl text-sm font-medium transition ${
        isActive ? "bg-primary-100 text-primary-700" : "text-white/90 hover:bg-white/10"
      }`
    }
  >{children}</NavLink>
);

export default function Sidebar() {
  const [openDKXT, setOpenDKXT] = useState(true); // Đăng ký xét tuyển
  const [openHoSo, setOpenHoSo] = useState(false); // Hồ sơ của tôi

  return (
    <aside className="w-72 bg-primary-700 text-white min-h-screen p-4 sticky top-0">
      <div className="mb-4 font-semibold opacity-90">Bảng điều khiển</div>
      <div className="flex flex-col gap-2">
        <Item to="/dashboard">Tổng quan</Item>
        

        <Item to="/dashboard/score-distribution">Xem phổ điểm</Item>
        <Item to="/dashboard/notifications">Nhận thông báo</Item>
        <Item to="/dashboard/search">Tra cứu nhanh</Item>

        {/* Đăng ký xét tuyển */}
        <div>
          <button
            className="flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium w-full bg-white/10 hover:bg-white/20"
            onClick={() => setOpenDKXT(o => !o)}
          >
            <span>Đăng ký xét tuyển</span>
            <span>{openDKXT ? "▲" : "▼"}</span>
          </button>
          {openDKXT && (
            <div className="flex flex-col gap-1 mt-1 ml-2">
              <Item to="/dashboard/application">Mẫu phiếu đăng ký</Item>
              <Item to="/dashboard/edit-contact">Sửa email và số điện thoại</Item>
            </div>
          )}
        </div>

        {/* Hồ sơ của tôi */}
        <div>
          <button
            className="flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-medium w-full bg-white/10 hover:bg-white/20"
            onClick={() => setOpenHoSo(o => !o)}
          >
            <span>Hồ sơ của tôi</span>
            <span>{openHoSo ? "▲" : "▼"}</span>
          </button>
          {openHoSo && (
            <div className="flex flex-col gap-1 mt-1 ml-2">
              <Item to="/dashboard/payments">Thanh toán</Item>
              <Item to="/dashboard/appointments">Lịch tư vấn</Item>
              <Item to="/dashboard/certificates">Chứng chỉ ngoại ngữ</Item>
            </div>
          )}
        </div>
      </div>
    </aside>
  );
}