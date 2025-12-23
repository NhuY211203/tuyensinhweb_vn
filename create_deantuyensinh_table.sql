-- Tạo bảng đề án tuyển sinh và thêm dữ liệu mẫu

-- Tạo bảng đề án tuyển sinh
CREATE TABLE IF NOT EXISTS `deantuyensinh` (
  `iddeantuyensinh` int(11) NOT NULL AUTO_INCREMENT,
  `idtruong` int(11) NOT NULL,
  `namxettuyen` int(11) NOT NULL,
  `tieude` varchar(255) NOT NULL,
  `noidung` longtext,
  `file_dinhkem` varchar(500) DEFAULT NULL,
  `ngay_congbo` date DEFAULT NULL,
  `han_nop_hoso` date DEFAULT NULL,
  `han_xac_nhan_nhap_hoc` date DEFAULT NULL,
  `lien_he` text,
  `website_chinh_thuc` varchar(255) DEFAULT NULL,
  `hotline` varchar(50) DEFAULT NULL,
  `email_lienhe` varchar(100) DEFAULT NULL,
  `dia_chi` text,
  `ghi_chu` text,
  `trang_thai` tinyint(1) NOT NULL DEFAULT 1,
  `ngay_tao` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `ngay_cap_nhat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`iddeantuyensinh`),
  KEY `idx_truong` (`idtruong`),
  KEY `idx_nam` (`namxettuyen`),
  KEY `idx_trangthai` (`trang_thai`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thêm dữ liệu mẫu đề án tuyển sinh

INSERT INTO `deantuyensinh` (`idtruong`, `namxettuyen`, `tieude`, `noidung`, `file_dinhkem`, `ngay_congbo`, `han_nop_hoso`, `han_xac_nhan_nhap_hoc`, `lien_he`, `website_chinh_thuc`, `hotline`, `email_lienhe`, `dia_chi`, `ghi_chu`, `trang_thai`) VALUES

-- ĐẠI HỌC QUỐC GIA HÀ NỘI
(1, 2024, 'Đề án tuyển sinh Đại học Quốc gia Hà Nội năm 2024', 
'Đại học Quốc gia Hà Nội tuyển sinh năm 2024 với nhiều ngành học hot như Công nghệ thông tin, Khoa học máy tính, Trí tuệ nhân tạo. Áp dụng phương thức xét tuyển đa dạng: xét điểm thi THPT, học bạ THPT, kết quả kỳ thi đánh giá năng lực.', 
'https://vnu.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-15', '2024-08-20', '2024-09-15', 
'Phòng Đào tạo - ĐHQG Hà Nội\nĐịa chỉ: 144 Xuân Thủy, Cầu Giấy, Hà Nội\nĐiện thoại: 024.37547506', 
'https://vnu.edu.vn', '024.37547506', 'tuyensinh@vnu.edu.vn', 
'144 Xuân Thủy, Cầu Giấy, Hà Nội', 
'Ưu tiên xét tuyển thẳng học sinh giỏi quốc gia, khu vực', 1),

(1, 2023, 'Đề án tuyển sinh Đại học Quốc gia Hà Nội năm 2023', 
'Tuyển sinh năm 2023 với 15.000 chỉ tiêu cho các ngành đào tạo chất lượng cao. Điểm chuẩn dự kiến từ 27-29 điểm cho các ngành hot.', 
'https://vnu.edu.vn/upload/2023/dean-tuyen-sinh-2023.pdf', 
'2023-03-20', '2023-08-25', '2023-09-20', 
'Phòng Đào tạo - ĐHQG Hà Nội', 
'https://vnu.edu.vn', '024.37547506', 'tuyensinh@vnu.edu.vn', 
'144 Xuân Thủy, Cầu Giấy, Hà Nội', 
'Miễn học phí cho sinh viên có hoàn cảnh khó khăn', 1),

-- ĐẠI HỌC BÁCH KHOA HÀ NỘI
(2, 2024, 'Đề án tuyển sinh Đại học Bách khoa Hà Nội năm 2024', 
'Trường Đại học Bách khoa Hà Nội tuyển sinh năm 2024 với 8.500 chỉ tiêu. Các ngành kỹ thuật, công nghệ thông tin, khoa học máy tính có điểm chuẩn cao. Áp dụng đào tạo theo hệ thống tín chỉ tiên tiến.', 
'https://hust.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-10', '2024-08-18', '2024-09-10', 
'Phòng Đào tạo - ĐHBK Hà Nội\nSố 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội\nHotline: 024.38692008', 
'https://hust.edu.vn', '024.38692008', 'tuyensinh@hust.edu.vn', 
'Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', 
'Chương trình đào tạo kỹ sư chất lượng cao theo chuẩn quốc tế', 1),

(2, 2023, 'Đề án tuyển sinh Đại học Bách khoa Hà Nội năm 2023', 
'Tuyển sinh 8.200 chỉ tiêu năm 2023. Ưu tiên các ngành STEM, công nghệ 4.0. Hợp tác với nhiều doanh nghiệp lớn trong đào tạo.', 
'https://hust.edu.vn/upload/2023/dean-tuyen-sinh-2023.pdf', 
'2023-03-15', '2023-08-20', '2023-09-15', 
'Phòng Đào tạo - ĐHBK Hà Nội', 
'https://hust.edu.vn', '024.38692008', 'tuyensinh@hust.edu.vn', 
'Số 1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', 
'Học bổng toàn phần cho sinh viên xuất sắc', 1),

-- ĐẠI HỌC QUỐC GIA TP.HCM
(3, 2024, 'Đề án tuyển sinh Đại học Quốc gia TP.HCM năm 2024', 
'ĐHQG TP.HCM tuyển sinh năm 2024 với 12.000 chỉ tiêu. Mạnh về các ngành kinh tế, công nghệ thông tin, y khoa. Áp dụng công nghệ AI trong đào tạo và quản lý.', 
'https://vnuhcm.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-20', '2024-08-22', '2024-09-18', 
'Phòng Đào tạo - ĐHQG TP.HCM\nKhu phố 6, Linh Trung, Thủ Đức, TP.HCM\nHotline: 028.37244270', 
'https://vnuhcm.edu.vn', '028.37244270', 'tuyensinh@vnuhcm.edu.vn', 
'Khu phố 6, Linh Trung, Thủ Đức, TP.HCM', 
'Môi trường học tập hiện đại, quốc tế hóa', 1),

-- ĐẠI HỌC KINH TẾ TP.HCM
(4, 2024, 'Đề án tuyển sinh Đại học Kinh tế TP.HCM năm 2024', 
'UEH tuyển sinh năm 2024 với 6.500 chỉ tiêu. Chuyên sâu về kinh tế, quản trị, tài chính. Chương trình đào tạo song bằng với các trường đại học quốc tế.', 
'https://ueh.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-25', '2024-08-25', '2024-09-20', 
'Phòng Tuyển sinh - UEH\n279 Nguyễn Tri Phương, Quận 10, TP.HCM\nHotline: 028.38309589', 
'https://ueh.edu.vn', '028.38309589', 'tuyensinh@ueh.edu.vn', 
'279 Nguyễn Tri Phương, Quận 10, TP.HCM', 
'Cơ hội thực tập tại các tập đoàn kinh tế lớn', 1),

-- ĐẠI HỌC KINH TẾ QUỐC DÂN
(5, 2024, 'Đề án tuyển sinh Đại học Kinh tế Quốc dân năm 2024', 
'NEU tuyển sinh năm 2024 với 5.800 chỉ tiêu. Mạnh về kinh tế, luật, quản trị. Đào tạo nguồn nhân lực chất lượng cao cho nền kinh tế.', 
'https://neu.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-18', '2024-08-20', '2024-09-15', 
'Phòng Đào tạo - NEU\n207 Giải Phóng, Hai Bà Trưng, Hà Nội\nHotline: 024.38749421', 
'https://neu.edu.vn', '024.38749421', 'tuyensinh@neu.edu.vn', 
'207 Giải Phóng, Hai Bà Trưng, Hà Nội', 
'Học bổng du học cho sinh viên xuất sắc', 1),

-- ĐẠI HỌC Y HÀ NỘI
(6, 2024, 'Đề án tuyển sinh Đại học Y Hà Nội năm 2024', 
'Đại học Y Hà Nội tuyển sinh năm 2024 với 1.200 chỉ tiêu. Các ngành y khoa, răng hàm mặt, dược học có điểm chuẩn rất cao. Đào tạo bác sĩ chất lượng cao phục vụ sức khỏe nhân dân.', 
'https://hmu.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-02-28', '2024-08-15', '2024-09-05', 
'Phòng Đào tạo - ĐH Y Hà Nội\nSố 1 Tôn Thất Tùng, Đống Đa, Hà Nội\nHotline: 024.38523798', 
'https://hmu.edu.vn', '024.38523798', 'tuyensinh@hmu.edu.vn', 
'Số 1 Tôn Thất Tùng, Đống Đa, Hà Nội', 
'Thực hành tại các bệnh viện hàng đầu cả nước', 1),

-- ĐẠI HỌC NGOẠI THƯƠNG
(7, 2024, 'Đề án tuyển sinh Đại học Ngoại thương năm 2024', 
'Đại học Ngoại thương tuyển sinh năm 2024 với 3.500 chỉ tiêu. Chuyên về kinh tế đối ngoại, thương mại quốc tế, ngoại ngữ. Môi trường đào tạo quốc tế.', 
'https://ftu.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-22', '2024-08-23', '2024-09-18', 
'Phòng Đào tạo - ĐH Ngoại thương\n91 Chùa Láng, Đống Đa, Hà Nội\nHotline: 024.37664875', 
'https://ftu.edu.vn', '024.37664875', 'tuyensinh@ftu.edu.vn', 
'91 Chùa Láng, Đống Đa, Hà Nội', 
'Cơ hội học tập và làm việc tại nước ngoài', 1),

-- ĐẠI HỌC LUẬT HÀ NỘI
(8, 2024, 'Đề án tuyển sinh Đại học Luật Hà Nội năm 2024', 
'Đại học Luật Hà Nội tuyển sinh năm 2024 với 2.200 chỉ tiêu. Đào tạo cử nhân luật chất lượng cao, đáp ứng nhu cầu xã hội. Chương trình đào tạo theo chuẩn quốc tế.', 
'https://hlu.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-12', '2024-08-18', '2024-09-12', 
'Phòng Đào tạo - ĐH Luật Hà Nội\n87 Nguyễn Chí Thanh, Đống Đa, Hà Nội\nHotline: 024.37547506', 
'https://hlu.edu.vn', '024.37547506', 'tuyensinh@hlu.edu.vn', 
'87 Nguyễn Chí Thanh, Đống Đa, Hà Nội', 
'Thực tập tại các cơ quan tư pháp, văn phòng luật sư', 1),

-- ĐẠI HỌC SƯ PHẠM HÀ NỘI
(9, 2024, 'Đề án tuyển sinh Đại học Sư phạm Hà Nội năm 2024', 
'HNUE tuyển sinh năm 2024 với 4.000 chỉ tiêu. Đào tạo giáo viên chất lượng cao cho các cấp học. Chương trình sư phạm hiện đại, tích hợp công nghệ giáo dục.', 
'https://hnue.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-08', '2024-08-15', '2024-09-08', 
'Phòng Đào tạo - HNUE\n136 Xuân Thủy, Cầu Giấy, Hà Nội\nHotline: 024.37547998', 
'https://hnue.edu.vn', '024.37547998', 'tuyensinh@hnue.edu.vn', 
'136 Xuân Thủy, Cầu Giấy, Hà Nội', 
'Học bổng sư phạm, cam kết việc làm sau tốt nghiệp', 1),

-- ĐẠI HỌC FPT
(10, 2024, 'Đề án tuyển sinh Đại học FPT năm 2024', 
'Đại học FPT tuyển sinh năm 2024 với 5.000 chỉ tiêu. Chuyên sâu về công nghệ thông tin, an toàn thông tin, kinh doanh số. Đào tạo gắn liền với thực tế doanh nghiệp.', 
'https://daihoc.fpt.edu.vn/upload/2024/dean-tuyen-sinh-2024.pdf', 
'2024-03-30', '2024-08-30', '2024-09-25', 
'Phòng Tuyển sinh - ĐH FPT\nKhu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội\nHotline: 024.73007007', 
'https://daihoc.fpt.edu.vn', '024.73007007', 'tuyensinh@fpt.edu.vn', 
'Khu Công nghệ cao Hòa Lạc, Thạch Thất, Hà Nội', 
'100% sinh viên có việc làm sau tốt nghiệp, mức lương khởi điểm cao', 1);

-- Thống kê dữ liệu đã thêm
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT idtruong) as total_schools,
    COUNT(DISTINCT namxettuyen) as total_years,
    MIN(namxettuyen) as min_year,
    MAX(namxettuyen) as max_year
FROM deantuyensinh;