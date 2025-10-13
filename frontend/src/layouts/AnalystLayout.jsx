import { Outlet } from "react-router-dom";
import Topbar from "../components/Topbar.jsx";
import SidebarAnalyst from "../components/SidebarAnalyst.jsx";

export default function AnalystLayout() {
  return (
    <div className="min-h-screen flex">
      <SidebarAnalyst />
      <div className="flex-1 flex flex-col">
        <Topbar />
        <main className="p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
}