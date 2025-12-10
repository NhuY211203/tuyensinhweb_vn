import { useEffect, useState, useMemo, useCallback } from "react";
import { useParams, useNavigate, useSearchParams } from "react-router-dom";
import api from "../../services/api";
import { 
  FileText, 
  Clock, 
  BookOpen, 
  Building2, 
  Hash,
  Loader2,
  AlertCircle,
  PlayCircle,
  Award
} from "lucide-react";

export default function DGNLExamDetail() {
  const { id } = useParams();
  const examId = Number(id);
  const [searchParams] = useSearchParams();
  const navigate = useNavigate();

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  const [exams, setExams] = useState([]);
  const [sections, setSections] = useState([]);
  const [questions, setQuestions] = useState([]);
  const [options, setOptions] = useState([]);
  const [selected, setSelected] = useState({});
  const [unansweredIds, setUnansweredIds] = useState([]);
  const [result, setResult] = useState(null);
  const [sectionSummaries, setSectionSummaries] = useState([]);
  const [timeUpNotice, setTimeUpNotice] = useState(false);
  const [warning, setWarning] = useState("");
  const [timeLeft, setTimeLeft] = useState(null);
  const [submitted, setSubmitted] = useState(false);
  const [autoSubmitted, setAutoSubmitted] = useState(false);
  const [showSolutions, setShowSolutions] = useState(false);
  const [activeSectionId, setActiveSectionId] = useState(null);
  const [questionResults, setQuestionResults] = useState({});

  const formatDuration = (seconds) => {
    if (seconds === null || seconds < 0) return "--:--";
    const hrs = Math.floor(seconds / 3600);
    const mins = Math.floor((seconds % 3600) / 60);
    const secs = seconds % 60;
    const segments = [];
    if (hrs > 0) segments.push(String(hrs).padStart(2, "0"));
    segments.push(String(mins).padStart(2, "0"));
    segments.push(String(secs).padStart(2, "0"));
    return segments.join(":");
  };

  const formatDurationVerbose = (seconds) => {
    if (seconds == null || seconds < 0) return "-";
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    if (mins === 0) return `${secs} giây`;
    if (secs === 0) return `${mins} phút`;
    return `${mins} phút ${secs} giây`;
  };

  const exam = useMemo(() => exams.find((e) => e.idkythi === examId), [exams, examId]);

  useEffect(() => {
    const fetchAll = async () => {
      setLoading(true);
      setError("");
      try {
        const [examsData, sectionsData, questionsData, optionsData] = await Promise.all([
          api.get("/dgnl/exams"),
          api.get("/dgnl/sections"),
          api.get("/dgnl/questions"),
          api.get("/dgnl/options"),
        ]);
        const val = (r) => r?.data ?? r ?? [];
        setExams(val(examsData));
        setSections(val(sectionsData));
        setQuestions(val(questionsData));
        setOptions(val(optionsData));
      } catch (err) {
        setError(err.message || "Có lỗi xảy ra khi tải dữ liệu");
      } finally {
        setLoading(false);
      }
    };
    fetchAll();
  }, [examId]);

  useEffect(() => {
    if (!exam || timeLeft !== null) return;
    const debugTimer = Number(searchParams.get("debugTimer"));
    const seconds = Number.isFinite(debugTimer) && debugTimer > 0
      ? Math.floor(debugTimer)
      : Math.max((exam.thoi_luong_phut || 0) * 60, 0);
    setTimeLeft(seconds);
  }, [exam, timeLeft, searchParams]);

  useEffect(() => {
    if (timeLeft === null || timeLeft <= 0 || submitted) return;
    const interval = setInterval(() => setTimeLeft((prev) => (prev > 0 ? prev - 1 : 0)), 1000);
    return () => clearInterval(interval);
  }, [timeLeft, submitted]);

  const examSections = useMemo(() => sections.filter((s) => s.idkythi === examId), [sections, examId]);
  const sectionIds = useMemo(() => examSections.map((s) => s.idsection), [examSections]);
  const questionsOfExam = useMemo(() => questions.filter((q) => sectionIds.includes(q.idsection)), [questions, sectionIds]);
  const optionsByQuestion = useMemo(() => {
    const map = new Map();
    options.forEach(opt => {
      if (!map.has(opt.idquestion)) map.set(opt.idquestion, []);
      map.get(opt.idquestion).push(opt);
    });
    map.forEach(arr => arr.sort((a, b) => (a.thu_tu || 0) - (b.thu_tu || 0)));
    return map;
  }, [options]);

  const handleSelectOption = (question, optionId) => {
    if (question.loai_cau === "multiple_choice") {
      setSelected(prev => {
        const current = prev[question.idquestion] || [];
        const next = current.includes(optionId) ? current.filter(id => id !== optionId) : [...current, optionId];
        return { ...prev, [question.idquestion]: next };
      });
    } else {
      setSelected(prev => ({ ...prev, [question.idquestion]: optionId }));
    }
    setUnansweredIds([]);
    setResult(null);
    setWarning("");
  };

  const correctOptionsByQuestion = useMemo(() => {
    const map = new Map();
    const getFallback = (qId) => (optionsByQuestion.get(qId) || []).filter(o => Number(o.is_correct) === 1).map(o => o.idoption);

    questionsOfExam.forEach(q => {
      const raw = (q.dap_an_dung || "").split(",").map(a => a.trim().toUpperCase()).filter(Boolean);
      const opts = optionsByQuestion.get(q.idquestion) || [];
      if (raw.length === 0) {
        const fallback = getFallback(q.idquestion);
        if (fallback.length) map.set(q.idquestion, fallback);
        return;
      }
      const letterMap = new Map(opts.map((o, i) => [String.fromCharCode(65 + i), o.idoption]));
      const ids = raw.map(l => letterMap.get(l)).filter(Boolean);
      map.set(q.idquestion, ids.length > 0 ? ids : getFallback(q.idquestion));
    });
    return map;
  }, [questionsOfExam, optionsByQuestion]);

  const totalQuestions = questionsOfExam.length;
  const answeredCount = useMemo(() => {
    return questionsOfExam.filter(q => {
      const v = selected[q.idquestion];
      return Array.isArray(v) ? v.length > 0 : Boolean(v);
    }).length;
  }, [questionsOfExam, selected]);

  const handleSubmit = useCallback((force = false) => {
    if (totalQuestions === 0) return;

    const unanswered = questionsOfExam.filter(q => {
      const value = selected[q.idquestion];
      return Array.isArray(value) ? value.length === 0 : !value;
    }).map(q => q.idquestion);

    if (!force && unanswered.length > 0) {
      setUnansweredIds(unanswered);
      setWarning(`Bạn còn ${unanswered.length} câu chưa trả lời. Vui lòng hoàn thành trước khi xem kết quả.`);
      document.getElementById(`question-${unanswered[0]}`)?.scrollIntoView({ behavior: "smooth", block: "center" });
      setResult(null);
      return;
    }

    setUnansweredIds(force ? [] : unanswered);
    setWarning("");

    let correct = 0;
    const sectionStats = new Map();
    const perQuestion = {};

    questionsOfExam.forEach(q => {
      const answer = selected[q.idquestion];
      const correctOpts = new Set(correctOptionsByQuestion.get(q.idquestion) || []);
      let isCorrect = false;
      if (q.loai_cau === "multiple_choice") {
        const user = new Set(Array.isArray(answer) ? answer : []);
        isCorrect = user.size === correctOpts.size && [...user].every(id => correctOpts.has(id));
      } else {
        isCorrect = correctOpts.has(answer);
      }
      if (isCorrect) correct++;

      const stats = sectionStats.get(q.idsection) || { total: 0, correct: 0 };
      stats.total++;
      if (isCorrect) stats.correct++;
      sectionStats.set(q.idsection, stats);
      perQuestion[q.idquestion] = { isCorrect, answered: Array.isArray(answer) ? answer.length > 0 : Boolean(answer) };
    });

    const examDuration = (exam?.thoi_luong_phut || 0) * 60;
    const usedSeconds = timeLeft != null && examDuration ? Math.max(0, examDuration - timeLeft) : null;

    setResult({ total: totalQuestions, correct, wrong: totalQuestions - correct, auto: force || autoSubmitted, usedSeconds });
    setSectionSummaries(examSections.map(s => ({ id: s.idsection, name: s.ten_section, ...(sectionStats.get(s.idsection) || { total: 0, correct: 0 }) })));
    setQuestionResults(perQuestion);
    if (!activeSectionId && examSections.length > 0) setActiveSectionId(examSections[0].idsection);

    if (exam) {
      try {
        const user = JSON.parse(localStorage.getItem("user") || '{}');
        api.post("/dgnl/attempts", {
          idkythi: examId,
          tong_so_cau: totalQuestions,
          tong_cau_dung: correct,
          tong_diem: correct * 10,
          idnguoidung: user?.id || user?.idnguoidung || null,
        }).catch(() => {});
      } catch {}
    }
    setSubmitted(true);
  }, [totalQuestions, questionsOfExam, selected, correctOptionsByQuestion, autoSubmitted, examSections, exam, timeLeft, activeSectionId, examId]);

  useEffect(() => {
    if (timeLeft === 0 && !autoSubmitted) {
      setAutoSubmitted(true);
      setSubmitted(true);
      setTimeUpNotice(true);
      handleSubmit(true);
    }
  }, [timeLeft, autoSubmitted, handleSubmit]);

  const progressPercent = totalQuestions > 0 ? Math.round((answeredCount / totalQuestions) * 100) : 0;

  return (
    <div className="lg:grid lg:grid-cols-[minmax(0,1fr)_260px] gap-6">
      <div className="space-y-4">
        <div className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-semibold text-primary-700">{exam ? exam.tenkythi : "Chi tiết kỳ thi"}</h1>
            <p className="text-sm text-gray-600">Danh sách câu hỏi của kỳ thi.</p>
          </div>
        </div>

        {timeLeft !== null && !submitted && (
          <div className={`rounded-lg border p-3 text-sm flex flex-col gap-2 ${timeLeft <= 300 ? "bg-rose-50 border-rose-200 text-rose-700" : "bg-amber-50 border-amber-200 text-amber-800"}`}>
            <div className="flex items-center justify-between">
              <span className="font-medium">Thời gian còn lại</span>
              <span className="font-semibold text-lg">{formatDuration(timeLeft)}</span>
            </div>
            {totalQuestions > 0 && (
              <div className="space-y-1">
                <div className="flex items-center justify-between text-xs"><span>Đã làm: {answeredCount}/{totalQuestions} câu</span><span>{progressPercent}%</span></div>
                <div className="h-2 rounded-full bg-white/60 overflow-hidden"><div className="h-full rounded-full bg-emerald-500 transition-all" style={{ width: `${progressPercent}%` }}/></div>
              </div>
            )}
          </div>
        )}

        {loading && <p>Đang tải dữ liệu...</p>}
        {error && <p className="text-red-600 text-sm">{error}</p>}
        {!loading && !error && timeUpNotice && <div className="p-3 bg-rose-50 border border-rose-200 text-rose-700 rounded-md text-sm">Hết thời gian làm bài. Hệ thống đã tự động nộp bài và tính điểm cho bạn.</div>}
        {!loading && !error && warning && <div className="p-3 bg-amber-50 border border-amber-200 text-amber-700 rounded-md text-sm">{warning}</div>}

        {result && (
          <div className="bg-gradient-to-br from-sky-50 via-white to-indigo-50 rounded-2xl shadow-sm p-5 space-y-4 border border-sky-100">
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
              <h2 className="text-base sm:text-lg font-semibold text-sky-800">Kết quả bài thi</h2>
              <div className="text-sm text-gray-700">
                <span className="mr-4">Thời gian quy định: <strong>{exam?.thoi_luong_phut || 0} phút</strong></span>
                <span>Thời gian làm bài thực tế: <strong>{formatDurationVerbose(result.usedSeconds)}</strong></span>
              </div>
            </div>
            <div className="overflow-x-auto rounded-xl bg-white/60">
              <table className="min-w-full text-sm">
                <thead className="bg-sky-100/80 text-sky-900">
                  <tr>
                    <th className="py-2 px-3 text-left font-semibold">Phần thi</th>
                    <th className="py-2 px-3 text-center font-semibold">Số câu đúng</th>
                  </tr>
                </thead>
                <tbody>
                  {sectionSummaries.filter(s => s.total > 0).map(s => (
                    <tr key={s.id} className="odd:bg-white even:bg-sky-50/40">
                      <td className="py-2 px-3">{s.name}</td>
                      <td className="py-2 px-3 text-center"><span className="font-semibold text-sky-800">{s.correct}</span><span className="text-gray-500"> / {s.total}</span></td>
                    </tr>
                  ))}
                  <tr className="bg-sky-50"><td className="py-2 px-3 font-semibold text-sky-900">Tổng</td><td className="py-2 px-3 text-center"><span className="font-semibold text-emerald-700">{result.correct}</span><span className="text-gray-500"> / {result.total}</span></td></tr>
                </tbody>
              </table>
            </div>
            {result.auto && <p className="text-xs text-gray-600">Bài làm đã được nộp tự động khi hết thời gian.</p>}
            <div className="flex flex-wrap gap-3 pt-1">
              <button type="button" onClick={() => { setShowSolutions(true); document.getElementById("question-viewport-top")?.scrollIntoView({ behavior: "smooth", block: "start" }); }} className="px-4 py-2 rounded-full bg-amber-500 hover:bg-amber-600 text-white text-sm font-semibold shadow-sm transition-colors">Xem lời giải</button>
              <button type="button" onClick={() => navigate("/dashboard/dgnl-practice")} className="px-4 py-2 rounded-full border border-sky-400 text-sky-700 text-sm font-semibold hover:bg-sky-50 transition-colors">Luyện thêm</button>
            </div>
          </div>
        )}

        {!loading && !error && (!submitted || showSolutions) && (
          <div id="question-viewport-top" className="bg-white rounded-lg shadow-sm p-4 text-sm space-y-4">
            {submitted && showSolutions && (
              <div className="flex flex-wrap gap-2 mb-3">
                {examSections.filter(s => questionsOfExam.some(q => q.idsection === s.idsection)).map(s => (
                  <button key={s.idsection} type="button" onClick={() => setActiveSectionId(s.idsection)} className={`px-4 py-1.5 rounded-full text-sm font-medium border ${activeSectionId === s.idsection ? "bg-sky-600 text-white border-sky-600" : "bg-white text-sky-700 border-sky-300 hover:bg-sky-50"}`}>{s.ten_section}</button>
                ))}
              </div>
            )}
            {examSections.filter(s => !submitted || !showSolutions || s.idsection === activeSectionId).map(section => (
              <div key={section.idsection} className="space-y-2">
                <h2 className="text-base sm:text-lg font-semibold text-sky-800">Phần {section.thu_tu}. {section.ten_section}</h2>
                <p className="text-xs sm:text-sm text-gray-600 font-medium">Nhóm năng lực: {section.nhom_nang_luc} • Số câu: {section.so_cau} • Thời lượng: {section.thoi_luong_phut} phút</p>
                <div className="space-y-3 mt-2">
                  {questionsOfExam.filter(q => q.idsection === section.idsection).map((q, idx) => {
                    const qOpts = optionsByQuestion.get(q.idquestion) || [];
                    const isMultiple = q.loai_cau === "multiple_choice";
                    const selectedForQ = selected[q.idquestion] || (isMultiple ? [] : null);
                    const correctSet = new Set(correctOptionsByQuestion.get(q.idquestion) || []);
                    return (
                      <div key={q.idquestion} id={`question-${q.idquestion}`} className={`border rounded-md p-3 ${unansweredIds.includes(q.idquestion) ? "bg-rose-50 border-rose-300" : "bg-gray-50"}`}>
                        <div className="font-medium">Câu {q.thu_tu || idx + 1}: {q.noi_dung}{isMultiple && <span className="ml-2 text-xs font-normal text-gray-500">(Chọn nhiều đáp án)</span>}</div>
                        <div className="mt-2 space-y-2">
                          {qOpts.map((opt, optIndex) => {
                            const letter = String.fromCharCode(65 + optIndex);
                            const checked = isMultiple ? (selectedForQ || []).includes(opt.idoption) : selectedForQ === opt.idoption;
                            const isCorrect = correctSet.has(opt.idoption);
                            return (
                              <div key={opt.idoption} className={`flex items-start gap-2 text-gray-800 ${result && showSolutions ? (isCorrect ? "text-emerald-700 font-semibold" : "") : "cursor-pointer"}`} onClick={() => !result && handleSelectOption(q, opt.idoption)}>
                                {!result && !showSolutions && <input type={isMultiple ? "checkbox" : "radio"} name={`q-${q.idquestion}`} className="mt-1 accent-primary-600" checked={checked} onChange={() => handleSelectOption(q, opt.idoption)} />}
                                {result && showSolutions && <span className="mt-1 text-xs font-medium">{isCorrect ? "✔" : "✘"}</span>}
                                <span className="font-medium mr-1">{letter}.</span><span>{opt.noi_dung}</span>
                              </div>
                            );
                          })}
                        </div>
                        {result && showSolutions && q.giai_thich && <div className="mt-3 text-sm text-gray-600 bg-white rounded-md p-3 border border-gray-100"><p className="font-semibold mb-1">Lời giải:</p><p>{q.giai_thich}</p></div>}
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
            {examSections.length === 0 && <p className="text-gray-500">Kỳ thi này chưa có cấu trúc phần/câu hỏi trong hệ thống.</p>}
          </div>
        )}
        {!loading && !error && questionsOfExam.length > 0 && !submitted && <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3 mt-4"><button onClick={() => handleSubmit(false)} className="px-6 py-2 rounded-full bg-amber-500 hover:bg-amber-600 text-white font-semibold shadow-sm transition-colors">Nộp bài</button><span className="text-sm text-gray-600">Vui lòng trả lời tất cả câu hỏi trước khi nộp bài.</span></div>}
      </div>
      {!submitted && (
        <aside className="mt-6 lg:mt-0">
          <div className="bg-white rounded-2xl shadow-lg p-4 text-sm space-y-4 sticky top-20">
            <div className="space-y-1 text-xs sm:text-sm">
              <div className="flex items-center justify-between"><span className="text-gray-600">Thời gian còn lại:</span><span className="font-semibold text-sky-700 text-base">{formatDuration(timeLeft ?? 0)}</span></div>
              <div className="flex items-center gap-4 pt-1"><div className="flex items-center gap-1"><span className="h-3 w-3 rounded-full bg-amber-500" /><span className="text-xs text-gray-600">Đã trả lời</span></div><div className="flex items-center gap-1"><span className="h-3 w-3 rounded-full border border-gray-300 bg-white" /><span className="text-xs text-gray-600">Chưa trả lời</span></div></div>
            </div>
            <div className="max-h-[360px] overflow-y-auto pr-1 border-t border-gray-100 pt-3 space-y-3 text-xs">
              {examSections.map(section => (
                <div key={section.idsection} className="space-y-1">
                  <div className="font-semibold text-gray-700">Phần {section.thu_tu}: {section.ten_section}</div>
                  <div className="grid grid-cols-5 gap-2">
                    {questionsOfExam.filter(q => q.idsection === section.idsection).map(q => {
                      const v = selected[q.idquestion];
                      const answered = Array.isArray(v) ? v.length > 0 : Boolean(v);
                      const cls = `h-7 w-7 rounded-full flex items-center justify-center border text-[11px] font-medium transition-colors ${answered ? "bg-amber-500 text-white border-amber-500" : "bg-white text-gray-700 border-gray-300"}`;
                      return <button key={q.idquestion} type="button" onClick={() => document.getElementById(`question-${q.idquestion}`)?.scrollIntoView({ behavior: "smooth", block: "start" })} className={cls}>{q.thu_tu || q.idquestion}</button>;
                    })}
                  </div>
                </div>
              ))}
            </div>
            {!submitted && questionsOfExam.length > 0 && <button type="button" onClick={() => { if (window.confirm("Bạn có chắc chắn muốn nộp bài?")) handleSubmit(true); }} className="mt-1 w-full rounded-full bg-amber-500 hover:bg-amber-600 text-white font-semibold py-2 text-sm shadow-md transition-colors">Nộp bài</button>}
          </div>
        </aside>
      )}
      {submitted && showSolutions && (
        <aside className="mt-6 lg:mt-0">
          <div className="bg-white rounded-2xl shadow-lg p-4 text-sm space-y-3 sticky top-20">
            <div className="flex items-center gap-3 text-xs"><div className="flex items-center gap-1"><span className="h-3 w-3 rounded-full bg-gray-300" /><span>Bỏ qua</span></div><div className="flex items-center gap-1"><span className="h-3 w-3 rounded-full bg-emerald-500" /><span>Đúng</span></div><div className="flex items-center gap-1"><span className="h-3 w-3 rounded-full bg-rose-500" /><span>Sai</span></div></div>
            <div className="max-h-[360px] overflow-y-auto pt-2 space-y-3 text-xs">
              {examSections.filter(s => s.idsection === activeSectionId).map(section => (
                <div key={section.idsection} className="space-y-1">
                  <div className="font-semibold text-gray-700">{section.ten_section}</div>
                  <div className="grid grid-cols-5 gap-2">
                    {questionsOfExam.filter(q => q.idsection === section.idsection).map(q => {
                      const info = questionResults[q.idquestion] || { answered: false, isCorrect: false };
                      let cls = `h-7 w-7 rounded-full flex items-center justify-center text-[11px] font-medium transition-colors ${info.answered ? (info.isCorrect ? "bg-emerald-500 text-white" : "bg-rose-500 text-white") : "bg-gray-200 text-gray-700"}`;
                      return <div key={q.idquestion} className={cls}>{q.thu_tu || q.idquestion}</div>;
                    })}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </aside>
      )}
    </div>
  );
}
