import { useState, useEffect, useMemo } from "react";

const colorPalette = [
  {
    badgeBg: "bg-[#E3F5EE]",
    badgeText: "text-[#0F8B6E]",
    border: "border-[#BDE9D4]",
    pillActive: "from-[#34D399] to-[#0D9488]",
  },
];

const getCategoryAccent = () => colorPalette[0];

const getArticleSummary = (item) => {
  if (!item) return "Thông tin đang được cập nhật.";
  const summary =
    (item.tom_tat || item.noi_dung_ngan || item.noi_dung || "").trim();
  return summary || "Thông tin đang được cập nhật.";
};

export default function News() {
  const [news, setNews] = useState([]);
  const [loading, setLoading] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalRecords, setTotalRecords] = useState(0);
  const [activeCategory, setActiveCategory] = useState("Tất cả");
  const perPage = 20;

  // Load news
  const loadNews = async (page = 1, per_page = 20) => {
    setLoading(true);
    try {
      const params = new URLSearchParams({
        page: page.toString(),
        per_page: per_page.toString(),
      });
      
      const url = `/api/tin-tuyen-sinh?${params}`;
      const response = await fetch(url).catch((err) => {
        return fetch(`http://localhost:8000/api/tin-tuyen-sinh?${params}`);
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      
      if (data.success) {
        setNews(data.data || []);
        setTotalPages(data.pagination?.last_page || 1);
        setTotalRecords(data.pagination?.total || 0);
        setCurrentPage(data.pagination?.current_page || 1);
      } else {
        setNews([]);
      }
    } catch (error) {
      console.error('Error loading news:', error);
      setNews([]);
    } finally {
      setLoading(false);
    }
  };

  // Load news on mount
  useEffect(() => {
    loadNews(1, perPage);
    window.scrollTo({ top: 0, behavior: "smooth" });
  }, []);

  const categories = useMemo(() => {
    const set = new Set();
    news.forEach((item) => {
      if (item?.loai_tin) set.add(item.loai_tin);
    });
    return ["Tất cả", ...Array.from(set)];
  }, [news]);

  useEffect(() => {
    if (activeCategory !== "Tất cả" && !categories.includes(activeCategory)) {
      setActiveCategory("Tất cả");
    }
  }, [categories, activeCategory]);

  const filteredNews = useMemo(() => {
    if (activeCategory === "Tất cả") return news;
    return news.filter((item) => item.loai_tin === activeCategory);
  }, [news, activeCategory]);

  const formatDate = (dateString) => {
    if (!dateString) return "";
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
      day: '2-digit',
      month: '2-digit',
      year: 'numeric'
    });
  };

  // Get optimized image URL
  const getImageUrl = (item) => {
    if (!item.hinh_anh_dai_dien) return null;
    
    // If it's already a full URL (Cloudinary or external), return as is
    if (item.hinh_anh_dai_dien.startsWith('http')) {
      // If Cloudinary URL and has public_id, optimize it
      if (item.hinh_anh_public_id && item.hinh_anh_dai_dien.includes('cloudinary.com')) {
        // Extract cloud name and public_id
        const cloudName = item.hinh_anh_dai_dien.match(/res\.cloudinary\.com\/([^\/]+)/)?.[1];
        if (cloudName) {
          return `https://res.cloudinary.com/${cloudName}/image/upload/f_auto,q_auto,dpr_auto,w_480,h_270,c_fill,g_auto/${item.hinh_anh_public_id}`;
        }
      }
      return item.hinh_anh_dai_dien;
    }
    
    // Local storage - convert to full URL
    return `http://localhost:8000${item.hinh_anh_dai_dien}`;
  };

  const handlePageChange = (newPage) => {
    loadNews(newPage, perPage);
    window.scrollTo({ top: 0, behavior: "smooth" });
  };

  const heroNews = useMemo(() => (filteredNews.length > 0 ? filteredNews[0] : null), [filteredNews]);
  const highlightNews = useMemo(() => filteredNews.slice(1, 4), [filteredNews]);
  const listNews = useMemo(() => filteredNews.slice(4), [filteredNews]);

  const SkeletonLine = ({ width = "100%" }) => (
    <div className={`h-4 bg-gray-200 rounded animate-pulse`} style={{ width }} />
  );

  return (
    <div className="min-h-screen bg-gradient-to-b from-[#E8FFF6] via-white to-[#E5F4FF]">
      <div className="max-w-6xl mx-auto px-4 py-10">
        <header className="mb-8 rounded-2xl p-6 border border-[#C7F1E1] shadow-sm bg-gradient-to-r from-[#E9FFF5] via-white to-[#F0FFF9]">
          <h1 className="text-4xl font-bold text-gray-900">
            Tin tức tuyển sinh
          </h1>
          <p className="text-sm text-gray-600 mt-3">
            Cập nhật nhanh các bài viết tuyển sinh, thông báo và học bổng mới nhất.
          </p>
        </header>

        {/* Category tabs */}
        <div className="flex flex-wrap gap-3 pb-4 mb-8">
          {categories.map((tab) => (
            <button
              key={tab}
              type="button"
              onClick={() => setActiveCategory(tab)}
              className={`px-5 py-2 rounded-full text-sm font-medium border transition-all duration-200 ${
                tab === activeCategory
                  ? "text-white shadow-md bg-gradient-to-r from-[#34D399] via-[#0FB981] to-[#0D9488] border-transparent"
                  : "text-gray-600 border-gray-200 hover:border-[#0FB981] hover:text-[#0F8B6E]"
              }`}
            >
              {tab}
            </button>
          ))}
        </div>

        {/* Hero and highlight */}
        {loading ? (
          <div className="space-y-4">
            <div className="h-64 bg-gray-200 rounded-2xl animate-pulse" />
            <div className="grid md:grid-cols-3 gap-4">
              {[0, 1, 2].map((i) => (
                <div key={i} className="space-y-3 bg-white p-4 rounded-xl shadow">
                  <div className="h-24 bg-gray-200 rounded animate-pulse" />
                  <SkeletonLine width="80%" />
                  <SkeletonLine width="60%" />
        </div>
              ))}
            </div>
          </div>
        ) : news.length === 0 ? (
          <div className="bg-white rounded-2xl shadow p-10 text-center text-gray-500">
            Hiện chưa có bài viết nào.
          </div>
        ) : (
          <>
            {heroNews && (
              <div className="grid lg:grid-cols-2 gap-6 mb-10">
                <NewsCardLarge item={heroNews} getImageUrl={getImageUrl} formatDate={formatDate} />
                <div className="grid gap-4">
                  {highlightNews.map((item) => (
                    <NewsCardHighlight
                      key={item.id_tin}
                      item={item}
                      getImageUrl={getImageUrl}
                      formatDate={formatDate}
                    />
                  ))}
                </div>
              </div>
            )}

            <div className="space-y-1 bg-white/90 border border-white rounded-3xl shadow-sm overflow-hidden">
              {listNews.map((item) => (
                <NewsListItem
                  key={item.id_tin}
                  item={item}
                  getImageUrl={getImageUrl}
                  formatDate={formatDate}
                />
              ))}
                        </div>
          </>
        )}

            {/* Pagination */}
        {!loading && totalPages > 1 && (
          <div className="flex items-center justify-center gap-2 mt-8">
                <button
                  onClick={() => handlePageChange(currentPage - 1)}
                  disabled={currentPage === 1}
              className="px-4 py-2 border border-gray-300 rounded disabled:opacity-50"
                >
                  Trước
                </button>
            <span className="text-sm text-gray-600">
                  Trang {currentPage} / {totalPages}
                </span>
                <button
                  onClick={() => handlePageChange(currentPage + 1)}
                  disabled={currentPage === totalPages}
              className="px-4 py-2 border border-gray-300 rounded disabled:opacity-50"
                >
                  Sau
                </button>
              </div>
        )}
      </div>
    </div>
  );
}

const ArticleLink = ({ item, className, children }) => {
  if (item?.nguon_bai_viet) {
    return (
      <a
        href={item.nguon_bai_viet}
        target="_blank"
        rel="noopener noreferrer"
        className={className}
      >
        {children}
      </a>
    );
  }
  return <div className={className}>{children}</div>;
};

const NewsCardLarge = ({ item, getImageUrl, formatDate }) => {
  const imageUrl = getImageUrl(item);
  const accent = getCategoryAccent(item.loai_tin);
  return (
    <ArticleLink
      item={item}
      className="block bg-white rounded-3xl shadow-lg hover:shadow-xl transition overflow-hidden group border border-white"
    >
      <div className="w-full bg-gray-100 overflow-hidden aspect-[16/9]">
        {imageUrl ? (
          <img
            src={imageUrl}
            alt={item.tieu_de}
            className="h-full w-full object-cover group-hover:scale-[1.01] transition-transform"
            onError={(e) => {
              e.currentTarget.style.display = "none";
              const fallback = e.currentTarget.nextElementSibling;
              if (fallback) fallback.style.display = "flex";
            }}
          />
        ) : null}
        <div
          className={`w-full h-full items-center justify-center text-gray-400 text-sm ${
            imageUrl ? "hidden" : "flex"
          }`}
        >
          Không có ảnh
        </div>
      </div>
      <div className="p-6 space-y-3 bg-gradient-to-br from-white via-white to-[#F7FAFF]">
        <span
          className={`inline-flex px-3 py-1 rounded-full text-[11px] font-semibold uppercase tracking-wide ${accent.badgeBg} ${accent.badgeText}`}
        >
          {item.loai_tin || "Tin tuyển sinh"}
        </span>
        <h2 className="text-2xl font-bold text-gray-900 leading-tight group-hover:text-[#0F8B6E] transition-colors">
          {item.tieu_de}
        </h2>
        <p className="text-sm text-gray-600 line-clamp-3">{getArticleSummary(item)}</p>
        <span className="text-xs text-gray-500 flex items-center gap-1">
          <span className="w-1.5 h-1.5 rounded-full bg-[#0FB981]" />
          {formatDate(item.ngay_dang)}
        </span>
      </div>
    </ArticleLink>
  );
};

const NewsCardHighlight = ({ item, getImageUrl, formatDate }) => {
  const imageUrl = getImageUrl(item);
  const accent = getCategoryAccent(item.loai_tin);
  return (
    <ArticleLink
      item={item}
      className="flex gap-4 bg-white rounded-2xl shadow-md hover:shadow-lg transition overflow-hidden group border border-white"
    >
      <div className="w-32 rounded overflow-hidden bg-gray-100 flex-shrink-0 aspect-[4/3]">
        {imageUrl ? (
          <img
            src={imageUrl}
            alt={item.tieu_de}
            className="w-full h-full object-cover group-hover:scale-[1.02] transition-transform"
            onError={(e) => {
              e.currentTarget.style.display = "none";
              const fallback = e.currentTarget.nextElementSibling;
              if (fallback) fallback.style.display = "flex";
            }}
          />
        ) : null}
        <div
          className={`w-full h-full items-center justify-center text-gray-400 text-xs ${
            imageUrl ? "hidden" : "flex"
          }`}
        >
          Không có ảnh
        </div>
      </div>
      <div className="py-3 pr-3 space-y-2">
        <span
          className={`inline-flex px-2 py-0.5 rounded-full text-[10px] font-semibold uppercase ${accent.badgeBg} ${accent.badgeText}`}
        >
          {item.loai_tin || "Tin"}
        </span>
        <h3 className="text-base font-semibold text-gray-900 leading-tight line-clamp-2 group-hover:text-[#0F8B6E]">
          {item.tieu_de}
        </h3>
        <p className="text-xs text-gray-500">{getArticleSummary(item)}</p>
        <p className="text-[11px] text-gray-400">{formatDate(item.ngay_dang)}</p>
      </div>
    </ArticleLink>
  );
};

const NewsListItem = ({ item, getImageUrl, formatDate }) => {
  const imageUrl = getImageUrl(item);
  const accent = getCategoryAccent(item.loai_tin);
  return (
    <ArticleLink
      item={item}
      className="flex gap-4 p-4 hover:bg-[#F0FFF7] transition-colors border-b border-[#E5F4EC] last:border-b-0"
    >
      <div className="w-32 rounded overflow-hidden flex-shrink-0 bg-gray-100 aspect-[4/3]">
        {imageUrl ? (
          <img
            src={imageUrl}
            alt={item.tieu_de}
            className="w-full h-full object-cover"
            onError={(e) => {
              e.currentTarget.style.display = "none";
              const fallback = e.currentTarget.nextElementSibling;
              if (fallback) fallback.style.display = "flex";
            }}
          />
        ) : null}
        <div
          className={`w-full h-full items-center justify-center text-gray-400 text-xs ${
            imageUrl ? "hidden" : "flex"
          }`}
        >
          Không có ảnh
        </div>
      </div>
      <div className="flex-1">
        <div className="flex items-center gap-2 mb-1">
          <span
            className={`px-2 py-0.5 rounded-full text-[10px] font-semibold uppercase ${accent.badgeBg} ${accent.badgeText}`}
          >
            {item.loai_tin || "Tin"}
          </span>
        </div>
        <h4 className="text-lg font-semibold text-gray-900 group-hover:text-[#0F8B6E] transition-colors">
          {item.tieu_de}
        </h4>
        <p className="text-sm text-gray-600 mt-1 line-clamp-2">{getArticleSummary(item)}</p>
        <div className="text-xs text-gray-500 mt-2 flex gap-4">
          <span>{formatDate(item.ngay_dang)}</span>
          {item.tentruong && <span>{item.tentruong}</span>}
        </div>
      </div>
    </ArticleLink>
  );
};
