import { useState } from "react";

const FAQ_ITEMS = [
  {
    id: 1,
    category: "Tài khoản & đăng nhập",
    question: "Làm sao để tạo tài khoản trên hệ thống?",
    answer:
      "Bạn bấm nút Đăng ký ở góc phải trên cùng, điền đầy đủ họ tên, email, mật khẩu. Sau khi đăng ký, hệ thống sẽ tạo tài khoản Thành viên để bạn sử dụng tất cả chức năng tra cứu, thi thử và đặt lịch tư vấn."
  },
  {
    id: 2,
    category: "Tài khoản & đăng nhập",
    question: "Quên mật khẩu thì xử lý như thế nào?",
    answer:
      "Tại màn hình Đăng nhập, chọn liên kết Quên mật khẩu, nhập email đã đăng ký. Hệ thống sẽ gửi hướng dẫn đặt lại mật khẩu mới về email của bạn."
  },
  {
    id: 3,
    category: "Hồ sơ cá nhân",
    question: "Mình có cần cập nhật đầy đủ hồ sơ cá nhân không?",
    answer:
      "Nên cập nhật đầy đủ thông tin cá nhân (họ tên, ngày sinh, trường học, khu vực, số điện thoại) trong mục Hồ sơ → Cập nhật hồ sơ. Thông tin này giúp hệ thống gợi ý ngành, trường và tạo lịch tư vấn phù hợp hơn."
  },
  {
    id: 4,
    category: "Hồ sơ cá nhân",
    question: "Thông tin hồ sơ có được bảo mật không?",
    answer:
      "Toàn bộ dữ liệu được lưu trong hệ thống nội bộ của nhà trường, chỉ dùng cho mục đích tư vấn định hướng và không chia sẻ cho bên thứ ba. Bạn có thể đổi mật khẩu định kỳ ở mục Bảo mật tài khoản."
  },
  {
    id: 5,
    category: "Tra cứu tuyển sinh",
    question: "Xem điểm chuẩn các năm ở đâu?",
    answer:
      "Bạn vào menu TRA CỨU → Tra cứu điểm chuẩn nhiều năm. Tại đây có thể lọc theo trường, ngành, năm tuyển sinh và tổ hợp môn để xem chi tiết điểm chuẩn."
  },
  {
    id: 6,
    category: "Tra cứu tuyển sinh",
    question: "Làm sao xem thông tin chi tiết của một ngành học?",
    answer:
      "Chọn mục TRA CỨU → Tra cứu thông tin tuyển sinh. Gõ tên ngành hoặc mã ngành, hệ thống sẽ hiển thị mô tả ngành, tổ hợp xét tuyển, chỉ tiêu, cơ hội việc làm và các trường đào tạo."
  },
  {
    id: 7,
    category: "Định hướng & bài test",
    question: "Bài trắc nghiệm Định hướng ngành học dùng để làm gì?",
    answer:
      "Bài trắc nghiệm giúp đánh giá sở thích, thế mạnh và nhóm ngành phù hợp với bạn. Sau khi làm test, hệ thống gợi ý các nhóm ngành và một số ngành tiêu biểu để bạn tham khảo."
  },
  {
    id: 8,
    category: "Định hướng & bài test",
    question: "Một ngày có thể làm bài trắc nghiệm định hướng mấy lần?",
    answer:
      "Bạn có thể làm lại nhiều lần, tuy nhiên nên suy nghĩ trả lời nghiêm túc để kết quả phản ánh đúng nhất. Kết quả gần nhất sẽ được dùng để gợi ý ngành học."
  },
  {
    id: 9,
    category: "Thi thử ĐGNL",
    question: "Thi thử Đánh giá năng lực trên hệ thống có giống cấu trúc thật không?",
    answer:
      "Các đề thi thử ĐGNL được xây dựng bám sát cấu trúc đề thi minh họa của ĐHQG TP.HCM: có nhiều phần, mỗi phần có số câu, mức độ và thời lượng tương đương. Bạn có thể xem lại đáp án và lời giải chi tiết sau khi làm bài."
  },
  {
    id: 10,
    category: "Thi thử ĐGNL",
    question: "Làm sao xem lại kết quả và đáp án sau khi thi thử?",
    answer:
      "Sau khi nộp bài, hệ thống sẽ hiển thị bảng tổng kết số câu đúng theo từng phần. Nhấn nút Xem lời giải để xem chi tiết đáp án đúng, lời giải và thống kê câu đúng/sai cho từng phần."
  },
  {
    id: 11,
    category: "Đặt lịch tư vấn",
    question: "Cách đặt lịch tư vấn với chuyên gia như thế nào?",
    answer:
      "Vào mục DỰ ĐOÁN & TƯ VẤN → Đặt lịch tư vấn. Chọn chuyên gia, chọn khung giờ phù hợp còn trống, nhập nội dung mong muốn trao đổi và xác nhận đặt lịch."
  },
  {
    id: 12,
    category: "Đặt lịch tư vấn",
    question: "Làm sao xem lại hoặc hủy lịch tư vấn đã đặt?",
    answer:
      "Trong Dashboard, mở mục Lịch tư vấn. Tại đây hiển thị danh sách các lịch đã đặt, trạng thái duyệt. Bạn có thể gửi yêu cầu đổi lịch hoặc hủy theo quy định của nhà trường."
  },
  {
    id: 13,
    category: "Thanh toán & điểm thưởng",
    question: "Hệ thống thanh toán dùng để làm gì?",
    answer:
      "Thanh toán dùng cho các dịch vụ thu phí như gói tư vấn chuyên sâu, đề thi nâng cao. Bạn có thể xem chi tiết trong mục ĐĂNG KÝ & THANH TOÁN → Lịch sử thanh toán."
  },
  {
    id: 14,
    category: "Thanh toán & điểm thưởng",
    question: "Điểm đổi thưởng hoạt động ra sao?",
    answer:
      "Khi bạn tham gia các hoạt động trên hệ thống (thi thử, làm khảo sát, giới thiệu bạn bè) có thể được cộng điểm thưởng. Điểm này được hiển thị trong mục Điểm đổi thưởng và dùng để quy đổi voucher hoặc quà tặng theo chương trình của nhà trường."
  },
  {
    id: 15,
    category: "Tin tức tuyển sinh",
    question: "Làm sao cập nhật nhanh tin tức tuyển sinh mới nhất?",
    answer:
      "Bạn có thể vào mục Tin tức trên thanh điều hướng hoặc các khối bản tin trong Dashboard. Hệ thống tổng hợp tin tuyển sinh, điều chỉnh chỉ tiêu, lịch thi và các thông báo quan trọng từ trường."
  },
  {
    id: 16,
    category: "Nguyện vọng & chiến lược",
    question: "Hệ thống có gợi ý cách sắp xếp nguyện vọng không?",
    answer:
      "Trong mục Hướng dẫn đăng ký nguyện vọng, chúng tôi cung cấp các mẫu chiến lược sắp xếp NV theo mức độ an toàn – phù hợp – mạo hiểm. Bạn nên kết hợp với kết quả Dự đoán & Đánh giá cơ hội để xây dựng danh sách NV tối ưu."
  },
  {
    id: 17,
    category: "Nguyện vọng & chiến lược",
    question: "Mình có thể lưu lại danh sách nguyện vọng để xem sau không?",
    answer:
      "Có. Ở mục Đăng ký nguyện vọng, bạn có thể thêm các ngành/trường quan tâm vào danh sách, hệ thống sẽ lưu lại để bạn chỉnh sửa dần trước khi chốt nguyện vọng chính thức trên cổng của Bộ hoặc của trường."
  },
  {
    id: 18,
    category: "Khác",
    question: "Làm thế nào để gửi góp ý cho đội ngũ phát triển hệ thống?",
    answer:
      "Trong trang Liên hệ, bạn có thể gửi góp ý trực tiếp hoặc nêu ý kiến khi làm khảo sát. Những phản hồi về giao diện, trải nghiệm, nội dung tư vấn đều rất quý giá để chúng tôi cải thiện sản phẩm."
  }
];

export default function AdvisingFAQ() {
  const [openId, setOpenId] = useState(null);

  const grouped = FAQ_ITEMS.reduce((acc, item) => {
    acc[item.category] = acc[item.category] || [];
    acc[item.category].push(item);
    return acc;
  }, {});

  return (
    <div className="max-w-5xl mx-auto space-y-8">
      {/* Header nổi bật */}
      <div className="rounded-3xl bg-gradient-to-r from-sky-500 via-sky-400 to-emerald-400 px-6 py-7 text-white shadow-md">
        <h1 className="text-3xl font-semibold tracking-tight">
          Các câu hỏi thường gặp
        </h1>
        <p className="mt-2 text-sm md:text-base text-sky-50/90 max-w-3xl">
          Tổng hợp những thắc mắc phổ biến khi sử dụng hệ thống tra cứu và tư vấn tuyển sinh.
          Hãy chọn nhóm chủ đề bạn quan tâm và bấm vào từng câu hỏi để xem chi tiết.
        </p>
      </div>

      {/* Danh sách nhóm câu hỏi */}
      <div className="space-y-4">
        {Object.entries(grouped).map(([category, items]) => (
          <section
            key={category}
            className="bg-white rounded-2xl shadow-sm border border-sky-50 overflow-hidden"
          >
            <div className="px-5 py-3 bg-sky-50 flex items-center justify-between">
              <h2 className="text-xs md:text-sm font-semibold text-sky-800 uppercase tracking-wide">
                {category}
              </h2>
              <span className="text-[11px] md:text-xs text-sky-600">
                {items.length} câu hỏi
              </span>
            </div>

            <div className="divide-y divide-gray-100">
              {items.map((item) => {
                const isOpen = openId === item.id;
                return (
                  <button
                    key={item.id}
                    type="button"
                    onClick={() => setOpenId(isOpen ? null : item.id)}
                    className={`w-full text-left px-5 py-3 transition-colors focus:outline-none ${
                      isOpen ? "bg-sky-50" : "hover:bg-sky-50/60"
                    }`}
                  >
                    <div className="flex items-start justify-between gap-3">
                      <span className="text-sm md:text-base font-medium text-gray-900">
                        {item.question}
                      </span>
                      <span
                        className={`mt-0.5 inline-flex h-6 w-6 items-center justify-center rounded-full border text-xs font-semibold ${
                          isOpen
                            ? "bg-sky-600 border-sky-600 text-white"
                            : "bg-white border-sky-300 text-sky-600"
                        }`}
                      >
                        {isOpen ? "−" : "+"}
                      </span>
                    </div>
                    {isOpen && (
                      <p className="mt-2 text-sm md:text-[15px] text-gray-700 leading-relaxed">
                        {item.answer}
                      </p>
                    )}
                  </button>
                );
              })}
            </div>
          </section>
        ))}
      </div>
    </div>
  );
}


