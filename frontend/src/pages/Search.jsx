import { useEffect, useState } from "react";
import ProgramCard from "../components/ProgramCard.jsx";
import SearchFilters from "../components/SearchFilters.jsx";
import api from "../services/api";

export default function Search() {
  const [filters, setFilters] = useState({
    q: "", school: "", method: "", combo: "", year: "", region: "", manganh: "", page: 1
  });
  const [programs, setPrograms] = useState([]);
  const [schools, setSchools] = useState([]);
  const [methods, setMethods] = useState([]);
  const [combos, setCombos] = useState([]);
  const [years, setYears] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [pagination, setPagination] = useState({ current_page: 1, last_page: 1, total: 0 });

  // Load filter options (schools, methods, years)
  useEffect(() => {
    let isMounted = true;
    async function loadFilters() {
      try {
        // Load in parallel
        const [schoolsRes, methodsRes, yearsRes] = await Promise.all([
          api.get("/truongdaihoc", { perPage: 100 }),
          api.get("/phuong-thuc", { perPage: 100 }),
          api.get("/years")
        ]);

        if (!isMounted) return;

        const schoolsList = (schoolsRes?.data ?? schoolsRes) || [];
        setSchools(schoolsList.map(s => ({ value: s.idtruong, label: s.tentruong })));

        const methodsList = (methodsRes?.data ?? methodsRes) || [];
        setMethods(methodsList.map(m => ({ value: m.idxettuyen, label: m.tenptxt })));

        const yearsList = (yearsRes?.data ?? yearsRes) || [];
        setYears(yearsList.map(y => ({ value: y.value ?? y, label: y.label ?? y })));
      } catch (e) {
        if (!isMounted) return;
        console.error("Error loading filters:", e);
        setError("Không thể tải dữ liệu bộ lọc");
      }
    }
    loadFilters();
    return () => { isMounted = false; };
  }, []);

  // Load combos based on selected major (manganh)
  useEffect(() => {
    let isMounted = true;
    async function loadCombos() {
      try {
        const params = {};
        if (filters.manganh) {
          params.manganh = filters.manganh;
          if (filters.school) params.idtruong = filters.school;
          if (filters.method) params.idxettuyen = filters.method;
          if (filters.year) params.nam = filters.year;
        } else {
          params.perPage = 100;
        }
        const combosRes = await api.get("/tohop-xettuyen", params);
        if (!isMounted) return;

        const combosList = (combosRes?.data ?? combosRes) || [];
        setCombos(combosList.map(c => ({
          value: c.ma_to_hop || c.code,
          label: c.mo_ta ? `${c.ma_to_hop || c.code} - ${c.mo_ta}` : (c.label || c.ma_to_hop || c.code)
        })));

        // Clear combo selection if current combo not found
        if (filters.combo) {
          const exists = combosList.some(c => (c.ma_to_hop || c.code) === filters.combo);
          if (!exists) setFilters(prev => ({ ...prev, combo: "" }));
        }
      } catch (e) {
        if (!isMounted) return;
        console.error("Error loading combos:", e);
      }
    }
    loadCombos();
    return () => { isMounted = false; };
  }, [filters.manganh, filters.school, filters.method, filters.year]);

  // Load programs based on filters
  useEffect(() => {
    let isMounted = true;
    async function loadPrograms() {
      setLoading(true);
      try {
        const params = {};
        if (filters.manganh) params.manganh = filters.manganh;
        else if (filters.q) params.keyword = filters.q;
        if (filters.school) params.idtruong = filters.school;
        if (filters.combo) params.tohop = filters.combo;
        if (filters.year) params.nam = filters.year;
        if (filters.method && filters.method !== '') params.idxettuyen = String(filters.method);
        params.perPage = 20;
        params.page = filters.page;

        const data = await api.get('/diemchuan', params);
        if (!isMounted) return;

        setPrograms(data.data || []);
        setPagination({
          current_page: data.current_page || data.pagination?.current_page || 1,
          last_page: data.last_page || data.pagination?.last_page || 1,
          total: data.total || data.pagination?.total || 0
        });
      } catch (e) {
        if (!isMounted) return;
        console.error("Error loading programs:", e);
        setError("Không thể tải dữ liệu chương trình");
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    loadPrograms();
    return () => { isMounted = false; };
  }, [filters]);

  if (error) {
    return (
      <div className="max-w-7xl mx-auto px-4 lg:px-6 py-10">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-red-600 mb-4">Lỗi tải dữ liệu</h1>
          <p className="text-gray-600 mb-4">{error}</p>
          <button 
            onClick={() => window.location.reload()} 
            className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
          >
            Thử lại
          </button>
        </div>
      </div>
    );
  }

  return (
    <div>
      <section className="bg-gradient-to-br from-primary-500 to-primary-700 text-white">
        <div className="max-w-7xl mx-auto px-4 lg:px-6 py-10">
          <h1 className="text-3xl md:text-4xl font-bold">Tìm kiếm ngành & chương trình</h1>
          <p className="mt-2 text-white/90">Lọc theo trường, năm, phương thức, tổ hợp, khu vực…</p>
        </div>
      </section>

      <section className="max-w-7xl mx-auto px-4 lg:px-6 -mt-8 pb-14 space-y-6">
        <SearchFilters
          filters={filters}
          setFilters={setFilters}
          years={years}
          combos={combos}
          methods={methods}
          schools={schools}
        />

        <div className="flex items-center justify-between">
          <div className="text-sm text-gray-600">
            Tìm thấy <b>{pagination.total}</b> chương trình
            {loading && <span className="ml-2 text-blue-600">Đang tải...</span>}
          </div>
        </div>

        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {programs.length > 0 ? (
            programs.map(item => <ProgramCard key={item.iddiemchuan} item={item} />)
          ) : (
            !loading && (
              <div className="col-span-full text-center py-12">
                <p className="text-gray-500">Không tìm thấy chương trình nào</p>
                <p className="text-sm text-gray-400 mt-2">Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
              </div>
            )
          )}
        </div>

        {pagination.last_page > 1 && (
          <div className="flex justify-center mt-8">
            <div className="flex gap-2">
              <button 
                disabled={pagination.current_page === 1}
                onClick={() => setFilters(prev => ({ ...prev, page: pagination.current_page - 1 }))}
                className="px-3 py-2 border rounded disabled:opacity-50"
              >
                Trước
              </button>
              <span className="px-3 py-2">
                {pagination.current_page} / {pagination.last_page}
              </span>
              <button 
                disabled={pagination.current_page === pagination.last_page}
                onClick={() => setFilters(prev => ({ ...prev, page: pagination.current_page + 1 }))}
                className="px-3 py-2 border rounded disabled:opacity-50"
              >
                Sau
              </button>
            </div>
          </div>
        )}
      </section>
    </div>
  );
}
