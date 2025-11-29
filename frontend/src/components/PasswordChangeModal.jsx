import { useState, useEffect, useRef } from 'react';

export default function PasswordChangeModal({ isOpen, onClose, onSubmit, isLoading }) {
  const [pwdForm, setPwdForm] = useState({ current: '', next: '', confirm: '' });
  const [pwdVisible, setPwdVisible] = useState({ current: false, next: false, confirm: false });
  const [banner, setBanner] = useState(null);
  const bannerTimer = useRef(null);

  const updatePwdField = (key) => (event) => {
    setPwdForm((prev) => ({ ...prev, [key]: event.target.value }));
  };

  const showBanner = (type, message) => {
    if (bannerTimer.current) clearTimeout(bannerTimer.current);
    setBanner({ type, message });
    bannerTimer.current = setTimeout(() => setBanner(null), 5000);
  };

  useEffect(() => {
    return () => {
      if (bannerTimer.current) clearTimeout(bannerTimer.current);
    };
  }, []);

  const handleSubmit = async () => {
    if (!pwdForm.current || !pwdForm.next || !pwdForm.confirm) {
      showBanner('error', 'Vui lòng điền đầy đủ thông tin.');
      return;
    }
    if (pwdForm.next.length < 6) {
      showBanner('error', 'Mật khẩu mới phải tối thiểu 6 ký tự.');
      return;
    }
    if (pwdForm.next !== pwdForm.confirm) {
      showBanner('error', 'Xác nhận mật khẩu không khớp.');
      return;
    }

    const success = await onSubmit(pwdForm);
    if (success) {
      setPwdForm({ current: '', next: '', confirm: '' });
      setPwdVisible({ current: false, next: false, confirm: false });
      handleClose();
    }
  };

  const handleClose = () => {
    setPwdForm({ current: '', next: '', confirm: '' });
    setPwdVisible({ current: false, next: false, confirm: false });
    setBanner(null);
    onClose();
  };

  if (!isOpen) return null;

  return (
    <>
      {/* Overlay */}
      <div
        className="fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity"
        onClick={handleClose}
      />

      {/* Modal */}
      <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div className="bg-white rounded-2xl shadow-lg max-w-md w-full max-h-[90vh] overflow-y-auto">
          {/* Header */}
          <div className="sticky top-0 bg-white border-b border-slate-200 px-6 py-4 flex items-center justify-between">
            <div>
              <h2 className="text-lg font-semibold text-slate-900">Đổi mật khẩu</h2>
              <p className="text-sm text-slate-500 mt-1">Bảo vệ tài khoản bằng mật khẩu mạnh.</p>
            </div>
            <button
              onClick={handleClose}
              className="text-slate-400 hover:text-slate-600 text-2xl leading-none"
            >
              ×
            </button>
          </div>

          {/* Content */}
          <div className="px-6 py-4 space-y-4">
            {banner && (
              <div
                className={`rounded-xl border px-4 py-3 text-sm text-center font-medium ${
                  banner.type === 'success'
                    ? 'border-emerald-200 bg-emerald-50 text-emerald-700'
                    : 'border-rose-200 bg-rose-50 text-rose-700'
                }`}
              >
                {banner.message}
              </div>
            )}

            <div className="space-y-4">
              {['current', 'next', 'confirm'].map((field) => (
                <div key={field} className="space-y-2">
                  <label className="text-sm font-medium text-slate-700">
                    {field === 'current' && 'Mật khẩu hiện tại'}
                    {field === 'next' && 'Mật khẩu mới'}
                    {field === 'confirm' && 'Xác nhận mật khẩu mới'}
                  </label>
                  <div className="relative">
                    <input
                      className="w-full px-4 py-2 border border-slate-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      type={pwdVisible[field] ? 'text' : 'password'}
                      value={pwdForm[field]}
                      onChange={updatePwdField(field)}
                      placeholder={
                        field === 'current'
                          ? 'Nhập mật khẩu hiện tại'
                          : field === 'next'
                          ? 'Nhập mật khẩu mới'
                          : 'Xác nhận mật khẩu mới'
                      }
                      disabled={isLoading}
                    />
                    <button
                      type="button"
                      onClick={() =>
                        setPwdVisible((prev) => ({ ...prev, [field]: !prev[field] }))
                      }
                      className="absolute inset-y-0 right-3 text-slate-400 hover:text-slate-600 text-sm font-medium"
                      disabled={isLoading}
                    >
                      {pwdVisible[field] ? 'Ẩn' : 'Hiện'}
                    </button>
                  </div>
                </div>
              ))}
            </div>

            <div className="text-xs text-slate-600 bg-blue-50 border border-blue-200 rounded-lg p-3">
              Gợi ý: Mật khẩu mạnh nên có ít nhất 6 ký tự, kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt.
            </div>
          </div>

          {/* Footer */}
          <div className="sticky bottom-0 bg-white border-t border-slate-200 px-6 py-4 flex gap-3 justify-end">
            <button
              onClick={handleClose}
              disabled={isLoading}
              className="px-4 py-2 rounded-lg border border-slate-300 text-slate-700 font-medium hover:bg-slate-50 disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Hủy
            </button>
            <button
              onClick={handleSubmit}
              disabled={isLoading}
              className={`px-6 py-2 rounded-lg text-white font-medium ${
                isLoading
                  ? 'bg-blue-300 cursor-wait'
                  : 'bg-blue-600 hover:bg-blue-700'
              } disabled:opacity-50 disabled:cursor-not-allowed`}
            >
              {isLoading ? 'Đang xử lý...' : 'Cập nhật mật khẩu'}
            </button>
          </div>
        </div>
      </div>
    </>
  );
}

