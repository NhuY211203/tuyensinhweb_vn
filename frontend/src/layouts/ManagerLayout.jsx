import { useState } from "react";
import { Outlet } from "react-router-dom";
import SidebarManager from "../components/SidebarManager.jsx";
import Topbar from "../components/Topbar.jsx";

export default function ManagerLayout() {
  return (
    <div className="min-h-screen bg-slate-50 text-slate-800 flex">
      {/* Sidebar cho Manager */}
      <SidebarManager />
      
      {/* Main content */}
      <div className="flex-1 flex flex-col">
        {/* Topbar */}
        <Topbar />
        
        {/* Nội dung chính */}
        <main className="flex-1 p-6">
          <div className="max-w-5xl mx-auto">
            <Outlet />
          </div>
        </main>
      </div>
    </div>
  );
}
