import AppLayout from "./AppLayout.jsx";
import { ToastProvider } from "../components/Toast.jsx";

export default function DashboardLayout() {
  return (
    <ToastProvider>
      <AppLayout />
    </ToastProvider>
  );
}
