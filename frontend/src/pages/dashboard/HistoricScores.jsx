import { useEffect, useState } from "react";
import api from "../../services/api";
import SearchFilters from "../../components/SearchFilters";

const ProgramCard = ({ item }) => (
  <div className="card p-4 space-y-2">
    <h3 className="font-semibold">{item.tennganh}</h3>
    <p className="text-sm text-gray-600">{item.tentruong}</p>
    <div className="flex flex-wrap gap-2 text-xs">
      <span className="px-2 py-1 rounded bg-blue-50 text-blue-700">Năm: {item.namxettuyen}</span>
      <span className="px-2 py-1 rounded bg-green-50 text-green-700">Điểm: {item.diemchuan}</span>
      <span className="px-2 py-1 rounded bg-purple-50 text-purple-700">Tổ hợp: {item.tohopmon}</span>
    </div>
  </div>
);

export default function HistoricScores() {
  const [filters, setFilters] = useState({ q: "", school: "", method: "", combo: "", year: "", page: 1, manganh: "" });
  const [programs, setPrograms] = useState([]);
  const [schools, setSchools] = useState([]);
  const [methods, setMethods] = useState([]);
  const [years, setYears] = useState([]);
  const [combos, setCombos] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [pagination, setPagination] = useState({ current_page: 1, last_page: 1, total: 0 });

  // Load filter options
  useEffect(() => {
    let isMounted = true;
    async function loadFilters() {
      try {
        const [schoolsRes, methodsRes, yearsRes] = await Promise.all([
          api.get("/truongdaihoc", { perPage: 200 }),
          api.get("/phuong-thuc", { perPage: 100 }),
          api.get("/years"),
        ]);

        if (!isMounted) return;

        // Map data to { value, label } format for Select component
        const schoolsData = schoolsRes?.data || schoolsRes || [];
        setSchools(schoolsData.map(s => ({ value: s.idtruong, label: s.tentruong })));

        const methodsData = methodsRes?.data || methodsRes || [];
        setMethods(methodsData.map(m => ({ value: m.idxettuyen, label: m.tenptxt })));

        const yearsData = yearsRes?.data || yearsRes || [];
        setYears(yearsData.map(y => ({ value: y.value, label: y.label })));

      } catch (error) {
        if (!isMounted) return;
        console.error("Error loading filters:", error);
        setError("Không thể tải dữ liệu bộ lọc");
      }
    }
    loadFilters();
    return () => { isMounted = false; };
  }, []);
  
  // Load combos based on other filters
  useEffect(() => {
    let isMounted = true;
    async function loadCombos() {
      try {
        const params = {};
        if (filters.manganh) params.manganh = filters.manganh;
        if (filters.school) params.idtruong = filters.school;
        if (filters.method) params.idxettuyen = filters.method;
        if (filters.year) params.nam = filters.year;
        if (!filters.manganh) params.perPage = 100;

        const combosRes = await api.get("/tohop-xettuyen", params);
        if (!isMounted) return;

        const combosList = (combosRes?.data ?? combosRes) || [];
        setCombos(combosList.map(c => ({ 
          value: c.ma_to_hop || c.code, 
          label: c.mo_ta ? `${c.ma_to_hop || c.code} - ${c.mo_ta}` : (c.label || c.ma_to_hop || c.code)
        })));

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
        const params = {
          keyword: filters.q,
          idtruong: filters.school,
          tohop: filters.combo,
          nam: filters.year,
          idxettuyen: filters.method,
          manganh: filters.manganh,
          perPage: 21, // 3 columns
          page: filters.page,
        };

        const data = await api.get('/diemchuan', params);
        if (!isMounted) return;

        setPrograms(data.data || []);
        setPagination({
          current_page: data.current_page || data.pagination?.current_page || 1,
          last_page: data.last_page || data.pagination?.last_page || 1,
          total: data.total || data.pagination?.total || 0,
        });
      } catch (error) {
        if (!isMounted) return;
        console.error("Error loading programs:", error);
        setError("Không thể tải dữ liệu chương trình");
      } finally {
        if (isMounted) setLoading(false);
      }
    }
    
    const handler = setTimeout(() => loadPrograms(), 300); // Debounce
    return () => clearTimeout(handler);

  }, [filters]);

  if (error) {
    return (
      <div className="text-center py-10">
        <h1 className="text-xl font-bold text-red-600">Lỗi tải dữ liệu</h1>
        <p className="text-gray-600">{error}</p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold">Tra cứu điểm chuẩn nhiều năm</h1>
      
      {/* Sử dụng SearchFilters component */}
      <SearchFilters 
        filters={filters} 
        setFilters={setFilters} 
        schools={schools} 
        methods={methods} 
        years={years} 
        combos={combos} 
      />

      <div className="text-sm text-gray-600">
        Tìm thấy <b>{pagination.total}</b> chương trình
        {loading && <span className="ml-2">Đang tải...</span>}
      </div>

      <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
        {programs.length > 0 
          ? programs.map(item => <ProgramCard key={item.iddiemchuan} item={item} />)
          : !loading && <div className="col-span-full text-center py-10 text-gray-500">Không có kết quả phù hợp.</div>
        }
      </div>

      {pagination.last_page > 1 && (
        <div className="flex justify-center mt-8">
          <div className="flex gap-2">
            <button disabled={pagination.current_page === 1} onClick={() => setFilters(prev => ({ ...prev, page: prev.page - 1 }))} className="px-3 py-2 border rounded disabled:opacity-50">Trước</button>
            <span className="px-3 py-2">Trang {pagination.current_page} / {pagination.last_page}</span>
            <button disabled={pagination.current_page === pagination.last_page} onClick={() => setFilters(prev => ({ ...prev, page: prev.page + 1 }))} className="px-3 py-2 border rounded disabled:opacity-50">Sau</button>
          </div>
        </div>
      )}
    </div>
  );
}