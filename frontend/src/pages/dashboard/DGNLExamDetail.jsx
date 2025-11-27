import { useEffect, useState, useMemo, useCallback } from "react";
import { useParams, Link, useSearchParams, useNavigate } from "react-router-dom";

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
    if (hrs > 0) {
      segments.push(String(hrs).padStart(2, "0"));
    }
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

  const exam = useMemo(
    () => exams.find((e) => e.idkythi === examId),
    [exams, examId]
  );

  useEffect(() => {
    const fetchAll = async () => {
      setLoading(true);
      setError("");
      try {
        const [examsRes, sectionsRes, questionsRes, optionsRes] =
          await Promise.all([
            fetch("/api/kythi-dgnl/exams"),
            fetch("/api/kythi-dgnl/sections"),
            fetch("/api/kythi-dgnl/questions"),
            fetch("/api/kythi-dgnl/options"),
          ]);

        const [examsData, sectionsData, questionsData, optionsData] =
          await Promise.all([
            examsRes.json(),
            sectionsRes.json(),
            questionsRes.json(),
            optionsRes.json(),
          ]);

        if (!examsRes.ok || !examsData.success) {
          throw new Error(examsData.message || "Không tải được kỳ thi");
        }
        if (!sectionsRes.ok || !sectionsData.success) {
          throw new Error(sectionsData.message || "Không tải được sections");
        }
        if (!questionsRes.ok || !questionsData.success) {
          throw new Error(questionsData.message || "Không tải được câu hỏi");
        }
        if (!optionsRes.ok || !optionsData.success) {
          throw new Error(optionsData.message || "Không tải được phương án");
        }

        setExams(examsData.data || []);
        setSections(sectionsData.data || []);
        setQuestions(questionsData.data || []);
        setOptions(optionsData.data || []);
      } catch (err) {
        setError(err.message || "Có lỗi xảy ra khi tải dữ liệu");
      } finally {
        setLoading(false);
      }
    };

    fetchAll();
  }, []);

  useEffect(() => {
    if (!exam) return;
    if (timeLeft !== null) return;
    const debugTimer = Number(searchParams.get("debugTimer"));
    const seconds = Number.isFinite(debugTimer) && debugTimer > 0
      ? Math.floor(debugTimer)
      : Math.max((exam.thoi_luong_phut || 0) * 60, 0);
    setTimeLeft(seconds);
  }, [exam, timeLeft, searchParams]);

  useEffect(() => {
    if (timeLeft === null || timeLeft <= 0 || submitted) return;
    const interval = setInterval(() => {
      setTimeLeft((prev) => {
        if (prev === null) return prev;
        return prev > 0 ? prev - 1 : 0;
      });
    }, 1000);
    return () => clearInterval(interval);
  }, [timeLeft, submitted]);

  const sectionsOfExam = useMemo(
    () => sections.filter((s) => s.idkythi === examId),
    [sections, examId]
  );

  const sectionIds = useMemo(
    () => sectionsOfExam.map((s) => s.idsection),
    [sectionsOfExam]
  );

  const questionsOfExam = useMemo(
    () => questions.filter((q) => sectionIds.includes(q.idsection)),
    [questions, sectionIds]
  );

  const optionsByQuestion = useMemo(() => {
    const map = new Map();
    for (const opt of options) {
      if (!map.has(opt.idquestion)) map.set(opt.idquestion, []);
      map.get(opt.idquestion).push(opt);
    }
    // sort by thu_tu nếu có
    for (const arr of map.values()) {
      arr.sort((a, b) => (a.thu_tu || 0) - (b.thu_tu || 0));
    }
    return map;
  }, [options]);

  const handleSelectOption = (question, optionId) => {
    if (question.loai_cau === "multiple_choice") {
      setSelected((prev) => {
        const current = prev[question.idquestion] || [];
        const exists = current.includes(optionId);
        const next = exists
          ? current.filter((id) => id !== optionId)
          : [...current, optionId];
        return { ...prev, [question.idquestion]: next };
      });
    } else {
      setSelected((prev) => ({ ...prev, [question.idquestion]: optionId }));
    }
    setUnansweredIds([]);
    setResult(null);
    setWarning("");
  };

  const correctOptionsByQuestion = useMemo(() => {
    const map = new Map();

    const getFallbackIds = (questionId) => {
      const opts = optionsByQuestion.get(questionId) || [];
      return opts.filter((opt) => Number(opt.is_correct) === 1).map((opt) => opt.idoption);
    };

    for (const q of questionsOfExam) {
      const rawAnswers = (q.dap_an_dung || "")
        .split(",")
        .map((ans) => ans.trim().toUpperCase())
        .filter(Boolean);

      const opts = optionsByQuestion.get(q.idquestion) || [];
      if (rawAnswers.length === 0) {
        const fallback = getFallbackIds(q.idquestion);
        if (fallback.length) {
          map.set(q.idquestion, fallback);
        }
        continue;
      }

      const letterToOptionId = new Map();
      opts.forEach((opt, idx) => {
        const letter = String.fromCharCode(65 + idx); // A,B,C...
        letterToOptionId.set(letter, opt.idoption);
      });

      const ids = rawAnswers
        .map((letter) => letterToOptionId.get(letter))
        .filter(Boolean);

      if (ids.length > 0) {
        map.set(q.idquestion, ids);
      } else {
        const fallback = getFallbackIds(q.idquestion);
        if (fallback.length) {
          map.set(q.idquestion, fallback);
        }
      }
    }

    return map;
  }, [questionsOfExam, optionsByQuestion]);

  const totalQuestions = questionsOfExam.length;
  const answeredCount = useMemo(() => {
    if (questionsOfExam.length === 0) return 0;
    let count = 0;
    for (const q of questionsOfExam) {
      const v = selected[q.idquestion];
      if (Array.isArray(v)) {
        if (v.length > 0) count++;
      } else if (v) {
        count++;
      }
    }
    return count;
  }, [questionsOfExam, selected]);

  const handleSubmit = useCallback((force = false) => {
    if (questionsOfExam.length === 0) return;

    const unanswered = [];
    for (const q of questionsOfExam) {
      const value = selected[q.idquestion];
      if (q.loai_cau === "multiple_choice") {
        if (!Array.isArray(value) || value.length === 0) {
          unanswered.push(q.idquestion);
        }
      } else if (!value) {
        unanswered.push(q.idquestion);
      }
    }

    if (!force && unanswered.length > 0) {
      setUnansweredIds(unanswered);
      setWarning(
        `Bạn còn ${unanswered.length} câu chưa trả lời. Vui lòng hoàn thành trước khi xem kết quả.`
      );
      const first = document.getElementById(`question-${unanswered[0]}`);
      if (first) {
        first.scrollIntoView({ behavior: "smooth", block: "center" });
      }
      setResult(null);
      return;
    }

    setUnansweredIds(force ? [] : unanswered);
    setWarning("");

    let correct = 0;
    const sectionStats = new Map();
    const perQuestion = {};

    for (const q of questionsOfExam) {
      const answer = selected[q.idquestion];
      const correctOpts = [...(correctOptionsByQuestion.get(q.idquestion) || [])];
      let isCorrect = false;

      if (q.loai_cau === "multiple_choice") {
        const user = Array.isArray(answer) ? [...answer].sort() : [];
        const target = [...correctOpts].sort();
        isCorrect =
          user.length === target.length &&
          user.every((value, idx) => value === target[idx]);
      } else {
        isCorrect = correctOpts.includes(answer);
      }

      if (isCorrect) correct++;

      const stats = sectionStats.get(q.idsection) || { total: 0, correct: 0 };
      stats.total += 1;
      if (isCorrect) stats.correct += 1;
      sectionStats.set(q.idsection, stats);

      const answered =
        Array.isArray(answer) ? answer.length > 0 : Boolean(answer);
      perQuestion[q.idquestion] = { isCorrect, answered };
    }

    const examDurationSeconds = (exam?.thoi_luong_phut || 0) * 60;
    const usedSeconds =
      timeLeft != null && examDurationSeconds
        ? Math.max(0, examDurationSeconds - timeLeft)
        : null;

    setResult({
      total: questionsOfExam.length,
      correct,
      wrong: questionsOfExam.length - correct,
      auto: force || autoSubmitted,
      usedSeconds,
    });
    setSectionSummaries(
      sectionsOfExam.map((section) => {
        const stats = sectionStats.get(section.idsection) || { total: 0, correct: 0 };
        return {
          id: section.idsection,
          name: section.ten_section,
          correct: stats.correct,
          total: stats.total,
        };
      })
    );
    setQuestionResults(perQuestion);
    if (!activeSectionId && sectionsOfExam.length > 0) {
      setActiveSectionId(sectionsOfExam[0].idsection);
    }
    // Gửi kết quả lên backend – không chặn UI nếu lỗi
    if (exam) {
      try {
        let userId = null;
        try {
          const raw = localStorage.getItem("user");
          if (raw) {
            const parsed = JSON.parse(raw);
            userId = parsed.id || parsed.idnguoidung || null;
          }
        } catch {}

        fetch("/api/kythi-dgnl/attempts", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            idkythi: examId,
            tong_so_cau: questionsOfExam.length,
            tong_cau_dung: correct,
            // mỗi câu đúng 10 điểm
            tong_diem: correct * 10,
            idnguoidung: userId,
          }),
        }).catch(() => {});
      } catch {}
    }

    setSubmitted(true);
  }, [questionsOfExam, selected, correctOptionsByQuestion, autoSubmitted, sectionsOfExam, exam, timeLeft, activeSectionId]);

  useEffect(() => {
    if (timeLeft !== 0 || autoSubmitted) return;
    setAutoSubmitted(true);
    setSubmitted(true);
    setTimeUpNotice(true);
    handleSubmit(true);
  }, [timeLeft, autoSubmitted, handleSubmit]);

  const progressPercent =
    totalQuestions > 0 ? Math.round((answeredCount / totalQuestions) * 100) : 0;

  return (
    <div className="lg:grid lg:grid-cols-[minmax(0,1fr)_260px] gap-6">
      {/* LEFT COLUMN: main content */}
      <div className="space-y-4">
        <div className="flex items-center justify-between gap-4">
          <div>
            <h1 className="text-2xl font-semibold text-primary-700">
              {exam ? exam.tenkythi : "Chi tiết kỳ thi"}
            </h1>
            <p className="text-sm text-gray-600">
              Danh sách câu hỏi của kỳ thi. Bước tiếp theo có thể là xây phần làm bài
              và chấm điểm tự động.
            </p>
          </div>
        </div>

        {timeLeft !== null && !submitted && (
          <div
            className={`rounded-lg border p-3 text-sm flex flex-col gap-2 ${
              timeLeft <= 300
                ? "bg-rose-50 border-rose-200 text-rose-700"
                : "bg-amber-50 border-amber-200 text-amber-800"
            }`}
          >
            <div className="flex items-center justify-between">
              <span className="font-medium">Thời gian còn lại</span>
              <span className="font-semibold text-lg">
                {formatDuration(timeLeft)}
              </span>
            </div>
            {totalQuestions > 0 && (
              <div className="space-y-1">
                <div className="flex items-center justify-between text-xs">
                  <span>
                    Đã làm: {answeredCount}/{totalQuestions} câu
                  </span>
                  <span>{progressPercent}%</span>
                </div>
                <div className="h-2 rounded-full bg-white/60 overflow-hidden">
                  <div
                    className="h-full rounded-full bg-emerald-500 transition-all"
                    style={{ width: `${progressPercent}%` }}
                  />
                </div>
              </div>
            )}
          </div>
        )}

        {loading && <p>Đang tải dữ liệu...</p>}
        {error && <p className="text-red-600 text-sm">{error}</p>}

        {!loading && !error && timeUpNotice && (
          <div className="p-3 bg-rose-50 border border-rose-200 text-rose-700 rounded-md text-sm">
            Hết thời gian làm bài. Hệ thống đã tự động nộp bài và tính điểm cho bạn.
          </div>
        )}

        {!loading && !error && warning && (
          <div className="p-3 bg-amber-50 border border-amber-200 text-amber-700 rounded-md text-sm">
            {warning}
          </div>
        )}

        {!loading && !error && result && (
          <div className="bg-gradient-to-br from-sky-50 via-white to-indigo-50 rounded-2xl shadow-sm p-5 space-y-4 border border-sky-100">
            <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2">
              <h2 className="text-base sm:text-lg font-semibold text-sky-800">
                Kết quả bài thi
              </h2>
              <div className="text-sm text-gray-700">
                <span className="mr-4">
                  Thời gian quy định:{" "}
                  <strong>{exam?.thoi_luong_phut || 0} phút</strong>
                </span>
                <span>
                  Thời gian làm bài thực tế:{" "}
                  <strong>{formatDurationVerbose(result.usedSeconds)}</strong>
                </span>
              </div>
            </div>

            <div className="overflow-x-auto rounded-xl bg-white/60">
              <table className="min-w-full text-sm">
                <thead className="bg-sky-100/80 text-sky-900">
                  <tr>
                    <th className="py-2 px-3 text-left font-semibold">Phần thi</th>
                    <th className="py-2 px-3 text-center font-semibold">
                      Số câu đúng
                    </th>
                  </tr>
                </thead>
                <tbody>
                  {sectionSummaries
                    .filter((s) => s.total > 0)
                    .map((s) => (
                      <tr key={s.id} className="odd:bg-white even:bg-sky-50/40">
                        <td className="py-2 px-3">{s.name}</td>
                        <td className="py-2 px-3 text-center">
                          <span className="font-semibold text-sky-800">
                            {s.correct}
                          </span>
                          <span className="text-gray-500"> / {s.total}</span>
                        </td>
                      </tr>
                    ))}
                  <tr className="bg-sky-50">
                    <td className="py-2 px-3 font-semibold text-sky-900">
                      Tổng
                    </td>
                    <td className="py-2 px-3 text-center">
                      <span className="font-semibold text-emerald-700">
                        {result.correct}
                      </span>
                      <span className="text-gray-500"> / {result.total}</span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>

            {result.auto && (
              <p className="text-xs text-gray-600">
                Bài làm đã được nộp tự động khi hết thời gian. Những câu chưa trả lời
                được tính là sai.
              </p>
            )}

            <div className="flex flex-wrap gap-3 pt-1">
              <button
                type="button"
                onClick={() => {
                  setShowSolutions(true);
                  const el = document.getElementById("question-viewport-top");
                  if (el) {
                    el.scrollIntoView({ behavior: "smooth", block: "start" });
                  } else {
                    window.scrollTo({ top: 0, behavior: "smooth" });
                  }
                }}
                className="px-4 py-2 rounded-full bg-amber-500 hover:bg-amber-600 text-white text-sm font-semibold shadow-sm transition-colors"
              >
                Xem lời giải
              </button>
              <button
                type="button"
                onClick={() => navigate("/dashboard/dgnl-practice")}
                className="px-4 py-2 rounded-full border border-sky-400 text-sky-700 text-sm font-semibold hover:bg-sky-50 transition-colors"
              >
                Luyện thêm
              </button>
            </div>
          </div>
        )}

        {!loading && !error && (!submitted || showSolutions) && (
          <div
            id="question-viewport-top"
            className="bg-white rounded-lg shadow-sm p-4 text-sm space-y-4"
          >
            {submitted && showSolutions && (
              <div className="flex flex-wrap gap-2 mb-3">
                {sectionSummaries
                  .filter((s) => s.total > 0)
                  .map((s) => (
                    <button
                      key={s.id}
                      type="button"
                      onClick={() => setActiveSectionId(s.id)}
                      className={`px-4 py-1.5 rounded-full text-sm font-medium border ${
                        activeSectionId === s.id
                          ? "bg-sky-600 text-white border-sky-600"
                          : "bg-white text-sky-700 border-sky-300 hover:bg-sky-50"
                      }`}
                    >
                      {s.name}
                    </button>
                  ))}
              </div>
            )}

            {sectionsOfExam
              .filter(
                (section) =>
                  !submitted ||
                  !showSolutions ||
                  section.idsection === activeSectionId
              )
              .map((section) => (
            <div key={section.idsection} className="space-y-2">
              <h2 className="text-base sm:text-lg font-semibold text-sky-800">
                Phần {section.thu_tu}. {section.ten_section}
              </h2>
              <p className="text-xs sm:text-sm text-gray-600 font-medium">
                Nhóm năng lực: {section.nhom_nang_luc} • Số câu: {section.so_cau} •
                Thời lượng: {section.thoi_luong_phut} phút
              </p>

              <div className="space-y-3 mt-2">
                {questionsOfExam
                  .filter((q) => q.idsection === section.idsection)
                  .map((q, idx) => {
                    const qOptions = optionsByQuestion.get(q.idquestion) || [];
                    const isMultiple = q.loai_cau === "multiple_choice";
                    const selectedForQ = selected[q.idquestion] || (isMultiple ? [] : null);

                    return (
                      <div
                        key={q.idquestion}
                        id={`question-${q.idquestion}`}
                        className={`border rounded-md p-3 ${
                          unansweredIds.includes(q.idquestion)
                            ? "bg-rose-50 border-rose-300"
                            : "bg-gray-50"
                        }`}
                      >
                        <div className="font-medium">
                          Câu {q.thu_tu || idx + 1}: {q.noi_dung}
                          {isMultiple && (
                            <span className="ml-2 text-xs font-normal text-gray-500">
                              (Chọn nhiều đáp án)
                            </span>
                          )}
                        </div>
                        <div className="mt-2 space-y-2">
                          {qOptions.map((opt, optIndex) => {
                            const letter = String.fromCharCode(65 + optIndex); // A,B,C,...
                            const checked = isMultiple
                              ? selectedForQ.includes(opt.idoption)
                              : selectedForQ === opt.idoption;

                            return (
                              <div
                                key={opt.idoption}
                                className={`flex items-start gap-2 text-gray-800 ${
                                  result && showSolutions
                                    ? correctOptionsByQuestion
                                        .get(q.idquestion)
                                        ?.includes(opt.idoption)
                                      ? "text-emerald-700 font-semibold"
                                      : ""
                                    : "cursor-pointer"
                                }`}
                                onClick={() =>
                                  !result && handleSelectOption(q, opt.idoption)
                                }
                              >
                                {!result && !showSolutions && (
                                  <input
                                    type={isMultiple ? "checkbox" : "radio"}
                                    name={`q-${q.idquestion}`}
                                    className="mt-1 accent-primary-600"
                                    checked={checked}
                                    onChange={() =>
                                      handleSelectOption(q, opt.idoption)
                                    }
                                  />
                                )}
                                {result && showSolutions && (
                                  <span className="mt-1 text-xs font-medium">
                                    {correctOptionsByQuestion
                                      .get(q.idquestion)
                                      ?.includes(opt.idoption)
                                      ? "✔"
                                      : "✘"}
                                  </span>
                                )}
                                <span className="font-medium mr-1">
                                  {letter}.
                                </span>
                                <span>{opt.noi_dung}</span>
                              </div>
                            );
                          })}
                        </div>
                        {result && showSolutions && q.giai_thich && (
                          <div className="mt-3 text-sm text-gray-600 bg-white rounded-md p-3 border border-gray-100">
                            <p className="font-semibold mb-1">Lời giải:</p>
                            <p>{q.giai_thich}</p>
                          </div>
                        )}
                      </div>
                    );
                  })}
              </div>
            </div>
          ))}

            {sectionsOfExam.length === 0 && (
              <p className="text-gray-500">
                Kỳ thi này chưa có cấu trúc phần/câu hỏi trong hệ thống.
              </p>
            )}
          </div>
        )}

        {!loading && !error && questionsOfExam.length > 0 && !submitted && (
          <div className="flex flex-col sm:flex-row items-start sm:items-center gap-3 mt-4">
            <button
              onClick={() => handleSubmit(false)}
              className="px-6 py-2 rounded-full bg-amber-500 hover:bg-amber-600 text-white font-semibold shadow-sm transition-colors"
            >
              Nộp bài
            </button>
            <span className="text-sm text-gray-600">
              Vui lòng trả lời tất cả câu hỏi trước khi nộp bài. Hệ thống sẽ tự động
              gửi bài khi hết thời gian.
            </span>
          </div>
        )}
      </div>

      {/* RIGHT COLUMN: question navigation when đang làm bài */}
      {!submitted && (
      <aside className="mt-6 lg:mt-0">
        <div className="bg-white rounded-2xl shadow-lg p-4 text-sm space-y-4 sticky top-20">
          {/* Time + legend */}
          <div className="space-y-1 text-xs sm:text-sm">
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Thời gian còn lại:</span>
              <span className="font-semibold text-sky-700 text-base">
                {formatDuration(timeLeft ?? 0)}
              </span>
            </div>
            <div className="flex items-center gap-4 pt-1">
              <div className="flex items-center gap-1">
                <span className="h-3 w-3 rounded-full bg-amber-500" />
                <span className="text-xs text-gray-600">Đã trả lời</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="h-3 w-3 rounded-full border border-gray-300 bg-white" />
                <span className="text-xs text-gray-600">Chưa trả lời</span>
              </div>
            </div>
          </div>

          {/* Question numbers by section */}
          <div className="max-h-[360px] overflow-y-auto pr-1 border-t border-gray-100 pt-3 space-y-3 text-xs">
            {sectionsOfExam.map((section) => (
              <div key={section.idsection} className="space-y-1">
                <div className="font-semibold text-gray-700">
                  Phần {section.thu_tu}: {section.ten_section}
                </div>
                <div className="grid grid-cols-5 gap-2">
                  {questionsOfExam
                    .filter((q) => q.idsection === section.idsection)
                    .map((q) => {
                      const v = selected[q.idquestion];
                      const answered = Array.isArray(v) ? v.length > 0 : Boolean(v);
                      const baseClass =
                        "h-7 w-7 rounded-full flex items-center justify-center border text-[11px] font-medium transition-colors";
                      const className = answered
                        ? baseClass + " bg-amber-500 text-white border-amber-500"
                        : baseClass + " bg-white text-gray-700 border-gray-300";

                      return (
                        <button
                          key={q.idquestion}
                          type="button"
                          onClick={() => {
                            const el = document.getElementById(`question-${q.idquestion}`);
                            if (el) {
                              el.scrollIntoView({ behavior: "smooth", block: "start" });
                            }
                          }}
                          className={className}
                        >
                          {q.thu_tu || q.idquestion}
                        </button>
                      );
                    })}
                </div>
              </div>
            ))}
          </div>

          {/* Submit button */}
          {!submitted && questionsOfExam.length > 0 && (
            <button
              type="button"
              onClick={() => {
                if (
                  window.confirm(
                    "Bạn có chắc chắn muốn nộp bài? Những câu chưa trả lời sẽ được tính là sai."
                  )
                ) {
                  handleSubmit(true);
                }
              }}
              className="mt-1 w-full rounded-full bg-amber-500 hover:bg-amber-600 text-white font-semibold py-2 text-sm shadow-md transition-colors"
            >
              Nộp bài
            </button>
          )}
        </div>
      </aside>
      )}

      {/* RIGHT COLUMN: review kết quả cho từng phần sau khi xem lời giải */}
      {submitted && showSolutions && (
        <aside className="mt-6 lg:mt-0">
          <div className="bg-white rounded-2xl shadow-lg p-4 text-sm space-y-3 sticky top-20">
            <div className="flex items-center gap-3 text-xs">
              <div className="flex items-center gap-1">
                <span className="h-3 w-3 rounded-full bg-gray-300" />
                <span>Bỏ qua</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="h-3 w-3 rounded-full bg-emerald-500" />
                <span>Đúng</span>
              </div>
              <div className="flex items-center gap-1">
                <span className="h-3 w-3 rounded-full bg-rose-500" />
                <span>Sai</span>
              </div>
            </div>

            <div className="max-h-[360px] overflow-y-auto pt-2 space-y-3 text-xs">
              {sectionsOfExam
                .filter((s) => s.idsection === activeSectionId)
                .map((section) => (
                  <div key={section.idsection} className="space-y-1">
                    <div className="font-semibold text-gray-700">
                      {section.ten_section}
                    </div>
                    <div className="grid grid-cols-5 gap-2">
                      {questionsOfExam
                        .filter((q) => q.idsection === section.idsection)
                        .map((q) => {
                          const info = questionResults[q.idquestion] || {
                            answered: false,
                            isCorrect: false,
                          };
                          const baseClass =
                            "h-7 w-7 rounded-full flex items-center justify-center text-[11px] font-medium transition-colors";
                          let className = baseClass + " bg-gray-200 text-gray-700";
                          if (info.answered && info.isCorrect) {
                            className =
                              baseClass + " bg-emerald-500 text-white";
                          } else if (info.answered && !info.isCorrect) {
                            className = baseClass + " bg-rose-500 text-white";
                          }

                          return (
                            <div key={q.idquestion} className={className}>
                              {q.thu_tu || q.idquestion}
                            </div>
                          );
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


