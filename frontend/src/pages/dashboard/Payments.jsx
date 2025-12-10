import { useEffect, useMemo, useState } from 'react';
import api from '../../services/api';

const statusStyles = {
  'Đã thanh toán': {
    pill: 'bg-emerald-50 text-emerald-700 border border-emerald-100',
    dot: 'bg-emerald-500'
  },
  'Chờ thanh toán': {
    pill: 'bg-amber-50 text-amber-700 border border-amber-100',
    dot: 'bg-amber-400'
  },
  'Thất bại': {
    pill: 'bg-rose-50 text-rose-700 border border-rose-100',
    dot: 'bg-rose-500'
  }
};

const formatCurrency = value =>
  new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(Number(value || 0));

const formatDate = value => {
  if (!value) return '-';
  try {
    return new Intl.DateTimeFormat('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }).format(new Date(value));
  } catch {
    return value;
  }
};

export default function Payments() {
  const [rows, setRows] = useState([]);
  const [loading, setLoading] = useState(true);

  // New payment creator (select method)
  const [showCreate, setShowCreate] = useState(false);
  const [method, setMethod] = useState('vietqr');
  const [amountInput, setAmountInput] = useState(200000);
  const [memoInput, setMemoInput] = useState(`TS-ORDER-${Date.now()}`);

  useEffect(() => {
    (async () => {
      try {
        setLoading(true);
        // Lấy user_id từ localStorage/sessionStorage
        const storedUserRaw = window.localStorage.getItem('user') || sessionStorage.getItem('user') || '{}';
        let parsedUser = {};
        try { parsedUser = JSON.parse(storedUserRaw || '{}'); } catch { parsedUser = {}; }
        const resolvedUserId = parsedUser.idnguoidung || parsedUser.id || window.localStorage.getItem('user_id') || sessionStorage.getItem('user_id') || 0;
        const userId = Number(resolvedUserId) || 0;

        const data = await api.get('/payments/history', { userId });
        if (data?.success) setRows(data.data || []);
        else console.warn('payments/history response', data);
      } catch (err) {
        console.error('payments/history error', err);
      } finally {
        setLoading(false);
      }
    })();
  }, []);

  const hasRows = useMemo(() => rows.length > 0, [rows.length]);

  return (
    <div className="space-y-6">
      <div className="rounded-3xl bg-gradient-to-r from-teal-50 via-white to-cyan-50 p-6 shadow-sm border border-teal-50">
        <p className="text-teal-600 text-sm font-semibold uppercase tracking-[0.2em]">Quản lý giao dịch</p>
        <div className="flex flex-wrap items-center justify-between gap-4">
          <div>
            <h1 className="text-3xl font-black text-slate-900 mt-2">Lịch sử thanh toán</h1>
            <p className="text-slate-500 mt-1">Theo dõi mọi khoản thanh toán và trạng thái xử lý theo thời gian thực.</p>
          </div>
          {hasRows && (
            <div className="flex gap-3">
              <span className="px-4 py-2 rounded-2xl bg-white text-slate-600 border border-slate-100 text-sm font-medium">
                Tổng giao dịch: {rows.length}
              </span>
              <span className="px-4 py-2 rounded-2xl bg-teal-600 text-white text-sm font-semibold shadow-md">
                Đã thanh toán: {rows.filter(r => r.trang_thai === 'Đã thanh toán').length}
              </span>
            </div>
          )}
        </div>
      </div>

      <div className="rounded-3xl border border-slate-100 shadow-[0_20px_60px_-35px_rgba(15,23,42,0.4)] bg-white overflow-hidden">
        <table className="w-full text-base">
          <thead className="bg-gradient-to-r from-teal-500 to-cyan-500 text-white text-sm uppercase tracking-wide">
            <tr>
              <th className="text-left px-6 py-4 font-semibold">MÃ GIAO DỊCH</th>
              <th className="text-left px-6 py-4 font-semibold">NGÀY THANH TOÁN</th>
              <th className="text-right px-6 py-4 font-semibold">SỐ TIỀN</th>
              <th className="text-left px-6 py-4 font-semibold">PHƯƠNG THỨC</th>
              <th className="text-center px-6 py-4 font-semibold">TRẠNG THÁI</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-slate-100">
            {loading && (
              <tr>
                <td className="px-6 py-8 text-center text-slate-500 text-base" colSpan={5}>
                  Đang tải dữ liệu giao dịch...
                </td>
              </tr>
            )}
            {!loading && !hasRows && (
              <tr>
                <td className="px-6 py-16 text-center" colSpan={5}>
                  <div className="space-y-3">
                    <p className="text-xl font-semibold text-slate-700">Chưa có giao dịch</p>
                    <p className="text-slate-500">Các hoạt động thanh toán của bạn sẽ hiển thị tại đây.</p>
                  </div>
                </td>
              </tr>
            )}
            {!loading && rows.map((r, idx) => {
              const { pill, dot } = statusStyles[r.trang_thai] || statusStyles['Chờ thanh toán'];
              return (
                <tr
                  key={`${r.ma_giao_dich}-${idx}`}
                  className="bg-white hover:bg-teal-50/60 transition-colors duration-200"
                >
                  <td className="px-6 py-5 font-semibold text-slate-900">
                    <div className="flex flex-col">
                      <span className="text-lg tracking-tight">{r.ma_giao_dich}</span>
                      <span className="text-sm text-slate-400">ZaloPayOA</span>
                    </div>
                  </td>
                  <td className="px-6 py-5 text-slate-700">{formatDate(r.ngay_thanh_toan)}</td>
                  <td className="px-6 py-5 text-right text-lg font-bold text-slate-900">{formatCurrency(r.so_tien)}</td>
                  <td className="px-6 py-5 text-slate-700">
                    <div className="inline-flex items-center gap-2 rounded-2xl bg-slate-50 px-3 py-2 text-sm font-medium text-slate-600 border border-slate-100">
                      <span className="w-2 h-2 rounded-full bg-slate-400"></span>
                      {r.phuong_thuc || 'Không xác định'}
                    </div>
                  </td>
                  <td className="px-6 py-5 text-center">
                    <span className={`inline-flex items-center gap-2 px-4 py-2 rounded-full text-sm font-semibold ${pill}`}>
                      <span className={`w-2 h-2 rounded-full ${dot}`}></span>
                      {r.trang_thai}
                    </span>
                  </td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
