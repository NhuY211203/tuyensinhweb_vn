import { useEffect, useMemo, useState } from "react";

// Trang tra cứu thông tin tuyển sinh với UI/UX cải tiến
export default function AdmissionInfo() {
  const [schools, setSchools] = useState([]);
  const [filteredSchools, setFilteredSchools] = useState([]);
  const [schoolCode, setSchoolCode] = useState("");
  const [years, setYears] = useState([]);
  const [selectedYear, setSelectedYear] = useState("");
  const methodTitles = useMemo(() => ({
    1: "Điểm thi THPT",
    2: "Điểm học bạ",
    3: "Đánh giá năng lực/Kỳ thi khác",
    4: "Xét tuyển kết hợp",
  }), []);
  const methodIcons = useMemo(() => ({
    1: "📊",
    2: "📚",
    3: "⭐",
    4: "✅",
  }), []);
  const [methodMajors, setMethodMajors] = useState({ 1: [], 2: [], 3: [], 4: [] });
  const [methodRules, setMethodRules] = useState({ 1: [], 2: [], 3: [], 4: [] });
  const [loadingMethods, setLoadingMethods] = useState(false);
  const [loadingSchools, setLoadingSchools] = useState(false);
  const [activeTab, setActiveTab] = useState(1);

  // Load years from API
  useEffect(() => {
    let ignore = false;
    async function loadYears() {
      try {
        const res = await fetch("http://localhost:8000/api/years").catch(() =>
          fetch("/api/years")
        );
        const json = await res.json();
        const yearsList = Array.isArray(json?.data) ? json.data : [];
        if (!ignore) {
          setYears(yearsList);
          if (yearsList.length > 0 && !selectedYear) {
            setSelectedYear(yearsList[0].value);
          }
        }
      } catch (e) {
        console.error("Error loading years:", e);
        const fallback = [2024, 2023, 2022, 2021, 2020].map(y => ({ value: String(y), label: String(y) }));
        if (!ignore) {
          setYears(fallback);
          if (!selectedYear) {
            setSelectedYear("2024");
          }
        }
      }
    }
    loadYears();
    return () => { ignore = true; };
  }, []);

  // Load all schools
  useEffect(() => {
    let ignore = false;
    async function load() {
      try {
        const res = await fetch("http://localhost:8000/api/truongdaihoc?perPage=200").catch(() =>
          fetch("/api/truongdaihoc?perPage=200")
        );
        const json = await res.json();
        const rows = Array.isArray(json?.data) ? json.data : [];
        const mapped = rows.map((r) => ({
          id: r.idtruong,
          code: r.matruong || String(r.idtruong),
          name: r.tentruong,
          website: r.lienhe || "",
          image: "/logo.png",
          address: r.diachi || "",
        }));
        if (!ignore) {
          setSchools(mapped);
        }
      } catch (e) {
        console.error("Error loading schools:", e);
      }
    }
    load();
    return () => { ignore = true; };
  }, []);

  // Filter schools by selected year
  useEffect(() => {
    let ignore = false;
    async function filterSchoolsByYear() {
      if (!selectedYear) {
        setFilteredSchools(schools);
        if (schools.length && !schoolCode) {
          setSchoolCode(schools[0].code);
        }
        return;
      }

      setLoadingSchools(true);
      try {
        const res = await fetch(`http://localhost:8000/api/admission-info?nam=${selectedYear}`).catch(() =>
          fetch(`/api/admission-info?nam=${selectedYear}`)
        );
        const json = await res.json();
        const rows = Array.isArray(json?.data) ? json.data : [];
        const schoolIds = new Set(rows.map(r => r.idtruong).filter(Boolean));
        const filtered = schools.filter(s => schoolIds.has(s.id));
        
        if (!ignore) {
          setFilteredSchools(filtered);
          if (schoolCode && !filtered.find(s => s.code === schoolCode)) {
            if (filtered.length > 0) {
              setSchoolCode(filtered[0].code);
            } else {
              setSchoolCode("");
            }
          } else if (!schoolCode && filtered.length > 0) {
            setSchoolCode(filtered[0].code);
          }
        }
      } catch (e) {
        console.error("Error filtering schools by year:", e);
        if (!ignore) {
          setFilteredSchools(schools);
        }
      } finally {
        if (!ignore) {
          setLoadingSchools(false);
        }
      }
    }
    
    if (schools.length > 0) {
      filterSchoolsByYear();
    }
    return () => { ignore = true; };
  }, [selectedYear, schools]);

  const school = useMemo(
    () => filteredSchools.find((s) => s.code === schoolCode),
    [filteredSchools, schoolCode]
  );

  // Fetch majors & quy chế tuyển sinh
  useEffect(() => {
    async function loadMajorsAndRules() {
      if (!school || !selectedYear) return;
      setLoadingMethods(true);
      try {
        const url = `http://localhost:8000/api/admission-info?idtruong=${encodeURIComponent(
          school.id ?? ""
        )}&nam=${selectedYear}`;
        const res = await fetch(url).catch(() =>
          fetch(`/api/admission-info?idtruong=${encodeURIComponent(school.id ?? "")}&nam=${selectedYear}`)
        );
        const json = await res.json();
        const rows = Array.isArray(json?.data) ? json.data : [];

        const groupMajors = { 1: [], 2: [], 3: [], 4: [] };

        rows.forEach((r) => {
          const idx = Number(r.idxettuyen || 0);
          if (![1, 2, 3, 4].includes(idx)) return;
          
          const combos = String(r.tohopmon || "")
            .split(";")
            .map((s) => s.trim())
            .filter(Boolean)
            .join("; ") || "-";
          
          groupMajors[idx].push({
            id: r.idthongtintuyensinh,
            code: r.manganh || "-",
            name: r.tennganh || r.manganh || "-",
            combos: combos,
            thoiluong_nam: r.thoiluong_nam || null,
            mota_tomtat: r.mota_tomtat || null,
            diemchuan: r.diemchuan || null,
            diem_san: r.diem_san || null,
            chitieu: r.chitieu || null,
            hocphidaitra: r.hocphidaitra || null,
            hocphitientien: r.hocphitientien || null,
            ghichu: r.ghichu || null,
          });
        });

        [1, 2, 3, 4].forEach((idx) => {
          groupMajors[idx] = groupMajors[idx]
            .sort((a, b) => {
              if (a.code !== b.code) return (a.code || "").localeCompare(b.code || "");
              return (a.combos || "").localeCompare(b.combos || "");
            })
            .map((m, i) => ({
              ...m,
              stt: i + 1,
            }));
        });

        setMethodMajors(groupMajors);

        // Lấy quy chế
        const rulesGroup = { 1: [], 2: [], 3: [], 4: [] };
        await Promise.all(
          [1, 2, 3, 4].map(async (idx) => {
            try {
              const qcUrl = `http://localhost:8000/api/admission-info/quyche?idtruong=${encodeURIComponent(
                school.id ?? ""
              )}&idxettuyen=${idx}&nam=${selectedYear}`;
              const qcRes = await fetch(qcUrl).catch(() =>
                fetch(`/api/admission-info/quyche?idtruong=${encodeURIComponent(
                  school.id ?? ""
                )}&idxettuyen=${idx}&nam=${selectedYear}`)
              );
              const qcJson = await qcRes.json();
              const rowsQc = Array.isArray(qcJson?.data) ? qcJson.data : [];
              rulesGroup[idx] = rowsQc.map(
                (r) => r.mota_ngan || r.noi_dung_day_du || ""
              ).filter(Boolean);
            } catch (err) {
              console.error("Error loading quyche for method", idx, err);
            }
          })
        );

        setMethodRules(rulesGroup);
      } catch (e) {
        console.error("Error loading majors / rules:", e);
      } finally {
        setLoadingMethods(false);
      }
    }
    loadMajorsAndRules();
  }, [school, selectedYear]);

  return (
    <div className="p-4 sm:p-6 lg:p-8" style={{ maxWidth: '100vw', overflowX: 'hidden' }}>
      <div className="w-full mx-auto" style={{ maxWidth: '1200px' }}>
        <h1 className="text-2xl font-bold mb-6 text-slate-900">Tra cứu thông tin tuyển sinh</h1>

        {/* Filter Bar - Cải tiến */}
        <div className="flex flex-col sm:flex-row gap-3 mb-8">
          <div className="flex-1 sm:min-w-[200px] sm:max-w-[280px]">
            <label className="block text-sm font-medium text-slate-700 mb-2">
              <span className="mr-2">📅</span>Chọn năm
            </label>
            <select
              value={selectedYear}
              onChange={(e) => setSelectedYear(e.target.value)}
              disabled={years.length === 0}
              className="w-full h-11 px-4 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:bg-slate-100 disabled:cursor-not-allowed transition-all"
              style={{ fontSize: '14px' }}
            >
              {years.length === 0 ? (
                <option value="">Đang tải...</option>
              ) : (
                years.map((year) => (
                  <option key={year.value} value={year.value}>
                    {year.label}
                  </option>
                ))
              )}
            </select>
          </div>

          <div className="flex-1 sm:min-w-[200px] sm:max-w-[280px]">
            <label className="block text-sm font-medium text-slate-700 mb-2">
              <span className="mr-2">🎓</span>Chọn trường
              {loadingSchools && <span className="ml-2 text-xs text-slate-400">(Đang tải...)</span>}
            </label>
            <select
              value={schoolCode}
              onChange={(e) => setSchoolCode(e.target.value)}
              disabled={loadingSchools || filteredSchools.length === 0}
              className="w-full h-11 px-4 border border-slate-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 disabled:bg-slate-100 disabled:cursor-not-allowed transition-all"
              style={{ fontSize: '14px' }}
            >
              {filteredSchools.length === 0 ? (
                <option value="">Không có trường nào có dữ liệu cho năm {selectedYear}</option>
              ) : (
                filteredSchools.map((s) => (
                  <option key={s.code} value={s.code}>
                    {s.name} ({s.code})
                  </option>
                ))
              )}
            </select>
          </div>
        </div>

        {/* School Info Card - Cải tiến */}
        {school && <SchoolInfoCard school={school} />}

        {/* Tabs - Cải tiến */}
        <div className="mb-6">
          <div className="flex flex-wrap gap-2 border-b border-slate-200">
            {[1, 2, 3, 4].map((idx) => (
              <button
                key={idx}
                onClick={() => setActiveTab(idx)}
                className={`flex items-center gap-2 px-6 py-4 text-sm font-medium transition-all relative ${
                  activeTab === idx
                    ? 'text-blue-600'
                    : 'text-slate-500 hover:text-slate-700 hover:bg-slate-50'
                }`}
                style={{ height: '56px', fontSize: '15px' }}
              >
                <span style={{ fontSize: '24px' }}>{methodIcons[idx]}</span>
                <span>{methodTitles[idx]}</span>
                {activeTab === idx && (
                  <div className="absolute bottom-0 left-0 right-0 h-0.5 bg-blue-600 rounded-t" style={{ height: '3px' }} />
                )}
              </button>
            ))}
          </div>
        </div>

        {/* Method Block - Chỉ hiển thị tab active */}
        <MethodBlock 
          method={{ 
            title: methodTitles[activeTab], 
            icon: methodIcons[activeTab],
            rules: methodRules[activeTab], 
            majors: methodMajors[activeTab] 
          }} 
          loading={loadingMethods} 
        />
      </div>
    </div>
  );
}

// School Info Card - Cải tiến theo design system
function SchoolInfoCard({ school }) {
  return (
    <div 
      className="bg-slate-50 border border-slate-200 rounded-xl overflow-hidden mb-8"
      style={{ padding: '16px', borderRadius: '12px' }}
    >
      <div className="flex items-start gap-4">
        <img 
          src={school.image} 
          alt={school.name} 
          className="object-contain flex-shrink-0"
          style={{ width: '32px', height: '32px' }}
        />
        <div className="flex-1 min-w-0">
          <div className="text-xs font-semibold text-slate-500 uppercase mb-2">GIỚI THIỆU TRƯỜNG</div>
          <div className="text-base font-semibold text-slate-900 mb-1" style={{ fontSize: '16px', fontWeight: 600 }}>
            {school.name}
          </div>
          <div className="text-sm text-slate-500 space-y-1" style={{ fontSize: '14px', lineHeight: '1.5' }}>
            {school.code && <div>Mã trường: {school.code}</div>}
            {school.website && (
              <div>
                Website: <a className="text-blue-600 underline" href={school.website} target="_blank" rel="noreferrer">{school.website}</a>
              </div>
            )}
            {school.address && <div>Địa chỉ: {school.address}</div>}
          </div>
        </div>
      </div>
    </div>
  );
}

// Method Block với Empty State và Table cải tiến
function MethodBlock({ method, loading = false }) {
  const [displayCount, setDisplayCount] = useState(15);
  const itemsPerPage = 10;
  const allMajors = method.majors || [];
  const displayedMajors = allMajors.slice(0, displayCount);
  const hasMore = allMajors.length > displayCount;
  const [isMobile, setIsMobile] = useState(false);

  useEffect(() => {
    const checkMobile = () => setIsMobile(window.innerWidth < 640);
    checkMobile();
    window.addEventListener('resize', checkMobile);
    return () => window.removeEventListener('resize', checkMobile);
  }, []);

  useEffect(() => {
    setDisplayCount(15);
  }, [allMajors.length]);

  const handleShowMore = () => {
    setDisplayCount(prev => Math.min(prev + itemsPerPage, allMajors.length));
  };

  // Empty State Component
  const EmptyState = () => (
    <div className="flex flex-col items-center justify-center py-16 px-6 text-center">
      <div className="text-6xl mb-4 opacity-40">📋</div>
      <h3 className="text-lg font-semibold text-slate-900 mb-2" style={{ fontSize: '18px', fontWeight: 600 }}>
        Chưa có dữ liệu
      </h3>
      <p className="text-sm text-slate-500 mb-6 max-w-md" style={{ fontSize: '14px' }}>
        Vui lòng chọn năm và trường để xem thông tin tuyển sinh
      </p>
    </div>
  );

  return (
    <section className="bg-white rounded-xl shadow-sm border border-slate-200">
      {/* Header */}
      <div className="p-6 border-b border-slate-200">
        <div className="flex items-center gap-3">
          <span className="text-2xl">{method.icon}</span>
          <h2 className="text-xl font-semibold text-slate-900">{method.title}</h2>
        </div>
        {method.rules && method.rules.length > 0 && (
          <ul className="list-disc pl-6 text-sm text-slate-700 mt-4 space-y-2">
            {method.rules.map((r, idx) => (
              <li key={idx} style={{ fontSize: '14px' }}>{r}</li>
            ))}
          </ul>
        )}
      </div>

      {/* Table Content */}
      <div className="p-6">
        {loading ? (
          <div className="py-12 text-center text-slate-500">Đang tải...</div>
        ) : displayedMajors.length === 0 ? (
          <EmptyState />
        ) : isMobile ? (
          // Mobile Card Layout
          <div className="space-y-4">
            {displayedMajors.map((m) => (
              <div 
                key={m.id || m.stt}
                className="bg-white border border-slate-200 rounded-xl p-5 shadow-sm hover:shadow-md transition-all"
                style={{ borderRadius: '12px' }}
              >
                <h3 className="text-base font-semibold text-slate-900 mb-3" style={{ fontSize: '16px', fontWeight: 600 }}>
                  {m.name}
                </h3>
                <div className="space-y-2 text-sm text-slate-600">
                  <div className="flex items-center gap-2">
                    <span>📋</span>
                    <span>Mã: {m.code}</span>
                  </div>
                  {m.combos !== "-" && (
                    <div className="flex items-center gap-2">
                      <span>📚</span>
                      <span>Tổ hợp: {m.combos}</span>
                    </div>
                  )}
                  {m.chitieu && (
                    <div className="flex items-center gap-2">
                      <span>👥</span>
                      <span>Chỉ tiêu: {m.chitieu}</span>
                    </div>
                  )}
                  {m.diemchuan && (
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-blue-600">Điểm chuẩn: {Number(m.diemchuan).toFixed(2)}</span>
                    </div>
                  )}
                  {m.diem_san && (
                    <div className="flex items-center gap-2">
                      <span className="font-bold text-orange-600">Điểm sàn: {Number(m.diem_san).toFixed(2)}</span>
                    </div>
                  )}
                  {m.hocphidaitra && (
                    <div className="flex items-center gap-2">
                      <span>💰</span>
                      <span>Học phí: {Number(m.hocphidaitra).toLocaleString('vi-VN')} đ</span>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        ) : (
          // Desktop Table Layout
          <>
            <div className="overflow-x-auto -mx-6 px-6">
              <table className="w-full border-collapse" style={{ tableLayout: 'fixed', width: '100%' }}>
                <thead>
                  <tr className="bg-slate-50 border-b border-slate-200">
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-left border-r border-slate-200" style={{ width: '60px' }}>STT</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-left border-r border-slate-200" style={{ minWidth: '100px' }}>Mã ngành</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-left border-r border-slate-200" style={{ minWidth: '200px' }}>Tên ngành</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-left border-r border-slate-200" style={{ minWidth: '120px' }}>Tổ hợp</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-center border-r border-slate-200" style={{ width: '100px' }}>Thời lượng</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-center border-r border-slate-200" style={{ width: '100px' }}>Điểm chuẩn</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-center border-r border-slate-200" style={{ width: '100px' }}>Điểm sàn</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-center border-r border-slate-200" style={{ width: '120px' }}>Chỉ tiêu</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-right border-r border-slate-200" style={{ minWidth: '140px' }}>Học phí đại trà</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-right border-r border-slate-200" style={{ minWidth: '140px' }}>Học phí tiên tiến</th>
                    <th className="px-4 py-3 text-xs font-semibold text-slate-700 uppercase text-left" style={{ minWidth: '200px' }}>Ghi chú</th>
                  </tr>
                </thead>
                <tbody>
                  {displayedMajors.map((m) => (
                    <tr 
                      key={m.id || m.stt} 
                      className="border-b border-slate-100 hover:bg-slate-50 transition-colors"
                      style={{ height: '56px' }}
                    >
                      <td className="px-4 py-3 text-sm text-center border-r border-slate-200">{m.stt}</td>
                      <td className="px-4 py-3 font-mono text-xs font-medium border-r border-slate-200">{m.code}</td>
                      <td className="px-4 py-3 text-sm border-r border-slate-200">{m.name}</td>
                      <td className="px-4 py-3 text-sm border-r border-slate-200">{m.combos}</td>
                      <td className="px-4 py-3 text-sm text-center border-r border-slate-200">{m.thoiluong_nam || "-"}</td>
                      <td className="px-4 py-3 text-center font-bold text-blue-600 text-sm border-r border-slate-200">
                        {m.diemchuan ? Number(m.diemchuan).toFixed(2) : "-"}
                      </td>
                      <td className="px-4 py-3 text-center font-bold text-orange-600 text-sm border-r border-slate-200">
                        {m.diem_san ? Number(m.diem_san).toFixed(2) : "-"}
                      </td>
                      <td className="px-4 py-3 text-sm text-center font-medium border-r border-slate-200">{m.chitieu || "-"}</td>
                      <td className="px-4 py-3 text-xs text-right border-r border-slate-200">
                        {m.hocphidaitra ? (Number(m.hocphidaitra).toLocaleString('vi-VN') + ' đ') : "-"}
                      </td>
                      <td className="px-4 py-3 text-xs text-right border-r border-slate-200">
                        {m.hocphitientien && Number(m.hocphitientien) > 0 
                          ? (Number(m.hocphitientien).toLocaleString('vi-VN') + ' đ') 
                          : "-"}
                      </td>
                      <td className="px-4 py-3 text-xs text-slate-600 leading-relaxed">{m.ghichu || "-"}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {hasMore && (
              <div 
                className="mt-4 text-center cursor-pointer select-none hover:bg-blue-50 transition-colors border-t border-slate-200 pt-4"
                onClick={handleShowMore}
                style={{ padding: '16px', fontSize: '14px', fontWeight: 500, color: '#0EA5E9' }}
              >
                Xem thêm ({allMajors.length - displayCount} ngành còn lại)
              </div>
            )}
            {!hasMore && displayedMajors.length > 0 && (
              <div className="mt-4 text-center text-slate-500 border-t border-slate-200 pt-4" style={{ padding: '16px', fontSize: '14px' }}>
                Đã hiển thị tất cả ({allMajors.length} ngành)
              </div>
            )}
          </>
        )}
      </div>
    </section>
  );
}
