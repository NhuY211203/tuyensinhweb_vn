import { useEffect, useMemo, useRef, useState } from 'react';
import { useToast } from '../../components/Toast';
import PasswordChangeModal from '../../components/PasswordChangeModal';
import api from '../../services/api';

// Helper to normalize URL from backend (in case it returns localhost)
const publicBase = api.baseURL.replace(/\/api$/, ''); // e.g. https://hoahoctro.42web.io/laravel/public
const normalizeUrl = (u) => (u ? u.replace(/^http:\/\/localhost:8000/, publicBase) : u);

export default function ConsultantProfile() {
  const toast = useToast();
  const storedUser = useMemo(() => {
    try {
      return JSON.parse(localStorage.getItem('user') || '{}');
    } catch {
      return {};
    }
  }, []);

  const consultantId = storedUser.idnguoidung || storedUser.id || localStorage.getItem('user_id');
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [avatarPreview, setAvatarPreview] = useState(normalizeUrl(storedUser.hinhdaidien) || '');
  const [avatarFile, setAvatarFile] = useState(null);
  const [majors, setMajors] = useState([]);
  const [banner, setBanner] = useState(null);
  const bannerTimer = useRef(null);
  const [changingPwd, setChangingPwd] = useState(false);
  const [showPwdModal, setShowPwdModal] = useState(false);
  const [profile, setProfile] = useState({
    hoten: storedUser.hoten || '',
    email: storedUser.email || '',
    sodienthoai: storedUser.sodienthoai || '',
    diachi: storedUser.diachi || '',
    ngaysinh: storedUser.ngaysinh ? storedUser.ngaysinh.split('T')[0] : '',
    gioitinh: storedUser.gioitinh || '',
    gioithieu: storedUser.gioithieu || '',
    idnhomnganh: storedUser.idnhomnganh ? String(storedUser.idnhomnganh) : '',
  });

  useEffect(() => {
    if (!consultantId) {
      setLoading(false);
      return;
    }
    loadMajors();
    loadProfile();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [consultantId]);

  const loadMajors = async () => {
    try {
      const res = await api.get('/nhomnganh');
      const list = Array.isArray(res?.data) ? res.data.map(g => ({ id: g.id || g.idnhomnganh, name: g.name || g.tennhom })) : [];
      setMajors(list);
    } catch (error) {
      console.warn('Không thể tải danh sách nhóm ngành', error);
    }
  };

  const loadProfile = async () => {
    setLoading(true);
    try {
      const json = await api.get(`/staff/consultants/${consultantId}`);
      if (json?.success && json.data) {
        const data = json.data;
        setProfile({
          hoten: data.name || '',
          email: data.email || '',
          sodienthoai: data.phone || '',
          diachi: data.address || '',
          ngaysinh: data.birthday ? data.birthday.split('T')[0] : '',
          gioitinh: data.gender || '',
          gioithieu: data.bio || '',
          idnhomnganh: data.nganhHoc?.id ? String(data.nganhHoc.id) : data.nganhHocId ? String(data.nganhHocId) : '',
        });
        if (data.avatar) {
          setAvatarPreview(normalizeUrl(data.avatar));
        }
      }
    } catch (error) {
      console.error('Không thể tải hồ sơ tư vấn viên', error);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (field) => (event) => {
    setProfile((prev) => ({
      ...prev,
      [field]: event.target.value,
    }));
  };

  const handleAvatarChange = (event) => {
    const file = event.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) {
      toast.push({ type: 'error', title: 'Vui lòng chọn tệp hình ảnh' });
      return;
    }
    if (file.size > 5 * 1024 * 1024) {
      toast.push({ type: 'error', title: 'Ảnh tối đa 5MB' });
      return;
    }
    setAvatarFile(file);
    setAvatarPreview(URL.createObjectURL(file));
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

  const saveProfile = async () => {
    if (!consultantId) {
      toast.push({ type: 'error', title: 'Không tìm thấy tài khoản' });
      showBanner('error', 'Không tìm thấy tài khoản.');
      return;
    }
    if (!profile.hoten?.trim()) {
      toast.push({ type: 'error', title: 'Vui lòng nhập họ và tên' });
      showBanner('error', 'Vui lòng nhập họ và tên.');
      return;
    }
    setSaving(true);
    const formData = new FormData();
    formData.append('id', consultantId);
    Object.entries(profile).forEach(([key, value]) => {
      if (value !== undefined && value !== null && value !== '') {
        formData.append(key, value);
      }
    });
    if (avatarFile) {
      formData.append('avatar', avatarFile);
    }

    try {
      const token = localStorage.getItem('token');
      const res = await fetch(`${api.baseURL}/profile/update`, {
        method: 'POST',
        headers: {
          'Accept': 'application/json',
          ...(token && { 'Authorization': `Bearer ${token}` }),
        },
        body: formData,
      });
      const json = await res.json();
      if (json?.success && json.data) {
        toast.push({ type: 'success', title: 'Đã lưu hồ sơ' });
        showBanner('success', 'Đã lưu hồ sơ thành công.');
        const updated = json.data;
        setProfile({
          hoten: updated.hoten || '',
          email: updated.email || '',
          sodienthoai: updated.sodienthoai || '',
          diachi: updated.diachi || '',
          ngaysinh: updated.ngaysinh ? updated.ngaysinh.split('T')[0] : '',
          gioitinh: updated.gioitinh || '',
          gioithieu: updated.gioithieu || '',
          idnhomnganh: updated.idnhomnganh ? String(updated.idnhomnganh) : '',
        });
        if (updated.hinhdaidien) {
          setAvatarPreview(normalizeUrl(updated.hinhdaidien));
        }
        const nextUser = { ...(storedUser || {}), ...updated };
        localStorage.setItem('user', JSON.stringify(nextUser));
        setAvatarFile(null);
      } else {
        const msg = json?.message || 'Không thể lưu';
        toast.push({ type: 'error', title: msg });
        showBanner('error', msg);
      }
    } catch (error) {
      console.error(error);
      toast.push({ type: 'error', title: 'Không thể kết nối máy chủ' });
      showBanner('error', 'Không thể kết nối máy chủ.');
    } finally {
      setSaving(false);
    }
  };

  const submitPasswordChange = async (pwdForm) => {
    setChangingPwd(true);
    try {
      const json = await api.post('/password/change', {
        id: consultantId,
        current_password: pwdForm.current,
        new_password: pwdForm.next,
        confirm_password: pwdForm.confirm,
      });
      if (json?.success) {
        toast.push({ type: 'success', title: 'Đổi mật khẩu thành công' });
        showBanner('success', 'Đổi mật khẩu thành công.');
        return true;
      } else {
        const msg = json?.message || 'Đổi mật khẩu thất bại.';
        toast.push({ type: 'error', title: msg });
        return false;
      }
    } catch (error) {
      toast.push({ type: 'error', title: 'Không thể kết nối máy chủ' });
      return false;
    } finally {
      setChangingPwd(false);
    }
  };

  if (!consultantId) {
    return (
      <div className="p-8">
        <div className="rounded-2xl bg-white p-8 shadow-sm text-center text-red-500">
          Không tìm thấy tài khoản tư vấn viên trong bộ nhớ trình duyệt.
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <div className="max-w-6xl mx-auto px-4 py-8 space-y-6">
        {banner && (
          <div
            className={`rounded-2xl border px-4 py-3 shadow-sm text-center text-sm font-medium ${
              banner.type === 'success'
                ? 'border-emerald-200 bg-emerald-50 text-emerald-700'
                : 'border-rose-200 bg-rose-50 text-rose-700'
            }`}
          >
            {banner.message}
            </div>
        )}

        <div className="flex flex-wrap items-center justify-between gap-4">
            <div>
            <p className="text-sm text-blue-600 font-semibold">Hồ sơ tư vấn viên</p>
            <h1 className="text-3xl font-bold text-slate-900 mt-1">Thông tin cá nhân</h1>
            <p className="text-slate-500 mt-2 max-w-2xl">
              Cập nhật ảnh đại diện, thông tin liên lạc và giới thiệu bản thân. Ảnh mới sẽ được tải lên Cloudinary để đảm bảo tối ưu hoá chất lượng.
            </p>
          </div>
          <button
            onClick={loadProfile}
            className="px-4 py-2 rounded-xl border border-slate-200 bg-white text-sm font-medium hover:bg-slate-100"
          >
            Tải lại dữ liệu
          </button>
      </div>

        <div className="grid gap-6 lg:grid-cols-[320px,1fr]">
          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-6 space-y-5">
            <div className="relative">
              <div className="w-36 h-36 rounded-2xl overflow-hidden border border-slate-100 mx-auto shadow-sm bg-slate-100 flex items-center justify-center">
                {avatarPreview ? (
                  <img src={avatarPreview} alt="avatar" className="w-full h-full object-cover" />
                ) : (
                  <span className="text-4xl text-slate-400 font-semibold">
                    {profile.hoten?.charAt(0)?.toUpperCase() || storedUser.hoten?.charAt(0) || 'TV'}
                  </span>
                )}
              </div>
              <label className="mt-5 block text-center">
                <input type="file" accept="image/*" className="hidden" onChange={handleAvatarChange} />
                <span className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-blue-50 text-blue-700 text-sm font-medium cursor-pointer hover:bg-blue-100">
                  📤 Tải ảnh mới
                </span>
              </label>
              <p className="text-center text-xs text-slate-400 mt-3">PNG/JPG, tối đa 5MB</p>
            </div>
            <div className="space-y-3">
              <div>
                <p className="text-xs uppercase tracking-wider text-slate-400">Email</p>
                <p className="text-sm font-medium text-slate-700">{profile.email || 'Chưa cập nhật'}</p>
            </div>
            <div>
                <p className="text-xs uppercase tracking-wider text-slate-400">Số điện thoại</p>
                <p className="text-sm font-medium text-slate-700">{profile.sodienthoai || 'Chưa cập nhật'}</p>
            </div>
              <div>
                <p className="text-xs uppercase tracking-wider text-slate-400">Nhóm ngành</p>
                <p className="text-sm font-medium text-slate-700">
                  {majors.find((m) => Number(m.id) === Number(profile.idnhomnganh))?.name || 'Chưa chọn'}
                </p>
          </div>
        </div>
      </div>

          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-6">
            {loading ? (
              <div className="animate-pulse space-y-4">
                <div className="h-4 bg-slate-100 rounded"></div>
                <div className="h-4 bg-slate-100 rounded w-5/6"></div>
                <div className="h-4 bg-slate-100 rounded w-2/3"></div>
              </div>
            ) : (
              <div className="grid md:grid-cols-2 gap-4">
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Họ và tên</label>
                  <input
                    className="input"
                    value={profile.hoten}
                    onChange={handleInputChange('hoten')}
                    placeholder="Nhập họ tên đầy đủ"
                  />
          </div>
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Email</label>
                  <input
                    className="input bg-slate-100 cursor-not-allowed"
                    type="email"
                    value={profile.email}
                    readOnly
                  />
                        </div>
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Số điện thoại</label>
                  <input
                    className="input"
                    value={profile.sodienthoai}
                    onChange={handleInputChange('sodienthoai')}
                    placeholder="09xx xxx xxx"
                  />
                      </div>
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Ngày sinh</label>
                  <input
                    className="input"
                    type="date"
                    value={profile.ngaysinh}
                    onChange={handleInputChange('ngaysinh')}
                  />
              </div>
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Giới tính</label>
                  <select className="input" value={profile.gioitinh} onChange={handleInputChange('gioitinh')}>
                    <option value="">-- Chọn --</option>
                    <option value="Nam">Nam</option>
                    <option value="Nữ">Nữ</option>
                    <option value="Khác">Khác</option>
                  </select>
              </div>
                <div className="space-y-1">
                  <label className="text-sm font-medium text-slate-600">Nhóm ngành phụ trách</label>
                  <select
                    className="input bg-slate-100 cursor-not-allowed"
                    value={profile.idnhomnganh}
                    disabled
                  >
                    <option value="">-- Chưa chọn --</option>
                    {majors.map((major) => (
                      <option key={major.id} value={major.id}>
                        {major.name}
                      </option>
                    ))}
                  </select>
                  <p className="text-xs text-slate-400">Liên hệ quản trị viên để thay đổi nhóm ngành.</p>
              </div>
                <div className="space-y-1 md:col-span-2">
                  <label className="text-sm font-medium text-slate-600">Địa chỉ liên lạc</label>
                  <input
                    className="input"
                    value={profile.diachi}
                    onChange={handleInputChange('diachi')}
                    placeholder="Số nhà, đường, quận/huyện, tỉnh/thành"
                  />
            </div>
                <div className="space-y-1 md:col-span-2">
                  <label className="text-sm font-medium text-slate-600">Giới thiệu bản thân</label>
                  <textarea
                    className="input min-h-[120px]"
                    value={profile.gioithieu}
                    onChange={handleInputChange('gioithieu')}
                    placeholder="Chia sẻ kinh nghiệm, thế mạnh và lời chào tới học sinh..."
                  />
                  <p className="text-xs text-slate-400 text-right">{profile.gioithieu.length}/2000</p>
            </div>
          </div>
            )}
        </div>
      </div>

        <div className="grid gap-6 lg:grid-cols-[320px,1fr]">
          <div className="hidden lg:block" />
          <div className="bg-white rounded-2xl shadow-sm border border-slate-100 p-6 space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <h2 className="text-lg font-semibold text-slate-900">Đổi mật khẩu</h2>
                <p className="text-sm text-slate-500">Bảo vệ tài khoản bằng mật khẩu mạnh.</p>
              </div>
              <button
                onClick={() => setShowPwdModal(true)}
                className="text-sm font-medium text-blue-600 hover:text-blue-800"
              >
                Thay đổi mật khẩu
              </button>
            </div>
          </div>
        </div>

        <div className="flex justify-end gap-3">
          <button
            className="px-4 py-2 rounded-xl text-slate-600 hover:bg-slate-200/60"
            onClick={() => {
              setAvatarFile(null);
              setAvatarPreview(storedUser.hinhdaidien || '');
              loadProfile();
            }}
          >
            Hủy
          </button>
          <button
            onClick={saveProfile}
            disabled={saving}
            className={`px-6 py-2 rounded-xl text-white font-medium shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 ${
              saving ? 'bg-blue-300 cursor-wait' : 'bg-blue-600 hover:bg-blue-700'
            }`}
          >
            {saving ? 'Đang lưu...' : 'Lưu thay đổi'}
          </button>
        </div>
      </div>

      {/* Password Change Modal */}
      <PasswordChangeModal
        isOpen={showPwdModal}
        onClose={() => setShowPwdModal(false)}
        onSubmit={submitPasswordChange}
        isLoading={changingPwd}
      />
    </div>
  );
}
