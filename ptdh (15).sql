-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3308
-- Thời gian đã tạo: Th12 08, 2025 lúc 02:58 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `ptdh`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bang_diem_boi_duong`
--

CREATE TABLE `bang_diem_boi_duong` (
  `iddiem_boi_duong` int(11) NOT NULL COMMENT 'ID điểm bồi đắp',
  `idnguoidung` int(11) NOT NULL COMMENT 'ID người dùng được bồi đắp',
  `idlichtuvan` int(11) DEFAULT NULL COMMENT 'ID lịch tư vấn liên quan',
  `iddoilich` int(11) DEFAULT NULL COMMENT 'ID yêu cầu đổi lịch',
  `so_diem` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Số điểm được bồi đắp',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Chưa sử dụng, 2: Đã sử dụng',
  `ngay_tao` datetime DEFAULT current_timestamp() COMMENT 'Ngày tạo điểm',
  `nguoi_tao` int(11) DEFAULT NULL COMMENT 'ID người tạo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng điểm bồi đắp cho người dùng bị đổi lịch tư vấn';

--
-- Đang đổ dữ liệu cho bảng `bang_diem_boi_duong`
--

INSERT INTO `bang_diem_boi_duong` (`iddiem_boi_duong`, `idnguoidung`, `idlichtuvan`, `iddoilich`, `so_diem`, `trang_thai`, `ngay_tao`, `nguoi_tao`) VALUES
(3, 33, 49, 3, 100.00, 1, '2025-11-23 00:28:42', 6);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bang_quy_doi_diem_ngoai_ngu`
--

CREATE TABLE `bang_quy_doi_diem_ngoai_ngu` (
  `idquy_doi` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `loai_chung_chi` varchar(50) NOT NULL COMMENT 'IELTS, TOEFL_iBT, TOEIC',
  `muc_diem_min` decimal(4,2) DEFAULT NULL COMMENT 'Mức điểm tối thiểu',
  `muc_diem_max` decimal(4,2) DEFAULT NULL COMMENT 'Mức điểm tối đa',
  `ielts_min` decimal(3,1) DEFAULT NULL COMMENT 'IELTS min (nếu áp dụng)',
  `ielts_max` decimal(3,1) DEFAULT NULL COMMENT 'IELTS max (nếu áp dụng)',
  `toefl_min` int(11) DEFAULT NULL COMMENT 'TOEFL iBT min (nếu áp dụng)',
  `toefl_max` int(11) DEFAULT NULL COMMENT 'TOEFL iBT max (nếu áp dụng)',
  `toeic_lr_min` int(11) DEFAULT NULL COMMENT 'TOEIC Listening & Reading min',
  `toeic_lr_max` int(11) DEFAULT NULL COMMENT 'TOEIC Listening & Reading max',
  `toeic_s_min` int(11) DEFAULT NULL COMMENT 'TOEIC Speaking min',
  `toeic_s_max` int(11) DEFAULT NULL COMMENT 'TOEIC Speaking max',
  `toeic_w_min` int(11) DEFAULT NULL COMMENT 'TOEIC Writing min',
  `toeic_w_max` int(11) DEFAULT NULL COMMENT 'TOEIC Writing max',
  `diem_quy_doi` decimal(4,2) NOT NULL COMMENT 'Điểm quy đổi tương đương (thang 10)',
  `thu_tu` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bang_quy_doi_diem_ngoai_ngu`
--

INSERT INTO `bang_quy_doi_diem_ngoai_ngu` (`idquy_doi`, `idphuong_thuc_chi_tiet`, `loai_chung_chi`, `muc_diem_min`, `muc_diem_max`, `ielts_min`, `ielts_max`, `toefl_min`, `toefl_max`, `toeic_lr_min`, `toeic_lr_max`, `toeic_s_min`, `toeic_s_max`, `toeic_w_min`, `toeic_w_max`, `diem_quy_doi`, `thu_tu`, `created_at`, `updated_at`) VALUES
(1, 4, 'IELTS', NULL, NULL, 6.5, 7.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8.00, 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(2, 4, 'IELTS', NULL, NULL, 7.0, 7.5, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8.50, 2, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(3, 4, 'IELTS', NULL, NULL, 7.5, 8.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 9.00, 3, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(4, 4, 'IELTS', NULL, NULL, 8.0, 9.0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 10.00, 4, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(5, 4, 'TOEFL_iBT', NULL, NULL, NULL, NULL, 80, 90, NULL, NULL, NULL, NULL, NULL, NULL, 8.00, 5, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(6, 4, 'TOEFL_iBT', NULL, NULL, NULL, NULL, 90, 100, NULL, NULL, NULL, NULL, NULL, NULL, 9.00, 6, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(7, 4, 'TOEFL_iBT', NULL, NULL, NULL, NULL, 100, 120, NULL, NULL, NULL, NULL, NULL, NULL, 10.00, 7, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(9, 1, 'IELTS', 8.00, 8.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 8.00, 1, '2025-12-01 08:28:14', '2025-12-01 08:28:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `bang_yeucau_doilich`
--

CREATE TABLE `bang_yeucau_doilich` (
  `iddoilich` int(11) NOT NULL COMMENT 'Khóa chính của yêu cầu đổi lịch',
  `idlichtuvan` int(11) NOT NULL COMMENT 'Khóa ngoại, liên kết đến bang_lichtuvan',
  `ngaymoi` date DEFAULT NULL COMMENT 'Ngày mới mà người dùng/tư vấn viên muốn đổi sang',
  `giomoi` time DEFAULT NULL COMMENT 'Giờ mới mà người dùng/tư vấn viên muốn đổi sang',
  `lydo_doilich` text DEFAULT NULL COMMENT 'Lý do cụ thể cho việc yêu cầu đổi lịch',
  `nguoigui_yeucau` varchar(255) DEFAULT NULL COMMENT 'Vai trò hoặc ID của người tạo yêu cầu',
  `thoigian_gui` datetime DEFAULT current_timestamp() COMMENT 'Thời điểm yêu cầu đổi lịch được gửi',
  `trangthai_duyet` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Trạng thái: 1=Chờ duyệt, 2=Đã duyệt, 3=Bị từ chối',
  `nguoiduyet` int(11) DEFAULT NULL COMMENT 'ID của người đã duyệt/từ chối yêu cầu',
  `thoigian_duyet` datetime DEFAULT NULL COMMENT 'Thời điểm yêu cầu được duyệt/từ chối',
  `ghichu_duyet` text DEFAULT NULL COMMENT 'Ghi chú của người duyệt'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `bang_yeucau_doilich`
--

INSERT INTO `bang_yeucau_doilich` (`iddoilich`, `idlichtuvan`, `ngaymoi`, `giomoi`, `lydo_doilich`, `nguoigui_yeucau`, `thoigian_gui`, `trangthai_duyet`, `nguoiduyet`, `thoigian_duyet`, `ghichu_duyet`) VALUES
(1, 46, '2025-11-25', '13:05:00', 'Bận lịch họp', '5', '2025-11-22 11:25:42', 2, 6, '2025-11-22 16:05:04', '1234567'),
(2, 48, '2025-11-24', '09:05:00', 'df', '5', '2025-11-22 11:41:57', 2, 6, '2025-11-22 16:03:57', '12'),
(3, 49, '2025-11-30', '13:05:00', 'dgf', '5', '2025-11-22 17:21:45', 2, 6, '2025-11-22 17:28:42', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cau_hinh_mon_nhan_he_so`
--

CREATE TABLE `cau_hinh_mon_nhan_he_so` (
  `idcauhinh` int(11) NOT NULL,
  `idthongtin` int(11) NOT NULL COMMENT 'ID thông tin tuyển sinh',
  `idmonhoc` int(11) NOT NULL COMMENT 'ID môn học được nhân hệ số',
  `he_so` decimal(3,2) DEFAULT 2.00 COMMENT 'Hệ số nhân (thường là 2.0)',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng cấu hình môn nhân hệ số trong tổ hợp xét tuyển';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chi_tiet_diem_thi_tot_nghiep`
--

CREATE TABLE `chi_tiet_diem_thi_tot_nghiep` (
  `idchitiet` int(11) NOT NULL,
  `idketqua` int(11) NOT NULL COMMENT 'ID kết quả tính điểm',
  `idmonthi` int(11) NOT NULL COMMENT 'ID môn thi',
  `diem_thi` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm thi',
  `mien_thi` tinyint(1) DEFAULT 0 COMMENT '1: Miễn thi, 0: Không miễn',
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng chi tiết điểm thi tốt nghiệp';

--
-- Đang đổ dữ liệu cho bảng `chi_tiet_diem_thi_tot_nghiep`
--

INSERT INTO `chi_tiet_diem_thi_tot_nghiep` (`idchitiet`, `idketqua`, `idmonthi`, `diem_thi`, `mien_thi`, `created_at`) VALUES
(1, 2, 1, 7.20, 0, '2025-11-30 10:39:51'),
(2, 2, 2, 8.20, 0, '2025-11-30 10:39:51'),
(3, 2, 3, 8.20, 0, '2025-11-30 10:39:51'),
(4, 2, 4, 7.50, 0, '2025-11-30 10:39:51'),
(5, 2, 5, 9.10, 0, '2025-11-30 10:39:51'),
(64, 4, 1, 1.01, 0, '2025-11-30 21:13:56'),
(65, 4, 2, 1.00, 0, '2025-11-30 21:13:56'),
(66, 4, 4, 1.01, 0, '2025-11-30 21:13:56'),
(67, 4, 5, 1.01, 0, '2025-11-30 21:13:56'),
(80, 3, 1, 1.01, 0, '2025-11-30 21:40:17'),
(81, 3, 2, 1.01, 0, '2025-11-30 21:40:17'),
(82, 3, 4, 1.01, 0, '2025-11-30 21:40:17'),
(83, 3, 5, 1.01, 0, '2025-11-30 21:40:17');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coso_truong`
--

CREATE TABLE `coso_truong` (
  `id` bigint(20) NOT NULL,
  `idtruong` int(11) NOT NULL,
  `ten_coso` varchar(120) NOT NULL,
  `khuvuc` varchar(50) DEFAULT NULL,
  `diachi_coso` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `coso_truong`
--

INSERT INTO `coso_truong` (`id`, `idtruong`, `ten_coso`, `khuvuc`, `diachi_coso`, `created_at`, `updated_at`) VALUES
(1, 1, 'Cơ sở chính', 'Miền Bắc', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(2, 2, 'Cơ sở chính', 'Miền Bắc', '1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(3, 3, 'Cơ sở chính', 'Miền Nam', 'Phường Linh Trung, Tp. Thủ Đức, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(4, 4, 'Cơ sở chính', 'Miền Nam', '279 Nguyễn Tri Phương, Q.10, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(5, 5, 'Cơ sở chính', 'Miền Bắc', '207 Giải Phóng, Hai Bà Trưng, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(6, 6, 'Cơ sở chính', 'Miền Nam', '268 Lý Thường Kiệt, Q.10, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(7, 7, 'Cơ sở chính', 'Miền Bắc', '1 Tôn Thất Tùng, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(8, 8, 'Cơ sở chính', 'Miền Nam', '217 Hồng Bàng, Q.5, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(9, 9, 'Cơ sở chính', 'Miền Trung', '3 Lê Lợi, TP. Huế', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(10, 10, 'Cơ sở chính', 'Miền Nam', 'Khu II, đường 3/2, Ninh Kiều, Cần Thơ', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(11, 11, 'Cơ sở chính 1', 'Miền Bắc', 'Tân Thịnh, TP. Thái Nguyên', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(12, 12, 'Cơ sở chính', 'Miền Trung', '03 Quang Trung, Hải Châu, Đà Nẵng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(13, 13, 'Cơ sở chính', 'Miền Bắc', '91 Chùa Láng, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(14, 14, 'Cơ sở chính', 'Miền Nam', '19 Nguyễn Hữu Thọ, Q.7, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(15, 15, 'Cơ sở chính', 'Miền Trung', '41 Lê Duẩn, Hải Châu, Đà Nẵng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(16, 16, 'Cơ sở chính', 'Miền Nam', '702 Nguyễn Văn Linh, Q.7, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(17, 17, 'Cơ sở chính', 'Miền Bắc', '87 Nguyễn Chí Thanh, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(18, 18, 'Cơ sở chính', 'Khác', '18 Ung Văn Khiêm, Long Xuyên, An Giang', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(19, 19, 'Cơ sở chính', 'Miền Nam', 'Khu phố 6, Linh Trung, Thủ Đức, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(20, 20, 'Cơ sở chính', 'Miền Bắc', '334 Nguyễn Trãi, Thanh Xuân, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(21, 21, 'Cơ sở chính', 'Miền Nam', '12 Nguyễn Văn Bảo, P.4, Q. Gò Vấp, TP. Hồ Chí Minh', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(22, 22, 'Cơ sở chính', 'Miền Bắc', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(23, 23, 'Cơ sở chính', 'Miền Bắc', 'Km9, Nguyễn Trãi, Thanh Xuân, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(24, 24, 'Cơ sở chính', 'Miền Bắc', 'Km10, Nguyễn Trãi, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(25, 25, 'Cơ sở chính', 'Miền Nam', '97 Man Thiện, Q.9, TP. Thủ Đức', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(26, 26, 'Cơ sở chính', 'Miền Bắc', '12 Chùa Bộc, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(27, 27, 'Cơ sở chính', 'Miền Bắc', '58 Lê Văn Hiến, Đức Thắng, Bắc Từ Liêm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(28, 28, 'Cơ sở chính', 'Miền Bắc', 'Số 3 Cầu Giấy, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(29, 29, 'Cơ sở chính', 'Miền Nam', '280 An Dương Vương, Q.5, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(30, 30, 'Cơ sở chính', 'Miền Nam', '10-12 Đinh Tiên Hoàng, Q.1, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(31, 31, 'Cơ sở chính', 'Miền Bắc', '13-15 Lê Thánh Tông, Hoàn Kiếm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(32, 188, 'Cơ sở chính', 'Miền Nam', 'Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(33, 189, 'Cơ sở chính', 'Miền Bắc', '136 Xuân Thuỷ, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(34, 190, 'Cơ sở chính', 'Miền Nam', '475A Điện Biên Phủ, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(35, 191, 'Cơ sở chính', 'Miền Nam', '141 Điện Biên Phủ, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(36, 192, 'Cơ sở chính', 'Miền Nam', '56 Hoàng Diệu 2, TP. Thủ Đức, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(37, 193, 'Cơ sở chính', 'Miền Nam', '669 QL1, Khu phố 3, TP. Thủ Đức, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(38, 194, 'Cơ sở chính', 'Miền Nam', '196 Pasteur, Quận 3, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(39, 195, 'Cơ sở chính', 'Miền Nam', 'Khu phố 6, Linh Trung, TP. Thủ Đức, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(40, 196, 'Cơ sở chính', 'Miền Nam', '2 đường D3, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(41, 197, 'Cơ sở chính', 'Miền Nam', '15 D5, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(42, 198, 'Cơ sở chính', 'Khác', 'Khoái Châu, Hưng Yên', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(43, 199, 'Cơ sở chính', 'Miền Nam', '104 Nguyễn Văn Trỗi, Phú Nhuận, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(44, 200, 'Cơ sở chính', 'Miền Trung', '54 Nguyễn Lương Bằng, Đà Nẵng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(45, 201, 'Cơ sở chính', 'Miền Trung', '71 Ngũ Hành Sơn, Đà Nẵng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(46, 202, 'Cơ sở chính', 'Miền Trung', '459 Tôn Đức Thắng, Đà Nẵng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(47, 203, 'Cơ sở chính', 'Miền Nam', 'Số 206, QL 1A, Biên Hòa, Đồng Nai', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(48, 204, 'Cơ sở chính', 'Miền Nam', '10 Huỳnh Văn Nghệ, Biên Hòa, Đồng Nai', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(49, 205, 'Cơ sở chính', 'Miền Bắc', '175 Tây Sơn, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(50, 206, 'Cơ sở chính', 'Miền Nam', '2 Trường Sa, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(51, 207, 'Cơ sở chính', 'Miền Bắc', '55 Giải Phóng, Hai Bà Trưng, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(52, 208, 'Cơ sở chính', 'Miền Nam', 'Km9, Quốc lộ 1A, Thủ Đức, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(53, 209, 'Cơ sở chính', 'Miền Bắc', '298 Cầu Diễn, Bắc Từ Liêm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(54, 210, 'Cơ sở chính', 'Miền Bắc', '484 Lạch Tray, Hải Phòng', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(55, 211, 'Cơ sở chính', 'Miền Bắc', '18 Phố Viên, Bắc Từ Liêm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(56, 212, 'Cơ sở chính', 'Miền Bắc', 'TT Trâu Quỳ, Gia Lâm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(57, 213, 'Cơ sở chính', 'Miền Bắc', 'Km10, Nguyễn Trãi, Thanh Xuân, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(58, 214, 'Cơ sở chính', 'Miền Nam', '306 Nguyễn Trãi, Quận 5, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(59, 215, 'Cơ sở chính', 'Miền Nam', '140 Lê Trọng Tấn, Tân Phú, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(60, 216, 'Cơ sở chính', 'Miền Nam', '97 Võ Văn Tần, Quận 3, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(61, 217, 'Cơ sở chính', 'Miền Bắc', 'B101 Nguyễn Hiền, Hai Bà Trưng, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(62, 218, 'Cơ sở chính', 'Miền Nam', '227 Nguyễn Văn Cừ, Quận 5, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(63, 219, 'Cơ sở chính', 'Miền Bắc', '336 Nguyễn Trãi, Thanh Xuân, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(64, 220, 'Cơ sở chính', 'Miền Bắc', '144 Xuân Thuỷ, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(65, 221, 'Cơ sở chính', 'Miền Bắc', '29A Ngõ 124 Vĩnh Tuy, Hai Bà Trưng, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(66, 222, 'Cơ sở chính', 'Miền Nam', '155 Sư Vạn Hạnh, Quận 10, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(67, 223, 'Cơ sở chính', 'Miền Bắc', '77 Nguyễn Chí Thanh, Đống Đa, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(68, 224, 'Cơ sở chính', 'Miền Nam', '10 đường 3/2, Quận 10, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(69, 225, 'Cơ sở chính', 'Miền Bắc', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(70, 226, 'Cơ sở chính', 'Miền Bắc', 'Khu CNC Hòa Lạc, Thạch Thất, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(71, 227, 'Cơ sở chính', 'Miền Nam', 'Công viên Phần mềm Quang Trung, Q12, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(72, 228, 'Cơ sở chính', 'Miền Nam', '185-187 Hoàng Văn Thụ, Phú Nhuận, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(73, 229, 'Cơ sở chính', 'Miền Nam', 'Số 6 Trần Văn Ơn, Thủ Dầu Một, Bình Dương', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(74, 230, 'Cơ sở chính', 'Miền Nam', '69/68 Đặng Thùy Trâm, Bình Thạnh, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(75, 231, 'Cơ sở chính', 'Miền Nam', '17 Phạm Ngọc Thạch, Quận 3, TP.HCM', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(76, 232, 'Cơ sở chính', 'Miền Bắc', '98 Dương Quảng Hàm, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(77, 233, 'Cơ sở chính', 'Miền Bắc', 'Yên Nghĩa, Hà Đông, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(78, 234, 'Cơ sở chính', 'Miền Bắc', '235 Hoàng Quốc Việt, Bắc Từ Liêm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(79, 235, 'Cơ sở chính', 'Miền Bắc', 'Số 7 Tôn Thất Thuyết, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(80, 236, 'Cơ sở chính', 'Miền Bắc', '79 Hồ Tùng Mậu, Cầu Giấy, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(81, 237, 'Cơ sở chính', 'Miền Bắc', '58 Lê Văn Hiến, Đức Thắng, Bắc Từ Liêm, Hà Nội', '2025-10-15 13:42:35', '2025-10-15 13:42:35'),
(128, 4, 'Cơ sở A', 'TP.HCM', '59C Nguyễn Đình Chiểu, Quận 3, TP.HCM', '2025-10-15 14:06:46', '2025-10-15 14:06:46'),
(129, 4, 'Cơ sở B', 'TP.HCM', '279 Nguyễn Tri Phương, Quận 10, TP.HCM', '2025-10-15 14:06:46', '2025-10-15 14:06:46'),
(130, 4, 'Cơ sở C', 'TP.HCM', '91 Đường 3/2, Quận 10, TP.HCM', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(131, 4, 'Cơ sở D', 'TP.HCM', '196 Trần Quang Khải, Quận 1, TP.HCM', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(132, 4, 'Cơ sở E', 'TP.HCM', '54 Nguyễn Văn Thủ, Quận 1, TP.HCM', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(133, 16, 'Cơ sở Hà Nội', 'Hà Nội', 'Tòa nhà Handi Resco, 521 Kim Mã, Phường Giảng Võ, Quận Ba Đình, Hà Nội', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(134, 6, 'Cơ sở Dĩ An', 'Đông Hòa, Dĩ An', 'Khu phố Tân Lập, phường Đông Hòa (Di An Campus)', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(135, 218, 'Cơ sở Linh Trung', 'TP. Thủ Đức', 'Khu đô thị ĐHQG-HCM, Khu phố 6, P. Linh Trung, TP. Thủ Đức', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(136, 30, 'Cơ sở Thủ Đức', 'TP. Thủ Đức', 'Khu phố 6, P. Linh Trung, TP. Thủ Đức, TP.HCM', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(137, 20, 'Cơ sở 19 Lê Thánh Tông', 'Hà Nội', '19 Lê Thánh Tông, Quận Hoàn Kiếm, Hà Nội', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(138, 20, 'Cơ sở Lương Thế Vinh', 'Hà Nội', '182 Lương Thế Vinh, Quận Thanh Xuân, Hà Nội', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(139, 1, 'Cơ sở Hòa Lạc', 'Hà Nội', 'Khu đô thị ĐHQGHN tại Hòa Lạc, xã Thạch Hòa, huyện Thạch Thất, Hà Nội', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(140, 13, 'Cơ sở Quảng Ninh', 'Quảng Ninh', '260 Bạch Đằng, Phường Vàng Danh, TP. Uông Bí, Quảng Ninh', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(141, 29, 'Cơ sở 2', 'TP.HCM', '222 Lê Văn Sỹ, Quận 3, TP.HCM', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(142, 10, 'Cơ sở Lý Tự Trọng', 'Cần Thơ', '01 Lý Tự Trọng, Quận Ninh Kiều, TP. Cần Thơ', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(143, 10, 'Khu Hòa An', 'Hậu Giang', 'Khu Hòa An, Huyện Phụng Hiệp, Tỉnh Hậu Giang', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(144, 12, 'Cơ sở Quang Trung', 'Đà Nẵng', 'K7/25 Quang Trung, Quận Hải Châu, TP. Đà Nẵng', '2025-10-15 14:06:47', '2025-10-15 14:06:47'),
(145, 12, 'Cơ sở Hòa Khánh Nam', 'Đà Nẵng', '120 Hoàng Minh Thảo, Quận Liên Chiểu, TP. Đà Nẵng', '2025-10-15 14:06:47', '2025-10-15 14:06:47');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `danhgia_lichtuvan`
--

CREATE TABLE `danhgia_lichtuvan` (
  `iddanhgia` int(11) NOT NULL COMMENT 'ID đánh giá',
  `idlichtuvan` int(11) NOT NULL COMMENT 'Tham chiếu lichtuvan.idlichtuvan',
  `idnguoidat` int(11) NOT NULL COMMENT 'Người đặt lịch – là người được phép đánh giá',
  `diemdanhgia` decimal(2,1) NOT NULL COMMENT 'Điểm 1.0–5.0',
  `nhanxet` text DEFAULT NULL COMMENT 'Nhận xét chi tiết',
  `an_danh` tinyint(1) DEFAULT 0 COMMENT '1: Ẩn tên, 0: Hiện tên',
  `trangthai` tinyint(1) DEFAULT 1 COMMENT '1: Hiển thị, 0: Ẩn',
  `ngaydanhgia` datetime DEFAULT current_timestamp(),
  `ngaycapnhat` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Đánh giá tư vấn – chỉ người đặt lịch được đánh giá (mỗi lịch 1 đánh giá)';

--
-- Đang đổ dữ liệu cho bảng `danhgia_lichtuvan`
--

INSERT INTO `danhgia_lichtuvan` (`iddanhgia`, `idlichtuvan`, `idnguoidat`, `diemdanhgia`, `nhanxet`, `an_danh`, `trangthai`, `ngaydanhgia`, `ngaycapnhat`) VALUES
(1, 46, 15, 5.0, 'dfdgfgf', 1, 1, '2025-11-27 14:22:43', '2025-12-01 13:29:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `de_an_tuyen_sinh`
--

CREATE TABLE `de_an_tuyen_sinh` (
  `idde_an` bigint(20) UNSIGNED NOT NULL,
  `idtruong` int(11) NOT NULL,
  `nam_tuyen_sinh` int(11) NOT NULL,
  `tieu_de` varchar(500) NOT NULL COMMENT 'VD: ĐỀ ÁN TUYỂN SINH ĐẠI HỌC KINH TẾ QUỐC DÂN 2026',
  `thong_tin_tom_tat` text DEFAULT NULL COMMENT 'Thông tin tuyển sinh tóm tắt',
  `thong_tin_day_du` longtext DEFAULT NULL COMMENT 'Thông tin tuyển sinh đầy đủ',
  `file_pdf_url` varchar(500) DEFAULT NULL COMMENT 'Đường dẫn file PDF đề án',
  `trang_thai` tinyint(4) DEFAULT 1 COMMENT '1=hoạt động, 0=không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `de_an_tuyen_sinh`
--

INSERT INTO `de_an_tuyen_sinh` (`idde_an`, `idtruong`, `nam_tuyen_sinh`, `tieu_de`, `thong_tin_tom_tat`, `thong_tin_day_du`, `file_pdf_url`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 21, 2025, 'ĐỀ ÁN TUYỂN SINH ĐẠI HỌC CÔNG NGHIỆP TP. HỒ CHÍ MINH NĂM 2025', 'Trường Đại học Công nghiệp TP. Hồ Chí Minh (IUH) thông báo tuyển sinh đại học chính quy năm 2025 với nhiều phương thức xét tuyển đa dạng, phù hợp với nhu cầu và năng lực của thí sinh.', 'Trường Đại học Công nghiệp TP. Hồ Chí Minh (IUH) là một trong những trường đại học công lập hàng đầu tại miền Nam, có bề dày lịch sử và uy tín trong đào tạo nguồn nhân lực chất lượng cao cho các ngành công nghiệp, kinh tế và kỹ thuật.\r\n\r\nNăm 2025, trường tuyển sinh đại học chính quy với các phương thức:\r\n- Xét tuyển bằng điểm thi tốt nghiệp THPT\r\n- Xét tuyển bằng điểm học bạ THPT\r\n- Xét tuyển bằng kết quả kỳ thi đánh giá năng lực\r\n- Xét tuyển thẳng theo quy định của Bộ GD&ĐT\r\n- Xét tuyển bằng chứng chỉ quốc tế (IELTS, TOEFL, SAT, ACT)\r\n\r\nTrường có nhiều ngành đào tạo đa dạng, từ kỹ thuật, công nghệ đến kinh tế, quản trị kinh doanh, phù hợp với xu hướng phát triển của thị trường lao động.', 'https://images.tuyensinh247.com/picture/2024/0422/ts-dh-cong-nghiep-tphcm.pdf', 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diemchuanxettuyen`
--

CREATE TABLE `diemchuanxettuyen` (
  `iddiemchuan` int(11) NOT NULL,
  `idtruong` int(11) NOT NULL,
  `manganh` varchar(20) NOT NULL,
  `idxettuyen` int(11) DEFAULT NULL,
  `tohopmon` varchar(255) DEFAULT NULL,
  `diemchuan` decimal(4,2) DEFAULT NULL,
  `namxettuyen` year(4) DEFAULT NULL,
  `ghichu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `diemchuanxettuyen`
--

INSERT INTO `diemchuanxettuyen` (`iddiemchuan`, `idtruong`, `manganh`, `idxettuyen`, `tohopmon`, `diemchuan`, `namxettuyen`, `ghichu`) VALUES
(3, 4, '7220201', 1, 'D09; D10; D01; D14; D15', 26.00, '2024', 'Môn Anh hệ số 2'),
(4, 2, '7480201', 1, 'A00;A01;D01', 28.80, '2024', NULL),
(5, 2, '7480201', 2, 'A00;A01;D01', 27.30, '2024', NULL),
(6, 2, '7480201', 3, 'A00;A01;D01', 99.99, '2024', NULL),
(7, 2, '7480201', 4, 'A00;A01;D01', 28.30, '2024', NULL),
(8, 19, '7480201', 1, 'A00;A01;D01', 27.50, '2024', NULL),
(9, 19, '7480201', 2, 'A00;A01;D01', 26.00, '2024', NULL),
(10, 19, '7480201', 3, 'A00;A01;D01', 99.99, '2024', NULL),
(11, 19, '7480201', 4, 'A00;A01;D01', 27.00, '2024', NULL),
(12, 6, '7480201', 1, 'A00;A01;D01', 28.20, '2024', NULL),
(13, 6, '7480201', 2, 'A00;A01;D01', 26.70, '2024', NULL),
(14, 6, '7480201', 3, 'A00;A01;D01', 99.99, '2024', NULL),
(15, 6, '7480201', 4, 'A00;A01;D01', 27.70, '2024', NULL),
(28, 7, '7720101', 1, 'A00;B00;D07', 28.50, '2024', NULL),
(29, 7, '7720101', 2, 'A00;B00;D07', 27.00, '2024', NULL),
(30, 7, '7720101', 3, 'A00;B00;D07', 99.99, '2024', NULL),
(31, 7, '7720101', 4, 'A00;B00;D07', 28.00, '2024', NULL),
(32, 8, '7720101', 1, 'A00;B00;D07', 28.80, '2024', NULL),
(33, 8, '7720101', 2, 'A00;B00;D07', 27.30, '2024', NULL),
(34, 8, '7720101', 3, 'A00;B00;D07', 99.99, '2024', NULL),
(35, 8, '7720101', 4, 'A00;B00;D07', 28.30, '2024', NULL),
(36, 5, '7310101', 1, 'A00;A01;D01', 27.20, '2024', NULL),
(37, 5, '7310101', 2, 'A00;A01;D01', 26.00, '2024', NULL),
(38, 5, '7310101', 3, 'A00;A01;D01', 99.99, '2024', NULL),
(39, 5, '7310101', 4, 'A00;A01;D01', 26.80, '2024', NULL),
(40, 4, '7310101', 1, 'A00;A01;D01', 26.50, '2024', NULL),
(41, 4, '7310101', 2, 'A00;A01;D01', 25.50, '2024', NULL),
(42, 4, '7310101', 3, 'A00;A01;D01', 99.99, '2024', NULL),
(43, 4, '7310101', 4, 'A00;A01;D01', 26.00, '2024', NULL),
(72, 29, '7140209', 1, 'A00;A01', 26.50, '2024', NULL),
(73, 29, '7140209', 2, 'A00;A01', 25.50, '2024', NULL),
(74, 29, '7140209', 3, 'A00;A01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(75, 29, '7140209', 4, 'A00;A01', 25.80, '2024', NULL),
(80, 17, '7380101', 1, 'C00;D01;A00', 27.20, '2024', NULL),
(81, 17, '7380101', 2, 'C00;D01;A00', 26.00, '2024', NULL),
(82, 17, '7380101', 3, 'C00;D01;A00', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(83, 17, '7380101', 4, 'C00;D01;A00', 26.80, '2024', NULL),
(84, 13, '7310106', 1, 'A00;A01;D01', 28.30, '2024', NULL),
(85, 13, '7310106', 2, 'A00;A01;D01', 27.00, '2024', NULL),
(86, 13, '7310106', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(87, 13, '7310106', 4, 'A00;A01;D01', 28.00, '2024', NULL),
(88, 26, '7340201', 1, 'A00;A01;D01', 25.80, '2024', NULL),
(89, 26, '7340201', 2, 'A00;A01;D01', 24.80, '2024', NULL),
(90, 26, '7340201', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(91, 26, '7340201', 4, 'A00;A01;D01', 25.30, '2024', NULL),
(92, 27, '7340201', 1, 'A00;A01;D01', 26.20, '2024', NULL),
(93, 27, '7340201', 2, 'A00;A01;D01', 25.30, '2024', NULL),
(94, 27, '7340201', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(95, 27, '7340201', 4, 'A00;A01;D01', 25.90, '2024', NULL),
(100, 23, '7220201', 1, 'D01', 27.00, '2024', NULL),
(101, 23, '7220201', 2, 'D01', 25.80, '2024', NULL),
(102, 23, '7220201', 3, 'D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(103, 23, '7220201', 4, 'D01', 26.50, '2024', NULL),
(104, 19, '7480103', 1, 'A00;A01;D01', 27.00, '2024', NULL),
(105, 19, '7480103', 2, 'A00;A01;D01', 25.80, '2024', NULL),
(106, 19, '7480103', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(107, 19, '7480103', 4, 'A00;A01;D01', 26.50, '2024', NULL),
(108, 19, '7480104', 1, 'A00;A01;D01', 26.80, '2024', NULL),
(109, 19, '7480104', 2, 'A00;A01;D01', 25.50, '2024', NULL),
(110, 19, '7480104', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(111, 19, '7480104', 4, 'A00;A01;D01', 26.20, '2024', NULL),
(112, 19, '7480101', 1, 'A00;A01;D01', 27.50, '2024', NULL),
(113, 19, '7480101', 2, 'A00;A01;D01', 26.20, '2024', NULL),
(114, 19, '7480101', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(115, 19, '7480101', 4, 'A00;A01;D01', 26.90, '2024', NULL),
(116, 19, '7480207', 1, 'A00;A01;D01', 28.00, '2024', NULL),
(117, 19, '7480207', 2, 'A00;A01;D01', 26.80, '2024', NULL),
(118, 19, '7480207', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(119, 19, '7480207', 4, 'A00;A01;D01', 27.50, '2024', NULL),
(120, 19, '7480202', 1, 'A00;A01;D01', 27.00, '2024', NULL),
(121, 19, '7480202', 2, 'A00;A01;D01', 25.80, '2024', NULL),
(122, 19, '7480202', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(123, 19, '7480202', 4, 'A00;A01;D01', 26.40, '2024', NULL),
(124, 5, '7340115', 1, 'A00;A01;D01', 26.80, '2024', NULL),
(125, 5, '7340115', 2, 'A00;A01;D01', 25.50, '2024', NULL),
(126, 5, '7340115', 3, 'A00;A01;D01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(127, 5, '7340115', 4, 'A00;A01;D01', 26.00, '2024', NULL),
(128, 6, '7520103', 1, 'A00;A01', 25.00, '2024', NULL),
(129, 6, '7520103', 2, 'A00;A01', 24.00, '2024', NULL),
(130, 6, '7520103', 3, 'A00;A01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(131, 6, '7520103', 4, 'A00;A01', 24.50, '2024', NULL),
(132, 6, '7520201', 1, 'A00;A01', 25.50, '2024', NULL),
(133, 6, '7520201', 2, 'A00;A01', 24.50, '2024', NULL),
(134, 6, '7520201', 3, 'A00;A01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(135, 6, '7520201', 4, 'A00;A01', 25.00, '2024', NULL),
(136, 6, '7580201', 1, 'A00;A01', 25.00, '2024', NULL),
(137, 6, '7580201', 2, 'A00;A01', 24.00, '2024', NULL),
(138, 6, '7580201', 3, 'A00;A01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(139, 6, '7580201', 4, 'A00;A01', 24.50, '2024', NULL),
(140, 6, '7510205', 1, 'A00;A01', 25.80, '2024', NULL),
(141, 6, '7510205', 2, 'A00;A01', 24.80, '2024', NULL),
(142, 6, '7510205', 3, 'A00;A01', 99.99, '2024', 'Điểm Đánh giá năng lực ĐHQG TP.HCM'),
(143, 6, '7510205', 4, 'A00;A01', 25.30, '2024', NULL),
(513, 14, '7480109', 1, 'A00;A01', 27.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(514, 14, '7340122', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(515, 14, '7510605', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(516, 14, '7480206', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(517, 14, '7480213', 4, 'A00;A01 + IELTS', 26.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(518, 10, '7440301', 1, 'A00;B00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(519, 10, '7520320', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(520, 10, '7540101', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(521, 10, '7520503', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(522, 11, '7520115', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(523, 11, '7520301', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(524, 11, '7520309', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(525, 12, '7340126', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(526, 12, '7210403', 4, 'V00 + Portfolio', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(527, 12, '7480219', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(528, 20, '7310635', 1, 'D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(529, 20, '7440302', 2, 'A00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(530, 21, '7510601', 2, 'A00;A01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(531, 21, '7480205', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(532, 22, '7340405', 2, 'A00;A01;D01', 24.50, '2024', 'Phương thức 2 – Học bạ'),
(533, 22, '7310410', 1, 'A00;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(534, 24, '7480221', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(535, 24, '7480215', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(536, 25, '7480218', 2, 'A00;A01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(537, 25, '7480219', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(538, 28, '7520604', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(539, 28, '7520501', 1, 'A00', 21.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(540, 30, '7310617', 2, 'D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(541, 30, '7310608', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(542, 31, '7720602', 2, 'B00', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(543, 31, '7720604', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(544, 2, '7720302', 2, 'B00', 21.00, '2024', 'Phương thức 2 – Học bạ'),
(545, 197, '7340114', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(546, 197, '7340121', 2, 'A00;A01;D01', 24.20, '2024', 'Phương thức 2 – Học bạ'),
(547, 214, '7340123', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(548, 214, '7340127', 2, 'A00;A01;D01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(549, 218, '7480206', 1, 'A00;A01', 26.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(550, 218, '7440301', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(551, 220, '7480106', 1, 'A00;A01', 26.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(552, 220, '7480109', 2, 'A00;A01', 25.00, '2024', 'Phương thức 2 – Học bạ'),
(576, 195, '7850101', 1, 'A00;B00', 21.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(577, 195, '7850102', 1, 'A00;B00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(578, 195, '7440301', 1, 'A00;B00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(579, 195, '7520320', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(580, 195, '7510412', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(581, 195, '7520321', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(582, 195, '7520501', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(583, 195, '7520503', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(584, 195, '7540101', 1, 'A00;B00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(585, 195, '7510415', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(586, 190, '7480211', 1, 'A00;A01', 25.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(587, 190, '7340123', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(588, 190, '7340127', 1, 'A00;A01;D01', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(589, 190, '7340121', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(590, 190, '7340404', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(591, 190, '7510605', 1, 'A00;A01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(592, 190, '7580201', 1, 'A00', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(593, 190, '7320104', 1, 'D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(594, 190, '7210403', 1, 'V00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(595, 190, '7340402', 1, 'A00;A01;D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(596, 193, '7340101', 1, 'A00;A01;D01', 25.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(597, 193, '7340120', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(598, 193, '7340121', 1, 'A00;A01;D01', 26.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(599, 193, '7340201', 1, 'A00;A01;D01', 25.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(600, 193, '7340404', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(601, 193, '7340123', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(602, 193, '7340117', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(603, 193, '7340208', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(604, 193, '7310401', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(605, 193, '7340405', 1, 'A00;A01;D01', 25.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(706, 218, '7440302', 1, 'A00;B00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(707, 218, '7440250', 1, 'A00;B00', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(708, 218, '7480109', 1, 'A00;A01', 26.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(709, 218, '7480205', 1, 'A00;A01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(710, 218, '7310601', 1, 'D01;D14', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(711, 218, '7320104', 1, 'D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(712, 218, '7210403', 1, 'V00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(713, 191, '7340101', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(714, 191, '7340120', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(715, 191, '7340121', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(716, 191, '7340201', 1, 'A00;A01;D01', 24.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(717, 191, '7340404', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(718, 191, '7340123', 1, 'A00;A01;D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(719, 191, '7340117', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(720, 191, '7340208', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(721, 191, '7310401', 1, 'A00;A01;D01', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(722, 191, '7340405', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(723, 192, '7340201', 1, 'A00;A01;D01', 25.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(724, 192, '7340101', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(725, 192, '7340120', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(726, 192, '7340121', 1, 'A00;A01;D01', 25.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(727, 192, '7340123', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(728, 192, '7340117', 1, 'A00;A01;D01', 24.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(729, 192, '7340208', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(730, 192, '7340404', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(731, 192, '7340405', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(732, 192, '7310101', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(733, 194, '7580201', 1, 'A00;A01;V00', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(734, 194, '7510205', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(735, 194, '7520112', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(736, 194, '7520201', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(737, 194, '7520216', 1, 'A00;A01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(738, 194, '7520301', 1, 'A00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(739, 194, '7520309', 1, 'A00', 23.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(740, 194, '7540101', 1, 'A00;B00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(741, 194, '7210406', 1, 'V00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(742, 194, '7210407', 1, 'V00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(743, 196, '7510605', 1, 'A00;A01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(744, 196, '7840101', 1, 'A00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(745, 196, '7840102', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(746, 196, '7840201', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(747, 196, '7520501', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(748, 196, '7520503', 1, 'A00', 22.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(749, 196, '7340113', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(750, 196, '7340124', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(751, 196, '7340125', 1, 'A00;A01;D01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(752, 196, '7510607', 1, 'A00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(753, 197, '7340101', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(754, 197, '7340120', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(755, 197, '7340121', 1, 'A00;A01;D01', 25.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(756, 197, '7340201', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(757, 197, '7340404', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(758, 197, '7340123', 1, 'A00;A01;D01', 23.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(759, 197, '7340117', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(760, 197, '7340208', 1, 'A00;A01;D01', 24.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(761, 197, '7310401', 1, 'A00;A01;D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(762, 197, '7340405', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(763, 198, '7520114', 1, 'A00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(764, 198, '7520140', 1, 'A00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(765, 198, '7520103', 1, 'A00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(766, 198, '7520201', 1, 'A00', 23.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(767, 198, '7520216', 1, 'A00', 23.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(768, 198, '7510205', 1, 'A00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(769, 198, '7520301', 1, 'A00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(770, 198, '7520309', 1, 'A00', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(771, 198, '7510601', 1, 'A00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(772, 198, '7540101', 1, 'A00;B00', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(773, 200, '7520103', 1, 'A00', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(774, 200, '7520201', 1, 'A00', 25.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(775, 200, '7520216', 1, 'A00', 26.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(776, 200, '7520320', 1, 'A00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(777, 200, '7540101', 1, 'A00;B00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(778, 200, '7580201', 1, 'A00', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(779, 200, '7510205', 1, 'A00', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(780, 200, '7520501', 1, 'A00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(781, 200, '7520503', 1, 'A00', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(782, 200, '7510605', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(783, 201, '7340101', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(784, 201, '7340120', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(785, 201, '7340121', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(786, 201, '7340201', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(787, 201, '7340404', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(788, 201, '7340123', 1, 'A00;A01;D01', 23.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(789, 201, '7340208', 1, 'A00;A01;D01', 24.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(790, 201, '7340117', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(791, 201, '7340405', 1, 'A00;A01;D01', 24.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(792, 201, '7310101', 1, 'A00;A01;D01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(793, 202, '7140209', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(794, 202, '7220201', 1, 'D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(795, 202, '7220204', 1, 'D01', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(796, 202, '7220209', 1, 'D01', 23.20, '2024', 'Phương thức 1 – Điểm thi THPT'),
(797, 202, '7220210', 1, 'D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(798, 202, '7220211', 1, 'D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(799, 202, '7310612', 1, 'D01', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(800, 202, '7310613', 1, 'D01', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(801, 202, '7310614', 1, 'D01', 22.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(802, 202, '7320104', 1, 'D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(803, 203, '7480211', 1, 'A00;A01', 24.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(804, 203, '7340121', 1, 'A00;A01;D01', 23.00, '2024', 'Phương thức 1 – Điểm thi THPT'),
(805, 203, '7340123', 1, 'A00;A01;D01', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(806, 203, '7340404', 1, 'A00;A01;D01', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(807, 203, '7510205', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(808, 203, '7520103', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(809, 203, '7520201', 1, 'A00;A01', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(810, 203, '7580201', 1, 'A00', 23.50, '2024', 'Phương thức 1 – Điểm thi THPT'),
(811, 203, '7320104', 1, 'D01', 22.80, '2024', 'Phương thức 1 – Điểm thi THPT'),
(812, 203, '7210403', 1, 'V00', 22.30, '2024', 'Phương thức 1 – Điểm thi THPT'),
(813, 191, '7340101', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(814, 191, '7340120', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(815, 191, '7340121', 2, 'A00;A01;D01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(816, 191, '7340201', 2, 'A00;A01;D01', 23.20, '2024', 'Phương thức 2 – Học bạ'),
(817, 191, '7340404', 2, 'A00;A01;D01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(818, 191, '7340123', 2, 'A00;A01;D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(819, 191, '7340117', 2, 'A00;A01;D01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(820, 191, '7340208', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(821, 191, '7310401', 2, 'A00;A01;D01', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(822, 191, '7340405', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(823, 191, '7340101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(824, 191, '7340120', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(825, 191, '7340121', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(826, 191, '7340201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(827, 191, '7340404', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(828, 191, '7340123', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(829, 191, '7340117', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(830, 191, '7340208', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(831, 191, '7310401', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(832, 191, '7340405', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(833, 191, '7340101', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(834, 191, '7340120', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(835, 191, '7340121', 4, 'A00;A01;D01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(836, 191, '7340201', 4, 'A00;A01;D01 + IELTS', 23.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(837, 191, '7340404', 4, 'A00;A01;D01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(838, 191, '7340123', 4, 'A00;A01;D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(839, 191, '7340117', 4, 'A00;A01;D01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(840, 191, '7340208', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(841, 191, '7310401', 4, 'A00;A01;D01 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(842, 191, '7340405', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(843, 192, '7340201', 2, 'A00;A01;D01', 24.50, '2024', 'Phương thức 2 – Học bạ'),
(844, 192, '7340101', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(845, 192, '7340120', 2, 'A00;A01;D01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(846, 192, '7340121', 2, 'A00;A01;D01', 24.20, '2024', 'Phương thức 2 – Học bạ'),
(847, 192, '7340123', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(848, 192, '7340117', 2, 'A00;A01;D01', 23.20, '2024', 'Phương thức 2 – Học bạ'),
(849, 192, '7340208', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(850, 192, '7340404', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(851, 192, '7340405', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(852, 192, '7310101', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(853, 192, '7340201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(854, 192, '7340101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(855, 192, '7340120', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(856, 192, '7340121', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(857, 192, '7340123', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(858, 192, '7340117', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(859, 192, '7340208', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(860, 192, '7340404', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(861, 192, '7340405', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(862, 192, '7310101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(863, 192, '7340201', 4, 'A00;A01;D01 + IELTS', 25.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(864, 192, '7340101', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(865, 192, '7340120', 4, 'A00;A01;D01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(866, 192, '7340121', 4, 'A00;A01;D01 + IELTS', 24.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(867, 192, '7340123', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(868, 192, '7340117', 4, 'A00;A01;D01 + IELTS', 23.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(869, 192, '7340208', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(870, 192, '7340404', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(871, 192, '7340405', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(872, 192, '7310101', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(873, 194, '7580201', 2, 'A00;A01;V00', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(874, 194, '7510205', 2, 'A00;A01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(875, 194, '7520112', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(876, 194, '7520201', 2, 'A00;A01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(877, 194, '7520216', 2, 'A00;A01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(878, 194, '7520301', 2, 'A00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(879, 194, '7520309', 2, 'A00', 22.20, '2024', 'Phương thức 2 – Học bạ'),
(880, 194, '7540101', 2, 'A00;B00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(881, 194, '7210406', 2, 'V00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(882, 194, '7210407', 2, 'V00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(883, 194, '7580201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(884, 194, '7510205', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(885, 194, '7520112', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(886, 194, '7520201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(887, 194, '7520216', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(888, 194, '7520301', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(889, 194, '7520309', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(890, 194, '7540101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(891, 194, '7210406', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(892, 194, '7210407', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(893, 194, '7580201', 4, 'A00;A01;V00 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(894, 194, '7510205', 4, 'A00;A01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(895, 194, '7520112', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(896, 194, '7520201', 4, 'A00;A01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(897, 194, '7520216', 4, 'A00;A01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(898, 194, '7520301', 4, 'A00 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(899, 194, '7520309', 4, 'A00 + IELTS', 22.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(900, 194, '7540101', 4, 'A00;B00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(901, 194, '7210406', 4, 'V00 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(902, 194, '7210407', 4, 'V00 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(903, 196, '7510605', 2, 'A00;A01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(904, 196, '7840101', 2, 'A00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(905, 196, '7840102', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(906, 196, '7840201', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(907, 196, '7520501', 2, 'A00', 21.00, '2024', 'Phương thức 2 – Học bạ'),
(908, 196, '7520503', 2, 'A00', 21.00, '2024', 'Phương thức 2 – Học bạ'),
(909, 196, '7340113', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(910, 196, '7340124', 2, 'A00;A01;D01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(911, 196, '7340125', 2, 'A00;A01;D01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(912, 196, '7510607', 2, 'A00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(913, 196, '7510605', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(914, 196, '7840101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(915, 196, '7840102', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(916, 196, '7840201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(917, 196, '7520501', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(918, 196, '7520503', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(919, 196, '7340113', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(920, 196, '7340124', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(921, 196, '7340125', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(922, 196, '7510607', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(923, 196, '7510605', 4, 'A00;A01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(924, 196, '7840101', 4, 'A00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(925, 196, '7840102', 4, 'A00 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(926, 196, '7840201', 4, 'A00 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(927, 196, '7520501', 4, 'A00 + IELTS', 21.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(928, 196, '7520503', 4, 'A00 + IELTS', 21.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(929, 196, '7340113', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(930, 196, '7340124', 4, 'A00;A01;D01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(931, 196, '7340125', 4, 'A00;A01;D01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(932, 196, '7510607', 4, 'A00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1113, 197, '7340101', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1114, 197, '7340120', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(1115, 197, '7340201', 2, 'A00;A01;D01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(1116, 197, '7340404', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1117, 197, '7340123', 2, 'A00;A01;D01', 22.80, '2024', 'Phương thức 2 – Học bạ'),
(1118, 197, '7340117', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1119, 197, '7340208', 2, 'A00;A01;D01', 23.20, '2024', 'Phương thức 2 – Học bạ'),
(1120, 197, '7310401', 2, 'A00;A01;D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1121, 197, '7340405', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1133, 197, '7340101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1134, 197, '7340120', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1135, 197, '7340121', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1136, 197, '7340201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1137, 197, '7340404', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1138, 197, '7340123', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1139, 197, '7340117', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1140, 197, '7340208', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1141, 197, '7310401', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1142, 197, '7340405', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1153, 197, '7340101', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1154, 197, '7340120', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1155, 197, '7340121', 4, 'A00;A01;D01 + IELTS', 24.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1156, 197, '7340201', 4, 'A00;A01;D01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1157, 197, '7340404', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1158, 197, '7340123', 4, 'A00;A01;D01 + IELTS', 23.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1159, 197, '7340117', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1160, 197, '7340208', 4, 'A00;A01;D01 + IELTS', 23.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1161, 197, '7310401', 4, 'A00;A01;D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1162, 197, '7340405', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1173, 198, '7520114', 2, 'A00', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1174, 198, '7520140', 2, 'A00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1175, 198, '7520103', 2, 'A00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1176, 198, '7520201', 2, 'A00', 22.20, '2024', 'Phương thức 2 – Học bạ'),
(1177, 198, '7520216', 2, 'A00', 22.80, '2024', 'Phương thức 2 – Học bạ'),
(1178, 198, '7510205', 2, 'A00', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1179, 198, '7520301', 2, 'A00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1180, 198, '7520309', 2, 'A00', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1181, 198, '7510601', 2, 'A00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(1182, 198, '7540101', 2, 'A00;B00', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(1193, 198, '7520114', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1194, 198, '7520140', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1195, 198, '7520103', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1196, 198, '7520201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1197, 198, '7520216', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1198, 198, '7510205', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1199, 198, '7520301', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1200, 198, '7520309', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1201, 198, '7510601', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1202, 198, '7540101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1213, 198, '7520114', 4, 'A00 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1214, 198, '7520140', 4, 'A00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1215, 198, '7520103', 4, 'A00 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1216, 198, '7520201', 4, 'A00 + IELTS', 22.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1217, 198, '7520216', 4, 'A00 + IELTS', 23.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1218, 198, '7510205', 4, 'A00 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1219, 198, '7520301', 4, 'A00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1220, 198, '7520309', 4, 'A00 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1221, 198, '7510601', 4, 'A00 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1222, 198, '7540101', 4, 'A00;B00 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1233, 200, '7520103', 2, 'A00', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1234, 200, '7520201', 2, 'A00', 24.20, '2024', 'Phương thức 2 – Học bạ'),
(1235, 200, '7520216', 2, 'A00', 25.00, '2024', 'Phương thức 2 – Học bạ'),
(1236, 200, '7520320', 2, 'A00', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1237, 200, '7540101', 2, 'A00;B00', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1238, 200, '7580201', 2, 'A00', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(1239, 200, '7510205', 2, 'A00', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1240, 200, '7520501', 2, 'A00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1241, 200, '7520503', 2, 'A00', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1242, 200, '7510605', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1253, 200, '7520103', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1254, 200, '7520201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1255, 200, '7520216', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1256, 200, '7520320', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1257, 200, '7540101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1258, 200, '7580201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1259, 200, '7510205', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1260, 200, '7520501', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1261, 200, '7520503', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1262, 200, '7510605', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1273, 200, '7520103', 4, 'A00 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1274, 200, '7520201', 4, 'A00 + IELTS', 24.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1275, 200, '7520216', 4, 'A00 + IELTS', 25.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1276, 200, '7520320', 4, 'A00 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1277, 200, '7540101', 4, 'A00;B00 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1278, 200, '7580201', 4, 'A00 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1279, 200, '7510205', 4, 'A00 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1280, 200, '7520501', 4, 'A00 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1281, 200, '7520503', 4, 'A00 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1282, 200, '7510605', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1293, 201, '7340101', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1294, 201, '7340120', 2, 'A00;A01;D01', 23.50, '2024', 'Phương thức 2 – Học bạ'),
(1295, 201, '7340121', 2, 'A00;A01;D01', 24.00, '2024', 'Phương thức 2 – Học bạ'),
(1296, 201, '7340201', 2, 'A00;A01;D01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(1297, 201, '7340404', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1298, 201, '7340123', 2, 'A00;A01;D01', 22.80, '2024', 'Phương thức 2 – Học bạ'),
(1299, 201, '7340208', 2, 'A00;A01;D01', 23.20, '2024', 'Phương thức 2 – Học bạ'),
(1300, 201, '7340117', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1301, 201, '7340405', 2, 'A00;A01;D01', 23.80, '2024', 'Phương thức 2 – Học bạ'),
(1302, 201, '7310101', 2, 'A00;A01;D01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1313, 201, '7340101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1314, 201, '7340120', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1315, 201, '7340121', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1316, 201, '7340201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1317, 201, '7340404', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1318, 201, '7340123', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1319, 201, '7340208', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1320, 201, '7340117', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1321, 201, '7340405', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1322, 201, '7310101', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1333, 201, '7340101', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1334, 201, '7340120', 4, 'A00;A01;D01 + IELTS', 24.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1335, 201, '7340121', 4, 'A00;A01;D01 + IELTS', 24.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1336, 201, '7340201', 4, 'A00;A01;D01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1337, 201, '7340404', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1338, 201, '7340123', 4, 'A00;A01;D01 + IELTS', 23.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1339, 201, '7340208', 4, 'A00;A01;D01 + IELTS', 23.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1340, 201, '7340117', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1341, 201, '7340405', 4, 'A00;A01;D01 + IELTS', 24.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1342, 201, '7310101', 4, 'A00;A01;D01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1353, 202, '7140209', 2, 'A00;A01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1354, 202, '7220201', 2, 'D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1355, 202, '7220204', 2, 'D01', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1356, 202, '7220209', 2, 'D01', 22.20, '2024', 'Phương thức 2 – Học bạ'),
(1357, 202, '7220210', 2, 'D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1358, 202, '7220211', 2, 'D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1359, 202, '7310612', 2, 'D01', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(1360, 202, '7310613', 2, 'D01', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(1361, 202, '7310614', 2, 'D01', 21.50, '2024', 'Phương thức 2 – Học bạ'),
(1362, 202, '7320104', 2, 'D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1373, 202, '7140209', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1374, 202, '7220201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1375, 202, '7220204', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1376, 202, '7220209', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1377, 202, '7220210', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1378, 202, '7220211', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1379, 202, '7310612', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1380, 202, '7310613', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1381, 202, '7310614', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1382, 202, '7320104', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1393, 202, '7140209', 4, 'A00;A01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1394, 202, '7220201', 4, 'D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1395, 202, '7220204', 4, 'D01 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1396, 202, '7220209', 4, 'D01 + IELTS', 22.70, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1397, 202, '7220210', 4, 'D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1398, 202, '7220211', 4, 'D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1399, 202, '7310612', 4, 'D01 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1400, 202, '7310613', 4, 'D01 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1401, 202, '7310614', 4, 'D01 + IELTS', 22.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1402, 202, '7320104', 4, 'D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1413, 203, '7480211', 2, 'A00;A01', 23.00, '2024', 'Phương thức 2 – Học bạ'),
(1414, 203, '7340121', 2, 'A00;A01;D01', 22.00, '2024', 'Phương thức 2 – Học bạ'),
(1415, 203, '7340123', 2, 'A00;A01;D01', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1416, 203, '7340404', 2, 'A00;A01;D01', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1417, 203, '7510205', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1418, 203, '7520103', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1419, 203, '7520201', 2, 'A00;A01', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1420, 203, '7580201', 2, 'A00', 22.50, '2024', 'Phương thức 2 – Học bạ'),
(1421, 203, '7320104', 2, 'D01', 21.80, '2024', 'Phương thức 2 – Học bạ'),
(1422, 203, '7210403', 2, 'V00', 21.30, '2024', 'Phương thức 2 – Học bạ'),
(1433, 203, '7480211', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1434, 203, '7340121', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1435, 203, '7340123', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1436, 203, '7340404', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1437, 203, '7510205', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1438, 203, '7520103', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1439, 203, '7520201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1440, 203, '7580201', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1441, 203, '7320104', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1442, 203, '7210403', 3, 'ĐGNL HCM', 99.99, '2024', 'Phương thức 3 – Đánh giá năng lực (ĐGNL HCM)'),
(1453, 203, '7480211', 4, 'A00;A01 + IELTS', 23.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1454, 203, '7340121', 4, 'A00;A01;D01 + IELTS', 22.50, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1455, 203, '7340123', 4, 'A00;A01;D01 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1456, 203, '7340404', 4, 'A00;A01;D01 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1457, 203, '7510205', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1458, 203, '7520103', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1459, 203, '7520201', 4, 'A00;A01 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1460, 203, '7580201', 4, 'A00 + IELTS', 23.00, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1461, 203, '7320104', 4, 'D01 + IELTS', 22.30, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1462, 203, '7210403', 4, 'V00 + IELTS', 21.80, '2024', 'Phương thức 4 – Xét tuyển kết hợp'),
(1554, 27, '7140209', 1, 'A00;A01;D01', 25.50, '2024', 'Phương thức 1 - Điểm thi THPT'),
(1555, 27, '7140209', 2, 'A00;A01;D01', 27.00, '2024', 'Phương thức 2 - Học bạ'),
(1556, 27, '7140209', 3, 'A00;A01;D01', 99.99, '2024', 'Phương thức 3 - ĐGNL HCM'),
(1557, 27, '7140209', 4, 'A00;A01;D01', 28.00, '2024', 'Phương thức 4 - Kết hợp chứng chỉ'),
(1558, 27, '7220201', 1, 'A00;A01;D01', 24.50, '2024', 'Phương thức 1 - Điểm thi THPT'),
(1559, 27, '7220201', 2, 'A00;A01;D01', 26.50, '2024', 'Phương thức 2 - Học bạ'),
(1560, 27, '7220201', 3, 'A00;A01;D01', 99.99, '2024', 'Phương thức 3 - ĐGNL HCM'),
(1561, 27, '7220201', 4, 'A00;A01;D01', 27.00, '2024', 'Phương thức 4 - Kết hợp'),
(1562, 27, '7340301', 1, 'A00;A01;D01', 25.00, '2024', 'Phương thức 1 - Điểm thi THPT'),
(1563, 27, '7340301', 2, 'A00;A01;D01', 26.00, '2024', 'Phương thức 2 - Học bạ'),
(1564, 27, '7340301', 3, 'A00;A01;D01', 99.99, '2024', 'Phương thức 3 - ĐGNL HCM'),
(1565, 27, '7340403', 1, 'A00;A01;D01', 26.00, '2024', 'Phương thức 1 - Điểm thi THPT'),
(1566, 27, '7340403', 2, 'A00;A01;D01', 27.00, '2024', 'Phương thức 2 - Học bạ'),
(1578, 28, '7480202', 2, 'D01;D96', 26.00, '2024', 'Test record 2'),
(1579, 2, '7340125', 1, 'A00', 26.00, '2024', 'ềdsfsf'),
(1580, 4, '7480201', 1, 'A00;A01;D01', 25.50, '2024', 'Phương thức 1 - Điểm thi'),
(1581, 4, '7340101', 2, 'A00;A01', 23.00, '2024', 'Phương thức 2 - Học bạ');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_hoc_ba`
--

CREATE TABLE `diem_hoc_ba` (
  `iddiem_hb` int(11) NOT NULL,
  `idnguoidung` int(11) NOT NULL COMMENT 'ID người dùng (học sinh)',
  `idmonhoc` int(11) NOT NULL COMMENT 'ID môn học',
  `lop` tinyint(2) NOT NULL COMMENT 'Lớp (10, 11, 12)',
  `hoc_ky` tinyint(1) DEFAULT NULL COMMENT 'Học kỳ (1, 2) - NULL nếu là cả năm',
  `diem_trung_binh` decimal(4,2) NOT NULL COMMENT 'Điểm trung bình',
  `nam_hoc` int(4) DEFAULT NULL COMMENT 'Năm học (VD: 2024)',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng điểm học bạ của học sinh';

--
-- Đang đổ dữ liệu cho bảng `diem_hoc_ba`
--

INSERT INTO `diem_hoc_ba` (`iddiem_hb`, `idnguoidung`, `idmonhoc`, `lop`, `hoc_ky`, `diem_trung_binh`, `nam_hoc`, `created_at`, `updated_at`) VALUES
(183, 15, 1, 10, 1, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(184, 15, 1, 10, 2, 8.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(185, 15, 1, 11, 1, 8.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(186, 15, 1, 11, 2, 8.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(187, 15, 1, 12, 1, 7.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(188, 15, 1, 12, 2, 6.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(189, 15, 2, 10, 1, 6.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(190, 15, 2, 10, 2, 7.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(191, 15, 2, 11, 1, 4.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(192, 15, 2, 11, 2, 3.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(193, 15, 2, 12, 1, 7.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(194, 15, 2, 12, 2, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(195, 15, 3, 10, 1, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(196, 15, 3, 10, 2, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(197, 15, 3, 11, 1, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(198, 15, 3, 11, 2, 0.09, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(199, 15, 3, 12, 1, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40'),
(200, 15, 3, 12, 2, 9.00, 2025, '2025-11-30 10:01:40', '2025-11-30 10:01:40');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_khuyen_khich`
--

CREATE TABLE `diem_khuyen_khich` (
  `iddiemkk` int(11) NOT NULL,
  `idnguoidung` bigint(20) UNSIGNED NOT NULL COMMENT 'ID người dùng (học sinh)',
  `loai_kk` varchar(100) DEFAULT NULL COMMENT 'Loại khuyến khích (VD: Giải thưởng, Chứng chỉ, v.v.)',
  `diem_kk` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm khuyến khích (0.00 - 10.00)',
  `mo_ta` text DEFAULT NULL COMMENT 'Mô tả chi tiết',
  `nam_ap_dung` int(4) DEFAULT 2025 COMMENT 'Năm áp dụng',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu điểm khuyến khích';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_mon_hoc_tot_nghiep`
--

CREATE TABLE `diem_mon_hoc_tot_nghiep` (
  `iddiemmon` int(11) NOT NULL,
  `idnguoidung` bigint(20) UNSIGNED NOT NULL COMMENT 'ID người dùng (học sinh)',
  `idmonhoc` int(11) NOT NULL COMMENT 'ID môn học',
  `lop` tinyint(2) NOT NULL COMMENT 'Lớp (10, 11, 12)',
  `diem_trung_binh` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm trung bình cả năm (0.00 - 10.00)',
  `nam_hoc` int(4) DEFAULT NULL COMMENT 'Năm học',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu điểm môn học cho tính điểm tốt nghiệp';

--
-- Đang đổ dữ liệu cho bảng `diem_mon_hoc_tot_nghiep`
--

INSERT INTO `diem_mon_hoc_tot_nghiep` (`iddiemmon`, `idnguoidung`, `idmonhoc`, `lop`, `diem_trung_binh`, `nam_hoc`, `created_at`, `updated_at`) VALUES
(559, 33, 2, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(560, 33, 2, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(561, 33, 2, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(562, 33, 1, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(563, 33, 1, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(564, 33, 1, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(565, 33, 3, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(566, 33, 3, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(567, 33, 3, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(568, 33, 12, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(569, 33, 12, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(570, 33, 12, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(571, 33, 4, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(572, 33, 4, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(573, 33, 4, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(574, 33, 8, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(575, 33, 8, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(576, 33, 8, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(577, 33, 9, 10, 9.00, 2023, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(578, 33, 9, 11, 9.00, 2024, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(579, 33, 9, 12, 9.00, 2025, '2025-11-30 21:13:53', '2025-11-30 21:13:53'),
(634, 15, 2, 10, 1.90, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(635, 15, 2, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(636, 15, 2, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(637, 15, 1, 10, 9.00, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(638, 15, 1, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(639, 15, 1, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(640, 15, 12, 10, 9.00, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(641, 15, 12, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(642, 15, 12, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(643, 15, 4, 10, 9.00, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(644, 15, 4, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(645, 15, 4, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(646, 15, 8, 10, 9.00, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(647, 15, 8, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(648, 15, 8, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(649, 15, 9, 10, 9.00, 2023, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(650, 15, 9, 11, 9.00, 2024, '2025-11-30 21:40:14', '2025-11-30 21:40:14'),
(651, 15, 9, 12, 9.00, 2025, '2025-11-30 21:40:14', '2025-11-30 21:40:14');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `diem_thi_tot_nghiep`
--

CREATE TABLE `diem_thi_tot_nghiep` (
  `iddiemthi` int(11) NOT NULL,
  `idnguoidung` bigint(20) UNSIGNED NOT NULL COMMENT 'ID người dùng (học sinh)',
  `idmonthi` int(11) NOT NULL COMMENT 'ID môn thi',
  `diem_thi` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm thi (0.00 - 10.00)',
  `mien_thi` tinyint(1) DEFAULT 0 COMMENT '1: Miễn thi, 0: Không miễn thi',
  `nam_thi` int(4) DEFAULT 2025 COMMENT 'Năm thi tốt nghiệp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu điểm thi tốt nghiệp THPT';

--
-- Đang đổ dữ liệu cho bảng `diem_thi_tot_nghiep`
--

INSERT INTO `diem_thi_tot_nghiep` (`iddiemthi`, `idnguoidung`, `idmonthi`, `diem_thi`, `mien_thi`, `nam_thi`, `created_at`, `updated_at`) VALUES
(11, 5, 1, 7.20, 0, 2025, '2025-11-30 10:39:49', '2025-11-30 10:39:49'),
(12, 5, 2, 8.20, 0, 2025, '2025-11-30 10:39:49', '2025-11-30 10:39:49'),
(13, 5, 3, 8.20, 0, 2025, '2025-11-30 10:39:49', '2025-11-30 10:39:49'),
(14, 5, 4, 7.50, 0, 2025, '2025-11-30 10:39:49', '2025-11-30 10:39:49'),
(15, 5, 5, 9.10, 0, 2025, '2025-11-30 10:39:49', '2025-11-30 10:39:49'),
(112, 33, 1, 1.01, 0, 2025, '2025-11-30 21:13:51', '2025-11-30 21:13:51'),
(113, 33, 2, 1.00, 0, 2025, '2025-11-30 21:13:51', '2025-11-30 21:13:51'),
(114, 33, 4, 1.01, 0, 2025, '2025-11-30 21:13:51', '2025-11-30 21:13:51'),
(115, 33, 5, 1.01, 0, 2025, '2025-11-30 21:13:51', '2025-11-30 21:13:51'),
(128, 15, 1, 1.01, 0, 2025, '2025-11-30 21:40:12', '2025-11-30 21:40:12'),
(129, 15, 2, 1.01, 0, 2025, '2025-11-30 21:40:12', '2025-11-30 21:40:12'),
(130, 15, 4, 1.01, 0, 2025, '2025-11-30 21:40:12', '2025-11-30 21:40:12'),
(131, 15, 5, 1.01, 0, 2025, '2025-11-30 21:40:12', '2025-11-30 21:40:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `dieukien_tuyensinh`
--

CREATE TABLE `dieukien_tuyensinh` (
  `id` bigint(20) NOT NULL,
  `idtruong` int(11) NOT NULL,
  `manganh` varchar(20) NOT NULL,
  `idxettuyen` int(11) NOT NULL,
  `nam` smallint(6) NOT NULL,
  `ielts_min` decimal(3,1) DEFAULT NULL,
  `chungchi_khac` varchar(255) DEFAULT NULL,
  `mon_batbuoc` varchar(255) DEFAULT NULL,
  `ghichu` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `dieukien_tuyensinh`
--

INSERT INTO `dieukien_tuyensinh` (`id`, `idtruong`, `manganh`, `idxettuyen`, `nam`, `ielts_min`, `chungchi_khac`, `mon_batbuoc`, `ghichu`, `created_at`, `updated_at`) VALUES
(1, 27, '7140209', 4, 2024, 6.0, 'SAT >= 1100 hoặc MOS >= 750', 'Toán; Vật lý hoặc Tin', 'Kết hợp chứng chỉ quốc tế', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(2, 27, '7340403', 4, 2024, 6.0, 'SAT >= 1100 hoặc MOS >= 750', 'Toán; Tin học quản trị', 'Ưu tiên chứng chỉ CNTT', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(3, 27, '7310106', 4, 2024, 6.0, 'Chứng chỉ Data/AI (Coursera, Google DA)', 'Toán; Xác suất-Thống kê', 'Nộp portfolio học thuật', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(4, 27, '7480103', 4, 2024, 6.0, 'CCNA/Network+ hoặc SAT >= 1100', 'Toán; Vật lý; Tin', 'Ưu tiên có CCNA/Net+', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(5, 27, '7480104', 4, 2024, 6.0, 'CEH/SEC+ hoặc SAT >= 1100', 'Toán; Tin; Ngoại ngữ', 'Ưu tiên có CEH/SEC+', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(6, 27, '7520114', 4, 2024, 6.0, 'Chứng chỉ IoT/Embedded (ARM, Arduino)', 'Toán; Vật lý; Tin', 'Có dự án nhúng là lợi thế', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(7, 27, '7520120', 4, 2024, 6.0, 'Chứng chỉ PLC/Automation (Siemens)', 'Toán; Vật lý; Tin', 'Ưu tiên có PLC cơ bản', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(8, 27, '7520201', 4, 2024, 6.0, 'Chứng chỉ vật liệu/3D Printing', 'Toán; Hóa; Lý', 'Ưu tiên có bài thi học thuật', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(9, 27, '7520320', 4, 2024, 6.0, 'Chứng chỉ CAD/CAM (Autodesk, SolidWorks)', 'Toán; Vật lý; Tin', 'Có portfolio CAD/CAM', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(10, 27, '7220201', 4, 2024, 5.5, 'IELTS Writing >= 5.5 hoặc SAT >= 1100', 'Ngữ văn; Toán; Tiếng Anh', 'Ưu tiên chứng chỉ tiếng Anh', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(11, 27, '7340301', 4, 2024, 5.5, 'Chứng chỉ kế toán (MOS/Excel >= 750)', 'Toán; Tin; Anh', 'Yêu cầu Excel thành thạo', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(12, 27, '7340115', 4, 2024, 5.5, 'IELTS >= 5.5 hoặc chứng chỉ ngoại giao', 'Ngữ văn; Anh; Sử/Địa', 'Ưu tiên hoạt động đối ngoại', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(13, 27, '7340123', 4, 2024, 5.5, 'Chứng chỉ kiểm toán/ACCA F1', 'Toán; Anh; Tin', 'Ưu tiên ACCA/FIA', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(14, 27, '7340127', 4, 2024, 5.5, 'Chứng chỉ HTTT kế toán/Excel chuyên sâu', 'Toán; Anh; Tin', 'Cần biết Excel nâng cao', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(15, 27, '7340404', 4, 2024, 5.5, 'Chứng chỉ tài chính (CFA Research Challenge)', 'Toán; Anh; Kinh tế', 'Ưu tiên có dự án tài chính', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(16, 27, '7210403', 4, 2024, 5.5, 'Chứng chỉ Media/Design (Adobe, UI/UX)', 'Ngữ văn; Anh', 'Nộp portfolio sáng tạo', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(17, 27, '7580201', 4, 2024, 5.5, 'Chứng chỉ vẽ/portfolio kiến trúc', 'Toán; Vẽ hình; Anh', 'Yêu cầu portfolio cơ bản', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(18, 27, '7510601', 4, 2024, 5.5, 'Chứng chỉ Lab/Bio (PCR, ELISA)', 'Toán; Hóa; Sinh', 'Ưu tiên có lab note', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(19, 27, '7440301', 4, 2024, 5.5, 'Chứng chỉ thí nghiệm Hóa/An toàn PTN', 'Toán; Hóa; Lý', 'Tuân thủ an toàn PTN', '2025-10-15 16:53:38', '2025-10-15 16:53:38'),
(20, 27, '7380101', 4, 2024, 5.5, 'IELTS >= 5.5 hoặc chứng chỉ pháp lý học thuật', 'Ngữ văn; Sử; Địa/Anh', 'Ưu tiên bài luận pháp lý', '2025-10-15 16:53:38', '2025-10-15 16:53:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `doi_tuong_uu_tien`
--

CREATE TABLE `doi_tuong_uu_tien` (
  `iddoituong` int(11) NOT NULL,
  `ma_doi_tuong` varchar(20) NOT NULL COMMENT 'Mã đối tượng (VD: DT01, DT02)',
  `ten_doi_tuong` varchar(255) NOT NULL COMMENT 'Tên đối tượng ưu tiên',
  `mo_ta` text DEFAULT NULL COMMENT 'Mô tả đối tượng',
  `diem_uu_tien` decimal(4,2) DEFAULT 0.00 COMMENT 'Mức điểm ưu tiên (theo quy định)',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục đối tượng ưu tiên';

--
-- Đang đổ dữ liệu cho bảng `doi_tuong_uu_tien`
--

INSERT INTO `doi_tuong_uu_tien` (`iddoituong`, `ma_doi_tuong`, `ten_doi_tuong`, `mo_ta`, `diem_uu_tien`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 'DT01', 'Con liệt sĩ', 'Con của liệt sĩ', 0.50, 1, NULL, NULL),
(2, 'DT02', 'Con thương binh, bệnh binh', 'Con của thương binh, bệnh binh mất sức lao động từ 81% trở lên', 0.50, 1, NULL, NULL),
(3, 'DT03', 'Con của người được cấp \"Giấy chứng nhận người hưởng chính sách như thương binh\"', 'Con của người được cấp \"Giấy chứng nhận người hưởng chính sách như thương binh\"', 0.50, 1, NULL, NULL),
(4, 'DT04', 'Anh hùng Lực lượng vũ trang nhân dân, Anh hùng Lao động', 'Anh hùng Lực lượng vũ trang nhân dân, Anh hùng Lao động', 0.50, 1, NULL, NULL),
(5, 'DT05', 'Người dân tộc thiểu số', 'Người dân tộc thiểu số', 0.25, 1, NULL, NULL),
(6, 'DT06', 'Người khuyết tật', 'Người khuyết tật', 0.25, 1, NULL, NULL),
(7, 'DT07', 'Không thuộc đối tượng ưu tiên', 'Không thuộc đối tượng ưu tiên', 0.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `file_de_an_tuyen_sinh`
--

CREATE TABLE `file_de_an_tuyen_sinh` (
  `idfile` bigint(20) UNSIGNED NOT NULL,
  `idde_an` bigint(20) UNSIGNED NOT NULL,
  `ten_file` varchar(500) NOT NULL,
  `duong_dan` varchar(500) NOT NULL,
  `loai_file` varchar(50) DEFAULT 'PDF' COMMENT 'PDF, DOC, DOCX',
  `kich_thuoc` bigint(20) DEFAULT NULL COMMENT 'Kích thước file (bytes)',
  `trang_thai` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `file_de_an_tuyen_sinh`
--

INSERT INTO `file_de_an_tuyen_sinh` (`idfile`, `idde_an`, `ten_file`, `duong_dan`, `loai_file`, `kich_thuoc`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 1, 'https://images.tuyensinh247.com/picture/2024/0422/ts-dh-cong-nghiep-tphcm.pdf', 'https://images.tuyensinh247.com/picture/2024/0422/ts-dh-cong-nghiep-tphcm.pdf', 'PDF', 5242880, 1, '2025-12-01 08:21:03', '2025-12-01 08:21:03'),
(2, 1, 'Huong_dan_nop_ho_so_IUH_2025.pdf', 'https://images.tuyensinh247.com/picture/2024/0422/ts-dh-cong-nghiep-tphcm.pdf', 'PDF', 2097152, 1, '2025-12-01 08:21:03', '2025-12-01 08:21:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ghi_chu_buoituvan`
--

CREATE TABLE `ghi_chu_buoituvan` (
  `id_ghichu` int(11) NOT NULL,
  `id_lichtuvan` int(11) NOT NULL,
  `id_tuvanvien` int(11) NOT NULL,
  `noi_dung` longtext NOT NULL,
  `ket_luan_nganh` varchar(255) DEFAULT NULL,
  `muc_quan_tam` tinyint(4) DEFAULT NULL,
  `diem_du_kien` decimal(4,2) DEFAULT NULL,
  `yeu_cau_bo_sung` varchar(255) DEFAULT NULL,
  `chia_se_voi_thisinh` tinyint(1) NOT NULL DEFAULT 0,
  `trang_thai` enum('NHAP','CHOT') NOT NULL DEFAULT 'NHAP',
  `is_chot` tinyint(4) GENERATED ALWAYS AS (`trang_thai` = 'CHOT') STORED,
  `thoi_han_sua_den` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `ghi_chu_buoituvan`
--

INSERT INTO `ghi_chu_buoituvan` (`id_ghichu`, `id_lichtuvan`, `id_tuvanvien`, `noi_dung`, `ket_luan_nganh`, `muc_quan_tam`, `diem_du_kien`, `yeu_cau_bo_sung`, `chia_se_voi_thisinh`, `trang_thai`, `thoi_han_sua_den`, `created_at`, `updated_at`, `deleted_at`) VALUES
(7, 57, 5, 'fddfd', 'Khác', 3, 12.00, 'ds', 0, 'NHAP', NULL, '2025-11-08 05:24:59', '2025-11-08 05:24:59', NULL),
(8, 55, 5, 'sdfder', 'CNTT', 3, 12.00, 'fd', 0, 'NHAP', NULL, '2025-11-08 05:34:56', '2025-11-08 05:34:56', NULL),
(9, 46, 5, 'cgfgfgf122323', NULL, 3, 25.00, 'fefd', 0, 'NHAP', NULL, '2025-11-29 08:45:36', '2025-11-29 08:45:36', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `gioi_thieu_truong`
--

CREATE TABLE `gioi_thieu_truong` (
  `idgioi_thieu` bigint(20) UNSIGNED NOT NULL,
  `idtruong` int(11) NOT NULL,
  `ten_tieng_anh` varchar(200) DEFAULT NULL COMMENT 'Tên tiếng Anh của trường',
  `ma_truong` varchar(20) DEFAULT NULL COMMENT 'Mã trường (VD: KHA)',
  `ten_viet_tat` varchar(50) DEFAULT NULL COMMENT 'Tên viết tắt (VD: NEU)',
  `dia_chi_day_du` text DEFAULT NULL COMMENT 'Địa chỉ đầy đủ',
  `website` varchar(200) DEFAULT NULL,
  `lich_su` longtext DEFAULT NULL COMMENT 'Lịch sử hình thành và phát triển',
  `su_menh` longtext DEFAULT NULL COMMENT 'Sứ mệnh của trường',
  `thanh_tuu` longtext DEFAULT NULL COMMENT 'Thành tựu và đóng góp',
  `quan_he_quoc_te` longtext DEFAULT NULL COMMENT 'Quan hệ quốc tế',
  `tam_nhin` longtext DEFAULT NULL COMMENT 'Tầm nhìn (VD: Vision 2030)',
  `anh_dai_dien` varchar(500) DEFAULT NULL COMMENT 'Đường dẫn ảnh đại diện trường',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `gioi_thieu_truong`
--

INSERT INTO `gioi_thieu_truong` (`idgioi_thieu`, `idtruong`, `ten_tieng_anh`, `ma_truong`, `ten_viet_tat`, `dia_chi_day_du`, `website`, `lich_su`, `su_menh`, `thanh_tuu`, `quan_he_quoc_te`, `tam_nhin`, `anh_dai_dien`, `created_at`, `updated_at`) VALUES
(1, 21, 'Industrial University of Ho Chi Minh City', 'IUH', 'IUH', '12 Nguyễn Văn Bảo, Phường 4, Quận Gò Vấp, TP. Hồ Chí Minh', 'http://www.iuh.edu.vn', 'Trường Đại học Công nghiệp TP. Hồ Chí Minh (IUH) được thành lập năm 2004 trên cơ sở nâng cấp từ Trường Cao đẳng Công nghiệp TP. Hồ Chí Minh (thành lập năm 1999). Trường là một trong những trường đại học công lập hàng đầu tại miền Nam, chuyên đào tạo nguồn nhân lực chất lượng cao cho các ngành công nghiệp, kinh tế và kỹ thuật.', 'Sứ mệnh của Trường Đại học Công nghiệp TP. Hồ Chí Minh là đào tạo nguồn nhân lực chất lượng cao, có kiến thức chuyên môn vững vàng, kỹ năng thực hành tốt, đáp ứng nhu cầu phát triển kinh tế - xã hội của đất nước và hội nhập quốc tế.', 'Trường đã đào tạo hàng chục nghìn kỹ sư, cử nhân chất lượng cao, được các doanh nghiệp đánh giá cao. Nhiều sinh viên tốt nghiệp đã trở thành lãnh đạo, chuyên gia trong các doanh nghiệp, tổ chức trong và ngoài nước. Trường có nhiều đề tài nghiên cứu khoa học được ứng dụng vào thực tế, góp phần phát triển công nghiệp và kinh tế.', 'Trường có quan hệ hợp tác với nhiều trường đại học, tổ chức quốc tế tại các nước như Nhật Bản, Hàn Quốc, Đức, Pháp, Mỹ, Úc... Sinh viên có nhiều cơ hội tham gia các chương trình trao đổi, thực tập tại nước ngoài.', 'Tầm nhìn đến năm 2030: Trở thành trường đại học công nghiệp hàng đầu Việt Nam, có uy tín trong khu vực, đào tạo nguồn nhân lực chất lượng cao, đáp ứng yêu cầu của cuộc cách mạng công nghiệp 4.0.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764493609/consultants/avatars/consultant_1764493593_692c091941041.jpg', '2025-12-01 08:21:25', '2025-12-01 08:21:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `hosothanhvien`
--

CREATE TABLE `hosothanhvien` (
  `idhoso` int(11) NOT NULL,
  `idnguoidung` int(11) DEFAULT NULL,
  `namtotnghiep` year(4) DEFAULT NULL,
  `truongthpt` varchar(200) DEFAULT NULL,
  `loaihinhdaotao` varchar(100) DEFAULT NULL,
  `khuvucuutien` varchar(100) DEFAULT NULL,
  `doituonguutien` varchar(100) DEFAULT NULL,
  `ma_to_hop` varchar(10) NOT NULL,
  `diemmon1` decimal(4,2) DEFAULT NULL,
  `diemmon2` decimal(4,2) DEFAULT NULL,
  `diemmon3` decimal(4,2) DEFAULT NULL,
  `diemutien` decimal(4,2) DEFAULT NULL,
  `tongdiem` decimal(4,2) DEFAULT NULL,
  `minhchung` text DEFAULT NULL,
  `trangthai` varchar(50) DEFAULT 'Chờ duyệt',
  `ngaylap` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ho_so_xet_tuyen`
--

CREATE TABLE `ho_so_xet_tuyen` (
  `idho_so` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `loai_ho_so` varchar(50) NOT NULL COMMENT 'CHUNG, THEO_DOI_TUONG, THEO_KHU_VUC',
  `noi_dung` text NOT NULL COMMENT 'Nội dung yêu cầu hồ sơ',
  `thu_tu` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `ho_so_xet_tuyen`
--

INSERT INTO `ho_so_xet_tuyen` (`idho_so`, `idphuong_thuc_chi_tiet`, `loai_ho_so`, `noi_dung`, `thu_tu`, `created_at`, `updated_at`) VALUES
(7, 1, 'CHUNG', '1. Phiếu đăng ký xét tuyển (theo mẫu của trường)\r\n2. Bản sao công chứng bằng tốt nghiệp THPT hoặc giấy chứng nhận tốt nghiệp tạm thời\r\n3. Bản sao công chứng học bạ THPT\r\n4. Bản sao công chứng giấy chứng minh nhân dân/căn cước công dân\r\n5. Ảnh 3x4 (2 ảnh, ghi rõ họ tên, ngày sinh ở mặt sau)\r\n6. Giấy chứng nhận ưu tiên (nếu có)\r\n7. Phong bì có dán tem, ghi rõ địa chỉ người nhận để trường gửi giấy báo trúng tuyển', 1, '2025-12-01 05:58:08', '2025-12-01 05:58:08'),
(8, 2, 'CHUNG', '1. Phiếu đăng ký xét tuyển bằng học bạ (theo mẫu của trường)\r\n2. Bản sao công chứng học bạ THPT (đầy đủ 3 năm lớp 10, 11, 12)\r\n3. Bản sao công chứng giấy chứng minh nhân dân/căn cước công dân\r\n4. Ảnh 3x4 (2 ảnh)\r\n5. Giấy chứng nhận ưu tiên (nếu có)\r\n6. Phong bì có dán tem', 1, '2025-12-01 05:58:08', '2025-12-01 05:58:08'),
(9, 4, 'CHUNG', '1. Phiếu đăng ký xét tuyển thẳng (theo mẫu của trường)\r\n2. Bản sao công chứng bằng tốt nghiệp THPT\r\n3. Bản sao công chứng học bạ THPT\r\n4. Bản sao công chứng giấy chứng minh nhân dân/căn cước công dân\r\n5. Bản sao công chứng giấy chứng nhận đạt giải (nếu xét tuyển thẳng theo giải thưởng)\r\n6. Bản sao công chứng chứng chỉ quốc tế (IELTS, TOEFL, SAT, ACT - nếu có)\r\n7. Ảnh 3x4 (2 ảnh)\r\n8. Phong bì có dán tem', 1, '2025-12-01 05:58:08', '2025-12-01 05:58:08');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ketquatuvan`
--

CREATE TABLE `ketquatuvan` (
  `idketquatuvan` int(11) NOT NULL,
  `idlichtuvan` int(11) DEFAULT NULL,
  `tieude` varchar(255) DEFAULT NULL,
  `tomtatnoidungtuvan` text DEFAULT NULL,
  `cacnganhkhuyennghi` text DEFAULT NULL,
  `cacbuoccanlam` text DEFAULT NULL,
  `loctheoyeucau` text DEFAULT NULL,
  `ghichuketquatuvan` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ket_qua_tinh_diem_hoc_ba`
--

CREATE TABLE `ket_qua_tinh_diem_hoc_ba` (
  `idketqua` int(11) NOT NULL,
  `idnguoidung` bigint(20) UNSIGNED NOT NULL COMMENT 'ID người dùng (học sinh)',
  `idphuongthuc_hb` int(11) NOT NULL COMMENT 'ID phương thức xét học bạ',
  `idthongtin` int(11) DEFAULT NULL COMMENT 'ID thông tin tuyển sinh (ngành/trường)',
  `tohopmon` varchar(200) DEFAULT NULL COMMENT 'Tổ hợp môn xét tuyển',
  `mon_nhan_he_so_2` int(11) DEFAULT NULL COMMENT 'ID môn nhân hệ số 2 (nếu có)',
  `iddoituong` int(11) DEFAULT NULL COMMENT 'ID đối tượng ưu tiên',
  `idkhuvuc` int(11) DEFAULT NULL COMMENT 'ID khu vực ưu tiên',
  `diem_to_hop` decimal(5,2) DEFAULT 0.00 COMMENT 'Điểm tổ hợp môn (chưa cộng ưu tiên)',
  `diem_uu_tien_doi_tuong` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm ưu tiên đối tượng',
  `diem_uu_tien_khu_vuc` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm ưu tiên khu vực',
  `tong_diem_uu_tien` decimal(4,2) DEFAULT 0.00 COMMENT 'Tổng điểm ưu tiên (sau khi áp dụng công thức)',
  `tong_diem_xet_tuyen` decimal(5,2) DEFAULT 0.00 COMMENT 'Tổng điểm xét tuyển (điểm tổ hợp + điểm ưu tiên)',
  `chi_tiet_tinh_toan` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Chi tiết tính toán (lưu dạng JSON)' CHECK (json_valid(`chi_tiet_tinh_toan`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng kết quả tính điểm xét tuyển học bạ';

--
-- Đang đổ dữ liệu cho bảng `ket_qua_tinh_diem_hoc_ba`
--

INSERT INTO `ket_qua_tinh_diem_hoc_ba` (`idketqua`, `idnguoidung`, `idphuongthuc_hb`, `idthongtin`, `tohopmon`, `mon_nhan_he_so_2`, `iddoituong`, `idkhuvuc`, `diem_to_hop`, `diem_uu_tien_doi_tuong`, `diem_uu_tien_khu_vuc`, `tong_diem_uu_tien`, `tong_diem_xet_tuyen`, `chi_tiet_tinh_toan`, `created_at`, `updated_at`) VALUES
(1, 15, 1, NULL, 'TOAN;LI;HOA', NULL, 4, 1, 27.00, 0.50, 0.75, 0.50, 27.50, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:35:00', '2025-11-30 09:35:00'),
(2, 15, 1, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:04', '2025-11-30 09:45:04'),
(3, 15, 1, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:07', '2025-11-30 09:45:07'),
(4, 15, 1, NULL, 'TOAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:08', '2025-11-30 09:45:08'),
(5, 15, 1, NULL, 'VAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:10', '2025-11-30 09:45:10'),
(6, 15, 1, NULL, 'VAN;TOAN;LI', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;LI\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:17', '2025-11-30 09:45:17'),
(7, 15, 1, NULL, 'VAN;TOAN;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:19', '2025-11-30 09:45:19'),
(8, 15, 1, NULL, 'VAN;TOAN;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:21', '2025-11-30 09:45:21'),
(9, 15, 1, NULL, 'VAN;TOAN;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:23', '2025-11-30 09:45:23'),
(10, 15, 1, NULL, 'VAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:25', '2025-11-30 09:45:25'),
(11, 15, 1, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:30', '2025-11-30 09:45:30'),
(12, 15, 1, NULL, 'TOAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:34', '2025-11-30 09:45:34'),
(13, 15, 1, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:37', '2025-11-30 09:45:37'),
(14, 15, 1, NULL, 'TOAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:39', '2025-11-30 09:45:39'),
(15, 15, 1, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:41', '2025-11-30 09:45:41'),
(16, 15, 1, NULL, 'VAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:43', '2025-11-30 09:45:43'),
(17, 15, 1, NULL, 'VAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:46', '2025-11-30 09:45:46'),
(18, 15, 1, NULL, 'VAN;SU;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SU;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:49', '2025-11-30 09:45:49'),
(19, 15, 1, NULL, 'VAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:45:54', '2025-11-30 09:45:54'),
(20, 15, 1, NULL, 'TOAN;LI;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:46:00', '2025-11-30 09:46:00'),
(21, 15, 1, NULL, 'TOAN;LI;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:46:01', '2025-11-30 09:46:01'),
(22, 15, 1, NULL, 'TOAN;HOA;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:46:12', '2025-11-30 09:46:12'),
(23, 15, 1, NULL, 'TOAN;HOA;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:46:21', '2025-11-30 09:46:21'),
(24, 15, 1, NULL, 'TOAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:46:39', '2025-11-30 09:46:39'),
(25, 15, 1, NULL, 'TOAN;SINH;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:47:05', '2025-11-30 09:47:05'),
(26, 15, 1, NULL, 'TOAN;SINH;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:47:19', '2025-11-30 09:47:19'),
(27, 15, 1, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:47:32', '2025-11-30 09:47:32'),
(28, 15, 1, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:47:42', '2025-11-30 09:47:42'),
(29, 15, 1, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:44', '2025-11-30 09:48:44'),
(30, 15, 1, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:45', '2025-11-30 09:48:45'),
(31, 15, 1, NULL, 'TOAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:45', '2025-11-30 09:48:45'),
(32, 15, 1, NULL, 'VAN;SU;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:46', '2025-11-30 09:48:46'),
(33, 15, 1, NULL, 'VAN;TOAN;LI', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;LI\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:47', '2025-11-30 09:48:47'),
(34, 15, 1, NULL, 'VAN;TOAN;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:47', '2025-11-30 09:48:47'),
(35, 15, 1, NULL, 'VAN;TOAN;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:48', '2025-11-30 09:48:48'),
(36, 15, 1, NULL, 'VAN;TOAN;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;TOAN;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:49', '2025-11-30 09:48:49'),
(37, 15, 1, NULL, 'VAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:50', '2025-11-30 09:48:50'),
(38, 15, 1, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:51', '2025-11-30 09:48:51'),
(39, 15, 1, NULL, 'TOAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:51', '2025-11-30 09:48:51'),
(40, 15, 1, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:52', '2025-11-30 09:48:52'),
(41, 15, 1, NULL, 'TOAN;DIA;ANH', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:53', '2025-11-30 09:48:53'),
(42, 15, 1, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:53', '2025-11-30 09:48:53'),
(43, 15, 1, NULL, 'VAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:54', '2025-11-30 09:48:54'),
(44, 15, 1, NULL, 'VAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:55', '2025-11-30 09:48:55'),
(45, 15, 1, NULL, 'VAN;SU;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;SU;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:56', '2025-11-30 09:48:56'),
(46, 15, 1, NULL, 'VAN;DIA;ANH', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"VAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:56', '2025-11-30 09:48:56'),
(47, 15, 1, NULL, 'TOAN;LI;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:57', '2025-11-30 09:48:57'),
(48, 15, 1, NULL, 'TOAN;LI;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:58', '2025-11-30 09:48:58'),
(49, 15, 1, NULL, 'TOAN;HOA;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:59', '2025-11-30 09:48:59'),
(50, 15, 1, NULL, 'TOAN;HOA;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;HOA;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:48:59', '2025-11-30 09:48:59'),
(51, 15, 1, NULL, 'TOAN;SU;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:00', '2025-11-30 09:49:00'),
(52, 15, 1, NULL, 'TOAN;SINH;DIA', NULL, NULL, NULL, 26.67, 0.00, 0.00, 0.00, 26.67, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":26.67,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:01', '2025-11-30 09:49:01'),
(53, 15, 1, NULL, 'TOAN;SINH;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:01', '2025-11-30 09:49:01'),
(54, 15, 1, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:02', '2025-11-30 09:49:02'),
(55, 15, 1, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:06', '2025-11-30 09:49:06'),
(56, 15, 2, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:46', '2025-11-30 09:49:46'),
(57, 15, 2, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:47', '2025-11-30 09:49:47'),
(58, 15, 2, NULL, 'TOAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:48', '2025-11-30 09:49:48'),
(59, 15, 2, NULL, 'VAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:49', '2025-11-30 09:49:49'),
(60, 15, 2, NULL, 'VAN;TOAN;LI', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;LI\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:50', '2025-11-30 09:49:50'),
(61, 15, 2, NULL, 'VAN;TOAN;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:50', '2025-11-30 09:49:50'),
(62, 15, 2, NULL, 'VAN;TOAN;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:51', '2025-11-30 09:49:51'),
(63, 15, 2, NULL, 'VAN;TOAN;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:52', '2025-11-30 09:49:52'),
(64, 15, 2, NULL, 'VAN;HOA;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;HOA;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:53', '2025-11-30 09:49:53'),
(65, 15, 2, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:53', '2025-11-30 09:49:53'),
(66, 15, 2, NULL, 'TOAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:54', '2025-11-30 09:49:54'),
(67, 15, 2, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:55', '2025-11-30 09:49:55'),
(68, 15, 2, NULL, 'TOAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:55', '2025-11-30 09:49:55'),
(69, 15, 2, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:56', '2025-11-30 09:49:56'),
(70, 15, 2, NULL, 'VAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:57', '2025-11-30 09:49:57'),
(71, 15, 2, NULL, 'VAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:57', '2025-11-30 09:49:57'),
(72, 15, 2, NULL, 'VAN;SU;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;SU;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:58', '2025-11-30 09:49:58'),
(73, 15, 2, NULL, 'VAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:49:59', '2025-11-30 09:49:59'),
(74, 15, 2, NULL, 'TOAN;LI;SINH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;SINH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:00', '2025-11-30 09:50:00'),
(75, 15, 2, NULL, 'TOAN;LI;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:00', '2025-11-30 09:50:00'),
(76, 15, 2, NULL, 'TOAN;HOA;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:00', '2025-11-30 09:50:00'),
(77, 15, 2, NULL, 'TOAN;HOA;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:01', '2025-11-30 09:50:01'),
(78, 15, 2, NULL, 'TOAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:02', '2025-11-30 09:50:02'),
(79, 15, 2, NULL, 'TOAN;SINH;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SINH;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:03', '2025-11-30 09:50:03'),
(80, 15, 2, NULL, 'TOAN;SINH;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SINH;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:03', '2025-11-30 09:50:03'),
(81, 15, 2, NULL, 'TOAN;SINH;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SINH;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:04', '2025-11-30 09:50:04'),
(82, 15, 2, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:50:08', '2025-11-30 09:50:08'),
(83, 15, 2, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:51', '2025-11-30 09:51:51'),
(84, 15, 2, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:52', '2025-11-30 09:51:52'),
(85, 15, 2, NULL, 'VAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:53', '2025-11-30 09:51:53'),
(86, 15, 2, NULL, 'VAN;TOAN;LI', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;LI\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:54', '2025-11-30 09:51:54'),
(87, 15, 2, NULL, 'VAN;TOAN;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:55', '2025-11-30 09:51:55'),
(88, 15, 2, NULL, 'VAN;TOAN;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;TOAN;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:56', '2025-11-30 09:51:56'),
(89, 15, 2, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:56', '2025-11-30 09:51:56'),
(90, 15, 2, NULL, 'TOAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:57', '2025-11-30 09:51:57'),
(91, 15, 2, NULL, 'TOAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:58', '2025-11-30 09:51:58'),
(92, 15, 2, NULL, 'TOAN;LI;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:58', '2025-11-30 09:51:58'),
(93, 15, 2, NULL, 'VAN;HOA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;HOA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:59', '2025-11-30 09:51:59'),
(94, 15, 2, NULL, 'VAN;SU;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;SU;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:51:59', '2025-11-30 09:51:59'),
(95, 15, 2, NULL, 'VAN;DIA;ANH', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"VAN;DIA;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:00', '2025-11-30 09:52:00'),
(96, 15, 2, NULL, 'TOAN;LI;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:01', '2025-11-30 09:52:01'),
(97, 15, 2, NULL, 'TOAN;HOA;SU', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;SU\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:01', '2025-11-30 09:52:01'),
(98, 15, 2, NULL, 'TOAN;HOA;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;HOA;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:02', '2025-11-30 09:52:02'),
(99, 15, 2, NULL, 'TOAN;SU;DIA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;SU;DIA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:02', '2025-11-30 09:52:02'),
(100, 15, 2, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 c\\u1ea3 n\\u0103m l\\u1edbp 12\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:52:05', '2025-11-30 09:52:05'),
(101, 15, 1, NULL, 'TOAN;LI;HOA', NULL, NULL, NULL, 27.00, 0.00, 0.00, 0.00, 27.00, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 3 n\\u0103m\",\"to_hop_mon\":\"TOAN;LI;HOA\",\"diem_chi_tiet\":{\"diem_to_hop\":27,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":true}}', '2025-11-30 09:54:54', '2025-11-30 09:54:54'),
(102, 15, 3, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 21.18, 0.00, 0.00, 0.00, 21.18, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 6 h\\u1ecdc k\\u1ef3\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":21.18,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":false}}', '2025-11-30 10:01:04', '2025-11-30 10:01:04'),
(103, 15, 3, NULL, 'TOAN;VAN;ANH', NULL, 1, NULL, 21.18, 0.50, 0.00, 0.50, 21.68, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 6 h\\u1ecdc k\\u1ef3\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":21.18,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":false}}', '2025-11-30 10:01:17', '2025-11-30 10:01:17'),
(104, 15, 3, NULL, 'TOAN;VAN;ANH', NULL, NULL, NULL, 21.18, 0.00, 0.00, 0.00, 21.18, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 6 h\\u1ecdc k\\u1ef3\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":21.18,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":false}}', '2025-11-30 10:01:30', '2025-11-30 10:01:30'),
(105, 15, 3, NULL, 'TOAN;VAN;ANH', NULL, 2, 3, 21.18, 0.50, 0.25, 0.75, 21.93, '{\"phuong_thuc\":\"X\\u00e9t h\\u1ecdc b\\u1ea1 6 h\\u1ecdc k\\u1ef3\",\"to_hop_mon\":\"TOAN;VAN;ANH\",\"diem_chi_tiet\":{\"diem_to_hop\":21.18,\"nguong_diem\":\"22.50\",\"ap_dung_quy_dinh\":false}}', '2025-11-30 10:01:41', '2025-11-30 10:01:41');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ket_qua_tinh_diem_tot_nghiep`
--

CREATE TABLE `ket_qua_tinh_diem_tot_nghiep` (
  `idketqua` int(11) NOT NULL,
  `idnguoidung` bigint(20) UNSIGNED NOT NULL COMMENT 'ID người dùng (học sinh)',
  `mien_thi_ngoai_ngu` tinyint(1) DEFAULT 0 COMMENT '1: Miễn thi ngoại ngữ, 0: Không miễn',
  `tong_diem_4_mon_thi` decimal(5,2) DEFAULT 0.00 COMMENT 'Tổng điểm 4 môn thi (hoặc 3 môn nếu miễn thi ngoại ngữ)',
  `tong_diem_kk` decimal(4,2) DEFAULT 0.00 COMMENT 'Tổng điểm khuyến khích',
  `diem_tb_lop_10` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm trung bình lớp 10',
  `diem_tb_lop_11` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm trung bình lớp 11',
  `diem_tb_lop_12` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm trung bình lớp 12',
  `dtb_cac_nam_hoc` decimal(4,2) DEFAULT 0.00 COMMENT 'ĐTB các năm học (theo công thức)',
  `diem_uu_tien` decimal(4,2) DEFAULT 0.00 COMMENT 'Điểm ưu tiên',
  `tong_diem_xet_tot_nghiep` decimal(5,2) DEFAULT 0.00 COMMENT 'Tổng điểm xét tốt nghiệp (DXTN)',
  `cong_thuc_ap_dung` varchar(50) DEFAULT NULL COMMENT 'Công thức áp dụng (THUONG hoặc MIEN_THI_NN)',
  `nam_thi` int(4) DEFAULT 2025 COMMENT 'Năm thi tốt nghiệp',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu kết quả tính điểm tốt nghiệp THPT';

--
-- Đang đổ dữ liệu cho bảng `ket_qua_tinh_diem_tot_nghiep`
--

INSERT INTO `ket_qua_tinh_diem_tot_nghiep` (`idketqua`, `idnguoidung`, `mien_thi_ngoai_ngu`, `tong_diem_4_mon_thi`, `tong_diem_kk`, `diem_tb_lop_10`, `diem_tb_lop_11`, `diem_tb_lop_12`, `dtb_cac_nam_hoc`, `diem_uu_tien`, `tong_diem_xet_tot_nghiep`, `cong_thuc_ap_dung`, `nam_thi`, `created_at`, `updated_at`) VALUES
(2, 5, 0, 40.20, 0.00, 0.00, 0.00, 0.00, 0.00, 0.50, 20.60, 'THUONG', 2025, '2025-11-30 10:39:51', '2025-11-30 10:39:51'),
(3, 15, 0, 4.04, 0.00, 7.82, 9.00, 9.00, 8.80, 0.00, 4.91, 'THUONG', 2025, '2025-11-30 10:47:08', '2025-11-30 21:40:17'),
(4, 33, 0, 4.03, 0.00, 9.00, 9.00, 9.00, 9.00, 2.00, 0.00, 'THUONG', 2025, '2025-11-30 20:17:44', '2025-11-30 21:13:56');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `khu_vuc_uu_tien`
--

CREATE TABLE `khu_vuc_uu_tien` (
  `idkhuvuc` int(11) NOT NULL,
  `ma_khu_vuc` varchar(20) NOT NULL COMMENT 'Mã khu vực (VD: KV1, KV2, KV2-NT, KV3)',
  `ten_khu_vuc` varchar(255) NOT NULL COMMENT 'Tên khu vực',
  `mo_ta` text DEFAULT NULL COMMENT 'Mô tả khu vực',
  `diem_uu_tien` decimal(4,2) DEFAULT 0.00 COMMENT 'Mức điểm ưu tiên',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục khu vực ưu tiên';

--
-- Đang đổ dữ liệu cho bảng `khu_vuc_uu_tien`
--

INSERT INTO `khu_vuc_uu_tien` (`idkhuvuc`, `ma_khu_vuc`, `ten_khu_vuc`, `mo_ta`, `diem_uu_tien`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 'KV1', 'Khu vực 1', 'Các xã khu vực I, II, III thuộc vùng dân tộc và miền núi; các xã đặc biệt khó khăn vùng bãi ngang ven biển và hải đảo', 0.75, 1, NULL, NULL),
(2, 'KV2-NT', 'Khu vực 2 nông thôn', 'Các thị xã, thị trấn thuộc huyện; các xã không thuộc KV1', 0.50, 1, NULL, NULL),
(3, 'KV2', 'Khu vực 2', 'Các thị xã, thành phố trực thuộc tỉnh; các thị xã, huyện ngoại thành của thành phố trực thuộc Trung ương', 0.25, 1, NULL, NULL),
(4, 'KV3', 'Khu vực 3', 'Các quận nội thành của thành phố trực thuộc Trung ương', 0.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl`
--

CREATE TABLE `kythi_dgnl` (
  `idkythi` bigint(20) UNSIGNED NOT NULL,
  `makythi` varchar(50) NOT NULL,
  `tenkythi` varchar(255) NOT NULL,
  `to_chuc` varchar(255) NOT NULL,
  `so_cau` smallint(5) UNSIGNED DEFAULT NULL,
  `thoi_luong_phut` smallint(5) UNSIGNED DEFAULT NULL,
  `hinh_thuc` varchar(120) DEFAULT NULL,
  `mo_ta_tong_quat` text DEFAULT NULL,
  `ghi_chu` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl`
--

INSERT INTO `kythi_dgnl` (`idkythi`, `makythi`, `tenkythi`, `to_chuc`, `so_cau`, `thoi_luong_phut`, `hinh_thuc`, `mo_ta_tong_quat`, `ghi_chu`, `created_at`, `updated_at`) VALUES
(1, 'HCM-DGNL', 'Đánh giá năng lực ĐHQG TP.HCM', 'ĐHQG TP.HCM', 120, 150, 'Trắc nghiệm', 'Đánh giá tư duy tổng hợp gồm logic, ngôn ngữ, giải quyết vấn đề và kiến thức KHTN-KHXH. Bài thi 120 câu, thời gian 150 phút, thang điểm 1200.', NULL, '2025-11-26 13:15:37', '2025-12-02 21:26:50');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_attempts`
--

CREATE TABLE `kythi_dgnl_attempts` (
  `idattempt` bigint(20) UNSIGNED NOT NULL,
  `idkythi` bigint(20) UNSIGNED NOT NULL,
  `idnguoidung` int(11) NOT NULL,
  `tong_diem` decimal(6,2) DEFAULT NULL,
  `tong_so_cau` smallint(5) UNSIGNED DEFAULT NULL,
  `tong_cau_dung` smallint(5) UNSIGNED DEFAULT NULL,
  `trang_thai` enum('draft','submitted') DEFAULT 'submitted',
  `nhan_xet` text DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl_attempts`
--

INSERT INTO `kythi_dgnl_attempts` (`idattempt`, `idkythi`, `idnguoidung`, `tong_diem`, `tong_so_cau`, `tong_cau_dung`, `trang_thai`, `nhan_xet`, `completed_at`, `created_at`, `updated_at`) VALUES
(2, 1, 15, 30.00, 120, 3, 'submitted', NULL, '2025-12-01 16:35:34', '2025-12-01 09:35:34', '2025-12-01 09:35:34');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_attempt_details`
--

CREATE TABLE `kythi_dgnl_attempt_details` (
  `idattempt_detail` bigint(20) UNSIGNED NOT NULL,
  `idattempt` bigint(20) UNSIGNED NOT NULL,
  `idquestion` bigint(20) UNSIGNED NOT NULL,
  `selected_option_ids` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`selected_option_ids`)),
  `cau_tra_loi_tu_luan` text DEFAULT NULL,
  `diem` decimal(5,2) DEFAULT 0.00,
  `is_correct` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_options`
--

CREATE TABLE `kythi_dgnl_options` (
  `idoption` bigint(20) UNSIGNED NOT NULL,
  `idquestion` bigint(20) UNSIGNED NOT NULL,
  `noi_dung` text NOT NULL,
  `is_correct` tinyint(1) DEFAULT 0,
  `thu_tu` tinyint(3) UNSIGNED DEFAULT NULL,
  `loi_giai` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl_options`
--

INSERT INTO `kythi_dgnl_options` (`idoption`, `idquestion`, `noi_dung`, `is_correct`, `thu_tu`, `loi_giai`) VALUES
(601, 1, '71', 0, 1, NULL),
(602, 1, '83', 0, 2, NULL),
(603, 1, '95', 1, 3, 'Quy luật: ×2+1'),
(604, 1, '101', 0, 4, NULL),
(605, 2, '8π', 0, 1, NULL),
(606, 2, '16π', 1, 2, 'R=2√2'),
(607, 2, '32π', 0, 3, NULL),
(608, 2, '64π', 0, 4, NULL),
(609, 3, 'A>D', 1, 1, 'Bắc cầu'),
(610, 3, 'A<D', 0, 2, NULL),
(611, 3, 'A=D', 0, 3, NULL),
(612, 3, 'Không xác định', 0, 4, NULL),
(613, 4, '2h', 0, 1, NULL),
(614, 4, '2.4h', 1, 2, '1/6+1/4=5/12'),
(615, 4, '3h', 0, 3, NULL),
(616, 4, '5h', 0, 4, NULL),
(617, 5, '3', 0, 1, NULL),
(618, 5, '5', 0, 2, NULL),
(619, 5, '7', 0, 3, NULL),
(620, 5, '9', 1, 4, '9 không nguyên tố'),
(621, 6, '40', 0, 1, NULL),
(622, 6, '42', 0, 2, NULL),
(623, 6, '45', 1, 3, 'M=13+A=1+T=20+H=8'),
(624, 6, '48', 0, 4, NULL),
(625, 7, '45', 0, 1, NULL),
(626, 7, '48', 1, 2, '2/(1/40+1/60)'),
(627, 7, '50', 0, 3, NULL),
(628, 7, '52', 0, 4, NULL),
(629, 8, '3', 0, 1, NULL),
(630, 8, '5', 1, 2, '40-(25+20-10)'),
(631, 8, '7', 0, 3, NULL),
(632, 8, '10', 0, 4, NULL),
(633, 9, '0.5', 1, 1, '27/54'),
(634, 9, '1', 0, 2, NULL),
(635, 9, '1.5', 0, 3, NULL),
(636, 9, '2', 0, 4, NULL),
(637, 10, '80', 0, 1, NULL),
(638, 10, '90', 0, 2, NULL),
(639, 10, '100', 1, 3, '30=20%×150=30%×100'),
(640, 10, '110', 0, 4, NULL),
(641, 11, '30', 0, 1, NULL),
(642, 11, '35', 0, 2, NULL),
(643, 11, '36', 1, 3, '6²'),
(644, 11, '40', 0, 4, NULL),
(645, 12, 'Một số A là C', 1, 1, 'Có thể đúng'),
(646, 12, 'Tất cả A là C', 0, 2, NULL),
(647, 12, 'Không A nào là C', 0, 3, NULL),
(648, 12, 'Tất cả C là A', 0, 4, NULL),
(649, 13, '10', 0, 1, NULL),
(650, 13, '11', 0, 2, NULL),
(651, 13, '12', 1, 3, 'x=12'),
(652, 13, '13', 0, 4, NULL),
(653, 14, '5', 0, 1, NULL),
(654, 14, '6', 1, 2, '(20+10)/5=6'),
(655, 14, '7', 0, 3, NULL),
(656, 14, '8', 0, 4, NULL),
(657, 15, '60°', 0, 1, NULL),
(658, 15, '72°', 1, 2, '20%×360°'),
(659, 15, '80°', 0, 3, NULL),
(660, 15, '90°', 0, 4, NULL),
(661, 16, '15/28', 1, 1, 'C(5,1)×C(3,1)/C(8,2)'),
(662, 16, '1/2', 0, 2, NULL),
(663, 16, '3/8', 0, 3, NULL),
(664, 16, '5/8', 0, 4, NULL),
(665, 17, '10', 0, 1, NULL),
(666, 17, '20', 0, 2, NULL),
(667, 17, '30', 1, 3, 'BCNN'),
(668, 17, '60', 0, 4, NULL),
(669, 18, '100', 0, 1, NULL),
(670, 18, '150', 0, 2, NULL),
(671, 18, '200', 1, 3, '10×20'),
(672, 18, '250', 0, 4, NULL),
(673, 19, '4', 0, 1, NULL),
(674, 19, '6', 0, 2, NULL),
(675, 19, '8', 1, 3, '|±8|=8'),
(676, 19, '64', 0, 4, NULL),
(677, 20, '▲', 0, 1, NULL),
(678, 20, '▼', 1, 2, 'Luân phiên'),
(679, 20, '■', 0, 3, NULL),
(680, 20, '●', 0, 4, NULL),
(681, 21, '12.5%', 0, 1, NULL),
(682, 21, '16.67%', 1, 2, '1-1/1.2'),
(683, 21, '18%', 0, 3, NULL),
(684, 21, '20%', 0, 4, NULL),
(685, 22, '20', 0, 1, NULL),
(686, 22, '22.5', 1, 2, '(100-10)/4'),
(687, 22, '25', 0, 3, NULL),
(688, 22, '27.5', 0, 4, NULL),
(689, 23, '105', 1, 1, '3×5×7'),
(690, 23, '210', 0, 2, NULL),
(691, 23, '315', 0, 3, NULL),
(692, 23, '420', 0, 4, NULL),
(693, 24, '106 triệu', 1, 1, '100×1.06'),
(694, 24, '107 triệu', 0, 2, NULL),
(695, 24, '108 triệu', 0, 3, NULL),
(696, 24, '110 triệu', 0, 4, NULL),
(697, 25, '-11', 1, 1, 'Giải PT'),
(698, 25, '-9', 0, 2, NULL),
(699, 25, '-7', 0, 3, NULL),
(700, 25, '-5', 0, 4, NULL),
(701, 26, '10%', 0, 1, NULL),
(702, 26, '12.5%', 1, 2, '25/200'),
(703, 26, '15%', 0, 3, NULL),
(704, 26, '20%', 0, 4, NULL),
(705, 27, '6', 0, 1, NULL),
(706, 27, '7', 0, 2, NULL),
(707, 27, '8', 1, 3, '5+3'),
(708, 27, '9', 0, 4, NULL),
(709, 28, 'Giảm 25%', 1, 1, '1.5×0.5=0.75'),
(710, 28, 'Không đổi', 0, 2, NULL),
(711, 28, 'Tăng 25%', 0, 3, NULL),
(712, 28, 'Giảm 50%', 0, 4, NULL),
(713, 29, '6', 1, 1, '(3×4)/2'),
(714, 29, '7.5', 0, 2, NULL),
(715, 29, '10', 0, 3, NULL),
(716, 29, '12', 0, 4, NULL),
(717, 30, '5 ngày', 0, 1, NULL),
(718, 30, '6 ngày', 1, 2, '12×8/16'),
(719, 30, '7 ngày', 0, 3, NULL),
(720, 30, '8 ngày', 0, 4, NULL),
(841, 31, 'GD chỉ truyền đạt', 0, 1, NULL),
(842, 31, 'GD vai trò toàn diện', 1, 2, NULL),
(843, 31, 'GD chỉ cho HS', 0, 3, NULL),
(844, 31, 'GD không liên quan nhân cách', 0, 4, NULL),
(845, 32, 'diển', 1, 1, NULL),
(846, 32, 'tham gia', 0, 2, NULL),
(847, 32, 'xuất sắc', 0, 3, NULL),
(848, 32, 'sôi nổi', 0, 4, NULL),
(849, 33, 'tránh né', 0, 1, NULL),
(850, 33, 'giải quyết', 1, 2, NULL),
(851, 33, 'phớt lờ', 0, 3, NULL),
(852, 33, 'làm ngơ', 0, 4, NULL),
(853, 34, 'Mỗi người có ước mơ riêng', 1, 1, NULL),
(854, 34, 'Mỗi người có ước mơ riêng của họ', 0, 2, NULL),
(855, 34, 'Mỗi người đều có ước mơ riêng của mình', 0, 3, NULL),
(856, 34, 'Mỗi người họ có ước mơ', 0, 4, NULL),
(857, 35, '(2)-(3)-(1)-(4)', 1, 1, NULL),
(858, 35, '(1)-(2)-(3)-(4)', 0, 2, NULL),
(859, 35, '(3)-(2)-(1)-(4)', 0, 3, NULL),
(860, 35, '(2)-(1)-(3)-(4)', 0, 4, NULL),
(861, 36, 'bền bỉ', 1, 1, NULL),
(862, 36, 'nhanh chóng', 0, 2, NULL),
(863, 36, 'chậm chạp', 0, 3, NULL),
(864, 36, 'linh hoạt', 0, 4, NULL),
(865, 37, 'Anh ấy nói, \"Tôi đến rồi\".', 0, 1, NULL),
(866, 37, 'Anh ấy nói: \"Tôi đến rồi.\"', 1, 2, NULL),
(867, 37, 'Anh ấy nói; \"Tôi đến rồi\".', 0, 3, NULL),
(868, 37, 'Anh ấy nói \"Tôi đến rồi.', 0, 4, NULL),
(869, 38, 'bi quan', 1, 1, NULL),
(870, 38, 'tích cực', 0, 2, NULL),
(871, 38, 'vui vẻ', 0, 3, NULL),
(872, 38, 'hạnh phúc', 0, 4, NULL),
(873, 39, 'nhưng', 1, 1, NULL),
(874, 39, 'vì', 0, 2, NULL),
(875, 39, 'do đó', 0, 3, NULL),
(876, 39, 'tuy nhiên', 0, 4, NULL),
(877, 40, 'Cảnh báo', 1, 1, NULL),
(878, 40, 'Ca ngợi', 0, 2, NULL),
(879, 40, 'Phản đối', 0, 3, NULL),
(880, 40, 'Bàng quan', 0, 4, NULL),
(881, 41, 'niềm nở', 1, 1, NULL),
(882, 41, 'nhiệt tình', 0, 2, NULL),
(883, 41, 'và', 0, 3, NULL),
(884, 41, 'với', 0, 4, NULL),
(885, 42, 'thấy', 1, 1, NULL),
(886, 42, 'cảm', 0, 2, NULL),
(887, 42, 'vui', 0, 3, NULL),
(888, 42, 'Không lỗi', 0, 4, NULL),
(889, 43, 'Làm rõ bằng ví dụ', 1, 1, NULL),
(890, 43, 'Chứng minh', 0, 2, NULL),
(891, 43, 'Phê bình', 0, 3, NULL),
(892, 43, 'Tóm tắt', 0, 4, NULL),
(893, 44, '(3)-(2)-(1)-(4)', 1, 1, NULL),
(894, 44, '(1)-(2)-(3)-(4)', 0, 2, NULL),
(895, 44, '(2)-(3)-(1)-(4)', 0, 3, NULL),
(896, 44, '(4)-(3)-(2)-(1)', 0, 4, NULL),
(897, 45, 'Tôi đi học', 1, 1, NULL),
(898, 45, 'Tôi đi học tập', 0, 2, NULL),
(899, 45, 'Tôi tôi đi học', 0, 3, NULL),
(900, 45, 'Đi học tôi', 0, 4, NULL),
(901, 46, 'bác bỏ', 1, 1, NULL),
(902, 46, 'đồng ý', 0, 2, NULL),
(903, 46, 'ủng hộ', 0, 3, NULL),
(904, 46, 'tiếp nhận', 0, 4, NULL),
(905, 47, 'Sai logic', 1, 1, NULL),
(906, 47, 'Đúng', 0, 2, NULL),
(907, 47, 'Không rõ', 0, 3, NULL),
(908, 47, 'Cần bổ sung', 0, 4, NULL),
(909, 48, 'làm', 1, 1, NULL),
(910, 48, 'thực', 0, 2, NULL),
(911, 48, 'thi', 0, 3, NULL),
(912, 48, 'nghĩ', 0, 4, NULL),
(913, 49, 'bỏ qua', 1, 1, NULL),
(914, 49, 'quan tâm', 0, 2, NULL),
(915, 49, 'chú ý', 0, 3, NULL),
(916, 49, 'tập trung', 0, 4, NULL),
(917, 50, 'Có luận điểm rõ ràng', 1, 1, NULL),
(918, 50, 'Chỉ kể chuyện', 0, 2, NULL),
(919, 50, 'Không có luận cứ', 0, 3, NULL),
(920, 50, 'Chỉ miêu tả', 0, 4, NULL),
(921, 51, 'Lợi ích đọc sách', 1, 1, NULL),
(922, 51, 'Cách đọc sách', 0, 2, NULL),
(923, 51, 'Loại sách hay', 0, 3, NULL),
(924, 51, 'Thời gian đọc', 0, 4, NULL),
(925, 52, 'chìa khoá', 1, 1, NULL),
(926, 52, 'kiên định', 0, 2, NULL),
(927, 52, 'bền bỉ', 0, 3, NULL),
(928, 52, 'là', 0, 4, NULL),
(929, 53, 'Lặp ý về chiều cao', 1, 1, NULL),
(930, 53, 'Không lỗi', 0, 2, NULL),
(931, 53, 'Cần bổ sung', 0, 3, NULL),
(932, 53, 'Thiếu chi tiết', 0, 4, NULL),
(933, 54, 'Miêu tả sinh động', 1, 1, NULL),
(934, 54, 'Vẽ tranh', 0, 2, NULL),
(935, 54, 'Chụp ảnh', 0, 3, NULL),
(936, 54, 'Ghi chép', 0, 4, NULL),
(937, 55, 'Mặt trời lặn đỏ rực', 1, 1, NULL),
(938, 55, 'Mặt trời lặn lặn', 0, 2, NULL),
(939, 55, 'Lặn mặt trời', 0, 3, NULL),
(940, 55, 'Trời lặn', 0, 4, NULL),
(941, 56, 'hiểu sâu', 1, 1, NULL),
(942, 56, 'biết qua', 0, 2, NULL),
(943, 56, 'nghe nói', 0, 3, NULL),
(944, 56, 'đọc được', 0, 4, NULL),
(945, 57, 'Thừa \"khẩn trương\"', 1, 1, NULL),
(946, 57, 'Đúng', 0, 2, NULL),
(947, 57, 'Thiếu từ', 0, 3, NULL),
(948, 57, 'Sai ngữ pháp', 0, 4, NULL),
(949, 58, 'Tranh luận mang tính học thuật', 1, 1, NULL),
(950, 58, 'Giống nhau', 0, 2, NULL),
(951, 58, 'Tranh cãi lịch sự hơn', 0, 3, NULL),
(952, 58, 'Không phân biệt', 0, 4, NULL),
(953, 59, 'Trung lập, khách quan', 1, 1, NULL),
(954, 59, 'Phản đối', 0, 2, NULL),
(955, 59, 'Ủng hộ hoàn toàn', 0, 3, NULL),
(956, 59, 'Lo lắng', 0, 4, NULL),
(957, 60, 'Không chỉ', 1, 1, NULL),
(958, 60, 'Bởi vì', 0, 2, NULL),
(959, 60, 'Mặc dù', 0, 3, NULL),
(960, 60, 'Do đó', 0, 4, NULL),
(1081, 61, 'Làm dự án quan trọng hơn trước', 0, 1, NULL),
(1082, 61, 'Đánh giá mức độ ưu tiên và phân bổ thời gian hợp lý', 1, 2, NULL),
(1083, 61, 'Nhờ người khác làm một dự án', 0, 3, NULL),
(1084, 61, 'Nộp cả hai muộn deadline', 0, 4, NULL),
(1085, 62, 'Bỏ qua vì không phải lỗi mình', 0, 1, NULL),
(1086, 62, 'Thông báo ngay và đề xuất sửa', 1, 2, NULL),
(1087, 62, 'Chỉ sửa phần của mình', 0, 3, NULL),
(1088, 62, 'Báo lãnh đạo mà không nói nhóm', 0, 4, NULL),
(1089, 63, 'Vay mượn để mua ngay', 0, 1, NULL),
(1090, 63, 'Tiết kiệm 2.5tr/tháng, giảm chi tiêu không cần thiết', 1, 2, NULL),
(1091, 63, 'Mua laptop rẻ hơn', 0, 3, NULL),
(1092, 63, 'Chờ có tiền mới mua', 0, 4, NULL),
(1093, 64, 'Phàn nàn với lãnh đạo', 0, 1, NULL),
(1094, 64, 'Trò chuyện riêng, tìm hiểu nguyên nhân và hỗ trợ', 1, 2, NULL),
(1095, 64, 'Làm thay phần của họ', 0, 3, NULL),
(1096, 64, 'Loại họ khỏi nhóm', 0, 4, NULL),
(1097, 65, 'Từ chối vì không biết làm', 0, 1, NULL),
(1098, 65, 'Nhận việc, học hỏi và xin hướng dẫn', 1, 2, NULL),
(1099, 65, 'Nhận nhưng làm qua loa', 0, 3, NULL),
(1100, 65, 'Nhận và nhờ người khác làm', 0, 4, NULL),
(1101, 66, 'Thi không hết sức để bạn đỗ', 0, 1, NULL),
(1102, 66, 'Cả hai cố gắng hết mình, kết quả là công bằng', 1, 2, NULL),
(1103, 66, 'Phá hoại bạn thân', 0, 3, NULL),
(1104, 66, 'Rút lui không thi', 0, 4, NULL),
(1105, 67, 'Áp đặt ý kiến của mình', 0, 1, NULL),
(1106, 67, 'Tổ chức họp, lắng nghe mọi ý kiến và biểu quyết', 1, 2, NULL),
(1107, 67, 'Im lặng để nhóm tự quyết', 0, 3, NULL),
(1108, 67, 'Tách nhóm làm riêng', 0, 4, NULL),
(1109, 68, 'Ưu tiên vui chơi', 0, 1, NULL),
(1110, 68, 'Cân bằng, dành thời gian học kỹ năng', 1, 2, NULL),
(1111, 68, 'Học kỹ năng và bỏ hoàn toàn giải trí', 0, 3, NULL),
(1112, 68, 'Hoãn học kỹ năng', 0, 4, NULL),
(1113, 69, 'Im lặng vì là bạn', 0, 1, NULL),
(1114, 69, 'Nhắc nhở bạn và báo giám thị nếu không nghe', 1, 2, NULL),
(1115, 69, 'Báo ngay giám thị', 0, 3, NULL),
(1116, 69, 'Giúp bạn gian lận', 0, 4, NULL),
(1117, 70, 'Làm đều cả 3 ngày', 0, 1, NULL),
(1118, 70, 'Ngày 1-2: 80% công việc, ngày 3: hoàn thiện và dự phòng', 1, 2, NULL),
(1119, 70, 'Chờ đến ngày cuối mới làm', 0, 3, NULL),
(1120, 70, 'Nhờ người khác hỗ trợ hết', 0, 4, NULL),
(1121, 71, 'Chấp nhận ngay', 0, 1, NULL),
(1122, 71, 'Hỏi rõ chi tiết trước khi quyết định', 1, 2, NULL),
(1123, 71, 'Từ chối luôn', 0, 3, NULL),
(1124, 71, 'Để người khác quyết định', 0, 4, NULL),
(1125, 72, 'Nghỉ việc tìm việc khác', 0, 1, NULL),
(1126, 72, 'Tìm ý nghĩa trong công việc và đặt mục tiêu cá nhân', 1, 2, NULL),
(1127, 72, 'Làm qua loa', 0, 3, NULL),
(1128, 72, 'Phàn nàn với đồng nghiệp', 0, 4, NULL),
(1129, 73, 'Bỏ học đi làm ngay', 0, 1, NULL),
(1130, 73, 'Tìm việc làm thêm vừa học vừa làm', 1, 2, NULL),
(1131, 73, 'Tiếp tục học, không quan tâm gia đình', 0, 3, NULL),
(1132, 73, 'Vay nợ để học', 0, 4, NULL),
(1133, 74, 'Làm theo mà không hỏi', 0, 1, NULL),
(1134, 74, 'Trao đổi lịch sự, nêu quan điểm và lý do', 1, 2, NULL),
(1135, 74, 'Từ chối thẳng thừng', 0, 3, NULL),
(1136, 74, 'Phàn nàn với đồng nghiệp', 0, 4, NULL),
(1137, 75, 'Bỏ cuộc', 0, 1, NULL),
(1138, 75, 'Trình bày lại với dữ liệu cụ thể, tôn trọng quyết định cuối', 1, 2, NULL),
(1139, 75, 'Làm theo ý mình', 0, 3, NULL),
(1140, 75, 'Tranh cãi gay gắt', 0, 4, NULL),
(1141, 76, 'Chọn lương cao', 0, 1, NULL),
(1142, 76, 'Cân nhắc tổng thể: chi phí đi lại, thời gian, phát triển dài hạn', 1, 2, NULL),
(1143, 76, 'Chọn gần nhà', 0, 3, NULL),
(1144, 76, 'Chọn ngẫu nhiên', 0, 4, NULL),
(1145, 77, 'Che giấu', 0, 1, NULL),
(1146, 77, 'Thừa nhận, xin lỗi và đề xuất khắc phục', 1, 2, NULL),
(1147, 77, 'Đổ lỗi cho người khác', 0, 3, NULL),
(1148, 77, 'Im lặng chờ người khác phát hiện', 0, 4, NULL),
(1149, 78, 'Đổ lỗi cho hoàn cảnh', 0, 1, NULL),
(1150, 78, 'Phân tích nguyên nhân và rút kinh nghiệm cụ thể', 1, 2, NULL),
(1151, 78, 'Quên đi và làm dự án mới', 0, 3, NULL),
(1152, 78, 'Đổ lỗi cho thành viên', 0, 4, NULL),
(1153, 79, 'Đòi phần thưởng', 0, 1, NULL),
(1154, 79, 'Chúc mừng người được chọn, tiếp tục cố gắng', 1, 2, NULL),
(1155, 79, 'Phàn nàn không công bằng', 0, 3, NULL),
(1156, 79, 'Bỏ việc', 0, 4, NULL),
(1157, 80, 'Tin theo đa số', 0, 1, NULL),
(1158, 80, 'Tìm nguồn đáng tin cậy và đối chiếu thông tin', 1, 2, NULL),
(1159, 80, 'Tin người quen', 0, 3, NULL),
(1160, 80, 'Không quan tâm', 0, 4, NULL),
(1161, 81, 'Chịu đựng', 0, 1, NULL),
(1162, 81, 'Điều chỉnh cách làm việc và tìm sự hỗ trợ', 1, 2, NULL),
(1163, 81, 'Nghỉ việc ngay', 0, 3, NULL),
(1164, 81, 'Phàn nàn', 0, 4, NULL),
(1165, 82, 'Từ chối vì sợ', 0, 1, NULL),
(1166, 82, 'Đánh giá kỹ rồi dám thử nếu hợp lý', 1, 2, NULL),
(1167, 82, 'Chấp nhận mà không suy nghĩ', 0, 3, NULL),
(1168, 82, 'Hỏi ý kiến mọi người', 0, 4, NULL),
(1169, 83, 'Tham gia để giữ tình bạn', 0, 1, NULL),
(1170, 83, 'Lịch sự từ chối và giải thích lý do', 1, 2, NULL),
(1171, 83, 'Tham gia nhưng miễn cưỡng', 0, 3, NULL),
(1172, 83, 'Cắt đứt quan hệ', 0, 4, NULL),
(1173, 84, 'Hoảng sợ', 0, 1, NULL),
(1174, 84, 'Bình tĩnh đánh giá và điều chỉnh kế hoạch', 1, 2, NULL),
(1175, 84, 'Bỏ cuộc', 0, 3, NULL),
(1176, 84, 'Phàn nàn về sự thay đổi', 0, 4, NULL),
(1177, 85, 'Tránh né họ', 0, 1, NULL),
(1178, 85, 'Chuyên nghiệp, tập trung vào công việc', 1, 2, NULL),
(1179, 85, 'Tạo xung đột', 0, 3, NULL),
(1180, 85, 'Phàn nàn với lãnh đạo', 0, 4, NULL),
(1181, 86, 'Làm tất cả cùng lúc', 0, 1, NULL),
(1182, 86, 'Ưu tiên mục tiêu quan trọng nhất trước', 1, 2, NULL),
(1183, 86, 'Chọn mục tiêu dễ nhất', 0, 3, NULL),
(1184, 86, 'Bỏ hết các mục tiêu', 0, 4, NULL),
(1185, 87, 'Buồn bã và từ bỏ', 0, 1, NULL),
(1186, 87, 'Lắng nghe, suy ngẫm và cải thiện', 1, 2, NULL),
(1187, 87, 'Phản bác gay gắt', 0, 3, NULL),
(1188, 87, 'Bỏ qua hoàn toàn', 0, 4, NULL),
(1189, 88, 'Chấp nhận mà không cân nhắc', 0, 1, NULL),
(1190, 88, 'Đánh giá tỷ lệ rủi ro/lợi ích cẩn thận', 1, 2, NULL),
(1191, 88, 'Từ chối vì sợ rủi ro', 0, 3, NULL),
(1192, 88, 'Để người khác quyết định', 0, 4, NULL),
(1193, 89, 'Chấp nhận giá trị tổ chức', 0, 1, NULL),
(1194, 89, 'Trao đổi cởi mở và tìm giải pháp hài hòa', 1, 2, NULL),
(1195, 89, 'Rời tổ chức ngay', 0, 3, NULL),
(1196, 89, 'Giữ im và chịu đựng', 0, 4, NULL),
(1197, 90, 'Nghỉ ngơi cả ngày', 0, 1, NULL),
(1198, 90, 'Cân bằng: công việc cần thiết, học tập và giải trí', 1, 2, NULL),
(1199, 90, 'Làm việc cả ngày', 0, 3, NULL),
(1200, 90, 'Vui chơi cả ngày', 0, 4, NULL),
(1201, 91, 'Newton', 0, 1, NULL),
(1202, 91, 'Lavoisier', 1, 2, NULL),
(1203, 91, 'Einstein', 0, 3, NULL),
(1204, 91, 'Dalton', 0, 4, NULL),
(1205, 92, 'Có thành tế bào', 1, 1, NULL),
(1206, 92, 'Có nhân', 0, 2, NULL),
(1207, 92, 'Có ty thể', 0, 3, NULL),
(1208, 92, 'Có màng tế bào', 0, 4, NULL),
(1209, 93, 'Lý Thường Kiệt', 0, 1, NULL),
(1210, 93, 'Ngô Quyền', 1, 2, NULL),
(1211, 93, 'Trần Hưng Đạo', 0, 3, NULL),
(1212, 93, 'Lê Lợi', 0, 4, NULL),
(1213, 94, 'Mặt Trời mọc Đông lặn Tây', 0, 1, NULL),
(1214, 94, 'Con lắc Foucault', 1, 2, NULL),
(1215, 94, 'Ngày đêm dài ngắn', 0, 3, NULL),
(1216, 94, 'Có gió', 0, 4, NULL),
(1217, 95, 'Ion dương', 0, 1, NULL),
(1218, 95, 'Ion âm', 1, 2, NULL),
(1219, 95, 'Nguyên tử trung hòa', 0, 3, NULL),
(1220, 95, 'Phân tử', 0, 4, NULL),
(1221, 96, 'Lá lục', 1, 1, NULL),
(1222, 96, 'Rễ', 0, 2, NULL),
(1223, 96, 'Thân', 0, 3, NULL),
(1224, 96, 'Hoa', 0, 4, NULL),
(1225, 97, '19/8/1945', 1, 1, NULL),
(1226, 97, '2/9/1945', 0, 2, NULL),
(1227, 97, '30/4/1975', 0, 3, NULL),
(1228, 97, '1/5/1975', 0, 4, NULL),
(1229, 98, 'Núi phía Bắc, đồng bằng phía Nam', 0, 1, NULL),
(1230, 98, 'Đồi núi chiếm 3/4 diện tích', 1, 2, NULL),
(1231, 98, 'Toàn đồng bằng', 0, 3, NULL),
(1232, 98, 'Toàn cao nguyên', 0, 4, NULL),
(1233, 99, 'Axit', 1, 1, NULL),
(1234, 99, 'Bazơ', 0, 2, NULL),
(1235, 99, 'Trung tính', 0, 3, NULL),
(1236, 99, 'Muối', 0, 4, NULL),
(1237, 100, 'Dự trữ năng lượng', 0, 1, NULL),
(1238, 100, 'Lưu trữ thông tin di truyền', 1, 2, NULL),
(1239, 100, 'Xúc tác phản ứng', 0, 3, NULL),
(1240, 100, 'Vận chuyển oxy', 0, 4, NULL),
(1241, 101, 'Đối lưu', 0, 1, NULL),
(1242, 101, 'Bức xạ', 1, 2, NULL),
(1243, 101, 'Dẫn nhiệt', 0, 3, NULL),
(1244, 101, 'Gió', 0, 4, NULL),
(1245, 102, 'Sắt', 0, 1, NULL),
(1246, 102, 'Nhôm', 1, 2, NULL),
(1247, 102, 'Vàng', 0, 3, NULL),
(1248, 102, 'Đồng', 0, 4, NULL),
(1249, 103, '23 cặp', 1, 1, NULL),
(1250, 103, '22 cặp', 0, 2, NULL),
(1251, 103, '24 cặp', 0, 3, NULL),
(1252, 103, '46 cặp', 0, 4, NULL),
(1253, 104, 'Nhiệt đới gió mùa', 1, 1, NULL),
(1254, 104, 'Ôn đới', 0, 2, NULL),
(1255, 104, 'Hàn đới', 0, 3, NULL),
(1256, 104, 'Xích đạo', 0, 4, NULL),
(1257, 105, '300.000 km/s', 1, 1, NULL),
(1258, 105, '150.000 km/s', 0, 2, NULL),
(1259, 105, '200.000 km/s', 0, 3, NULL),
(1260, 105, '250.000 km/s', 0, 4, NULL),
(1261, 106, 'Quang hợp', 0, 1, NULL),
(1262, 106, 'Đốt cháy', 1, 2, NULL),
(1263, 106, 'Phân hủy nước', 0, 3, NULL),
(1264, 106, 'Điện phân', 0, 4, NULL),
(1265, 107, 'Gan', 0, 1, NULL),
(1266, 107, 'Tụy', 1, 2, NULL),
(1267, 107, 'Thận', 0, 3, NULL),
(1268, 107, 'Lá lách', 0, 4, NULL),
(1269, 108, '1954', 1, 1, NULL),
(1270, 108, '1945', 0, 2, NULL),
(1271, 108, '1975', 0, 3, NULL),
(1272, 108, '1955', 0, 4, NULL),
(1273, 109, 'Sông Mê Kông', 1, 1, NULL),
(1274, 109, 'Sông Hồng', 0, 2, NULL),
(1275, 109, 'Sông Đồng Nai', 0, 3, NULL),
(1276, 109, 'Sông Cửu Long', 0, 4, NULL),
(1277, 110, 'Quán tính', 1, 1, NULL),
(1278, 110, 'Gia tốc', 0, 2, NULL),
(1279, 110, 'Lực và khối lượng', 0, 3, NULL),
(1280, 110, 'Tác dụng và phản tác dụng', 0, 4, NULL),
(1281, 111, 'H2O', 1, 1, NULL),
(1282, 111, 'H2O2', 0, 2, NULL),
(1283, 111, 'HO', 0, 3, NULL),
(1284, 111, 'H3O', 0, 4, NULL),
(1285, 112, 'Ti thể', 1, 1, NULL),
(1286, 112, 'Nhân tế bào', 0, 2, NULL),
(1287, 112, 'Lục lạp', 0, 3, NULL),
(1288, 112, 'Bộ máy Golgi', 0, 4, NULL),
(1289, 113, '1945', 1, 1, NULL),
(1290, 113, '1918', 0, 2, NULL),
(1291, 113, '1950', 0, 3, NULL),
(1292, 113, '1939', 0, 4, NULL),
(1293, 114, 'Thứ 13', 0, 1, NULL),
(1294, 114, 'Thứ 15', 1, 2, NULL),
(1295, 114, 'Thứ 10', 0, 3, NULL),
(1296, 114, 'Thứ 20', 0, 4, NULL),
(1297, 115, 'Khối lượng và khoảng cách', 1, 1, NULL),
(1298, 115, 'Chỉ khối lượng', 0, 2, NULL),
(1299, 115, 'Chỉ khoảng cách', 0, 3, NULL),
(1300, 115, 'Vận tốc', 0, 4, NULL),
(1301, 116, 'Vàng', 0, 1, NULL),
(1302, 116, 'Bạc', 1, 2, NULL),
(1303, 116, 'Đồng', 0, 3, NULL),
(1304, 116, 'Nhôm', 0, 4, NULL),
(1305, 117, 'Gan', 0, 1, NULL),
(1306, 117, 'Thận', 1, 2, NULL),
(1307, 117, 'Tim', 0, 3, NULL),
(1308, 117, 'Phổi', 0, 4, NULL),
(1309, 118, '1967', 1, 1, NULL),
(1310, 118, '1945', 0, 2, NULL),
(1311, 118, '1975', 0, 3, NULL),
(1312, 118, '1954', 0, 4, NULL),
(1313, 119, 'Nga', 1, 1, NULL),
(1314, 119, 'Canada', 0, 2, NULL),
(1315, 119, 'Trung Quốc', 0, 3, NULL),
(1316, 119, 'Mỹ', 0, 4, NULL),
(1317, 120, 'Bình đẳng xã hội', 1, 1, NULL),
(1318, 120, 'Cạnh tranh tự do', 0, 2, NULL),
(1319, 120, 'Tư hữu tuyệt đối', 0, 3, NULL),
(1320, 120, 'Phân biệt giai cấp', 0, 4, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_questions`
--

CREATE TABLE `kythi_dgnl_questions` (
  `idquestion` bigint(20) UNSIGNED NOT NULL,
  `idsection` bigint(20) UNSIGNED NOT NULL,
  `noi_dung` text NOT NULL,
  `loai_cau` enum('single_choice','multiple_choice','true_false','short_answer') DEFAULT 'single_choice',
  `thu_tu` smallint(5) UNSIGNED DEFAULT NULL,
  `do_kho` enum('easy','medium','hard') DEFAULT 'medium',
  `diem_mac_dinh` decimal(5,2) DEFAULT 1.00,
  `dap_an_dung` char(1) DEFAULT NULL COMMENT 'A, B, C, D',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl_questions`
--

INSERT INTO `kythi_dgnl_questions` (`idquestion`, `idsection`, `noi_dung`, `loai_cau`, `thu_tu`, `do_kho`, `diem_mac_dinh`, `dap_an_dung`, `created_at`, `updated_at`) VALUES
(1, 1, 'Cho dãy số: 2, 5, 11, 23, 47, ... Số tiếp theo là:', 'single_choice', 1, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-12-03 06:22:26'),
(2, 1, 'Hình vuông cạnh 4cm. Diện tích hình tròn ngoại tiếp là:', 'single_choice', 2, 'medium', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(3, 1, 'Nếu A > B, B > C, C > D thì:', 'single_choice', 3, 'easy', 10.00, 'A', '2025-11-26 13:18:57', '2025-12-03 06:13:20'),
(4, 1, 'Bể nước: vòi A đầy trong 6h, vòi B trong 4h. Cả 2 vòi chảy đầy trong:', 'single_choice', 4, 'hard', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(5, 1, 'Tìm số khác loại: 3, 5, 7, 9, 11', 'single_choice', 5, 'easy', 10.00, 'D', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(6, 1, 'A=1, B=2... từ \"MATH\" có tổng:', 'single_choice', 6, 'medium', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(7, 1, 'Đi 40km/h, về 60km/h. Vận tốc TB:', 'single_choice', 7, 'hard', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(8, 1, '40 HS: 25 giỏi Toán, 20 giỏi Lý, 10 giỏi cả 2. Không giỏi môn nào:', 'single_choice', 8, 'medium', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(9, 1, 'Hình lập phương cạnh 3cm. Tỉ số V/S:', 'single_choice', 9, 'medium', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(10, 1, '20% của 150 = 30% của:', 'single_choice', 10, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(11, 1, 'Dãy: 1, 4, 9, 16, 25, ... số tiếp theo:', 'single_choice', 11, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(12, 1, 'Tất cả A là B, một số B là C. Kết luận:', 'single_choice', 12, 'medium', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(13, 1, '2x + 5 = 3x - 7, x = ?', 'single_choice', 13, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(14, 1, '5 phòng × 4 người + 10 người. Trung bình mỗi phòng:', 'single_choice', 14, 'medium', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(15, 1, 'Biểu đồ tròn: C = 20%. Góc là:', 'single_choice', 15, 'easy', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(16, 1, '5 bi đỏ, 3 bi xanh. Rút 2 bi. P(1đỏ 1xanh):', 'single_choice', 16, 'hard', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(17, 1, 'BCNN(2,3,5) = ?', 'single_choice', 17, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(18, 1, 'HCN chu vi 60cm, dài gấp đôi rộng. Diện tích:', 'single_choice', 18, 'medium', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(19, 1, 'x² = 64, |x| = ?', 'single_choice', 19, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(20, 1, 'Quy luật: ▲▼▲▼▲... tiếp theo:', 'single_choice', 20, 'easy', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(21, 1, 'Gạo tăng 20%, giảm tiêu thụ bao nhiêu % để chi phí không đổi?', 'single_choice', 21, 'hard', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(22, 1, 'TB của 5 số là 20. Bỏ số 10, TB 4 số còn lại:', 'single_choice', 22, 'medium', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(23, 1, 'Số chia hết cho 3, 5, 7:', 'single_choice', 23, 'medium', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(24, 1, '100tr gửi 6%/năm. Sau 1 năm:', 'single_choice', 24, 'easy', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(25, 1, '(x-3)/2 = (x+1)/3, x = ?', 'single_choice', 25, 'medium', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(26, 1, '25 là bao nhiêu % của 200?', 'single_choice', 26, 'easy', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(27, 1, 'A>B>C, B-C=5, A-B=3. A-C=?', 'single_choice', 27, 'easy', 10.00, 'C', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(28, 1, 'Tăng 50% rồi giảm 50%:', 'single_choice', 28, 'hard', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(29, 1, 'Tam giác vuông 3-4-5. Diện tích:', 'single_choice', 29, 'medium', 10.00, 'A', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(30, 1, '12 công nhân làm xong trong 8 ngày. 16 công nhân làm xong trong:', 'single_choice', 30, 'medium', 10.00, 'B', '2025-11-26 13:18:57', '2025-11-26 14:40:36'),
(31, 2, '\"Giáo dục hun đúc nhân cách, phát triển tư duy.\" Ý chính:', 'single_choice', 31, 'easy', 10.00, 'B', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(32, 2, 'Từ SAI: \"Cuộc thi diển ra sôi nổi\"', 'single_choice', 32, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(33, 2, 'Đồng nghĩa \"khắc phục\":', 'single_choice', 33, 'medium', 10.00, 'B', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(34, 2, 'Câu ĐÚNG ngữ pháp:', 'single_choice', 34, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(35, 2, 'Sắp xếp: (1)Trách nhiệm chung (2)Ô nhiễm toàn cầu (3)Ảnh hưởng sức khỏe (4)Hành động ngay', 'single_choice', 35, 'hard', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(36, 2, 'Đồng nghĩa \"kiên trì\":', 'single_choice', 36, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(37, 2, 'SAI dấu câu:', 'single_choice', 37, 'medium', 10.00, 'B', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(38, 2, 'Trái nghĩa \"lạc quan\":', 'single_choice', 38, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(39, 2, 'Hoàn thiện: \"Dù mưa, ___ vẫn đi học\"', 'single_choice', 39, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(40, 2, '\"Công nghệ 4.0 thách thức bảo mật.\" Tác giả:', 'single_choice', 40, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(41, 2, 'SAI chính tả: \"nhiệt tình và niềm nở\"', 'single_choice', 41, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(42, 2, 'Thừa từ: \"Tôi thấy cảm thấy vui\"', 'single_choice', 42, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(43, 2, '\"minh họa\" nghĩa là:', 'single_choice', 43, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(44, 2, 'Sắp xếp: (1)Biện pháp (2)Nghiêm trọng (3)Rác nhựa (4)Hành động', 'single_choice', 44, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(45, 2, 'ĐÚNG ngữ pháp:', 'single_choice', 45, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(46, 2, '\"phản bác\" đồng nghĩa:', 'single_choice', 46, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(47, 2, 'Lỗi logic: \"Tất cả chăm nên một số điểm cao\"', 'single_choice', 47, 'hard', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(48, 2, 'Điền từ: \"Anh ấy ___ việc có trách nhiệm\"', 'single_choice', 48, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(49, 2, 'Trái nghĩa \"ưu tiên\":', 'single_choice', 49, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(50, 2, 'ĐÚNG về văn nghị luận:', 'single_choice', 50, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(51, 2, '\"Đọc sách mở rộng kiến thức.\" Nội dung chính:', 'single_choice', 51, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(52, 2, 'SAI: \"kiên định và bền bỉ là chìa khoá\"', 'single_choice', 52, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(53, 2, 'Lặp ý: \"cao, to lớn, chiều cao vượt trội\"', 'single_choice', 53, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(54, 2, '\"khắc họa\" nghĩa:', 'single_choice', 54, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(55, 2, 'Câu hay nhất:', 'single_choice', 55, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(56, 2, '\"thấu hiểu\" gần nghĩa:', 'single_choice', 56, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(57, 2, 'Sửa: \"nhanh chóng và khẩn trương\"', 'single_choice', 57, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(58, 2, '\"tranh luận\" khác \"tranh cãi\":', 'single_choice', 58, 'hard', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(59, 2, '\"AI thay thế con người.\" Thái độ:', 'single_choice', 59, 'medium', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(60, 2, 'Hoàn thiện: \"___ học giỏi, còn khiêm tốn\"', 'single_choice', 60, 'easy', 10.00, 'A', '2025-11-26 13:27:26', '2025-11-26 14:40:36'),
(61, 3, 'Bạn có 2 dự án quan trọng cùng deadline. Bạn sẽ:', 'single_choice', 61, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(62, 3, 'Phát hiện sai sót trong báo cáo nhóm trước khi nộp. Bạn:', 'single_choice', 62, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(63, 3, 'Lương 10tr/tháng, chi tiêu 8tr, muốn mua laptop 15tr sau 6 tháng. Bạn:', 'single_choice', 63, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(64, 3, 'Đồng đội làm việc kém, ảnh hưởng nhóm. Bạn:', 'single_choice', 64, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(65, 3, 'Nhận công việc mới nhưng thiếu kỹ năng. Bạn:', 'single_choice', 65, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(66, 3, 'Bạn học và bạn thân thi cùng trường, chỉ nhận 1 người. Bạn:', 'single_choice', 66, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(67, 3, 'Xung đột ý kiến trong nhóm về hướng thực hiện dự án. Bạn:', 'single_choice', 67, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(68, 3, 'Có cơ hội học thêm kỹ năng nhưng mất thời gian vui chơi. Bạn:', 'single_choice', 68, 'easy', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(69, 3, 'Phát hiện bạn gian lận trong thi. Bạn:', 'single_choice', 69, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(70, 3, 'Deadline 3 ngày, khối lượng lớn. Bạn phân bổ thời gian:', 'single_choice', 70, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(71, 3, 'Lời mời hấp dẫn nhưng chưa rõ chi tiết. Bạn:', 'single_choice', 71, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(72, 3, 'Công việc lặp lại nhàm chán. Bạn duy trì động lực bằng:', 'single_choice', 72, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(73, 3, 'Gia đình gặp khó khăn tài chính, bạn đang học đại học. Bạn:', 'single_choice', 73, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(74, 3, 'Lãnh đạo yêu cầu không hợp lý. Bạn:', 'single_choice', 74, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(75, 3, 'Bạn có ý tưởng tốt nhưng nhóm không đồng ý. Bạn:', 'single_choice', 75, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(76, 3, 'Phải chọn: Công việc lương cao xa nhà hay lương thấp gần nhà. Bạn:', 'single_choice', 76, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(77, 3, 'Mắc sai lầm gây thiệt hại cho tổ chức. Bạn:', 'single_choice', 77, 'easy', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(78, 3, 'Dự án thất bại do nhiều nguyên nhân. Bạn rút kinh nghiệm:', 'single_choice', 78, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(79, 3, 'Bạn và người khác cùng xứng đáng được khen thưởng nhưng chỉ có 1 suất. Bạn:', 'single_choice', 79, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(80, 3, 'Thông tin trái chiều về một vấn đề. Bạn:', 'single_choice', 80, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(81, 3, 'Áp lực công việc ảnh hưởng sức khỏe. Bạn:', 'single_choice', 81, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(82, 3, 'Cơ hội tốt nhưng phải rời khỏi vùng an toàn. Bạn:', 'single_choice', 82, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(83, 3, 'Bạn bè rủ hoạt động gây tranh cãi về đạo đức. Bạn:', 'single_choice', 83, 'easy', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(84, 3, 'Kế hoạch bị thay đổi đột ngột. Bạn:', 'single_choice', 84, 'easy', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(85, 3, 'Phải làm việc với người không ưa. Bạn:', 'single_choice', 85, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(86, 3, 'Có nhiều mục tiêu nhưng nguồn lực hạn chế. Bạn:', 'single_choice', 86, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(87, 3, 'Nhận phản hồi tiêu cực về công việc. Bạn:', 'single_choice', 87, 'easy', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(88, 3, 'Cơ hội phát triển nhưng rủi ro cao. Bạn:', 'single_choice', 88, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(89, 3, 'Xung đột giá trị cá nhân với tổ chức. Bạn:', 'single_choice', 89, 'hard', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(90, 3, 'Thời gian rảnh cuối tuần, nhiều việc cần làm. Bạn ưu tiên:', 'single_choice', 90, 'medium', 10.00, 'B', '2025-11-26 13:29:28', '2025-11-26 14:40:36'),
(91, 4, 'Định luật bảo toàn khối lượng do ai phát hiện?', 'single_choice', 91, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(92, 4, 'Tế bào thực vật khác tế bào động vật ở điểm nào?', 'single_choice', 92, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(93, 4, 'Chiến thắng Bạch Đằng năm 938 do ai lãnh đạo?', 'single_choice', 93, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(94, 4, 'Hiện tượng nào chứng minh Trái Đất tự quay?', 'single_choice', 94, 'medium', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(95, 4, 'Anion là gì?', 'single_choice', 95, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(96, 4, 'Quang hợp ở thực vật xảy ra tại đâu?', 'single_choice', 96, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(97, 4, 'Cách mạng tháng Tám năm 1945 thành công vào ngày nào?', 'single_choice', 97, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(98, 4, 'Địa hình Việt Nam đặc trưng:', 'single_choice', 98, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(99, 4, 'pH < 7 thì dung dịch:', 'single_choice', 99, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(100, 4, 'ADN có chức năng:', 'single_choice', 100, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(101, 4, 'Năng lượng từ Mặt Trời đến Trái Đất nhờ:', 'single_choice', 101, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(102, 4, 'Nguyên tố kim loại phổ biến nhất trong vỏ Trái Đất:', 'single_choice', 102, 'medium', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(103, 4, 'Nhiễm sắc thể ở người bình thường:', 'single_choice', 103, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(104, 4, 'Đông Nam Á có khí hậu:', 'single_choice', 104, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(105, 4, 'Tốc độ ánh sáng trong chân không:', 'single_choice', 105, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(106, 4, 'Phản ứng hóa học nào tỏa nhiệt?', 'single_choice', 106, 'medium', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(107, 4, 'Cơ quan nào sản xuất insulin?', 'single_choice', 107, 'medium', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(108, 4, 'Cuộc kháng chiến chống Pháp kết thúc năm:', 'single_choice', 108, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(109, 4, 'Sông dài nhất Việt Nam:', 'single_choice', 109, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(110, 4, 'Định luật Newton thứ nhất về:', 'single_choice', 110, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(111, 4, 'Công thức nước là:', 'single_choice', 111, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(112, 4, 'Hô hấp tế bào diễn ra ở đâu?', 'single_choice', 112, 'medium', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(113, 4, 'Liên hợp quốc được thành lập năm:', 'single_choice', 113, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(114, 4, 'Dân số Việt Nam xếp thứ mấy thế giới?', 'single_choice', 114, 'medium', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(115, 4, 'Lực hấp dẫn phụ thuộc vào:', 'single_choice', 115, 'medium', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(116, 4, 'Kim loại nào dẫn điện tốt nhất?', 'single_choice', 116, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(117, 4, 'Cơ quan nào lọc máu?', 'single_choice', 117, 'easy', 10.00, 'B', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(118, 4, 'ASEAN được thành lập năm:', 'single_choice', 118, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(119, 4, 'Quốc gia nào có diện tích lớn nhất thế giới?', 'single_choice', 119, 'easy', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36'),
(120, 4, 'Chủ nghĩa xã hội chủ trương:', 'single_choice', 120, 'medium', 10.00, 'A', '2025-11-26 13:30:30', '2025-11-26 14:40:36');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_sections`
--

CREATE TABLE `kythi_dgnl_sections` (
  `idsection` bigint(20) UNSIGNED NOT NULL,
  `idkythi` bigint(20) UNSIGNED NOT NULL,
  `ma_section` varchar(50) DEFAULT NULL,
  `ten_section` varchar(255) NOT NULL,
  `nhom_nang_luc` varchar(80) DEFAULT NULL,
  `so_cau` smallint(5) UNSIGNED DEFAULT NULL,
  `thoi_luong_phut` smallint(5) UNSIGNED DEFAULT NULL,
  `thu_tu` tinyint(3) UNSIGNED DEFAULT 1,
  `mo_ta` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl_sections`
--

INSERT INTO `kythi_dgnl_sections` (`idsection`, `idkythi`, `ma_section`, `ten_section`, `nhom_nang_luc`, `so_cau`, `thoi_luong_phut`, `thu_tu`, `mo_ta`, `created_at`, `updated_at`) VALUES
(1, 1, 'LOGIC', 'Tư duy logic – toán học', 'logic', 31, NULL, 1, 'Suy luận số, dãy số, hình học, bài toán thực tế.', '2025-11-26 13:16:46', '2025-12-03 04:43:17'),
(2, 1, 'LANG', 'Ngôn ngữ – đọc hiểu', 'ngon_ngu', 30, NULL, 2, 'Đọc hiểu, ngữ pháp, từ vựng.', '2025-11-26 13:16:46', '2025-11-26 13:18:19'),
(3, 1, 'PROBLEM', 'Giải quyết vấn đề', 'giai_quyet', 30, NULL, 3, 'Tình huống thực tiễn, ra quyết định.', '2025-11-26 13:16:46', '2025-11-26 13:18:19'),
(4, 1, 'GENERAL', 'Tổng hợp KHTN & KHXH', 'tong_hop', 30, NULL, 4, 'Lý – Hóa – Sinh, Sử – Địa – GDCD.', '2025-11-26 13:16:46', '2025-11-26 13:18:19');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `kythi_dgnl_topics`
--

CREATE TABLE `kythi_dgnl_topics` (
  `idtopic` bigint(20) UNSIGNED NOT NULL,
  `idsection` bigint(20) UNSIGNED NOT NULL,
  `ten_chu_de` varchar(255) NOT NULL,
  `mo_ta` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `kythi_dgnl_topics`
--

INSERT INTO `kythi_dgnl_topics` (`idtopic`, `idsection`, `ten_chu_de`, `mo_ta`, `created_at`, `updated_at`) VALUES
(10, 1, 'Suy luận số học', 'Dãy số, quy luật, phép tính', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(11, 1, 'Tư duy hình học', 'Hình phẳng, không gian', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(12, 1, 'Biểu đồ - Dữ liệu', 'Phân tích biểu đồ, bảng số liệu', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(13, 2, 'Đọc hiểu', 'Phân tích văn bản', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(14, 2, 'Ngữ pháp - Từ vựng', 'Chính tả, từ đồng/trái nghĩa', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(15, 3, 'Tình huống xã hội', 'Giao tiếp, quan hệ', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(16, 3, 'Quản lý cá nhân', 'Thời gian, tài chính', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(17, 4, 'Khoa học tự nhiên', 'Lý Hóa Sinh', '2025-11-26 13:18:30', '2025-11-26 13:18:30'),
(18, 4, 'Khoa học xã hội', 'Sử Địa GDCD', '2025-11-26 13:18:30', '2025-11-26 13:18:30');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `lichtuvan`
--

SET NAMES utf8mb4;
CREATE TABLE lichtuvan (
idlichtuvan int(11) NOT NULL AUTO_INCREMENT,
idnguoidung int(11) DEFAULT NULL,
idnguoidat int(11) DEFAULT NULL,
tieude varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
noidung text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
chudetuvan varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
molavande varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
ngayhen date DEFAULT NULL,
giohen time DEFAULT NULL,
giobatdau time DEFAULT NULL,
ketthuc time DEFAULT NULL,
tinhtrang varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Chờ xử lý',
trangthai varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'Hoạt động',
duyetlich tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=Chưa duyệt, 2=Đã duyệt',
idnguoiduyet int(11) DEFAULT NULL,
ngayduyet datetime DEFAULT NULL,
ghichu text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
danhdanhgiadem text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
nhanxet text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
PRIMARY KEY (idlichtuvan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `lichtuvan`
--

INSERT INTO `lichtuvan` (`idlichtuvan`, `idnguoidung`, `idnguoidat`, `tieude`, `noidung`, `chudetuvan`, `molavande`, `ngayhen`, `giohen`, `giobatdau`, `ketthuc`, `tinhtrang`, `trangthai`, `duyetlich`, `idnguoiduyet`, `ngayduyet`, `ghichu`, `danhdanhgiadem`, `nhanxet`) VALUES
(30, 5, NULL, 'Lịch tư vấn 2025-10-23', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-23', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(31, 5, NULL, 'Lịch tư vấn 2025-10-23', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-23', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(32, 5, NULL, 'Lịch tư vấn 2025-10-23', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-23', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(33, 5, NULL, 'Lịch tư vấn 2025-10-22', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-22', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(34, 5, NULL, 'Lịch tư vấn 2025-10-22', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-22', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(35, 5, NULL, 'Lịch tư vấn 2025-10-31', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-31', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 3, 34, '2025-10-23 14:54:16', '', 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(36, 5, NULL, 'Lịch tư vấn 2025-10-31', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-31', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Đăng ký lịch trống - Quý 4 (Tháng 10-12) 2025'),
(37, 5, NULL, 'Lịch tư vấn 2025-10-23', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-23', '15:10:00', '15:10:00', '17:10:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)'),
(38, 5, NULL, 'Lịch tư vấn 2025-10-23', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (17:15-19:15)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-23', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (17:15-19:15)'),
(39, 5, NULL, 'Lịch tư vấn 2025-10-24', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (09:05-11:05)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-24', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 2, 6, '2025-10-23 15:32:57', 'vinh12', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (09:05-11:05)'),
(40, 5, NULL, 'Lịch tư vấn 2025-10-24', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-24', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 2, 34, '2025-10-23 15:14:41', '', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)'),
(41, 5, NULL, 'Lịch tư vấn 2025-10-24', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (07:00-09:00)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-24', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (07:00-09:00)'),
(42, 5, NULL, 'Lịch tư vấn 2025-10-24', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)', 'Tư vấn tuyển sinh', 'Zoom', '2025-10-24', '15:10:00', '15:10:00', '17:10:00', 'Chờ xử lý', '1', 2, 34, '2025-10-23 15:09:09', 'sdzfxgchvjklm,', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)'),
(43, 5, NULL, 'Lịch tư vấn 2025-10-24', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (17:15-19:15)', 'Tư vấn tuyển sinh', 'Zoom', '2025-10-24', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 2, 14, '2025-10-23 15:25:16', '', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (17:15-19:15)'),
(44, 5, NULL, 'Lịch tư vấn 2025-10-25', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-25', '15:10:00', '15:10:00', '17:10:00', 'Chờ xử lý', '1', 3, 34, '2025-10-23 14:54:49', '', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (15:10-17:10)'),
(45, 5, NULL, 'Lịch tư vấn 2025-10-25', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-25', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 2, 34, '2025-10-23 15:07:21', '', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)'),
(46, 5, 15, 'Lịch tư vấn 2025-10-31', 'sadgfhj', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-25', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '2', 2, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'sadgfhj'),
(47, 5, NULL, 'Lịch tư vấn 2025-10-30', 'sadgfhj', 'Tư vấn tuyển sinh', 'Zoom', '2025-10-30', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'sadgfhj'),
(48, 5, 15, 'Lịch tư vấn 2025-11-01', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (09:05-11:05)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-11-24', '09:05:00', '09:05:00', '11:05:00', 'Đã đặt lịch', '2', 2, 6, '2025-10-28 15:57:26', '12345', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (09:05-11:05)'),
(49, 5, 33, 'Lịch tư vấn 2025-11-01', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)', 'Tư vấn tuyển sinh', 'Google Meet', '2025-11-30', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '2', 2, 6, '2025-10-29 15:07:44', NULL, 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (13:05-15:05)'),
(50, 5, NULL, 'Lịch tư vấn 2025-11-04', '1234', 'Tư vấn tuyển sinh', 'Google Meet', '2025-11-04', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 3, 6, '2025-11-08 16:15:11', 'dsgdfg', 'http://localhost:5173/consultant/schedule', '1234'),
(51, 5, NULL, 'Lịch tư vấn 2025-10-31', '1234567', 'Tư vấn tuyển sinh', 'Google Meet', '2025-10-31', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 3, 6, '2025-11-08 16:22:17', 'Không nêu lý do', 'http://localhost:5173/consultant/schedule', '1234567'),
(52, 5, 15, 'Lịch tư vấn 2025-11-04', '1234678', 'Tư vấn tuyển sinh', 'Microsoft Teams', '2025-11-04', '15:10:00', '15:10:00', '17:10:00', 'Đã đặt lịch', '2', 2, 6, '2025-11-01 08:26:55', '', 'http://localhost:5173/consultant/schedule', '1234678'),
(53, 5, NULL, 'Lịch tư vấn 2025-11-04', '1234678', 'Tư vấn tuyển sinh', 'Microsoft Teams', '2025-11-04', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', '1234678'),
(54, 5, 15, 'Lịch tư vấn 2025-11-05', '7890', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-05', '09:05:00', '09:05:00', '11:05:00', 'Đã đặt lịch', '2', 2, 6, '2025-11-04 13:00:35', '', 'http://localhost:5173/consultant/schedule', '7890'),
(55, 5, 15, 'Lịch tư vấn 2025-11-06', '7890', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-06', '09:05:00', '09:05:00', '11:05:00', 'Đã đặt lịch', '2', 2, 6, '2025-11-04 15:12:05', '', 'http://localhost:5173/consultant/schedule', '7890'),
(56, 5, NULL, 'Lịch tư vấn 2025-11-06', '890', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-06', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 2, 6, '2025-11-04 15:43:32', '', 'http://localhost:5173/consultant/schedule', '890'),
(57, 5, 15, 'Lịch tư vấn 2025-11-06', '890', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-06', '15:10:00', '15:10:00', '17:10:00', 'Đã đặt lịch', '2', 2, 6, '2025-11-04 15:43:32', '', 'http://localhost:5173/consultant/schedule', '890'),
(58, 5, NULL, 'Lịch tư vấn 2025-11-06', '890', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-06', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 2, 6, '2025-11-04 15:43:32', '', 'http://localhost:5173/consultant/schedule', '890'),
(59, 5, 15, 'Lịch tư vấn 2025-11-14', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (07:00-09:00)', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-14', '07:00:00', '07:00:00', '09:00:00', 'Đã đặt lịch', '2', 2, 6, '2025-11-08 16:25:29', '1234', 'http://localhost:5173/consultant/schedule', 'Lịch tư vấn trống - Quý 4 (Tháng 10-12) 2025 (07:00-09:00)'),
(60, 5, NULL, 'Lịch tư vấn 2025-11-14', 'dfdf', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-14', '13:05:00', '13:05:00', '15:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'dfdf'),
(61, 5, NULL, 'Lịch tư vấn 2025-11-14', 'dfdf', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-14', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 1, NULL, NULL, NULL, 'http://localhost:5173/consultant/schedule', 'dfdf'),
(62, 5, NULL, 'Lịch tư vấn 2025-11-23', 'dfghjkl', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-23', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 2, 6, '2025-11-22 11:01:32', '', 'http://localhost:5173/consultant/schedule', 'dfghjkl'),
(63, 5, NULL, 'Lịch tư vấn 2025-11-23', 'dfghjkl', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-23', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 3, 6, '2025-11-22 10:32:53', '123456', 'http://localhost:5173/consultant/schedule', 'dfghjkl'),
(64, 5, NULL, 'Lịch tư vấn 2025-11-24', 'dfghjkl', 'Tư vấn tuyển sinh', 'Zoom', '2025-11-24', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 2, 6, '2025-11-22 10:34:06', 'sfd', 'http://localhost:5173/consultant/schedule', 'dfghjkl'),
(65, 5, NULL, 'Lịch tư vấn 2025-12-06', 'sfd', 'Tư vấn tuyển sinh', 'Google Meet', '2025-12-06', '17:15:00', '17:15:00', '19:15:00', 'Chờ xử lý', '1', 2, 6, '2025-12-05 03:08:13', '', 'http://localhost:5173/consultant/schedule', 'sfd'),
(66, 5, NULL, 'Lịch tư vấn 2025-12-07', 'sfd', 'Tư vấn tuyển sinh', 'Google Meet', '2025-12-07', '07:00:00', '07:00:00', '09:00:00', 'Chờ xử lý', '1', 2, 6, '2025-12-05 03:08:13', '', 'http://localhost:5173/consultant/schedule', 'sfd'),
(67, 5, NULL, 'Lịch tư vấn 2025-12-07', 'sfd', 'Tư vấn tuyển sinh', 'Google Meet', '2025-12-07', '09:05:00', '09:05:00', '11:05:00', 'Chờ xử lý', '1', 2, 6, '2025-12-05 03:08:13', '', 'http://localhost:5173/consultant/schedule', 'sfd');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mon_hoc`
--

CREATE TABLE `mon_hoc` (
  `idmonhoc` int(11) NOT NULL,
  `ma_mon_hoc` varchar(20) NOT NULL COMMENT 'Mã môn học (VD: TOAN, VAN, ANH)',
  `ten_mon_hoc` varchar(255) NOT NULL COMMENT 'Tên môn học',
  `ten_viet_tat` varchar(50) DEFAULT NULL COMMENT 'Tên viết tắt (VD: Toán, Văn, T.Anh)',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục môn học';

--
-- Đang đổ dữ liệu cho bảng `mon_hoc`
--

INSERT INTO `mon_hoc` (`idmonhoc`, `ma_mon_hoc`, `ten_mon_hoc`, `ten_viet_tat`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 'TOAN', 'Toán', 'Toán', 1, NULL, NULL),
(2, 'VAN', 'Ngữ văn', 'Văn', 1, NULL, NULL),
(3, 'ANH', 'Tiếng Anh', 'T.Anh', 1, NULL, NULL),
(4, 'SU', 'Lịch sử', 'Sử', 1, NULL, NULL),
(5, 'DIA', 'Địa lý', 'Địa', 1, NULL, NULL),
(6, 'GDKTPL', 'Giáo dục kinh tế và pháp luật', 'GDKTPL', 1, NULL, NULL),
(7, 'LI', 'Vật lý', 'Lí', 1, NULL, NULL),
(8, 'HOA', 'Hóa học', 'Hóa', 1, NULL, NULL),
(9, 'SINH', 'Sinh học', 'Sinh', 1, NULL, NULL),
(10, 'TIN', 'Tin học', 'Tin học', 1, NULL, NULL),
(11, 'CN', 'Công nghệ', 'Công nghệ', 1, NULL, NULL),
(12, 'GDQPAN', 'GD Quốc phòng & An ninh', 'GDQPAN', 1, '2025-11-30 11:12:43', '2025-11-30 11:13:42');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mon_thi_tot_nghiep`
--

CREATE TABLE `mon_thi_tot_nghiep` (
  `idmonthi` int(11) NOT NULL,
  `ma_mon_thi` varchar(20) NOT NULL COMMENT 'Mã môn thi (VAN, TOAN, TU_CHON_1, TU_CHON_2, NGOAI_NGU)',
  `ten_mon_thi` varchar(100) NOT NULL COMMENT 'Tên môn thi',
  `loai_mon` enum('BAT_BUOC','TU_CHON','NGOAI_NGU') DEFAULT 'BAT_BUOC' COMMENT 'Loại môn: Bắt buộc, Tự chọn, Ngoại ngữ',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `nam_ap_dung` int(4) DEFAULT 2025 COMMENT 'Năm áp dụng',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh sách môn thi tốt nghiệp THPT';

--
-- Đang đổ dữ liệu cho bảng `mon_thi_tot_nghiep`
--

INSERT INTO `mon_thi_tot_nghiep` (`idmonthi`, `ma_mon_thi`, `ten_mon_thi`, `loai_mon`, `trang_thai`, `nam_ap_dung`, `created_at`, `updated_at`) VALUES
(1, 'VAN', 'Ngữ văn', 'BAT_BUOC', 1, 2025, NULL, NULL),
(2, 'TOAN', 'Toán', 'BAT_BUOC', 1, 2025, NULL, NULL),
(4, 'TU_CHON_1', 'Tự chọn 1', 'TU_CHON', 1, 2025, NULL, NULL),
(5, 'TU_CHON_2', 'Tự chọn 2', 'TU_CHON', 1, 2025, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nganhhoc`
--

CREATE TABLE `nganhhoc` (
  `idnganh` int(11) NOT NULL,
  `idnhomnganh` int(11) DEFAULT NULL,
  `manganh` varchar(20) NOT NULL,
  `tennganh` varchar(200) NOT NULL,
  `capdo` varchar(50) DEFAULT NULL,
  `bangcap` varchar(100) DEFAULT NULL,
  `motanganh` text DEFAULT NULL,
  `mucluong` varchar(100) DEFAULT NULL,
  `xuhuong` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nganhhoc`
--

INSERT INTO `nganhhoc` (`idnganh`, `idnhomnganh`, `manganh`, `tennganh`, `capdo`, `bangcap`, `motanganh`, `mucluong`, `xuhuong`) VALUES
(27, NULL, '7480201', 'Công nghệ thông tin', 'Đại học', 'Cử nhân', 'Phát triển phần mềm', '15-30 triệu', 'Nhu cầu cao'),
(28, 1, '7480101', 'Khoa học máy tính', 'Đại học', 'Cử nhân', 'Thuật toán, lập trình, nghiên cứu máy tính', '15-35 triệu', 'Tăng mạnh'),
(29, NULL, '7480103', 'Khoa học dữ liệu', 'Đại học', 'Cử nhân', 'Phân tích dữ liệu và AI', '20-40 triệu', 'Rất nóng'),
(30, 1, '7480104', 'Hệ thống thông tin', 'Đại học', 'Cử nhân', 'Phân tích, thiết kế, quản lý hệ thống thông tin', '12-25 triệu', 'Ổn định'),
(31, 1, '7480207', 'Trí tuệ nhân tạo', 'Đại học', 'Cử nhân', 'AI, machine learning, xử lý dữ liệu lớn', '20-50 triệu', 'Rất nóng'),
(32, NULL, '7480202', 'An toàn thông tin', 'Đại học', 'Cử nhân', 'Bảo mật và an toàn dữ liệu', '15-35 triệu', 'Tăng nhanh'),
(33, NULL, '7720101', 'Y khoa', 'Đại học', 'Bác sĩ', 'Khám và điều trị bệnh', '25-50 triệu', 'Luôn cao'),
(34, NULL, '7720201', 'Dược học', 'Đại học', 'Dược sĩ', 'Nghiên cứu và sản xuất thuốc', '20-40 triệu', 'Rất cao'),
(35, 2, '7720501', 'Răng - Hàm - Mặt', 'Đại học', 'Bác sĩ', 'Nha khoa', '20-50 triệu', 'Ổn định'),
(36, 2, '7720301', 'Điều dưỡng', 'Đại học', 'Cử nhân', 'Chăm sóc bệnh nhân', '10-20 triệu', 'Ổn định'),
(37, 2, '7720601', 'Kỹ thuật xét nghiệm y học', 'Đại học', 'Cử nhân', 'Xét nghiệm lâm sàng', '10-18 triệu', 'Ổn định'),
(38, 2, '7720701', 'Y tế công cộng', 'Đại học', 'Cử nhân', 'Chăm sóc sức khỏe cộng đồng', '10-20 triệu', 'Ổn định'),
(39, NULL, '7340101', 'Quản trị kinh doanh', 'Đại học', 'Cử nhân', 'Quản trị doanh nghiệp', '12-25 triệu', 'Ổn định'),
(40, 3, '7310101', 'Kinh tế', 'Đại học', 'Cử nhân', 'Phân tích, hoạch định chính sách kinh tế', '12-25 triệu', 'Cao'),
(41, 3, '7340115', 'Marketing', 'Đại học', 'Cử nhân', 'Truyền thông, quảng cáo, thị trường', '12-30 triệu', 'Rất cao'),
(42, 3, '7340301', 'Kế toán', 'Đại học', 'Cử nhân', 'Tài chính - kế toán - kiểm toán', '12-25 triệu', 'Ổn định'),
(43, NULL, '7340201', 'Tài chính – Ngân hàng', 'Đại học', 'Cử nhân', 'Quản lý tài chính và đầu tư', '15-30 triệu', 'Ổn định'),
(44, 3, '7340120', 'Kinh doanh quốc tế', 'Đại học', 'Cử nhân', 'Thương mại, xuất nhập khẩu', '15-35 triệu', 'Tăng'),
(45, 4, '7520103', 'Kỹ thuật cơ khí', 'Đại học', 'Kỹ sư', 'Thiết kế, vận hành máy móc', '12-25 triệu', 'Ổn định'),
(46, 4, '7520201', 'Kỹ thuật điện', 'Đại học', 'Kỹ sư', 'Thiết kế & vận hành hệ thống điện', '12-28 triệu', 'Ổn định'),
(47, NULL, '7580201', 'Kiến trúc', 'Đại học', 'Kiến trúc sư', 'Thiết kế công trình xây dựng', '18-35 triệu', 'Tăng'),
(48, 4, '7510205', 'Công nghệ kỹ thuật ô tô', 'Đại học', 'Kỹ sư', 'Bảo trì, thiết kế, vận hành ô tô', '12-28 triệu', 'Tăng'),
(49, 4, '7520216', 'Kỹ thuật điều khiển & tự động hóa', 'Đại học', 'Kỹ sư', 'Tự động hóa sản xuất, robotics', '15-35 triệu', 'Rất cao'),
(50, 4, '7540101', 'Công nghệ thực phẩm', 'Đại học', 'Kỹ sư', 'Chế biến & kiểm định thực phẩm', '12-20 triệu', 'Ổn định'),
(51, 5, '7220201', 'Ngôn ngữ Anh', 'Đại học', 'Cử nhân', 'Dịch thuật, giảng dạy, truyền thông', '10-20 triệu', 'Cao'),
(52, 5, '7220204', 'Ngôn ngữ Trung Quốc', 'Đại học', 'Cử nhân', 'Phiên dịch, giao thương', '12-25 triệu', 'Tăng'),
(53, 5, '7220209', 'Ngôn ngữ Nhật', 'Đại học', 'Cử nhân', 'Phiên dịch, làm tại DN Nhật', '12-30 triệu', 'Tăng mạnh'),
(54, 5, '7220210', 'Ngôn ngữ Hàn', 'Đại học', 'Cử nhân', 'Phiên dịch, làm tại DN Hàn', '12-28 triệu', 'Tăng'),
(55, 5, '7310206', 'Quan hệ quốc tế', 'Đại học', 'Cử nhân', 'Ngoại giao, chính trị, phân tích quốc tế', '15-35 triệu', 'Ổn định'),
(56, 5, '7220211', 'Biên - Phiên dịch', 'Đại học', 'Cử nhân', 'Dịch thuật chuyên nghiệp', '12-25 triệu', 'Cao'),
(57, 3, '7310106', 'Kinh tế đối ngoại', 'Đại học', 'Cử nhân', 'Thương mại, xuất nhập khẩu, quan hệ kinh tế quốc tế', '15-35 triệu', 'Tăng'),
(58, 5, '7380101', 'Luật', 'Đại học', 'Cử nhân', 'Pháp luật, tư pháp, luật kinh tế', '12-25 triệu', 'Ổn định'),
(59, 5, '7140209', 'Sư phạm Toán học', 'Đại học', 'Cử nhân', 'Đào tạo giáo viên Toán', '10-20 triệu', 'Ổn định'),
(60, 4, '7520112', 'Kỹ thuật xây dựng công trình giao thông', 'Đại học', 'Kỹ sư', 'Xây dựng cầu đường, hạ tầng giao thông', '12-25 triệu', 'Ổn định'),
(61, 1, '7480106', 'Kỹ thuật máy tính', 'Đại học', 'Kỹ sư', 'Phần cứng, kiến trúc máy tính, nhúng', '15-35 triệu', 'Tăng'),
(62, 1, '7480102', 'Truyền thông và mạng máy tính', 'Đại học', 'Cử nhân', 'Thiết kế/vận hành mạng, an ninh hạ tầng', '15-30 triệu', 'Ổn định'),
(63, 1, '7480109', 'Khoa học dữ liệu', 'Đại học', 'Cử nhân', 'Khai phá dữ liệu, học máy, phân tích dự báo', '18-45 triệu', 'Rất cao'),
(64, 1, '7480205', 'Mạng máy tính và truyền thông dữ liệu', 'Đại học', 'Cử nhân', 'Hệ thống mạng, truyền dẫn, tối ưu hiệu năng', '15-32 triệu', 'Ổn định'),
(65, 1, '7480206', 'Internet vạn vật (IoT) và hệ thống nhúng', 'Đại học', 'Kỹ sư', 'IoT, cảm biến, gateway, embedded', '15-35 triệu', 'Tăng'),
(66, 1, '7480112', 'Khoa học máy tính ứng dụng', 'Đại học', 'Cử nhân', 'AI ứng dụng, tối ưu hoá, mô phỏng', '18-40 triệu', 'Tăng'),
(67, 2, '7720115', 'Y học cổ truyền', 'Đại học', 'Bác sĩ', 'Khám chữa bệnh theo y học cổ truyền', '12-30 triệu', 'Ổn định'),
(68, 2, '7720110', 'Y học dự phòng', 'Đại học', 'Bác sĩ', 'Phòng chống dịch, sức khoẻ cộng đồng', '12-28 triệu', 'Tăng'),
(69, 2, '7720401', 'Dinh dưỡng', 'Đại học', 'Cử nhân', 'Dinh dưỡng lâm sàng & cộng đồng', '10-22 triệu', 'Ổn định'),
(70, 2, '7720602', 'Kỹ thuật hình ảnh y học', 'Đại học', 'Cử nhân', 'X-quang, CT, MRI', '10-22 triệu', 'Ổn định'),
(71, 2, '7720603', 'Kỹ thuật phục hồi chức năng', 'Đại học', 'Cử nhân', 'Vật lý trị liệu, PHCN', '10-22 triệu', 'Ổn định'),
(72, 2, '7720604', 'Vật lý y khoa', 'Đại học', 'Cử nhân', 'Ứng dụng vật lý trong chẩn đoán và xạ trị', '12-25 triệu', 'Tăng'),
(73, 2, '7720502', 'Kỹ thuật phục hình răng', 'Đại học', 'Cử nhân', 'Chế tác phục hình răng', '12-25 triệu', 'Ổn định'),
(74, 2, '7720302', 'Hộ sinh', 'Đại học', 'Cử nhân', 'Chăm sóc sức khoẻ sinh sản', '10-20 triệu', 'Ổn định'),
(75, 3, '7340404', 'Quản trị nhân lực', 'Đại học', 'Cử nhân', 'Tuyển dụng, C&B, L&D, chiến lược nhân sự', '12-28 triệu', 'Cao'),
(76, 3, '7340114', 'Thương mại quốc tế', 'Đại học', 'Cử nhân', 'Xuất nhập khẩu, logistics thương mại', '12-30 triệu', 'Tăng'),
(77, 3, '7340121', 'Kinh doanh thương mại', 'Đại học', 'Cử nhân', 'Bán lẻ, phân phối, quản trị kênh', '12-28 triệu', 'Ổn định'),
(78, 3, '7340118', 'Bất động sản', 'Đại học', 'Cử nhân', 'Đầu tư, môi giới, thẩm định giá', '12-35 triệu', 'Tăng'),
(79, NULL, '7310401', 'Tâm lý học', 'Đại học', 'Cử nhân', 'Tham vấn và trị liệu tâm lý', '12-20 triệu', 'Ổn định'),
(80, 3, '7310205', 'Kinh tế phát triển', 'Đại học', 'Cử nhân', 'Phát triển kinh tế vùng/ngành', '12-25 triệu', 'Ổn định'),
(81, NULL, '7520207', 'Kỹ thuật điện tử viễn thông', 'Đại học', 'Kỹ sư', 'Thiết kế hệ thống truyền thông', '18-32 triệu', 'Tăng mạnh'),
(82, 4, '7520115', 'Kỹ thuật nhiệt', 'Đại học', 'Kỹ sư', 'Nhiệt – lạnh, điều hoà, năng lượng', '12-28 triệu', 'Ổn định'),
(83, 4, '7520301', 'Kỹ thuật hoá học', 'Đại học', 'Kỹ sư', 'Công nghệ hoá, vật liệu, quy trình', '12-30 triệu', 'Ổn định'),
(84, 4, '7520309', 'Kỹ thuật vật liệu', 'Đại học', 'Kỹ sư', 'VL kim loại, polymer, gốm, compozit', '12-28 triệu', 'Tăng nhẹ'),
(85, 4, '7540201', 'Công nghệ dệt, may', 'Đại học', 'Kỹ sư', 'CN dệt, thiết kế & quản lý sản xuất may', '10-22 triệu', 'Ổn định'),
(86, 4, '7520320', 'Kỹ thuật môi trường', 'Đại học', 'Kỹ sư', 'Xử lý nước/khí thải, môi trường công nghiệp', '12-25 triệu', 'Tăng'),
(87, 4, '7520501', 'Kỹ thuật địa chất', 'Đại học', 'Kỹ sư', 'Địa chất công trình, tài nguyên', '12-25 triệu', 'Ổn định'),
(88, 4, '7520503', 'Kỹ thuật trắc địa – bản đồ', 'Đại học', 'Kỹ sư', 'Đo đạc, GIS, bản đồ số', '12-25 triệu', 'Ổn định'),
(89, 4, '7520604', 'Kỹ thuật dầu khí', 'Đại học', 'Kỹ sư', 'Thăm dò, khai thác, chế biến dầu khí', '15-35 triệu', 'Ổn định'),
(90, 5, '7220203', 'Ngôn ngữ Pháp', 'Đại học', 'Cử nhân', 'Biên phiên dịch, du lịch, ngoại giao', '10-20 triệu', 'Ổn định'),
(91, 5, '7220202', 'Ngôn ngữ Nga', 'Đại học', 'Cử nhân', 'Biên phiên dịch, năng lượng, kỹ thuật', '10-18 triệu', 'Ổn định'),
(92, 5, '7220205', 'Ngôn ngữ Đức', 'Đại học', 'Cử nhân', 'Biên phiên dịch, DN Đức tại VN', '12-22 triệu', 'Tăng'),
(93, 5, '7220206', 'Ngôn ngữ Ý', 'Đại học', 'Cử nhân', 'Du lịch, văn hoá, truyền thông', '10-18 triệu', 'Ổn định'),
(94, 5, '7220213', 'Ngôn ngữ Tây Ban Nha', 'Đại học', 'Cử nhân', 'Biên phiên dịch, ngoại giao, thương mại', '10-18 triệu', 'Ổn định'),
(95, 5, '7310608', 'Đông phương học', 'Đại học', 'Cử nhân', 'Văn hoá – xã hội các nước phương Đông', '10-20 triệu', 'Ổn định'),
(96, 5, '7310612', 'Trung Quốc học', 'Đại học', 'Cử nhân', 'Văn hoá, kinh tế, xã hội Trung Quốc', '10-22 triệu', 'Tăng'),
(97, 5, '7310613', 'Nhật Bản học', 'Đại học', 'Cử nhân', 'Văn hoá, kinh tế, xã hội Nhật Bản', '12-25 triệu', 'Tăng'),
(98, 5, '7310614', 'Hàn Quốc học', 'Đại học', 'Cử nhân', 'Văn hoá, kinh tế, xã hội Hàn Quốc', '12-25 triệu', 'Tăng'),
(99, 6, '7320101', 'Báo chí', 'Đại học', 'Cử nhân', 'Phóng viên, biên tập, sản xuất nội dung', '10-20 triệu', 'Ổn định'),
(100, 6, '7320104', 'Truyền thông đa phương tiện', 'Đại học', 'Cử nhân', 'Thiết kế nội dung số, media, UX video', '12-25 triệu', 'Tăng'),
(101, 6, '7320108', 'Quan hệ công chúng (PR)', 'Đại học', 'Cử nhân', 'PR, sự kiện, quản trị thương hiệu', '12-28 triệu', 'Cao'),
(102, 6, '7210403', 'Thiết kế đồ hoạ', 'Đại học', 'Cử nhân', 'Branding, UI/UX, minh hoạ', '12-30 triệu', 'Rất cao'),
(103, 6, '7210404', 'Thiết kế thời trang', 'Đại học', 'Cử nhân', 'Thiết kế, sản xuất, kinh doanh thời trang', '12-25 triệu', 'Ổn định'),
(104, 6, '7210234', 'Công nghệ điện ảnh – truyền hình', 'Đại học', 'Cử nhân', 'Quay phim, dựng, kỹ xảo', '12-25 triệu', 'Tăng'),
(105, 7, '7340122', 'Thương mại điện tử', 'Đại học', 'Cử nhân', 'E-commerce, vận hành sàn, digital commerce', '12-28 triệu', 'Rất cao'),
(106, 7, '7510605', 'Logistics và quản lý chuỗi cung ứng', 'Đại học', 'Kỹ sư/Cử nhân', 'Vận tải, kho bãi, tối ưu chuỗi', '12-30 triệu', 'Rất cao'),
(107, 7, '7340204', 'Bảo hiểm – Tài chính', 'Đại học', 'Cử nhân', 'Bảo hiểm nhân thọ/phi nhân thọ, định phí', '12-25 triệu', 'Ổn định'),
(108, 7, '7340402', 'Quản trị khách sạn', 'Đại học', 'Cử nhân', 'Vận hành khách sạn, resort', '10-22 triệu', 'Phục hồi'),
(109, 7, '7810201', 'Quản trị dịch vụ du lịch và lữ hành', 'Đại học', 'Cử nhân', 'Điều hành tour, hướng dẫn, điều phối', '10-22 triệu', 'Ổn định'),
(110, 8, '7520401', 'Kỹ thuật năng lượng', 'Đại học', 'Kỹ sư', 'Thiết kế/vận hành hệ thống năng lượng', '12-28 triệu', 'Tăng'),
(111, 8, '7520402', 'Năng lượng tái tạo', 'Đại học', 'Kỹ sư', 'Điện gió, điện mặt trời, lưu trữ năng lượng', '12-30 triệu', 'Rất cao'),
(112, 8, '7850101', 'Quản lý tài nguyên và môi trường', 'Đại học', 'Cử nhân', 'Quản lý môi trường, tài nguyên thiên nhiên', '10-22 triệu', 'Tăng'),
(113, 8, '7510406', 'Công nghệ kỹ thuật môi trường', 'Đại học', 'Kỹ sư', 'Công nghệ xử lý chất thải, tuần hoàn', '12-25 triệu', 'Tăng'),
(114, 8, '7440301', 'Khoa học môi trường', 'Đại học', 'Cử nhân', 'Đánh giá tác động, quan trắc môi trường', '10-20 triệu', 'Ổn định'),
(115, 1, '7480210', 'Kỹ thuật trí tuệ nhân tạo ứng dụng', 'Đại học', 'Cử nhân', 'Phát triển giải pháp AI ứng dụng trong doanh nghiệp', '18-45 triệu', 'Rất cao'),
(116, 1, '7480211', 'Khoa học dữ liệu và phân tích kinh doanh', 'Đại học', 'Cử nhân', 'Phân tích dữ liệu hỗ trợ quyết định kinh doanh', '18-40 triệu', 'Cao'),
(117, 1, '7480212', 'An ninh mạng nâng cao', 'Đại học', 'Cử nhân', 'Phòng thủ, điều tra số, quản trị rủi ro an ninh', '18-38 triệu', 'Tăng'),
(118, 1, '7480213', 'Điện toán đám mây và hạ tầng số', 'Đại học', 'Cử nhân', 'Thiết kế vận hành hệ thống cloud, container, CI/CD', '18-40 triệu', 'Rất cao'),
(119, 1, '7480214', 'Kỹ thuật robot và tự hành (định hướng phần mềm)', 'Đại học', 'Cử nhân', 'Lập trình robot, thị giác máy tính, điều khiển', '18-40 triệu', 'Tăng'),
(120, 1, '7480215', 'Thiết kế trải nghiệm số (UX Engineering)', 'Đại học', 'Cử nhân', 'Kết hợp UX, frontend hiện đại và analytics', '15-30 triệu', 'Tăng'),
(121, 2, '7720112', 'Y học gia đình', 'Đại học', 'Bác sĩ', 'Chăm sóc sức khoẻ ban đầu, quản lý bệnh mạn tính', '12-28 triệu', 'Ổn định'),
(122, 2, '7720303', 'Điều dưỡng nha khoa', 'Đại học', 'Cử nhân', 'Chăm sóc người bệnh trong lĩnh vực răng–hàm–mặt', '10-20 triệu', 'Ổn định'),
(123, 2, '7720402', 'Khoa học sức khỏe', 'Đại học', 'Cử nhân', 'Nghiên cứu, thống kê y học và quản lý sức khoẻ', '10-22 triệu', 'Tăng'),
(124, 2, '7720498', 'Quản lý bệnh viện', 'Đại học', 'Cử nhân', 'Quản trị vận hành bệnh viện, chất lượng y tế', '12-25 triệu', 'Tăng'),
(125, 2, '7720605', 'Công nghệ y học tái tạo', 'Đại học', 'Cử nhân', 'Vật liệu sinh học, y học tái tạo', '12-25 triệu', 'Mới nổi'),
(126, 2, '7720801', 'Tin học y tế (Health Informatics)', 'Đại học', 'Cử nhân', 'Hồ sơ bệnh án điện tử, phân tích dữ liệu y tế', '12-28 triệu', 'Tăng'),
(127, 3, '7340405', 'Hệ thống thông tin quản lý', 'Đại học', 'Cử nhân', 'Phân tích quy trình, ERP, chuyển đổi số DN', '12-28 triệu', 'Cao'),
(128, 3, '7340408', 'Quản trị chất lượng', 'Đại học', 'Cử nhân', 'ISO, Six Sigma, cải tiến liên tục', '12-26 triệu', 'Ổn định'),
(129, 3, '7340123', 'Kinh doanh số', 'Đại học', 'Cử nhân', 'Mô hình số, nền tảng, phân tích hành vi', '12-28 triệu', 'Tăng'),
(130, 3, '7340117', 'Thẩm định giá', 'Đại học', 'Cử nhân', 'Định giá tài sản, BĐS, máy móc thiết bị', '12-30 triệu', 'Tăng'),
(131, 3, '7340208', 'Tài chính công nghệ (FinTech)', 'Đại học', 'Cử nhân', 'Sản phẩm tài chính số, thanh toán, blockchain', '15-35 triệu', 'Rất cao'),
(132, 3, '7310415', 'Quản lý công', 'Đại học', 'Cử nhân', 'Chính sách công, quản trị địa phương', '12-25 triệu', 'Ổn định'),
(133, 4, '7520114', 'Kỹ thuật cơ điện tử', 'Đại học', 'Kỹ sư', 'Cơ khí + điện – điện tử + điều khiển', '15-32 triệu', 'Cao'),
(134, 4, '7520120', 'Kỹ thuật hàng không', 'Đại học', 'Kỹ sư', 'Khí động lực, kết cấu, bảo trì tàu bay', '18-40 triệu', 'Tăng'),
(135, 4, '7520126', 'Kỹ thuật robot', 'Đại học', 'Kỹ sư', 'Robot công nghiệp, dịch vụ, tự hành', '18-40 triệu', 'Tăng'),
(136, 4, '7520312', 'Công nghệ vật liệu nano', 'Đại học', 'Kỹ sư', 'Vật liệu tiên tiến, nano–composite', '15-32 triệu', 'Mới nổi'),
(137, 4, '7520325', 'Kỹ thuật in 3D và sản xuất bồi đắp', 'Đại học', 'Kỹ sư', 'Công nghệ AM, thiết kế – chế tạo nhanh', '15-30 triệu', 'Tăng'),
(138, 4, '7520504', 'Địa kỹ thuật và nền móng', 'Đại học', 'Kỹ sư', 'Địa kỹ thuật, xử lý nền, ổn định công trình', '12-28 triệu', 'Ổn định'),
(139, 5, '7220207', 'Ngôn ngữ Thái Lan', 'Đại học', 'Cử nhân', 'Biên – phiên dịch, du lịch, thương mại', '10-18 triệu', 'Ổn định'),
(140, 5, '7220212', 'Ngôn ngữ Bồ Đào Nha', 'Đại học', 'Cử nhân', 'Dịch thuật, thương mại, ngoại giao', '10-18 triệu', 'Mới'),
(141, 5, '7220214', 'Ngôn ngữ Ả Rập', 'Đại học', 'Cử nhân', 'Ngoại giao, dầu khí, thương mại Trung Đông', '10-20 triệu', 'Ngách'),
(142, 5, '7310601', 'Quốc tế học', 'Đại học', 'Cử nhân', 'Quan hệ quốc tế, khu vực học, toàn cầu hoá', '12-25 triệu', 'Ổn định'),
(143, 5, '7310630', 'Việt Nam học', 'Đại học', 'Cử nhân', 'Văn hoá – du lịch – nghiên cứu Việt Nam', '10-20 triệu', 'Ổn định'),
(144, 5, '7310617', 'Châu Âu học', 'Đại học', 'Cử nhân', 'Lịch sử, chính trị, kinh tế châu Âu', '10-20 triệu', 'Ngách'),
(145, 6, '7320110', 'Quảng cáo', 'Đại học', 'Cử nhân', 'Sáng tạo, media planning, digital ads', '12-28 triệu', 'Cao'),
(146, 6, '7320115', 'Truyền thông số', 'Đại học', 'Cử nhân', 'Nội dung số, social, data-driven content', '12-28 triệu', 'Rất cao'),
(147, 6, '7210205', 'Sản xuất âm nhạc', 'Đại học', 'Cử nhân', 'Thu âm, phối khí, công nghệ âm thanh', '12-25 triệu', 'Tăng'),
(148, 6, '7210407', 'Thiết kế UI/UX', 'Đại học', 'Cử nhân', 'Thiết kế trải nghiệm và giao diện số', '15-30 triệu', 'Rất cao'),
(149, 6, '7210406', 'Minh hoạ số', 'Đại học', 'Cử nhân', 'Minh hoạ, concept art, xuất bản số', '12-25 triệu', 'Tăng'),
(150, 6, '7320111', 'Quản trị truyền thông', 'Đại học', 'Cử nhân', 'Chiến lược truyền thông, quản trị khủng hoảng', '12-26 triệu', 'Ổn định'),
(151, 7, '7340124', 'Quản trị bán lẻ', 'Đại học', 'Cử nhân', 'Vận hành cửa hàng, chuỗi bán lẻ, category', '12-26 triệu', 'Tăng'),
(152, 7, '7340125', 'Quản trị chuỗi cung ứng toàn cầu', 'Đại học', 'Cử nhân', 'Hoạch định, tối ưu chuỗi cung ứng quốc tế', '12-30 triệu', 'Rất cao'),
(153, 7, '7810103', 'Quản trị sự kiện', 'Đại học', 'Cử nhân', 'Tổ chức sự kiện, MICE, experiential', '10-22 triệu', 'Phục hồi'),
(154, 7, '7840101', 'Vận tải biển', 'Đại học', 'Cử nhân', 'Khai thác đội tàu, đại lý hàng hải', '12-28 triệu', 'Ổn định'),
(155, 7, '7340207', 'Tài chính quốc tế', 'Đại học', 'Cử nhân', 'Đầu tư quốc tế, kinh tế tiền tệ', '12-28 triệu', 'Ổn định'),
(156, 7, '7340113', 'Thương mại điện tử xuyên biên giới', 'Đại học', 'Cử nhân', 'XNK qua sàn, vận hành cross-border', '12-28 triệu', 'Tăng'),
(157, 8, '7520410', 'Kỹ thuật năng lượng gió', 'Đại học', 'Kỹ sư', 'Thiết kế, vận hành trang trại điện gió', '12-30 triệu', 'Rất cao'),
(158, 8, '7520411', 'Kỹ thuật năng lượng mặt trời', 'Đại học', 'Kỹ sư', 'Hệ thống PV, lưu trữ, inverter', '12-30 triệu', 'Rất cao'),
(159, 8, '7850102', 'Biến đổi khí hậu và phát triển bền vững', 'Đại học', 'Cử nhân', 'Thích ứng, giảm thiểu, chính sách khí hậu', '12-25 triệu', 'Tăng'),
(160, 8, '7510412', 'Quản lý chất thải rắn và kinh tế tuần hoàn', 'Đại học', 'Cử nhân', 'Thiết kế hệ thống thu gom – tái chế', '12-25 triệu', 'Tăng'),
(161, 8, '7440250', 'Khoa học Trái đất và hệ thông tin địa lý', 'Đại học', 'Cử nhân', 'Địa tin học, viễn thám, GIS môi trường', '12-25 triệu', 'Ổn định'),
(162, 8, '7520412', 'Hệ thống lưu trữ năng lượng (ESS)', 'Đại học', 'Kỹ sư', 'Ắc quy, BESS, tối ưu tích trữ cho lưới điện', '12-30 triệu', 'Mới nổi'),
(211, 1, '7480216', 'Kỹ thuật an toàn thông tin số', 'Đại học', 'Cử nhân', 'Phòng thủ số, điều tra số, quản trị rủi ro', '18-38 triệu', 'Tăng'),
(212, 1, '7480217', 'Khoa học máy tính định hướng AI', 'Đại học', 'Cử nhân', 'Nền tảng AI, học sâu, tối ưu hoá', '18-45 triệu', 'Rất cao'),
(213, 1, '7480218', 'Kỹ thuật phần mềm nhúng', 'Đại học', 'Kỹ sư', 'Phần mềm cho hệ nhúng/thiết bị thông minh', '16-35 triệu', 'Tăng'),
(214, 1, '7480219', 'Phát triển Game & Multimedia', 'Đại học', 'Cử nhân', 'Game engine, đồ họa thời gian thực', '15-32 triệu', 'Tăng'),
(215, 1, '7480220', 'Hệ thống thông tin địa lý số (Geo-IT)', 'Đại học', 'Cử nhân', 'GIS, viễn thám, bản đồ số', '15-30 triệu', 'Tăng nhẹ'),
(216, 1, '7480221', 'Blockchain và Web3', 'Đại học', 'Cử nhân', 'Hệ phân tán, hợp đồng thông minh, bảo mật', '18-40 triệu', 'Mới nổi'),
(217, 2, '7720802', 'Quản trị thông tin y tế', 'Đại học', 'Cử nhân', 'Quản lý HIS, hồ sơ bệnh án điện tử', '12-25 triệu', 'Tăng'),
(218, 2, '7720420', 'Sức khỏe tinh thần', 'Đại học', 'Cử nhân', 'Tham vấn, chăm sóc sức khỏe tâm thần', '10-22 triệu', 'Mới nổi'),
(219, 2, '7720403', 'Dinh dưỡng thể thao', 'Đại học', 'Cử nhân', 'Dinh dưỡng cho vận động viên/hiệu suất', '10-22 triệu', 'Ngách'),
(220, 2, '7720610', 'Công nghệ xét nghiệm di truyền', 'Đại học', 'Cử nhân', 'Sinh học phân tử, xét nghiệm gen', '12-25 triệu', 'Tăng'),
(221, 2, '7720203', 'Dược lâm sàng', 'Đại học', 'Dược sĩ', 'Tư vấn sử dụng thuốc, tương tác thuốc', '12-26 triệu', 'Ổn định'),
(222, 2, '7720304', 'Điều dưỡng cộng đồng', 'Đại học', 'Cử nhân', 'Chăm sóc ban đầu tại cộng đồng', '10-20 triệu', 'Ổn định'),
(223, 3, '7340126', 'Quản trị khởi nghiệp và đổi mới sáng tạo', 'Đại học', 'Cử nhân', 'Khởi nghiệp, thiết kế mô hình kinh doanh', '12-28 triệu', 'Tăng'),
(224, 3, '7340403', 'Quản trị văn phòng', 'Đại học', 'Cử nhân', 'Vận hành hành chính, số hoá quy trình', '10-20 triệu', 'Ổn định'),
(225, 3, '7340302', 'Kiểm toán', 'Đại học', 'Cử nhân', 'Kiểm toán tài chính, kiểm toán nội bộ', '12-28 triệu', 'Ổn định'),
(226, 3, '7340108', 'Quản trị dự án', 'Đại học', 'Cử nhân', 'Lập kế hoạch, giám sát, PMO', '12-28 triệu', 'Cao'),
(227, 3, '7340127', 'Thương mại số & Marketing số', 'Đại học', 'Cử nhân', 'Kinh doanh nền tảng, phân tích hành vi số', '12-30 triệu', 'Rất cao'),
(228, 3, '7310410', 'Quản lý đô thị', 'Đại học', 'Cử nhân', 'Chính sách – quy hoạch – hạ tầng đô thị', '12-25 triệu', 'Tăng nhẹ'),
(229, 4, '7520212', 'Kỹ thuật y sinh', 'Đại học', 'Kỹ sư', 'Thiết bị y tế, cảm biến sinh học', '15-32 triệu', 'Tăng'),
(230, 4, '7520140', 'Kỹ thuật cơ điện lạnh', 'Đại học', 'Kỹ sư', 'Điều hoà–lạnh, nhiệt động, HVAC', '12-28 triệu', 'Ổn định'),
(231, 4, '7520208', 'Hệ thống điện thông minh', 'Đại học', 'Kỹ sư', 'SCADA, tự động hoá lưới điện, IoT năng lượng', '15-32 triệu', 'Tăng'),
(232, 4, '7520326', 'Vật liệu sinh học', 'Đại học', 'Kỹ sư', 'Polymer sinh học, y sinh, bao bì xanh', '12-28 triệu', 'Mới nổi'),
(233, 4, '7510203', 'Công nghệ kỹ thuật cơ điện tử ô tô', 'Đại học', 'Kỹ sư', 'Cơ điện tử ứng dụng trong ô tô thông minh', '15-32 triệu', 'Tăng'),
(234, 4, '7520128', 'Kỹ thuật hạt nhân ứng dụng', 'Đại học', 'Kỹ sư', 'Đo lường hạt nhân, an toàn bức xạ', '15-30 triệu', 'Ngách'),
(235, 5, '7220215', 'Ngôn ngữ Hàn – Nhật (song ngữ)', 'Đại học', 'Cử nhân', 'Biên phiên dịch, DN Hàn–Nhật', '12-25 triệu', 'Tăng'),
(236, 5, '7220216', 'Ngôn ngữ Trung – Anh thương mại', 'Đại học', 'Cử nhân', 'Thương mại, xuất nhập khẩu song ngữ', '12-25 triệu', 'Tăng'),
(237, 5, '7220217', 'Biên dịch đa phương tiện', 'Đại học', 'Cử nhân', 'Phụ đề, lồng tiếng, nội dung số', '10-20 triệu', 'Mới nổi'),
(238, 5, '7310620', 'Châu Á học', 'Đại học', 'Cử nhân', 'Nghiên cứu khu vực châu Á', '10-20 triệu', 'Ổn định'),
(239, 5, '7310625', 'Hoa Kỳ học', 'Đại học', 'Cử nhân', 'Lịch sử, chính trị, văn hoá Hoa Kỳ', '10-20 triệu', 'Ngách'),
(240, 5, '7310635', 'Liên minh châu Âu học', 'Đại học', 'Cử nhân', 'Thể chế, kinh tế, chính sách EU', '10-20 triệu', 'Ngách'),
(241, 6, '7210408', 'Thiết kế game', 'Đại học', 'Cử nhân', 'Game art, level design, UX game', '12-28 triệu', 'Rất cao'),
(242, 6, '7210210', 'Nghệ thuật số & Hoạt hình', 'Đại học', 'Cử nhân', '2D/3D animation, VFX', '12-28 triệu', 'Tăng'),
(243, 6, '7210221', 'Đạo diễn điện ảnh', 'Đại học', 'Cử nhân', 'Đạo diễn, biên kịch, sản xuất phim', '12-30 triệu', 'Ổn định'),
(244, 6, '7320120', 'Sản xuất nội dung số', 'Đại học', 'Cử nhân', 'Content studio, podcast, video social', '12-26 triệu', 'Rất cao'),
(245, 6, '7210409', 'Thiết kế công nghiệp', 'Đại học', 'Cử nhân', 'Thiết kế sản phẩm, ergonomics', '12-28 triệu', 'Ổn định'),
(246, 6, '7320121', 'Truyền thông thương hiệu số', 'Đại học', 'Cử nhân', 'Branding, performance, dữ liệu', '12-28 triệu', 'Tăng'),
(247, 7, '7510601', 'Quản lý công nghiệp', 'Đại học', 'Kỹ sư/Cử nhân', 'Hoạch định sản xuất, tối ưu vận hành', '12-28 triệu', 'Cao'),
(248, 7, '7510603', 'Chuỗi cung ứng số', 'Đại học', 'Cử nhân', 'SCM ứng dụng IoT/AI/Blockchain', '12-30 triệu', 'Rất cao'),
(249, 7, '7810104', 'Quản trị nhà hàng', 'Đại học', 'Cử nhân', 'Vận hành F&B, tiêu chuẩn dịch vụ', '10-22 triệu', 'Phục hồi'),
(250, 7, '7840201', 'Khai thác cảng', 'Đại học', 'Cử nhân', 'Khai thác bến bãi, điều độ cảng', '12-28 triệu', 'Ổn định'),
(251, 7, '7510607', 'Logistics hàng không', 'Đại học', 'Cử nhân', 'Vận tải hàng không, kho vận, an ninh', '12-30 triệu', 'Tăng'),
(252, 7, '7840102', 'Quản lý vận tải đa phương thức', 'Đại học', 'Cử nhân', 'Kết nối đường bộ/biển/không/đường sắt', '12-28 triệu', 'Tăng'),
(253, 8, '7440302', 'Khí tượng – Thủy văn', 'Đại học', 'Cử nhân', 'Quan trắc, dự báo thời tiết – thủy văn', '10-22 triệu', 'Ổn định'),
(254, 8, '7520502', 'Địa chất dầu khí', 'Đại học', 'Kỹ sư', 'Trầm tích, địa chất dầu khí, mô phỏng mỏ', '15-32 triệu', 'Ổn định'),
(255, 8, '7520321', 'Kỹ thuật môi trường nước', 'Đại học', 'Kỹ sư', 'Cấp thoát nước, xử lý nước thải', '12-26 triệu', 'Tăng'),
(256, 8, '7850103', 'Chính sách môi trường', 'Đại học', 'Cử nhân', 'Kinh tế – luật môi trường, quản trị bền vững', '12-25 triệu', 'Tăng'),
(257, 8, '7520405', 'Lưới điện thông minh', 'Đại học', 'Kỹ sư', 'Smart grid, đo đếm thông minh, điều khiển', '15-32 triệu', 'Tăng'),
(258, 8, '7510415', 'An toàn – sức khỏe – môi trường (HSE)', 'Đại học', 'Cử nhân', 'Quản lý rủi ro, an toàn lao động, môi trường', '12-25 triệu', 'Ổn định');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nganh_theo_phuong_thuc`
--

CREATE TABLE `nganh_theo_phuong_thuc` (
  `idnganh_phuong_thuc` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `idnganhtruong` int(11) NOT NULL,
  `to_hop_mon` varchar(100) DEFAULT NULL COMMENT 'Tổ hợp môn xét tuyển (VD: A00;A01;D01;D07 hoặc Q00, K00)',
  `ghi_chu` varchar(500) DEFAULT NULL COMMENT 'Ghi chú đặc biệt',
  `loai_nganh` varchar(50) DEFAULT NULL COMMENT 'NGANH_MOI, NGANH_VIET, NGANH_QUOC_TE',
  `thu_tu` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nganh_theo_phuong_thuc`
--

INSERT INTO `nganh_theo_phuong_thuc` (`idnganh_phuong_thuc`, `idphuong_thuc_chi_tiet`, `idnganhtruong`, `to_hop_mon`, `ghi_chu`, `loai_nganh`, `thu_tu`, `created_at`, `updated_at`) VALUES
(5, 1, 159, 'B01;B00', 'fvn', 'NGANH_VIET', 1, '2025-12-01 07:50:14', '2025-12-01 08:20:08');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nganh_truong`
--

CREATE TABLE `nganh_truong` (
  `idnganhtruong` bigint(20) NOT NULL,
  `idtruong` int(11) NOT NULL,
  `manganh` varchar(20) NOT NULL,
  `hinhthuc` varchar(60) DEFAULT NULL,
  `thoiluong_nam` tinyint(4) DEFAULT NULL,
  `so_ky` tinyint(4) DEFAULT NULL,
  `tohop_xettuyen_truong` varchar(255) DEFAULT NULL,
  `hocphi_ky` int(11) DEFAULT NULL,
  `hocphi_ghichu` varchar(255) DEFAULT NULL,
  `decuong_url` varchar(255) DEFAULT NULL,
  `mota_tomtat` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `nam` year(4) DEFAULT NULL,
  `tenptxt` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nganh_truong`
--

INSERT INTO `nganh_truong` (`idnganhtruong`, `idtruong`, `manganh`, `hinhthuc`, `thoiluong_nam`, `so_ky`, `tohop_xettuyen_truong`, `hocphi_ky`, `hocphi_ghichu`, `decuong_url`, `mota_tomtat`, `created_at`, `updated_at`, `nam`, `tenptxt`) VALUES
(131, 27, '7140209', '1', 4, 8, 'A00;A01;D01', 5800000, 'Đào tạo kết hợp trực tuyến 30%', 'https://example.com/decuong/congnghe_thongtin.pdf', 'Công nghệ thông tin - Hệ thống thông tin', '2024-05-25 02:00:00', '2024-12-05 03:00:00', '2024', NULL),
(132, 27, '7220201', '1', 4, 8, 'A00;A01', 5600000, 'Thanh toán học phí theo tín chỉ', 'https://example.com/decuong/quan_tri_kinh_doanh.pdf', 'Quản trị kinh doanh - Kinh doanh số', '2024-05-25 02:10:00', '2024-12-05 03:00:00', '2025', NULL),
(133, 27, '7340301', '1', 4, 8, 'A00;D07', 5400000, 'Hỗ trợ lệ phí chứng chỉ thực hành', 'https://example.com/decuong/ke_toan.pdf', 'Kế toán - Kế toán tài chính', '2024-05-25 02:15:00', '2024-12-05 03:00:00', '2025', NULL),
(134, 27, '7340403', '1', 4, 8, NULL, 5500000, 'Chuẩn đầu ra kỹ năng phân tích HTTT', NULL, 'Hệ thống thông tin quản lý - E-Business', '2024-05-25 02:20:00', '2024-12-05 03:00:00', '2025', NULL),
(135, 27, '7310106', '1', 4, 8, NULL, 5300000, 'Tăng cường môn Phân tích dữ liệu', NULL, 'Thống kê - Khoa học dữ liệu', '2024-05-25 02:25:00', '2024-12-05 03:00:00', '2025', NULL),
(136, 27, '7480103', '1', 4, 8, NULL, 5800000, 'Thực hành tại phòng lab mạng ảo hóa', NULL, 'Kỹ thuật mạng & truyền thông', '2024-05-25 02:30:00', '2024-12-05 03:00:00', '2025', NULL),
(137, 27, '7480104', '1', 4, 8, NULL, 6000000, 'Học phần An toàn thông tin theo CEH', NULL, 'An toàn thông tin - Cybersecurity', '2024-05-25 02:35:00', '2024-12-05 03:00:00', '2025', NULL),
(138, 27, '7520114', '1', 4, 8, NULL, 5700000, 'Học phần IoT/Điện tử nhúng tùy chọn', NULL, 'Kỹ thuật điện tử - Viễn thông', '2024-05-25 02:40:00', '2024-12-05 03:00:00', '2025', NULL),
(139, 27, '7520120', '1', 4, 8, NULL, 5700000, 'Đồ án tích hợp với doanh nghiệp', NULL, 'Kỹ thuật điều khiển & Tự động hóa', '2024-05-25 02:45:00', '2024-12-05 03:00:00', '2025', NULL),
(140, 27, '7210403', '1', 4, 8, NULL, 5800000, 'Xưởng sáng tạo Media Studio', NULL, '', '2024-05-25 02:50:00', '2024-12-05 03:00:00', '2026', NULL),
(141, 27, '7580201', '1', 5, 10, NULL, 6200000, 'Chương trình 5 năm, đồ án kiến trúc', NULL, 'Kiến trúc - Kiến trúc nội thất', '2024-05-25 02:55:00', '2024-12-05 03:00:00', NULL, NULL),
(142, 27, '7510601', '1', 4, 8, NULL, 5400000, 'Phòng thí nghiệm sinh học phân tử', NULL, 'Công nghệ sinh học - Ứng dụng', '2024-05-25 03:00:00', '2024-12-05 03:00:00', NULL, NULL),
(143, 27, '7440301', '1', 4, 8, NULL, 5200000, 'Phí vật tư thí nghiệm tính riêng', NULL, 'Kỹ thuật hóa học - CN thực phẩm', '2024-05-25 03:05:00', '2024-12-05 03:00:00', NULL, NULL),
(144, 27, '7380101', '1', 4, 8, NULL, 5000000, 'Liên kết thực tập tại toà án/viện kiểm sát', NULL, 'Luật - Tố tụng hình sự', '2024-05-25 03:10:00', '2024-12-05 03:00:00', NULL, NULL),
(145, 27, '7340115', '1', 4, 8, NULL, 5600000, 'CLB học thuật IR miễn phí cho SV', NULL, 'Quan hệ quốc tế - Kinh tế đối ngoại', '2024-05-25 03:15:00', '2024-12-05 03:00:00', NULL, NULL),
(146, 27, '7340123', '1', 4, 8, NULL, 5400000, 'Học phần chuyên sâu kiểm toán', 'https://example.com/decuong/ke_toan.pdf', 'Kế toán công - Kiểm toán khu vực công', '2024-05-25 03:20:00', '2024-12-05 03:00:00', NULL, NULL),
(147, 27, '7340127', '1', 4, 8, NULL, 5400000, 'Tăng cường kỹ năng phân tích dữ liệu', 'https://example.com/decuong/ke_toan.pdf', 'Hệ thống thông tin kế toán', '2024-05-25 03:25:00', '2024-12-05 03:00:00', NULL, NULL),
(148, 27, '7340404', '1', 4, 8, NULL, 5500000, 'Lộ trình học CFA level 1 tích hợp', NULL, 'Tài chính - Đầu tư', '2024-05-25 03:30:00', '2024-12-05 03:00:00', NULL, NULL),
(149, 27, '7520201', '1', 4, 8, NULL, 5600000, 'Chuẩn CDIO, đồ án theo nhóm', NULL, 'Kỹ thuật vật liệu', '2024-05-25 03:35:00', '2024-12-05 03:00:00', NULL, NULL),
(150, 27, '7520320', '1', 4, 8, NULL, 5600000, 'Thực hành CAD/CAM nâng cao', NULL, 'Kỹ thuật cơ điện tử', '2024-05-25 03:40:00', '2024-12-05 03:00:00', NULL, NULL),
(155, 27, '7480201', 'Đại học chính quy', 4, 8, 'A00;A01;D01', 12000000, 'Học phí dự kiến mỗi kỳ (tham khảo)', '/decuong/7480201.pdf', 'Ngành Công nghệ thông tin – đào tạo kỹ sư CNTT, phần mềm, mạng...', NULL, NULL, '2025', 'Đại học CNTT chính quy'),
(156, 27, '7340101', 'Đại học chính quy', 4, 8, 'A00;A01;D01;D96', 11500000, 'Chưa bao gồm các khoản phí khác', '/decuong/7340101.pdf', 'Ngành Quản trị kinh doanh – quản trị doanh nghiệp, marketing, nhân sự...', NULL, NULL, '2025', 'Đại học QTKD chính quy'),
(157, 21, '7480201', 'Đại học chính quy', 4, 8, 'A00;A01;D01', 12500000, 'Học phí tham khảo, có thể điều chỉnh hằng năm', '/decuong/iuh/7480201.pdf', 'Ngành Công nghệ thông tin – đào tạo kỹ sư phần mềm, mạng, AI...', NULL, NULL, '2025', 'Đại học CNTT chính quy'),
(158, 21, '7340301', 'Đại học chính quy', 4, 8, 'A00;A01;D01;D07', 11000000, 'Đã bao gồm học phí luyện thi Kế toán trưởng (nếu có)', '/decuong/iuh/7340301.pdf', 'Ngành Kế toán – đào tạo cử nhân kế toán doanh nghiệp, tài chính...', NULL, NULL, '2025', 'Đại học Kế toán chính quy'),
(159, 21, '7340101', 'Đại học chính quy', 4, 8, 'A00;A01;D01;D96', 11800000, 'Mức phí ước tính, cập nhật theo học kỳ', '/decuong/iuh/7340101.pdf', 'Ngành Quản trị kinh doanh – quản trị doanh nghiệp, marketing, nhân sự...', NULL, NULL, '2025', 'Đại học QTKD chính quy');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguoidung`
--

CREATE TABLE `nguoidung` (
  `idnguoidung` int(11) NOT NULL,
  `idvaitro` int(11) NOT NULL,
  `idnhomnganh` int(11) DEFAULT NULL,
  `taikhoan` varchar(100) NOT NULL,
  `matkhau` varchar(255) NOT NULL,
  `email` varchar(150) DEFAULT NULL,
  `hinhdaidien` varchar(255) DEFAULT NULL COMMENT 'Đường dẫn hình đại diện',
  `gioithieu` text DEFAULT NULL COMMENT 'Giới thiệu bản thân',
  `hoten` varchar(200) NOT NULL,
  `sodienthoai` varchar(20) DEFAULT NULL,
  `diachi` text DEFAULT NULL,
  `ngaysinh` date DEFAULT NULL,
  `gioitinh` enum('Nam','Nữ','Khác') DEFAULT NULL,
  `trangthai` tinyint(4) DEFAULT 1,
  `ngaytao` timestamp NOT NULL DEFAULT current_timestamp(),
  `ngaycapnhat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nguoidung`
--

INSERT INTO `nguoidung` (`idnguoidung`, `idvaitro`, `idnhomnganh`, `taikhoan`, `matkhau`, `email`, `hinhdaidien`, `gioithieu`, `hoten`, `sodienthoai`, `diachi`, `ngaysinh`, `gioitinh`, `trangthai`, `ngaytao`, `ngaycapnhat`) VALUES
(5, 4, 1, 'tuvan01', '$2y$10$HV52Kcr9d2DAe.i5FI5p/eJP2YjgZeqq8q.7cE/wes.VTczc8JNkq', 'tuvan@example.com', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764258213/consultants/avatars/consultant_5.jpg', 'Tôi là Nguyễn Tư Vấn, một chuyên gia tư vấn trong lĩnh vực Công nghệ Thông tin với kinh nghiệm chuyên sâu từ năm 1993. Tôi cam kết lắng nghe, phân tích kỹ lưỡng và đưa ra các giải pháp CNTT chiến lược, tối ưu, giúp khách hàng đạt được hiệu quả kinh doanh vượt trội. Với vai trò tư vấn viên, tôi luôn ưu tiên sự rõ ràng, minh bạch và hiệu quả trong mọi dự án.', 'Nguyễn Tư Vấn', '0901000002', 'TP. Hồ Chí Minh', '1993-05-10', 'Nữ', 1, '2025-10-08 13:26:17', '2025-11-29 09:13:41'),
(6, 5, NULL, 'phutrach01', '$2y$10$qaAwUNBlduk8atJP78a.4OztPMKDM6bML8cZw/ZayP5dkP8iz2yW2', 'phutrach01@example.com', NULL, NULL, 'Trần Phụ Trách', '0901000003', 'Hà Nội', '1988-07-22', 'Nam', 1, '2025-10-08 13:26:17', '2025-10-11 17:49:58'),
(7, 6, NULL, 'phanTich01', '$2y$10$R86/o3Gi.AqolxCV.UeDl.RREhFNsEO7HLsW5O7O4zDJJb2xg5mYe', 'phantich01@example.com', NULL, NULL, 'Lê Phân Tích', '0901000004', 'Đà Nẵng', '1992-03-18', 'Nữ', 1, '2025-10-08 13:26:17', '2025-10-11 17:50:18'),
(14, 5, NULL, 'vinh@example.com', '$2y$12$s1wG8Acpk9PbjLmdyKK.HuUli6nINyJJCpgRInazbPEYLtSHlMbcK', 'vinh@example.com', NULL, NULL, 'vinh', '0326495729', 'Hồ Chí Minh', '2025-10-17', 'Nam', 1, '2025-10-11 04:08:00', '2025-10-23 15:14:06'),
(15, 2, NULL, 'y@example.com', '$2y$12$8xNOs9rrzuCxAvbnFwHM0.N5vBjYCCmBj567sQCiwnKRCdriIXQ/G', 'vinhcoco9@gmail.com', NULL, NULL, 'ý', '0326495728', 'tp hồ chí minh', '2024-06-12', 'Nam', 1, '2025-10-11 05:52:08', '2025-11-29 11:51:44'),
(16, 4, 1, 'tv_cntt_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_cntt_01@hoahoctro.vn', NULL, NULL, 'Nguyễn Minh Khoa', '0901001001', 'TP. Hồ Chí Minh', '1992-03-15', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(17, 4, 1, 'tv_cntt_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_cntt_02@hoahoctro.vn', NULL, NULL, 'Trần Quang Huy', '0901001002', 'TP. Hồ Chí Minh', '1990-08-22', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(18, 4, 2, 'tv_yte_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_yte_01@hoahoctro.vn', NULL, NULL, 'Phạm Thùy Dương', '0902002001', 'Hà Nội', '1989-12-05', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(19, 4, 2, 'tv_yte_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_yte_02@hoahoctro.vn', NULL, NULL, 'Lê Hoài Nam', '0902002002', 'Hà Nội', '1991-04-10', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(20, 4, 3, 'tv_ktql_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_ktql_01@hoahoctro.vn', NULL, NULL, 'Võ Bảo Châu', '0903003001', 'Đà Nẵng', '1993-06-18', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(21, 4, 3, 'tv_ktql_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_ktql_02@hoahoctro.vn', NULL, NULL, 'Đỗ Anh Tuấn', '0903003002', 'Đà Nẵng', '1988-11-02', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(22, 4, 4, 'tv_ktcn_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_ktcn_01@hoahoctro.vn', NULL, NULL, 'Ngô Thế Phong', '0904004001', 'Cần Thơ', '1990-02-20', NULL, 1, '2025-10-18 07:57:57', '2025-11-29 11:55:05'),
(23, 4, 4, 'tv_ktcn_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_ktcn_02@hoahoctro.vn', NULL, NULL, 'Bùi Gia Huy', '0904004002', 'Cần Thơ', '1994-07-09', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(24, 4, 5, 'tv_nnqt_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_nnqt_01@hoahoctro.vn', NULL, NULL, 'Trịnh Khánh Linh', '0905005001', 'Hải Phòng', '1995-01-27', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(25, 4, 5, 'tv_nnqt_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_nnqt_02@hoahoctro.vn', NULL, NULL, 'Nguyễn Hải Yến', '0905005002', 'Hải Phòng', '1992-05-30', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(26, 4, 6, 'tv_sttt_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_sttt_01@hoahoctro.vn', NULL, NULL, 'Huỳnh Nhật Minh', '0906006001', 'TP. Hồ Chí Minh', '1993-09-14', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(27, 4, 6, 'tv_sttt_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_sttt_02@hoahoctro.vn', NULL, NULL, 'Phan Thanh Vy', '0906006002', 'TP. Hồ Chí Minh', '1996-03-08', NULL, 1, '2025-10-18 07:57:57', '2025-11-29 11:51:39'),
(28, 4, 7, 'tv_tmdt_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_tmdt_01@hoahoctro.vn', NULL, NULL, 'Lương Đức Hiếu', '0907007001', 'Bình Dương', '1991-10-25', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(29, 4, 7, 'tv_tmdt_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_tmdt_02@hoahoctro.vn', NULL, NULL, 'Mai Ngọc Bích', '0907007002', 'Bình Dương', '1990-12-12', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(30, 4, 8, 'tv_nlbt_01', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_nlbt_01@hoahoctro.vn', NULL, NULL, 'Đinh Trọng Tín', '0908008001', 'Nha Trang', '1987-08-03', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(31, 4, 8, 'tv_nlbt_02', '$2y$10$HV52Kcr9d2DAe.i5Fl5p/eJP2YjgZeq8q.7cE/weslN3cOChUUSy', 'tv_nlbt_02@hoahoctro.vn', NULL, NULL, 'Trương Mỹ An', '0908008002', 'Nha Trang', '1994-04-22', NULL, 1, '2025-10-18 07:57:57', '2025-10-18 07:57:57'),
(32, 3, NULL, 'admin', '$2y$12$8xNOs9rrzuCxAvbnFwHM0.N5vBjYCCmBj567sQCiwnKRCdriIXQ/G', 'admin@hoahoctro.vn', NULL, NULL, 'Nguyễn Thu Hà', '0908000001', 'Hà Nội', '1989-02-10', 'Nữ', 1, '2025-10-18 09:52:48', '2025-10-18 09:56:33'),
(33, 2, NULL, 'v@example.com', '$2y$12$huvvGBwzUg46ASgLYaRwYeRregQHKTKDjhxz2fwGIdSDXqC4VRQEW', 'v@example.com', NULL, NULL, 'Vinh', '0326495727', 'Hồ Chí Minh', '2025-10-18', 'Nam', 1, '2025-10-18 22:22:58', '2025-10-18 22:22:58'),
(34, 1, 1, 'admin_34', '$2y$12$OtQfSnuyyqTyyxH2ahLj.eNfhPiz8IY/NXnUAl3cN7DFXRrdwXxoS', 'admin34@example.com', NULL, NULL, 'Administrator 34', '0123456789', 'Admin Address', '1990-01-01', 'Nam', 1, '2025-10-23 07:51:18', '2025-10-23 07:51:18'),
(36, 2, NULL, 'vinhvl@gmail.com', '$2y$12$NStHUMweIPTYUHVUHzBwr.6dYDdmizaBpDezrsJFT7PegatTCaQ8m', 'vinhvl@gmail.com', NULL, NULL, 'vinhthyt', NULL, 'gfhgjhgk', '2003-05-22', 'Nam', 1, '2025-11-30 00:23:40', '2025-11-30 00:23:40'),
(37, 5, NULL, 'fghgh@gmail.com', '$2y$12$gm8mRaZh7TNlHcsSBDxFrOVOx5TmAeQRatf9D6eJ8fS6WSYxpdO9a', 'fghgh@gmail.com', NULL, NULL, 'ẻgfhggf', NULL, 'gjhjhj', '2006-01-31', 'Nam', 1, '2025-11-30 00:33:05', '2025-11-30 00:33:05'),
(38, 4, 8, 'tuvan123@gmail.com', '$2y$12$makUL8Ep8t3l2xZjFk848Oi6YfHCKvdquJ/Jwb32gjC0YCOomZ3D2', 'tuvan123@gmail.com', NULL, 'égdhg', 'yuuuy', '0326495738', 'dfggfj', '2004-12-28', 'Nam', 1, '2025-11-30 02:04:16', '2025-11-30 02:04:16'),
(39, 4, 1, 'tuvan345@gmail.com', '$2y$12$TE95mAkMc3qAqJckh8UBSudwIh1.foiSGMDH/7LEZ1nahvdls//Tm', 'tuvan345@gmail.com', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764493609/consultants/avatars/consultant_1764493593_692c091941041.jpg', 'fghgh', 'fgfhj', '0326495767', 'ẻg', '2004-06-16', 'Nam', 1, '2025-11-30 02:06:48', '2025-11-30 02:06:48');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nguyenvong`
--

CREATE TABLE `nguyenvong` (
  `idnguyenvong` int(11) NOT NULL,
  `idhoso` int(11) DEFAULT NULL,
  `thutu` int(11) DEFAULT NULL,
  `thutuutien` int(11) DEFAULT NULL,
  `diemxettuyen` decimal(4,2) DEFAULT NULL,
  `sohitrungtuyen` int(11) DEFAULT NULL,
  `ghichu` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `nhomnganh`
--

CREATE TABLE `nhomnganh` (
  `idnhomnganh` int(11) NOT NULL,
  `manhom` varchar(20) NOT NULL,
  `tennhom` varchar(200) NOT NULL,
  `motanhom` text DEFAULT NULL,
  `trangthai` tinyint(4) DEFAULT 1,
  `ngaytao` timestamp NOT NULL DEFAULT current_timestamp(),
  `ngaycapnhat` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `nhomnganh`
--

INSERT INTO `nhomnganh` (`idnhomnganh`, `manhom`, `tennhom`, `motanhom`, `trangthai`, `ngaytao`, `ngaycapnhat`) VALUES
(1, 'CNTT', 'Công nghệ Thông tin', 'Nhóm ngành về phần mềm, phần cứng, mạng máy tính, AI và các công nghệ số hiện đại', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(2, 'YTE', 'Y tế - Sức khỏe', 'Nhóm ngành chăm sóc sức khỏe con người, bao gồm y học, dược học và y tế công cộng', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(3, 'KTQL', 'Kinh tế - Quản lý', 'Nhóm ngành về kinh doanh, tài chính, marketing và quản trị doanh nghiệp', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(4, 'KTCS', 'Kỹ thuật - Công nghệ', 'Nhóm ngành kỹ thuật ứng dụng trong xây dựng, môi trường, sinh học và sản xuất', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(5, 'NNQT', 'Ngoại ngữ - Quốc tế', 'Nhóm ngành về ngôn ngữ, giao tiếp quốc tế và quản trị kinh doanh quốc tế', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(6, 'STTT', 'Sáng tạo - Truyền thông', 'Nhóm ngành nghệ thuật, thiết kế, truyền thông và sáng tạo nội dung số', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(7, 'TMDT', 'Thương mại - Logistics', 'Nhóm ngành thương mại điện tử, logistics và quản lý chuỗi cung ứng', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21'),
(8, 'NLBT', 'Năng lượng - Bền vững', 'Nhóm ngành năng lượng tái tạo, công nghệ xanh và phát triển bền vững', 1, '2025-09-27 09:08:21', '2025-09-27 09:08:21');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phong_chat`
--

CREATE TABLE `phong_chat` (
  `idphongchat` int(11) NOT NULL,
  `idlichtuvan` int(11) NOT NULL,
  `idtuvanvien` int(11) NOT NULL,
  `idnguoidat` int(11) NOT NULL,
  `trang_thai` tinyint(4) NOT NULL DEFAULT 1,
  `ngay_tao` timestamp NOT NULL DEFAULT current_timestamp(),
  `ngay_cap_nhat` timestamp NULL DEFAULT NULL,
  `ngay_dong` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `phong_chat`
--

INSERT INTO `phong_chat` (`idphongchat`, `idlichtuvan`, `idtuvanvien`, `idnguoidat`, `trang_thai`, `ngay_tao`, `ngay_cap_nhat`, `ngay_dong`) VALUES
(1, 46, 5, 15, 1, '2025-10-29 00:37:11', '2025-10-30 00:36:43', NULL),
(2, 49, 5, 33, 1, '2025-10-29 01:08:38', '2025-11-22 18:12:37', NULL),
(3, 48, 5, 15, 1, '2025-11-01 01:22:18', '2025-11-01 01:22:18', NULL),
(4, 52, 5, 15, 1, '2025-11-01 07:41:33', '2025-11-01 07:41:33', NULL),
(5, 54, 5, 15, 1, '2025-11-04 06:02:53', '2025-11-04 06:02:53', NULL),
(6, 55, 5, 15, 1, '2025-11-04 08:16:02', '2025-11-04 08:16:02', NULL),
(7, 57, 5, 15, 1, '2025-11-04 08:45:12', '2025-11-08 09:35:52', NULL),
(8, 54, 5, 7, 1, '2025-11-04 10:27:15', '2025-11-04 10:27:15', NULL),
(9, 55, 5, 7, 1, '2025-11-04 10:27:15', '2025-11-04 10:27:15', NULL),
(10, 57, 5, 7, 1, '2025-11-04 10:27:15', '2025-11-04 10:27:15', NULL),
(11, 59, 5, 15, 1, '2025-11-08 20:33:26', '2025-11-08 20:34:41', NULL),
(12, 59, 5, 5, 1, '2025-11-08 20:34:27', '2025-11-08 20:34:27', NULL),
(14, 48, 5, 6, 1, '2025-11-22 10:22:47', '2025-11-22 10:22:47', NULL),
(15, 46, 5, 6, 1, '2025-11-22 10:22:47', '2025-11-22 10:22:47', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phong_chat_support`
--

CREATE TABLE `phong_chat_support` (
  `idphongchat_support` int(11) NOT NULL,
  `idnguoidung` int(11) NOT NULL COMMENT 'ID người dùng (Thành viên)',
  `idnguoi_phu_trach` int(11) NOT NULL COMMENT 'ID người phụ trách (Staff)',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Đang hoạt động, 0: Đã đóng',
  `ngay_tao` datetime DEFAULT current_timestamp(),
  `ngay_cap_nhat` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Phòng chat hỗ trợ giữa người dùng và người phụ trách';

--
-- Đang đổ dữ liệu cho bảng `phong_chat_support`
--

INSERT INTO `phong_chat_support` (`idphongchat_support`, `idnguoidung`, `idnguoi_phu_trach`, `trang_thai`, `ngay_tao`, `ngay_cap_nhat`) VALUES
(1, 15, 6, 1, '2025-11-22 14:18:04', '2025-12-01 16:32:38'),
(2, 6, 6, 1, '2025-11-22 14:21:35', '2025-11-22 14:21:35'),
(3, 5, 6, 1, '2025-11-22 14:50:12', '2025-11-22 15:05:44'),
(4, 33, 6, 1, '2025-11-22 18:11:43', '2025-12-05 04:06:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phuong_thuc_tuyen_sinh_chi_tiet`
--

CREATE TABLE `phuong_thuc_tuyen_sinh_chi_tiet` (
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `idde_an` bigint(20) UNSIGNED NOT NULL,
  `ma_phuong_thuc` varchar(50) NOT NULL COMMENT 'THPT, DGNL_HN, DGNL_HCM, TSA, CCQT, UTXT_XT_THANG, KET_HOP_...',
  `ten_phuong_thuc` varchar(200) NOT NULL COMMENT 'VD: Điểm thi THPT, Điểm ĐGNL HN, Chứng chỉ quốc tế',
  `thu_tu_hien_thi` int(11) DEFAULT 0 COMMENT 'Thứ tự hiển thị trong menu',
  `doi_tuong` text DEFAULT NULL COMMENT 'Đối tượng áp dụng',
  `dieu_kien_xet_tuyen` text DEFAULT NULL COMMENT 'Điều kiện xét tuyển',
  `cong_thuc_tinh_diem` text DEFAULT NULL COMMENT 'Công thức tính điểm xét tuyển',
  `mo_ta_quy_che` longtext DEFAULT NULL COMMENT 'Mô tả quy chế chi tiết',
  `thoi_gian_bat_dau` datetime DEFAULT NULL COMMENT 'Thời gian bắt đầu xét tuyển',
  `thoi_gian_ket_thuc` datetime DEFAULT NULL COMMENT 'Thời gian kết thúc xét tuyển',
  `ghi_chu` text DEFAULT NULL,
  `trang_thai` tinyint(4) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `phuong_thuc_tuyen_sinh_chi_tiet`
--

INSERT INTO `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`, `idde_an`, `ma_phuong_thuc`, `ten_phuong_thuc`, `thu_tu_hien_thi`, `doi_tuong`, `dieu_kien_xet_tuyen`, `cong_thuc_tinh_diem`, `mo_ta_quy_che`, `thoi_gian_bat_dau`, `thoi_gian_ket_thuc`, `ghi_chu`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 1, 'THPT', 'Xét tuyển bằng điểm thi tốt nghiệp THPT', 1, 'Thí sinh đã tốt nghiệp THPT hoặc tương đương, có điểm thi tốt nghiệp THPT năm 2025', 'Thí sinh đạt điểm thi tốt nghiệp THPT từ ngưỡng điểm tối thiểu do Bộ GD&ĐT quy định. Điểm xét tuyển = Tổng điểm 3 môn thi theo tổ hợp xét tuyển + Điểm ưu tiên (nếu có)', 'ĐXT = [Tổng điểm 03 môn thi theo tổ hợp xét tuyển] + [Điểm ưu tiên khu vực] + [Điểm ưu tiên đối tượng]', 'Phương thức này áp dụng cho tất cả các ngành đào tạo của trường. Thí sinh đăng ký xét tuyển trực tuyến trên hệ thống của Bộ GD&ĐT hoặc nộp hồ sơ trực tiếp tại trường.', '2025-06-15 08:00:00', '2025-08-15 17:00:00', 'Đây là phương thức xét tuyển chính, chiếm tỷ lệ lớn nhất trong tổng chỉ tiêu tuyển sinh.', 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(2, 1, 'HOC_BA', 'Xét tuyển bằng điểm học bạ THPT', 2, 'Thí sinh đã tốt nghiệp THPT hoặc tương đương, có học bạ THPT', 'Thí sinh có điểm trung bình học tập lớp 10, 11, 12 đạt từ 6.5 trở lên. Điểm xét tuyển = (ĐTB lớp 10 + ĐTB lớp 11 + ĐTB lớp 12) / 3 + Điểm ưu tiên', 'ĐXT = [(ĐTB lớp 10 + ĐTB lớp 11 + ĐTB lớp 12) / 3] + [Điểm ưu tiên khu vực] + [Điểm ưu tiên đối tượng]', 'Phương thức này cho phép thí sinh xét tuyển sớm, không cần chờ kết quả thi tốt nghiệp THPT. Thí sinh có thể nộp hồ sơ từ tháng 3 đến tháng 7.', '2025-03-01 08:00:00', '2025-07-31 17:00:00', 'Phương thức này phù hợp với thí sinh có học lực tốt, muốn xác định sớm kết quả trúng tuyển.', 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(3, 1, 'DGNL_HCM', 'Xét tuyển bằng kết quả kỳ thi ĐGNL ĐHQG-HCM', 3, 'Thí sinh đã tham gia kỳ thi đánh giá năng lực do ĐHQG-HCM tổ chức năm 2025', 'Thí sinh có điểm thi ĐGNL từ 600 điểm trở lên (thang điểm 1200). Điểm xét tuyển = Điểm thi ĐGNL + Điểm ưu tiên', 'ĐXT = [Điểm thi ĐGNL] + [Điểm ưu tiên khu vực] + [Điểm ưu tiên đối tượng]', 'Trường chấp nhận kết quả thi ĐGNL của ĐHQG-HCM. Thí sinh có thể sử dụng kết quả thi từ đợt 1 hoặc đợt 2.', '2025-05-01 08:00:00', '2025-08-10 17:00:00', 'Phương thức này phù hợp với thí sinh muốn có thêm cơ hội xét tuyển bằng kết quả thi độc lập.', 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12'),
(4, 1, 'UTXT_XT_THANG', 'Xét tuyển thẳng và ưu tiên xét tuyển', 4, 'Thí sinh thuộc các đối tượng được xét tuyển thẳng theo quy định của Bộ GD&ĐT và quy định riêng của trường', 'Thí sinh đạt giải trong các kỳ thi học sinh giỏi quốc gia, quốc tế; thí sinh có chứng chỉ quốc tế; thí sinh thuộc diện ưu tiên xét tuyển theo quy định', 'ĐXT = Điểm tối đa (không cần thi tuyển)', 'Xét tuyển thẳng áp dụng cho: Học sinh giỏi quốc gia, quốc tế; Thí sinh có chứng chỉ IELTS 6.5+, TOEFL iBT 80+, SAT 1200+; Thí sinh thuộc diện chính sách theo quy định.', '2025-03-01 08:00:00', '2025-08-15 17:00:00', 'Thí sinh cần nộp đầy đủ hồ sơ chứng minh đủ điều kiện xét tuyển thẳng.', 1, '2025-12-01 05:41:12', '2025-12-01 05:41:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `phuong_thuc_xet_hoc_ba`
--

CREATE TABLE `phuong_thuc_xet_hoc_ba` (
  `idphuongthuc_hb` int(11) NOT NULL,
  `ten_phuong_thuc` varchar(255) NOT NULL COMMENT 'Tên phương thức (VD: Xét học bạ 3 năm)',
  `ma_phuong_thuc` varchar(50) NOT NULL COMMENT 'Mã phương thức (VD: HB_3_NAM)',
  `mo_ta` text DEFAULT NULL COMMENT 'Mô tả chi tiết phương thức',
  `cach_tinh` text DEFAULT NULL COMMENT 'Cách tính điểm (VD: (Điểm lớp 10 + 11 + 12)/3)',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng phương thức xét học bạ';

--
-- Đang đổ dữ liệu cho bảng `phuong_thuc_xet_hoc_ba`
--

INSERT INTO `phuong_thuc_xet_hoc_ba` (`idphuongthuc_hb`, `ten_phuong_thuc`, `ma_phuong_thuc`, `mo_ta`, `cach_tinh`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 'Xét học bạ 3 năm', 'HB_3_NAM', 'Xét điểm trung bình cả năm của 3 môn trong tổ hợp xét tuyển của 3 năm lớp 10, 11, 12', '(TB lớp 10 + TB lớp 11 + TB lớp 12)/3', 1, NULL, NULL),
(2, 'Xét học bạ cả năm lớp 12', 'HB_12_NAM', 'Xét điểm trung bình cả năm lớp 12 của 3 môn trong tổ hợp xét tuyển', 'TB cả năm lớp 12', 1, NULL, NULL),
(3, 'Xét học bạ 6 học kỳ', 'HB_6_HK', 'Xét điểm trung bình 6 học kỳ của 3 môn trong tổ hợp xét tuyển', '(HK1.10 + HK2.10 + HK1.11 + HK2.11 + HK1.12 + HK2.12)/6', 1, NULL, NULL),
(4, 'Xét học bạ lớp 10, 11, HK1 lớp 12', 'HB_10_11_HK1_12', 'Xét điểm trung bình lớp 10, 11 và học kỳ 1 lớp 12', '(TB lớp 10 + TB lớp 11 + HK1.12)/3', 1, NULL, NULL),
(5, 'Xét học bạ 3 học kỳ', 'HB_3_HK', 'Xét điểm trung bình 3 học kỳ gần nhất', '(HK2.11 + HK1.12 + HK2.12)/3', 1, NULL, NULL),
(6, 'Xét học bạ 5 học kỳ', 'HB_5_HK', 'Xét điểm trung bình 5 học kỳ', '(HK2.10 + HK1.11 + HK2.11 + HK1.12 + HK2.12)/5', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ptxt`
--

CREATE TABLE `ptxt` (
  `idxettuyen` int(11) NOT NULL,
  `tenptxt` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `ptxt`
--

INSERT INTO `ptxt` (`idxettuyen`, `tenptxt`) VALUES
(1, 'Điểm thi THPT'),
(2, ' Điểm học bạ'),
(3, ' Điểm ĐGNL HCM'),
(4, ' Điểm xét tuyển kết hợp');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quyche_xettuyen`
--

CREATE TABLE `quyche_xettuyen` (
  `idquyche` int(11) NOT NULL,
  `idtruong` int(11) DEFAULT NULL COMMENT 'NULL = áp dụng cho mọi trường',
  `idnganhtruong` int(11) DEFAULT NULL COMMENT 'NULL = áp dụng cho mọi ngành_trường',
  `idxettuyen` int(11) NOT NULL COMMENT 'FK -> ptxt.idxettuyen',
  `nam_ap_dung` int(4) NOT NULL COMMENT 'Năm áp dụng, ví dụ 2025',
  `mota_ngan` varchar(255) DEFAULT NULL COMMENT 'Mô tả ngắn hiển thị ngoài list',
  `noi_dung_day_du` text DEFAULT NULL COMMENT 'Toàn văn quy chế/điều kiện xét tuyển',
  `cong_thuc_diem` text DEFAULT NULL COMMENT 'Mô tả cách tính/ quy đổi điểm xét tuyển',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `quyche_xettuyen`
--

INSERT INTO `quyche_xettuyen` (`idquyche`, `idtruong`, `idnganhtruong`, `idxettuyen`, `nam_ap_dung`, `mota_ngan`, `noi_dung_day_du`, `cong_thuc_diem`, `created_at`, `updated_at`) VALUES
(1, 27, 140, 1, 2025, 'THPT: tổ hợp A00/A01, tổng ≥ 20', 'Ngành Quản trị kinh doanh - Kinh doanh số xét tuyển theo điểm thi THPT với các tổ hợp A00, A01. Thí sinh đã tốt nghiệp THPT; điểm từng môn từ 5,0 trở lên; tổng điểm 3 môn (chưa nhân hệ số) từ 20,0 trở lên.', 'Điểm xét tuyển = (Toán + Lý + Hóa) hoặc (Toán + Lý + Anh) + Điểm ưu tiên', '2025-11-26 17:41:48', '2025-11-26 17:41:48'),
(2, 27, 133, 2, 2025, 'Học bạ: TB 3 môn khối A từ 7,5', 'Ngành Kế toán - Kế toán tài chính xét tuyển theo học bạ dựa trên điểm trung bình 3 môn Toán, Lý, Hóa (hoặc Toán, Văn, Anh) của lớp 11 và 12. Điều kiện: TB ≥ 7,5; không môn nào dưới 6,5; hạnh kiểm Khá trở lên.', 'Điểm xét tuyển = TB(Điểm TB 3 môn lớp 11 + lớp 12) × 3', '2025-11-26 17:41:48', '2025-11-26 17:41:48'),
(3, 27, 131, 3, 2025, 'ĐGNL: ưu tiên ngành CNTT, ngưỡng từ 750', 'Ngành Công nghệ thông tin - Hệ thống thông tin xét tuyển theo điểm thi ĐGNL ĐHQG TP.HCM với ngưỡng tối thiểu 750/1200. Thí sinh có điểm từ 800 trở lên được ưu tiên trong xếp lớp chương trình chất lượng cao.', 'Điểm xét tuyển = Điểm ĐGNL (thang 1200)', '2025-11-26 17:41:48', '2025-11-26 17:41:48');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quy_dinh_diem_uu_tien`
--

CREATE TABLE `quy_dinh_diem_uu_tien` (
  `idquydinh` int(11) NOT NULL,
  `ten_quy_dinh` varchar(255) NOT NULL COMMENT 'Tên quy định',
  `mo_ta` text DEFAULT NULL COMMENT 'Mô tả quy định',
  `nguong_diem` decimal(5,2) DEFAULT 22.50 COMMENT 'Ngưỡng điểm (VD: 22.5)',
  `cong_thuc` text DEFAULT NULL COMMENT 'Công thức tính điểm ưu tiên',
  `nam_ap_dung` int(4) NOT NULL COMMENT 'Năm áp dụng',
  `trang_thai` tinyint(1) DEFAULT 1 COMMENT '1: Hoạt động, 0: Không hoạt động',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quy định tính điểm ưu tiên';

--
-- Đang đổ dữ liệu cho bảng `quy_dinh_diem_uu_tien`
--

INSERT INTO `quy_dinh_diem_uu_tien` (`idquydinh`, `ten_quy_dinh`, `mo_ta`, `nguong_diem`, `cong_thuc`, `nam_ap_dung`, `trang_thai`, `created_at`, `updated_at`) VALUES
(1, 'Quy định điểm ưu tiên 2024', 'Nếu tổng điểm từ 22.5 trở lên thì áp dụng công thức giảm điểm ưu tiên', 22.50, '[(30 - Tổng điểm đạt được)/7.5] x Tổng điểm ưu tiên được xác định thông thường', 2024, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `quy_dinh_diem_uu_tien_de_an`
--

CREATE TABLE `quy_dinh_diem_uu_tien_de_an` (
  `idquy_dinh_de_an` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `nguong_diem` decimal(5,2) DEFAULT 22.50 COMMENT 'Ngưỡng điểm áp dụng quy định',
  `muc_diem_cong_cctaqt` decimal(4,2) DEFAULT 0.75 COMMENT 'Mức điểm cộng với thí sinh có CCTAQT',
  `cong_thuc_diem_uu_tien` text DEFAULT NULL COMMENT 'Công thức tính điểm ưu tiên',
  `mo_ta_quy_dinh` longtext DEFAULT NULL COMMENT 'Mô tả quy định chi tiết',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `quy_dinh_diem_uu_tien_de_an`
--

INSERT INTO `quy_dinh_diem_uu_tien_de_an` (`idquy_dinh_de_an`, `idphuong_thuc_chi_tiet`, `nguong_diem`, `muc_diem_cong_cctaqt`, `cong_thuc_diem_uu_tien`, `mo_ta_quy_dinh`, `created_at`, `updated_at`) VALUES
(1, 1, 22.50, 0.75, 'Điểm ưu tiên = [(30 - Tổng điểm đạt được)/7.5] × Mức điểm ưu tiên quy định', 'Áp dụng cho thí sinh có điểm xét tuyển từ 22.5 trở lên. Thí sinh có chứng chỉ CCTAQT (Chứng chỉ tiếng Anh quốc tế) được cộng thêm 0.75 điểm.', '2025-12-01 06:00:12', '2025-12-01 06:00:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tep_minhchung_buoituvan`
--

CREATE TABLE `tep_minhchung_buoituvan` (
  `id_file` int(11) NOT NULL,
  `id_ghichu` int(11) DEFAULT NULL,
  `id_lichtuvan` int(11) DEFAULT NULL,
  `duong_dan` varchar(255) NOT NULL,
  `ten_file` varchar(255) DEFAULT NULL,
  `loai_file` enum('hinh_anh','video','pdf','link') NOT NULL DEFAULT 'pdf',
  `la_minh_chung` tinyint(1) NOT NULL DEFAULT 1,
  `mo_ta` varchar(255) DEFAULT NULL,
  `nguoi_tai_len` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tep_minhchung_buoituvan`
--

INSERT INTO `tep_minhchung_buoituvan` (`id_file`, `id_ghichu`, `id_lichtuvan`, `duong_dan`, `ten_file`, `loai_file`, `la_minh_chung`, `mo_ta`, `nguoi_tai_len`, `created_at`) VALUES
(6, 7, 57, 'http://localhost:8000/storage/evidence/1762609341_B_____c_1.jpg', 'Bssớc 1.jpg', 'hinh_anh', 1, '12345', 5, '2025-11-08 13:42:22'),
(7, 9, 46, 'http://localhost:8000/storage/evidence/1764405936_ts2.jpg', 'ts2.jpg', 'hinh_anh', 1, 'fdf', 5, '2025-11-29 08:45:37');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thanhtoan`
--

CREATE TABLE `thanhtoan` (
  `id_thanhtoan` int(11) NOT NULL,
  `id_lichtuvan` int(11) NOT NULL,
  `id_nguoidung` int(11) NOT NULL,
  `phuongthuc` enum('ZaloPayOA') NOT NULL DEFAULT 'ZaloPayOA',
  `ma_phieu` varchar(40) NOT NULL,
  `so_tien` decimal(12,2) NOT NULL CHECK (`so_tien` > 0),
  `don_vi_tien` varchar(10) NOT NULL DEFAULT 'VND',
  `so_tien_giam` decimal(12,2) DEFAULT 0.00,
  `phi_giao_dich` decimal(12,2) DEFAULT 0.00,
  `so_tien_thuc_thu` decimal(12,2) GENERATED ALWAYS AS (`so_tien` - ifnull(`so_tien_giam`,0) + ifnull(`phi_giao_dich`,0)) VIRTUAL,
  `trang_thai` enum('KhoiTao','ChoThanhToan','DaThanhToan','ThatBai','HetHan','HoanTienMotPhan','DaHoanTien') NOT NULL DEFAULT 'KhoiTao',
  `ma_giao_dich_app` varchar(50) NOT NULL,
  `ma_giao_dich_zp` varchar(50) DEFAULT NULL,
  `duong_dan_thanh_toan` varchar(255) DEFAULT NULL,
  `duong_dan_qr` varchar(255) DEFAULT NULL,
  `du_lieu_yeu_cau` longtext DEFAULT NULL,
  `du_lieu_phan_hoi` longtext DEFAULT NULL,
  `noi_dung` varchar(255) DEFAULT NULL,
  `ly_do_that_bai` varchar(255) DEFAULT NULL,
  `thoi_gian_tao` datetime NOT NULL DEFAULT current_timestamp(),
  `thoi_gian_cap_nhat` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `thoi_gian_thanh_toan` datetime DEFAULT NULL,
  `ngay_xoa` datetime DEFAULT NULL,
  `khoa_thanh_cong` int(11) GENERATED ALWAYS AS (case when `trang_thai` = 'DaThanhToan' then `id_lichtuvan` else NULL end) VIRTUAL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thanhtoan`
--

INSERT INTO `thanhtoan` (`id_thanhtoan`, `id_lichtuvan`, `id_nguoidung`, `phuongthuc`, `ma_phieu`, `so_tien`, `don_vi_tien`, `so_tien_giam`, `phi_giao_dich`, `trang_thai`, `ma_giao_dich_app`, `ma_giao_dich_zp`, `duong_dan_thanh_toan`, `duong_dan_qr`, `du_lieu_yeu_cau`, `du_lieu_phan_hoi`, `noi_dung`, `ly_do_that_bai`, `thoi_gian_tao`, `thoi_gian_cap_nhat`, `thoi_gian_thanh_toan`, `ngay_xoa`) VALUES
(1, 48, 15, 'ZaloPayOA', 'ORD_1761983605_48', 550000.00, 'VND', 0.00, 50000.00, 'KhoiTao', '251101_886464', NULL, NULL, NULL, '[]', '{\"return_code\":2,\"return_message\":\"Giao d\\u1ecbch th\\u1ea5t b\\u1ea1i\",\"sub_return_code\":-401,\"sub_return_message\":\"D\\u1eef li\\u1ec7u y\\u00eau c\\u1ea7u kh\\u00f4ng h\\u1ee3p l\\u1ec7\"}', NULL, 'Giao dịch thất bại', '2025-11-01 07:53:25', '2025-11-01 07:53:26', NULL, NULL),
(2, 48, 15, 'ZaloPayOA', 'ORD_1761983640_48', 550000.00, 'VND', 0.00, 50000.00, 'KhoiTao', '251101_518388', NULL, NULL, NULL, '[]', '{\"return_code\":2,\"return_message\":\"Giao d\\u1ecbch th\\u1ea5t b\\u1ea1i\",\"sub_return_code\":-401,\"sub_return_message\":\"D\\u1eef li\\u1ec7u y\\u00eau c\\u1ea7u kh\\u00f4ng h\\u1ee3p l\\u1ec7\"}', NULL, 'Giao dịch thất bại', '2025-11-01 07:54:00', '2025-11-01 07:54:01', NULL, NULL),
(3, 48, 15, 'ZaloPayOA', 'ORD_1761983870_48', 550000.00, 'VND', 0.00, 50000.00, 'KhoiTao', '251101_544558', NULL, NULL, NULL, '[]', '{\"return_code\":1,\"return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"sub_return_code\":1,\"sub_return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"zp_trans_token\":\"ACMsQsDjRJlDCERvS2WFs2iw\",\"order_url\":\"https:\\/\\/qcgateway.zalopay.vn\\/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ01zUXNEalJKbERDRVJ2UzJXRnMyaXciLCJhcHBpZCI6MjU1NH0=\",\"order_token\":\"ACMsQsDjRJlDCERvS2WFs2iw\"}', NULL, NULL, '2025-11-01 07:57:50', '2025-11-01 07:57:53', NULL, NULL),
(4, 48, 15, 'ZaloPayOA', 'ORD_1761984122_48', 550000.00, 'VND', 0.00, 50000.00, 'ChoThanhToan', '251101_170508', NULL, 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0MxTlpDN2YzZnFKV2xVbDJaVHYtaWciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0MxTlpDN2YzZnFKV2xVbDJaVHYtaWciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"return_code\":1,\"return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"sub_return_code\":1,\"sub_return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"zp_trans_token\":\"ACC1NZC7f3fqJWlUl2ZTv-ig\",\"order_url\":\"https:\\/\\/qcgateway.zalopay.vn\\/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0MxTlpDN2YzZnFKV2xVbDJaVHYtaWciLCJhcHBpZCI6MjU1NH0=\",\"order_token\":\"ACC1NZC7f3fqJWlUl2ZTv-ig\"}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-01 08:02:02', '2025-11-01 08:02:03', NULL, NULL),
(5, 48, 15, 'ZaloPayOA', 'ORD_1761984835_48', 550000.00, 'VND', 0.00, 50000.00, 'ChoThanhToan', '251101_676312', NULL, 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ19idEoyOXoxWkRNdXlXejlnVzdpS3ciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ19idEoyOXoxWkRNdXlXejlnVzdpS3ciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"return_code\":1,\"return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"sub_return_code\":1,\"sub_return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"zp_trans_token\":\"AC_btJ29z1ZDMuyWz9gW7iKw\",\"order_url\":\"https:\\/\\/qcgateway.zalopay.vn\\/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ19idEoyOXoxWkRNdXlXejlnVzdpS3ciLCJhcHBpZCI6MjU1NH0=\",\"order_token\":\"AC_btJ29z1ZDMuyWz9gW7iKw\"}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-01 08:13:55', '2025-11-01 08:13:56', NULL, NULL),
(6, 48, 15, 'ZaloPayOA', 'ORD_1761985108_48', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251101_295728', '251101000011742', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0dLcUFLd1JkaFFUN2tmQjZoQkZvSFEiLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0dLcUFLd1JkaFFUN2tmQjZoQkZvSFEiLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251101_295728\",\"app_time\":1761985108285,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1761985108_48\\\",\\\"invoiceId\\\":48,\\\"id_thanhtoan\\\":6}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251101000011742,\"server_time\":1761985330752,\"channel\":38,\"merchant_user_id\":\"nkINL_eJ8PhKC2zdTdsIMTSUBTqso1UnWeluzegy57Y\",\"zp_user_id\":\"nkINL_eJ8PhKC2zdTdsIMTSUBTqso1UnWeluzegy57Y\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-01 08:18:28', '2025-11-01 08:22:08', '2025-11-01 08:22:08', NULL),
(7, 52, 15, 'ZaloPayOA', 'ORD_1762005427_52', 550000.00, 'VND', 0.00, 50000.00, 'ChoThanhToan', '251101_975933', NULL, 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3Y5eXd6WVR6QmdkeWxlSHQtbWs3TmciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3Y5eXd6WVR6QmdkeWxlSHQtbWs3TmciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"return_code\":1,\"return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"sub_return_code\":1,\"sub_return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"zp_trans_token\":\"ACv9ywzYTzBgdyleHt-mk7Ng\",\"order_url\":\"https:\\/\\/qcgateway.zalopay.vn\\/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3Y5eXd6WVR6QmdkeWxlSHQtbWs3TmciLCJhcHBpZCI6MjU1NH0=\",\"order_token\":\"ACv9ywzYTzBgdyleHt-mk7Ng\"}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-01 13:57:07', '2025-11-01 13:57:12', NULL, NULL),
(8, 52, 15, 'ZaloPayOA', 'ORD_1762007975_52', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251101_421765', '251101000014466', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0FYc3pTTkozU2J6SVdKUVRyc04yRmciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0FYc3pTTkozU2J6SVdKUVRyc04yRmciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251101_421765\",\"app_time\":1762007975377,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1762007975_52\\\",\\\"invoiceId\\\":52,\\\"id_thanhtoan\\\":8}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251101000014466,\"server_time\":1762008081177,\"channel\":39,\"merchant_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"zp_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-01 14:39:35', '2025-11-01 14:41:18', '2025-11-01 14:41:18', NULL),
(9, 54, 15, 'ZaloPayOA', 'ORD_1762261256_54', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251104_035059', '251104000009604', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3VSX1lTQUROdHVqU1pnVHFGclJXdnciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3VSX1lTQUROdHVqU1pnVHFGclJXdnciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251104_035059\",\"app_time\":1762261256365,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1762261256_54\\\",\\\"invoiceId\\\":54,\\\"id_thanhtoan\\\":9}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251104000009604,\"server_time\":1762261365013,\"channel\":39,\"merchant_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"zp_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-04 13:00:56', '2025-11-04 13:02:43', '2025-11-04 13:02:43', NULL),
(10, 55, 15, 'ZaloPayOA', 'ORD_1762269146_55', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251104_236981', '251104000009515', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3BSSWZBZ0IwQlN6TEpicUMzaTBQT1EiLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3BSSWZBZ0IwQlN6TEpicUMzaTBQT1EiLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251104_236981\",\"app_time\":1762269146794,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1762269146_55\\\",\\\"invoiceId\\\":55,\\\"id_thanhtoan\\\":10}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251104000009515,\"server_time\":1762269350448,\"channel\":39,\"merchant_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"zp_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-04 15:12:26', '2025-11-04 15:15:49', '2025-11-04 15:15:49', NULL),
(11, 57, 15, 'ZaloPayOA', 'ORD_1762271047_57', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251104_662583', '251104000009518', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ2FVS1JLNG1tWV8yV05qb184UmVFZ0EiLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ2FVS1JLNG1tWV8yV05qb184UmVFZ0EiLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251104_662583\",\"app_time\":1762271047628,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1762271047_57\\\",\\\"invoiceId\\\":57,\\\"id_thanhtoan\\\":11}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251104000009518,\"server_time\":1762271104549,\"channel\":39,\"merchant_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"zp_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-04 15:44:07', '2025-11-04 15:45:03', '2025-11-04 15:45:03', NULL),
(12, 59, 15, 'ZaloPayOA', 'ORD_1762658498_59', 550000.00, 'VND', 0.00, 50000.00, 'DaThanhToan', '251109_364633', '251109000000204', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3RKSXpsQjdkcDZKQVFkMDFQTXNWZGciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ3RKSXpsQjdkcDZKQVFkMDFQTXNWZGciLCJhcHBpZCI6MjU1NH0=', '[]', '{\"app_id\":2554,\"app_trans_id\":\"251109_364633\",\"app_time\":1762658498167,\"app_user\":\"2554\",\"amount\":550000,\"embed_data\":\"{\\\"orderId\\\":\\\"ORD_1762658498_59\\\",\\\"invoiceId\\\":59,\\\"id_thanhtoan\\\":12}\",\"item\":\"[{\\\"item_name\\\":\\\"Ph\\\\u00ed t\\\\u01b0 v\\\\u1ea5n t\\\\u01b0 v\\\\u1ea5n tuy\\\\u1ec3n sinh\\\",\\\"item_quantity\\\":1,\\\"item_price\\\":550000}]\",\"zp_trans_id\":251109000000204,\"server_time\":1762659194484,\"channel\":39,\"merchant_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"zp_user_id\":\"uIRitZRyxiEttz_0nEJvobPa4_ltlNHFs3GPa-nMQbs\",\"user_fee_amount\":0,\"discount_amount\":0}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-11-09 03:21:38', '2025-11-09 03:33:15', '2025-11-09 03:33:15', NULL),
(13, 66, 33, 'ZaloPayOA', 'ORD_1764907302_66', 550000.00, 'VND', 0.00, 50000.00, 'ChoThanhToan', '251205_506764', NULL, 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0kwc0prV3hUWDR3SFVjd1YySExVU2ciLCJhcHBpZCI6MjU1NH0=', 'https://qcgateway.zalopay.vn/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0kwc0prV3hUWDR3SFVjd1YySExVU2ciLCJhcHBpZCI6MjU1NH0=', '{\"pointsUsed\":0,\"discountAmount\":0}', '{\"return_code\":1,\"return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"sub_return_code\":1,\"sub_return_message\":\"Giao d\\u1ecbch th\\u00e0nh c\\u00f4ng\",\"zp_trans_token\":\"ACI0sJkWxTX4wHUcwV2HLUSg\",\"order_url\":\"https:\\/\\/qcgateway.zalopay.vn\\/openinapp?order=eyJ6cHRyYW5zdG9rZW4iOiJBQ0kwc0prV3hUWDR3SFVjd1YySExVU2ciLCJhcHBpZCI6MjU1NH0=\",\"order_token\":\"ACI0sJkWxTX4wHUcwV2HLUSg\"}', 'Thanh toán phí tư vấn tuyển sinh', NULL, '2025-12-05 04:01:42', '2025-12-05 04:01:47', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thongbao`
--

CREATE TABLE `thongbao` (
  `idthongbao` bigint(20) NOT NULL COMMENT 'Mã thông báo',
  `tieude` varchar(255) NOT NULL COMMENT 'Tiêu đề thông báo',
  `noidung` text NOT NULL COMMENT 'Nội dung chi tiết của thông báo',
  `kieuguithongbao` enum('ngay','lenlich') DEFAULT 'ngay' COMMENT 'Kiểu gửi: ngay = gửi ngay, lenlich = gửi theo lịch',
  `thoigiangui_dukien` datetime DEFAULT NULL COMMENT 'Thời gian dự kiến gửi (nếu là gửi theo lịch)',
  `nguoitao_id` int(11) DEFAULT NULL COMMENT 'Người tạo thông báo (FK tới bảng nguoidung)',
  `idnguoinhan` int(11) DEFAULT NULL,
  `ngaytao` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Ngày tạo thông báo',
  `ngaycapnhat` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp() COMMENT 'Ngày cập nhật thông báo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lưu thông tin nội dung các thông báo được gửi trong hệ thống';

--
-- Đang đổ dữ liệu cho bảng `thongbao`
--

INSERT INTO `thongbao` (`idthongbao`, `tieude`, `noidung`, `kieuguithongbao`, `thoigiangui_dukien`, `nguoitao_id`, `idnguoinhan`, `ngaytao`, `ngaycapnhat`) VALUES
(6, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, NULL, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(7, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 5, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(8, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 16, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(9, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 17, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(10, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 18, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(11, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 19, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(12, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 20, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(13, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 21, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(14, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 22, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(15, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 23, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(16, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 24, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(17, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 25, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(18, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 26, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(19, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 27, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(20, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 28, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(21, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 29, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(22, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 30, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(23, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 31, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(24, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 1, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(25, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 2, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(26, 'Test thông báo', 'Đây là nội dung test thông báo', 'ngay', '2025-10-27 06:05:27', NULL, 3, '2025-10-26 23:05:27', '2025-10-26 23:05:27'),
(27, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, NULL, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(28, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 5, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(29, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 16, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(30, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 17, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(31, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 18, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(32, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 19, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(33, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 20, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(34, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 21, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(35, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 22, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(36, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 23, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(37, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 24, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(38, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 25, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(39, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 26, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(40, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 27, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(41, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 28, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(42, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 29, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(43, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 30, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(44, 'zxcm', 'dfghjkl', 'ngay', '2025-10-27 06:26:25', NULL, 31, '2025-10-26 23:26:25', '2025-10-26 23:26:25'),
(45, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, NULL, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(46, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 5, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(47, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 16, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(48, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 17, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(49, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 18, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(50, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 19, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(51, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 20, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(52, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 21, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(53, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 22, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(54, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 23, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(55, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 24, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(56, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 25, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(57, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 26, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(58, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 27, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(59, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 28, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(60, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 29, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(61, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 30, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(62, 'vinhgsdsjdfd', 'jkukkukuuk20', 'ngay', '2025-10-27 06:48:50', NULL, 31, '2025-10-26 23:48:50', '2025-10-26 23:48:50'),
(63, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, NULL, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(64, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 5, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(65, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 16, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(66, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 17, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(67, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 18, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(68, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 19, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(69, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 20, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(70, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 21, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(71, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 22, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(72, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 23, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(73, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 24, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(74, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 25, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(75, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 26, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(76, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 27, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(77, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 28, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(78, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 29, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(79, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 30, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(80, 'xccdvzz', 'vdvdvdvdc', 'ngay', '2025-10-27 06:50:10', NULL, 31, '2025-10-26 23:50:10', '2025-10-26 23:50:10'),
(81, 'sdghhj12', '22345', 'ngay', '2025-10-27 07:09:30', 6, NULL, '2025-10-27 00:09:30', '2025-10-27 00:09:30'),
(82, 'sdghhj12', '22345', 'ngay', '2025-10-27 07:09:30', 6, 30, '2025-10-27 00:09:30', '2025-10-27 00:09:30'),
(83, 'sdghhj12', '22345', 'ngay', '2025-10-27 07:09:30', 6, 22, '2025-10-27 00:09:30', '2025-10-27 00:09:30'),
(84, 'Test không có dòng dư', 'Đây là test cuối cùng', 'ngay', '2025-10-27 07:38:35', 34, 33, '2025-10-27 00:38:35', '2025-10-27 00:38:35'),
(85, 'Test không có dòng dư', 'Đây là test cuối cùng', 'ngay', '2025-10-27 07:38:35', 34, 34, '2025-10-27 00:38:35', '2025-10-27 00:38:35'),
(86, 'cập nhật lịch', 'lịch đã được cập nhật', 'ngay', '2025-10-27 07:40:12', 6, 30, '2025-10-27 00:40:12', '2025-10-27 00:40:12'),
(87, 'đăng kí lịch', 'thông báo lich', 'ngay', '2025-10-27 08:00:54', 6, 5, '2025-10-27 01:00:54', '2025-10-27 01:00:54'),
(88, 'nguyễn văn vinh', 'vinh', 'ngay', '2025-10-27 08:08:22', 6, 17, '2025-10-27 01:08:22', '2025-10-27 01:08:22'),
(89, '123456', '234567898', 'ngay', '2025-10-28 14:01:33', 6, 5, '2025-10-28 07:01:33', '2025-10-28 07:01:33'),
(90, 'Thông báo đăng kí lịch', 'test', 'ngay', '2025-11-09 02:27:19', 6, 18, '2025-11-08 19:27:19', '2025-11-08 19:27:19'),
(91, 'Thông báo đăng kí lịch', 'test', 'ngay', '2025-11-09 02:27:19', 6, 28, '2025-11-08 19:27:19', '2025-11-08 19:27:19'),
(92, 'đăng kí lịch', 'test', 'ngay', '2025-11-09 02:29:07', 5, 5, '2025-11-08 19:29:07', '2025-11-08 19:29:07'),
(93, 'Bạn đã nhận 100 điểm bồi đắp', 'Lịch tư vấn của bạn đã bị thay đổi bởi Trần Phụ Trách.\n\nĐể bù đắp sự bất tiện, bạn đã nhận được 100 điểm bồi đắp.\nBạn có thể sử dụng điểm này cho các dịch vụ của hệ thống.', 'ngay', '2025-11-22 17:28:42', 6, 33, '2025-11-22 10:28:42', '2025-11-22 10:28:42'),
(94, 'Yêu cầu thay đổi lịch tư vấn đã được duyệt', 'Yêu cầu thay đổi lịch tư vấn của bạn đã được Trần Phụ Trách duyệt.\n\nLịch mới:\n- Ngày: 30/11/2025\n- Thời gian: 13:05 - 15:05\n', 'ngay', '2025-11-22 17:28:42', 6, 5, '2025-11-22 10:28:42', '2025-11-22 10:28:42'),
(95, 'Tin nhắn mới từ ý', 'Bạn có tin nhắn mới trong chat hỗ trợ: ', 'ngay', '2025-11-23 02:57:56', 15, 6, '2025-11-22 19:57:56', '2025-11-22 19:57:56'),
(96, 'Đăng kí lịch', 'dk lịch', 'ngay', '2025-11-29 06:43:13', 6, 29, '2025-11-28 23:43:13', '2025-11-28 23:43:13'),
(97, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 5, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(98, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 16, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(99, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 17, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(100, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 18, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(101, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 19, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(102, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 20, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(103, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 21, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(104, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 22, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(105, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 23, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(106, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 24, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(107, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 25, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(108, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 26, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(109, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 27, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(110, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 28, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(111, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 29, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(112, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 30, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(113, 'Đã mở đăng ký lịch', 'Đã mở đăng ký lịch đến ngày 06/12/2025. Vui lòng đăng ký lịch tư vấn của bạn.', 'ngay', '2025-11-29 07:29:48', 6, 31, '2025-11-29 00:29:48', '2025-11-29 00:29:48'),
(114, 'Yêu cầu cập nhật ghi chú buổi tư vấn', 'Bạn được yêu cầu cập nhật ghi chú và minh chứng cho buổi tư vấn vào 24/11/2025 (09:05 - 11:05). Vui lòng truy cập trang quản lý lịch tư vấn để cập nhật.', 'ngay', '2025-11-29 16:57:52', 6, 5, '2025-11-29 09:57:52', '2025-11-29 09:57:52'),
(115, 'Yêu cầu cập nhật ghi chú buổi tư vấn', 'Bạn được yêu cầu cập nhật ghi chú và minh chứng cho buổi tư vấn vào 24/11/2025 (09:05 - 11:05). Vui lòng truy cập trang quản lý lịch tư vấn để cập nhật.', 'ngay', '2025-11-29 17:03:08', 6, 5, '2025-11-29 10:03:08', '2025-11-29 10:03:08'),
(116, 'Yêu cầu cập nhật ghi chú buổi tư vấn', 'Bạn được yêu cầu cập nhật ghi chú và minh chứng cho buổi tư vấn vào 24/11/2025 (09:05 - 11:05). Vui lòng truy cập trang quản lý lịch tư vấn để cập nhật.', 'ngay', '2025-11-29 17:11:19', 6, 5, '2025-11-29 10:11:19', '2025-11-29 10:11:19'),
(117, 'Yêu cầu cập nhật ghi chú buổi tư vấn', 'Bạn được yêu cầu cập nhật ghi chú và minh chứng cho buổi tư vấn vào 24/11/2025 (09:05 - 11:05). Vui lòng truy cập trang quản lý lịch tư vấn để cập nhật.', 'ngay', '2025-11-29 17:14:52', 6, 5, '2025-11-29 10:14:52', '2025-11-29 10:14:52'),
(118, 'Tin nhắn mới từ Vinh', 'Bạn có tin nhắn mới trong chat hỗ trợ: fghj', 'ngay', '2025-12-05 04:04:55', 33, 6, '2025-12-04 21:04:55', '2025-12-04 21:04:55'),
(119, 'Tin nhắn mới từ Vinh', 'Bạn có tin nhắn mới trong chat hỗ trợ: ', 'ngay', '2025-12-05 04:06:55', 33, 6, '2025-12-04 21:06:55', '2025-12-04 21:06:55');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thongbao_lich`
--

CREATE TABLE `thongbao_lich` (
  `id` int(10) UNSIGNED NOT NULL COMMENT 'Khóa chính',
  `idlichtuvan` int(11) NOT NULL COMMENT 'Mã lịch tư vấn (FK → lichtuvan.idlichtuvan)',
  `loai` enum('reminder') NOT NULL DEFAULT 'reminder' COMMENT 'Loại thông báo',
  `offset_phut` int(11) NOT NULL COMMENT 'Số phút trước giờ hẹn (vd: 1440, 120, 15)',
  `thoigian_gui` datetime NOT NULL COMMENT 'Thời điểm dự kiến gửi (send_at)',
  `trangthai` enum('pending','sent','failed','canceled') NOT NULL DEFAULT 'pending' COMMENT 'Trạng thái gửi',
  `thongbao_loi` text DEFAULT NULL COMMENT 'Nội dung lỗi (nếu có)',
  `khoa_idempotent` varchar(100) NOT NULL COMMENT 'Khóa duy nhất: {idlichtuvan}-{offset_phut}',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Ngày tạo',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Ngày cập nhật'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng nhắc lịch gửi email trước giờ tư vấn';

--
-- Đang đổ dữ liệu cho bảng `thongbao_lich`
--

INSERT INTO `thongbao_lich` (`id`, `idlichtuvan`, `loai`, `offset_phut`, `thoigian_gui`, `trangthai`, `thongbao_loi`, `khoa_idempotent`, `created_at`, `updated_at`) VALUES
(1, 54, 'reminder', 120, '2025-11-05 07:05:00', 'sent', NULL, '54-120', '2025-11-04 21:30:34', '2025-11-05 13:48:12'),
(2, 54, 'reminder', 15, '2025-11-05 08:50:00', 'sent', NULL, '54-15', '2025-11-04 21:30:34', '2025-11-05 13:48:14'),
(4, 54, 'reminder', 1, '2025-11-04 21:57:59', 'sent', NULL, '54-test-now', '2025-11-04 21:30:47', '2025-11-04 14:58:28'),
(5, 54, 'reminder', 1, '2025-11-04 21:46:06', 'sent', NULL, '54-1762267565', '2025-11-04 21:46:05', '2025-11-04 14:46:22'),
(6, 57, 'reminder', 1440, '2025-11-04 22:58:41', 'sent', NULL, '57-1440', '2025-11-04 15:45:04', '2025-11-04 15:58:52'),
(7, 57, 'reminder', 120, '2025-11-06 13:10:00', 'sent', NULL, '57-120', '2025-11-04 15:45:04', '2025-11-06 14:34:29'),
(8, 57, 'reminder', 15, '2025-11-06 14:55:00', 'sent', NULL, '57-15', '2025-11-04 15:45:04', '2025-11-06 14:34:31'),
(9, 55, 'reminder', 1440, '2025-11-05 09:05:00', 'sent', NULL, '55-1440', '2025-11-04 15:53:01', '2025-11-05 13:48:15'),
(10, 55, 'reminder', 120, '2025-11-06 07:05:00', 'sent', NULL, '55-120', '2025-11-04 15:53:01', '2025-11-06 02:50:11'),
(11, 55, 'reminder', 15, '2025-11-06 08:50:00', 'sent', NULL, '55-15', '2025-11-04 15:53:01', '2025-11-06 02:50:12'),
(12, 56, 'reminder', 1440, '2025-11-05 13:05:00', 'failed', 'Không có email người dùng', '56-1440', '2025-11-04 15:53:01', '2025-11-05 13:48:15'),
(13, 56, 'reminder', 120, '2025-11-06 11:05:00', 'failed', 'Không có email người dùng', '56-120', '2025-11-04 15:53:01', '2025-11-06 04:05:02'),
(14, 56, 'reminder', 15, '2025-11-06 12:50:00', 'failed', 'Không có email người dùng', '56-15', '2025-11-04 15:53:01', '2025-11-06 05:50:06'),
(15, 58, 'reminder', 1440, '2025-11-05 17:15:00', 'failed', 'Không có email người dùng', '58-1440', '2025-11-04 15:53:01', '2025-11-05 13:48:15'),
(16, 58, 'reminder', 120, '2025-11-06 15:15:00', 'failed', 'Không có email người dùng', '58-120', '2025-11-04 15:53:01', '2025-11-06 14:34:31'),
(17, 58, 'reminder', 15, '2025-11-06 17:00:00', 'failed', 'Không có email người dùng', '58-15', '2025-11-04 15:53:01', '2025-11-06 14:34:31'),
(18, 57, 'reminder', 1, '2025-11-04 22:57:01', 'sent', NULL, '57-1762271821', '2025-11-04 22:57:01', '2025-11-04 15:57:08'),
(19, 59, 'reminder', 1440, '2025-11-13 07:00:00', 'sent', NULL, '59-1440', '2025-11-09 03:33:16', '2025-11-14 10:18:16'),
(20, 59, 'reminder', 120, '2025-11-14 05:00:00', 'sent', NULL, '59-120', '2025-11-09 03:33:16', '2025-11-14 10:18:19'),
(21, 59, 'reminder', 15, '2025-11-09 06:45:00', 'sent', NULL, '59-15', '2025-11-09 03:33:16', '2025-11-09 03:48:36'),
(22, 64, 'reminder', 1440, '2025-11-23 07:00:00', 'failed', 'Không có email người dùng', '64-1440', '2025-11-22 10:35:05', '2025-11-23 00:26:51'),
(23, 64, 'reminder', 120, '2025-11-24 05:00:00', 'failed', 'Không có email người dùng', '64-120', '2025-11-22 10:35:05', '2025-11-25 10:41:34'),
(24, 64, 'reminder', 15, '2025-11-24 06:45:00', 'failed', 'Không có email người dùng', '64-15', '2025-11-22 10:35:05', '2025-11-25 10:41:34'),
(25, 62, 'reminder', 120, '2025-11-23 05:00:00', 'failed', 'Không có email người dùng', '62-120', '2025-11-22 11:02:05', '2025-11-23 00:26:51'),
(26, 62, 'reminder', 15, '2025-11-23 06:45:00', 'failed', 'Không có email người dùng', '62-15', '2025-11-22 11:02:05', '2025-11-23 00:26:51'),
(27, 48, 'reminder', 1440, '2025-11-23 09:05:00', 'sent', NULL, '48-1440', '2025-11-22 16:04:02', '2025-11-25 10:41:34'),
(28, 48, 'reminder', 120, '2025-11-24 07:05:00', 'sent', NULL, '48-120', '2025-11-22 16:04:02', '2025-11-25 10:41:35'),
(29, 48, 'reminder', 15, '2025-11-24 08:50:00', 'sent', NULL, '48-15', '2025-11-22 16:04:02', '2025-11-25 10:41:37'),
(30, 49, 'reminder', 1440, '2025-11-29 13:05:00', 'sent', NULL, '49-1440', '2025-11-28 09:22:33', '2025-11-29 07:00:48'),
(31, 49, 'reminder', 120, '2025-11-30 11:05:00', 'failed', 'Unable to connect with STARTTLS.', '49-120', '2025-11-28 09:22:33', '2025-11-30 07:59:52'),
(32, 49, 'reminder', 15, '2025-11-30 12:50:00', 'failed', 'Unable to connect with STARTTLS.', '49-15', '2025-11-28 09:22:33', '2025-11-30 08:00:08'),
(33, 65, 'reminder', 1440, '2025-12-05 17:15:00', 'failed', 'Không có email người dùng', '65-1440', '2025-12-05 14:52:06', '2025-12-05 14:53:02'),
(34, 65, 'reminder', 120, '2025-12-06 15:15:00', 'failed', 'Không có email người dùng', '65-120', '2025-12-05 14:52:06', '2025-12-08 12:17:39'),
(35, 65, 'reminder', 15, '2025-12-06 17:00:00', 'failed', 'Không có email người dùng', '65-15', '2025-12-05 14:52:06', '2025-12-08 12:17:39'),
(36, 66, 'reminder', 1440, '2025-12-06 07:00:00', 'failed', 'Không có email người dùng', '66-1440', '2025-12-05 14:52:06', '2025-12-08 12:17:37'),
(37, 66, 'reminder', 120, '2025-12-07 05:00:00', 'failed', 'Không có email người dùng', '66-120', '2025-12-05 14:52:07', '2025-12-08 12:17:39'),
(38, 66, 'reminder', 15, '2025-12-07 06:45:00', 'failed', 'Không có email người dùng', '66-15', '2025-12-05 14:52:07', '2025-12-08 12:17:39'),
(39, 67, 'reminder', 1440, '2025-12-06 09:05:00', 'failed', 'Không có email người dùng', '67-1440', '2025-12-05 14:52:07', '2025-12-08 12:17:39'),
(40, 67, 'reminder', 120, '2025-12-07 07:05:00', 'failed', 'Không có email người dùng', '67-120', '2025-12-05 14:52:07', '2025-12-08 12:17:39'),
(41, 67, 'reminder', 15, '2025-12-07 08:50:00', 'failed', 'Không có email người dùng', '67-15', '2025-12-05 14:52:07', '2025-12-08 12:17:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thongtintuyensinh`
--

CREATE TABLE `thongtintuyensinh` (
  `idthongtintuyensinh` int(11) NOT NULL,
  `idnganhtruong` int(11) NOT NULL,
  `chuong_trinh` varchar(100) DEFAULT NULL,
  `idtruong` int(11) NOT NULL,
  `namxettuyen` int(11) DEFAULT NULL,
  `idxettuyen` int(11) DEFAULT NULL,
  `tohopmon` varchar(255) DEFAULT NULL,
  `diemchuan` decimal(4,2) DEFAULT NULL,
  `diem_san` decimal(5,2) DEFAULT NULL,
  `chitieu` int(11) DEFAULT NULL,
  `hocphidaitra` decimal(15,2) DEFAULT NULL,
  `hocphitientien` decimal(15,2) DEFAULT NULL,
  `ghichu` text DEFAULT NULL,
  `trangthai` tinyint(1) NOT NULL DEFAULT 1
) ;

--
-- Đang đổ dữ liệu cho bảng `thongtintuyensinh`
--

INSERT INTO `thongtintuyensinh` (`idthongtintuyensinh`, `idnganhtruong`, `chuong_trinh`, `idtruong`, `namxettuyen`, `idxettuyen`, `tohopmon`, `diemchuan`, `diem_san`, `chitieu`, `hocphidaitra`, `hocphitientien`, `ghichu`, `trangthai`) VALUES
(1, 131, '1', 27, 2024, 1, 'A00;A01;D01', 19.00, 16.00, 100, 5800000.00, 0.00, 'Đào tạo kết hợp trực tuyến 30%', 1),
(2, 132, '1', 27, 2025, 1, 'A00;A01', 20.00, 17.00, 120, 5600000.00, 0.00, 'Thanh toán học phí theo tín chỉ', 1),
(3, 133, '1', 27, 2025, 1, 'A00;D07', 20.00, 17.00, 120, 5400000.00, 0.00, 'Hỗ trợ lệ phí chứng chỉ thực hành', 1),
(4, 134, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5500000.00, 0.00, 'Chuẩn đầu ra kỹ năng phân tích HTTT', 1),
(5, 135, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5300000.00, 0.00, 'Tăng cường môn Phân tích dữ liệu', 1),
(6, 136, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5800000.00, 0.00, 'Thực hành tại phòng lab mạng ảo hóa', 1),
(7, 137, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 6000000.00, 0.00, 'Học phần An toàn thông tin theo CEH', 1),
(8, 138, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5700000.00, 0.00, 'Học phần IoT/Điện tử nhúng tùy chọn', 1),
(9, 139, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5700000.00, 0.00, 'Đồ án tích hợp với doanh nghiệp', 1),
(10, 140, '1', 27, 2026, 1, NULL, 20.00, 15.00, 100, 5800000.00, 0.00, 'Xưởng sáng tạo Media Studio', 1),
(11, 141, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 6200000.00, 0.00, 'Chương trình 5 năm, đồ án kiến trúc', 1),
(12, 142, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5400000.00, 0.00, 'Phòng thí nghiệm sinh học phân tử', 1),
(13, 143, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5200000.00, 0.00, 'Phí vật tư thí nghiệm tính riêng', 1),
(14, 144, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5000000.00, 0.00, 'Liên kết thực tập tại toà án/viện kiểm sát', 1),
(15, 145, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5600000.00, 0.00, 'CLB học thuật IR miễn phí cho SV', 1),
(16, 146, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5400000.00, 0.00, 'Học phần chuyên sâu kiểm toán', 1),
(17, 147, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5400000.00, 0.00, 'Tăng cường kỹ năng phân tích dữ liệu', 1),
(18, 148, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5500000.00, 0.00, 'Lộ trình học CFA level 1 tích hợp', 1),
(19, 149, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5600000.00, 0.00, 'Chuẩn CDIO, đồ án theo nhóm', 1),
(20, 150, '1', 27, NULL, 1, NULL, 20.00, 15.00, 100, 5600000.00, 0.00, 'Thực hành CAD/CAM nâng cao', 1),
(32, 141, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 6200000.00, 0.00, 'Chương trình 5 năm, đồ án kiến trúc', 1),
(33, 142, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5400000.00, 0.00, 'Phòng thí nghiệm sinh học phân tử', 1),
(34, 143, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5200000.00, 0.00, 'Phí vật tư thí nghiệm tính riêng', 1),
(35, 144, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5000000.00, 0.00, 'Liên kết thực tập tại toà án/viện kiểm sát', 1),
(36, 145, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5600000.00, 0.00, 'CLB học thuật IR miễn phí cho SV', 1),
(37, 146, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5400000.00, 0.00, 'Học phần chuyên sâu kiểm toán', 1),
(38, 147, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5400000.00, 0.00, 'Tăng cường kỹ năng phân tích dữ liệu', 1),
(39, 148, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5500000.00, 0.00, 'Lộ trình học CFA level 1 tích hợp', 1),
(40, 149, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5600000.00, 0.00, 'Chuẩn CDIO, đồ án theo nhóm', 1),
(41, 150, '1', 27, 2025, 1, NULL, 20.00, 17.00, 120, 5600000.00, 0.00, 'Thực hành CAD/CAM nâng cao', 1);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `thong_tin_bo_sung_phuong_thuc`
--

CREATE TABLE `thong_tin_bo_sung_phuong_thuc` (
  `idthong_tin_bo_sung` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `loai_thong_tin` varchar(50) NOT NULL COMMENT 'SAT_CODE, ACT_CODE, DIEM_TOI_THIEU, THOI_HAN_CHUNG_CHI',
  `ten_thong_tin` varchar(200) NOT NULL,
  `noi_dung` text NOT NULL,
  `thu_tu` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `thong_tin_bo_sung_phuong_thuc`
--

INSERT INTO `thong_tin_bo_sung_phuong_thuc` (`idthong_tin_bo_sung`, `idphuong_thuc_chi_tiet`, `loai_thong_tin`, `ten_thong_tin`, `noi_dung`, `thu_tu`, `created_at`, `updated_at`) VALUES
(1, 4, 'SAT_CODE', 'Mã đăng ký SAT', 'Thí sinh khi thi SAT cần đăng ký mã của Trường Đại học Công nghiệp TP. Hồ Chí Minh với tổ chức thi SAT là 1234-IUH (mã giả định, cần cập nhật mã thực tế)', 1, '2025-12-01 06:00:12', '2025-12-01 06:00:12'),
(2, 1, 'ACT_CODE', 'Mã đăng ký ACT', 'Thí sinh khi thi ACT cần đăng ký mã của Trường Đại học Công nghiệp TP. Hồ Chí Minh với tổ chức thi ACT là 5678-IUH (mã giả định, cần cập nhật mã thực tế)', 2, '2025-12-01 06:00:12', '2025-12-01 06:00:12'),
(3, 1, 'DIEM_TOI_THIEU', 'Điểm tối thiểu xét tuyển', 'Điểm tối thiểu xét tuyển = Điểm sàn do Bộ GD&ĐT quy định. Trường có thể quy định điểm chuẩn cao hơn điểm sàn tùy theo từng ngành và số lượng hồ sơ đăng ký.', 1, '2025-12-01 06:00:12', '2025-12-01 06:00:12'),
(4, 4, 'THOI_HAN_CHUNG_CHI', 'Thời hạn chứng chỉ quốc tế', 'Chứng chỉ IELTS, TOEFL, SAT, ACT phải còn hiệu lực trong thời gian nộp hồ sơ. Thời hạn chứng chỉ: IELTS/TOEFL: 2 năm; SAT/ACT: 5 năm.', 3, '2025-12-01 06:00:12', '2025-12-01 06:00:12');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tin_nhan`
--

CREATE TABLE `tin_nhan` (
  `idtinnhan` int(11) NOT NULL,
  `idphongchat` int(11) NOT NULL,
  `idnguoigui` int(11) NOT NULL,
  `noi_dung` text NOT NULL,
  `tep_dinh_kem` varchar(255) DEFAULT NULL,
  `da_xem` tinyint(1) NOT NULL DEFAULT 0,
  `ngay_xem` timestamp NULL DEFAULT NULL,
  `ngay_tao` timestamp NOT NULL DEFAULT current_timestamp(),
  `xoa_mem_luc` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `tin_nhan`
--

INSERT INTO `tin_nhan` (`idtinnhan`, `idphongchat`, `idnguoigui`, `noi_dung`, `tep_dinh_kem`, `da_xem`, `ngay_xem`, `ngay_tao`, `xoa_mem_luc`) VALUES
(1, 1, 5, 'ádsfghj', NULL, 0, NULL, '2025-10-29 00:38:09', NULL),
(2, 1, 15, 'chào', NULL, 0, NULL, '2025-10-29 00:47:05', NULL),
(3, 1, 5, 'dfghjk', NULL, 0, NULL, '2025-10-29 00:47:45', NULL),
(4, 1, 15, 'qừdgfg', NULL, 0, NULL, '2025-10-29 00:50:05', NULL),
(5, 1, 5, 'dak chào', NULL, 0, NULL, '2025-10-29 00:50:15', NULL),
(6, 2, 5, 'chào em', NULL, 0, NULL, '2025-10-29 01:08:47', NULL),
(7, 2, 5, 'ádfg', NULL, 0, NULL, '2025-10-29 01:13:05', NULL),
(8, 2, 5, 'zdfdfgfhgg', NULL, 0, NULL, '2025-10-29 01:14:50', NULL),
(9, 2, 33, 'xxvgh', NULL, 0, NULL, '2025-10-29 01:15:24', NULL),
(10, 2, 33, 'chào', NULL, 0, NULL, '2025-10-29 02:46:25', NULL),
(11, 2, 33, 'chào', NULL, 0, NULL, '2025-10-29 02:46:27', NULL),
(12, 1, 15, 'sàdg', NULL, 0, NULL, '2025-10-30 00:24:37', NULL),
(13, 1, 15, 'sàdgsadfg', NULL, 0, NULL, '2025-10-30 00:24:53', NULL),
(14, 1, 15, '1234', NULL, 0, NULL, '2025-10-30 00:34:42', NULL),
(15, 1, 15, 'ưedfg', NULL, 0, NULL, '2025-10-30 00:36:43', NULL),
(16, 7, 5, 'gh', NULL, 0, NULL, '2025-11-08 09:35:52', NULL),
(17, 11, 15, 'chào', NULL, 0, NULL, '2025-11-08 20:33:52', NULL),
(18, 11, 5, 'hi', NULL, 0, NULL, '2025-11-08 20:34:41', NULL),
(19, 2, 33, '[FILE:https://res.cloudinary.com/dmbsmwwtf/raw/upload/v1763860341/chat_support/chat_support/TestCase_DoanhNghiep__1__1763860331.tmp:TestCase_DoanhNghiep (1).docx]', NULL, 0, NULL, '2025-11-22 18:12:37', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tin_nhan_support`
--

CREATE TABLE `tin_nhan_support` (
  `idtinnhan_support` int(11) NOT NULL,
  `idphongchat_support` int(11) NOT NULL COMMENT 'ID phòng chat hỗ trợ',
  `idnguoigui` int(11) NOT NULL COMMENT 'ID người gửi tin nhắn',
  `noi_dung` text NOT NULL COMMENT 'Nội dung tin nhắn',
  `tep_dinh_kem` varchar(255) DEFAULT NULL COMMENT 'Đường dẫn file đính kèm',
  `da_xem` tinyint(1) DEFAULT 0 COMMENT '0: Chưa xem, 1: Đã xem',
  `ngay_xem` datetime DEFAULT NULL COMMENT 'Thời gian xem tin nhắn',
  `ngay_tao` datetime DEFAULT current_timestamp() COMMENT 'Thời gian tạo tin nhắn',
  `xoa_mem_luc` datetime DEFAULT NULL COMMENT 'Thời gian xóa mềm (soft delete)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tin nhắn trong phòng chat hỗ trợ';

--
-- Đang đổ dữ liệu cho bảng `tin_nhan_support`
--

INSERT INTO `tin_nhan_support` (`idtinnhan_support`, `idphongchat_support`, `idnguoigui`, `noi_dung`, `tep_dinh_kem`, `da_xem`, `ngay_xem`, `ngay_tao`, `xoa_mem_luc`) VALUES
(1, 1, 15, 'vcvcv', NULL, 1, '2025-11-22 15:04:20', '2025-11-22 14:18:12', NULL),
(2, 1, 15, 'ghg', NULL, 1, '2025-11-22 15:04:20', '2025-11-22 14:27:22', NULL),
(3, 1, 15, 'gfg', NULL, 1, '2025-11-22 15:04:20', '2025-11-22 14:42:45', NULL),
(4, 3, 6, 'vbn', NULL, 1, '2025-11-23 01:18:35', '2025-11-22 15:05:44', NULL),
(5, 1, 6, 'hghj', NULL, 1, '2025-11-22 15:06:05', '2025-11-22 15:05:54', NULL),
(6, 1, 6, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1763825324/chat_support/qd7dlnw6fxyxjvqifvk2.jpg', 1, '2025-11-22 15:29:12', '2025-11-22 15:28:55', NULL),
(7, 1, 15, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/raw/upload/v1763825748/chat_support/oplcouldmoltlf0lberd.tmp', 1, '2025-11-22 15:36:05', '2025-11-22 15:35:50', NULL),
(8, 1, 6, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/raw/upload/v1763826136/chat_support/m3cllljhisy78wurtpgi.tmp|TestCase_DoanhNghiep.docx', 1, '2025-11-22 15:42:35', '2025-11-22 15:42:18', NULL),
(9, 1, 6, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/raw/upload/v1763826451/chat_support/chat_support/TestCase_DoanhNghiep_1763826447.tmp|TestCase_DoanhNghiep.docx', 1, '2025-11-22 15:48:23', '2025-11-22 15:47:35', NULL),
(10, 1, 15, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1763866668/chat_support/chat_support/cac_mau_xe_o_to_the_thao_gia_re_nhat_3-1400x788_1763866661.jpg|cac_mau_xe_o_to_the_thao_gia_re_nhat_3-1400x788.jpg', 1, '2025-11-23 02:58:22', '2025-11-23 02:57:56', NULL),
(11, 1, 6, 'hjjl', NULL, 1, '2025-12-01 16:32:39', '2025-12-01 16:32:38', NULL),
(12, 4, 33, 'fghj', NULL, 1, '2025-12-05 04:06:52', '2025-12-05 04:04:55', NULL),
(13, 4, 33, '[Đã gửi file]', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764907547/chat_support/chat_support/sitemap_actors_4_drawio__1__1764907537.png|sitemap_actors_4.drawio (1).png', 1, '2025-12-05 04:07:09', '2025-12-05 04:06:55', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tin_tuyensinh`
--

CREATE TABLE `tin_tuyensinh` (
  `id_tin` int(11) NOT NULL,
  `id_truong` int(11) DEFAULT NULL,
  `id_nguoidang` int(11) DEFAULT NULL,
  `tieu_de` varchar(255) NOT NULL,
  `tom_tat` text DEFAULT NULL,
  `hinh_anh_dai_dien` varchar(255) DEFAULT NULL,
  `nguon_bai_viet` varchar(500) DEFAULT NULL,
  `loai_tin` enum('Tin tuyển sinh','Thông báo','Học bổng','Sự kiện','Khác') NOT NULL DEFAULT 'Tin tuyển sinh',
  `trang_thai` enum('Chờ duyệt','Đã duyệt','Ẩn','Đã gỡ') NOT NULL DEFAULT 'Chờ duyệt',
  `ngay_dang` datetime NOT NULL DEFAULT current_timestamp(),
  `ngay_cap_nhat` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `ma_nguon` varchar(50) DEFAULT NULL,
  `hash_noidung` char(64) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tin_tuyensinh`
--

INSERT INTO `tin_tuyensinh` (`id_tin`, `id_truong`, `id_nguoidang`, `tieu_de`, `tom_tat`, `hinh_anh_dai_dien`, `nguon_bai_viet`, `loai_tin`, `trang_thai`, `ngay_dang`, `ngay_cap_nhat`, `ma_nguon`, `hash_noidung`) VALUES
(3, 240, NULL, 'https://ts.udn.vn/DHCD/Chinhquy/DHTbao/15171', 'sdfghj', 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/2wBDAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQH/wAARCAHeA1IDASIAAhEB', 'https://ts.udn.vn/DHCD/Chinhquy/DHTbao/15171', 'Thông báo', 'Đã duyệt', '2025-11-06 05:14:55', '2025-11-06 12:33:03', 'dfgf', 'ff98d2d5c00e37d09650af2e091b187a53dbbc0b11254b508f71db7ed3ddca0e'),
(4, 26, NULL, 'test', 'sdfvd', 'http://localhost:5173/analyst/posts', 'http://localhost:5173/analyst/posts', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-06 05:39:52', NULL, 'ẻdgfhgj', ''),
(5, 199, NULL, 'ưertyh', 'xzdfg', '/storage/img/dvQbcp3RzbYzCaaM70FRHxmGocnMtQCPKy4IbI7w.jpg', 'http://localhost:5173/analyst/posts', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-06 16:04:30', NULL, 'sdfghh', ''),
(6, NULL, NULL, 'sdfbg', 'ÁDFGsdf', '/storage/img/jkwAoxRWr1Kv4QOCL69u0KKL3CEcz2gUiHD2hqFi.png', 'http://localhost:5173/analyst/posts', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-06 16:08:38', NULL, 'sdfg', ''),
(7, 24, NULL, 'sdfghgj', 'ádfgh', '/storage/img/sodYac9l4vJVKmMWw9Nz0K7lCDdytQE1bOltnNK0.jpg', 'http://localhost:5173/analyst/posts', 'Thông báo', 'Đã duyệt', '2025-11-06 16:13:19', NULL, 'dgfhyjku', ''),
(8, NULL, NULL, 'dbv', 'dfghj', '/storage/img/s69PxBVooMyTQidvcMrHKmAa0mh0BEUkf64d4Qkc.jpg', 'http://localhost:5173/analyst/posts', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-06 16:19:22', NULL, 'scvc', ''),
(9, 224, NULL, 'sdfdg', 'ádfgn', '/storage/img/myUZcOQnsyqN1zpmwLqFWEfKAzbnWgUF5OaDLDQa.png', 'http://localhost:5173/analyst/posts', 'Thông báo', 'Đã duyệt', '2025-11-06 16:29:56', NULL, 'asafdsg', ''),
(15, 223, NULL, 'Bộ sách giáo khoa tiếng Anh thiết kế theo khung chương trình Bộ Giáo dục', 'Từ năm 2026, trường Đại học Sư phạm Hà Nội 2 bỏ xét học bạ với 17 ngành, đồng thời bỏ xét điểm thi đánh giá năng lực của hai đại học quốc gia và Sư phạm Hà Nội.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764300705/Tracuutuyensinh/phpE8F7.jpg', 'https://vnexpress.net/bo-sach-giao-khoa-tieng-anh-thiet-ke-theo-khung-chuong-trinh-bo-giao-duc-4987004.html', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-28 03:31:46', NULL, 'dddfhg', ''),
(16, 212, NULL, 'Nhiều đại học xóa sổ tổ hợp truyền thống, giảm xét học bạ', 'Nhiều đại học dự kiến phương thức tuyển sinh 2026 theo hướng bỏ một số tổ hợp truyền thống như C00, A00, A01 hoặc giảm xét học bạ.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764315714/Tracuutuyensinh/php894F.jpg', 'https://vnexpress.net/nhieu-dai-hoc-xoa-so-to-hop-truyen-thong-giam-xet-hoc-ba-4985589.html', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-28 07:41:55', NULL, 'DHT', ''),
(20, 212, NULL, 'Lịch thi đánh giá năng lực Đại học Quốc gia Hà Nội từ tháng 3/2026', 'Kỳ thi đánh giá năng lực HSA của Đại học Quốc gia Hà Nội diễn ra từ tháng 3 đến 5/2026 ở nhiều tỉnh, thành, thí sinh đăng ký thi từ cuối tháng 12.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764315997/Tracuutuyensinh/php72B.jpg', 'https://vnexpress.net/lich-thi-danh-gia-nang-luc-hsa-cua-dai-hoc-quoc-gia-ha-noi-nam-2026-moi-nhat-4961423.html', 'Thông báo', 'Đã duyệt', '2025-11-28 07:46:38', '2025-11-30 00:56:08', 'fgh', 'e5be0e748031bfa9c23dd38cd56b60199efd8f027b621487db2c3aadd231efec'),
(21, 223, NULL, 'Học viện Biên phòng bỏ xét tuyển tổ hợp C00, A01', 'Từ năm 2026, Học viện Biên phòng sẽ chỉ dùng ba tổ hợp xét tuyển, không xét bằng C00 (Văn, Sử, Địa) và A01 (Toán, Lý, Anh) như mọi năm.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764316549/Tracuutuyensinh/php78DA.webp', 'https://vnexpress.net/hoc-vien-bien-phong-bo-xet-tuyen-to-hop-c00-a01-4964917.html', 'Thông báo', 'Đã duyệt', '2025-11-28 07:55:49', '2025-12-01 17:40:57', 'xvcv', '46664d616108d19c1684049b9b20519d590b9593079be73e04e0b0527472b95d'),
(22, 223, NULL, 'Trường y đầu tiên dự kiến phương án tuyển sinh 2026', 'Trường Đại học Y khoa Phạm Ngọc Thạch dự kiến tăng chỉ tiêu, mở thêm ngành và chương trình đào tạo Y khoa mới vào năm 2026.', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764320073/Tracuutuyensinh/php4215.webp', 'https://vnexpress.net/dai-hoc-y-khoa-pham-ngoc-thach-du-kien-phuong-thuc-tuyen-sinh-2026-4962774.html', 'Thông báo', 'Đã duyệt', '2025-11-28 08:54:34', '2025-11-30 01:18:46', 'dbgfn', 'a6da25de94a3dacfdd74615e431fc57439491299e9a9f40987efa328f1a5c7f8'),
(23, 224, NULL, 'Thông tin tuyển sinh Học viện kỹ thuật quân sự 2026', 'Học viện kỹ thuật quân sự thông báo tổ hợp xét tuyển năm 2026 gồm các tổ hợp như sau:', 'https://res.cloudinary.com/dmbsmwwtf/image/upload/v1764320618/Tracuutuyensinh/php8CD4.png', 'https://thi.tuyensinh247.com/thong-tin-tuyen-sinh-hoc-vien-ky-thuat-quan-su-2026-c24a87813.html', 'Tin tuyển sinh', 'Đã duyệt', '2025-11-28 09:03:38', '2025-11-30 01:05:41', 'xdgf', '0e1d13591f62a0783facf36ccbeaa5c1f76cc22c22ade398f31d2e22521842b4');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `tohop_xettuyen`
--

CREATE TABLE `tohop_xettuyen` (
  `ma_to_hop` varchar(10) NOT NULL,
  `mon1` varchar(100) NOT NULL,
  `mon2` varchar(100) NOT NULL,
  `mon3` varchar(120) NOT NULL,
  `mo_ta` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `tohop_xettuyen`
--

INSERT INTO `tohop_xettuyen` (`ma_to_hop`, `mon1`, `mon2`, `mon3`, `mo_ta`, `created_at`, `updated_at`) VALUES
('A00', 'Toán', 'Vật lý', 'Hóa học', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A01', 'Toán', 'Vật lý', 'Tiếng Anh', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A02', 'Toán', 'Vật lý', 'Sinh học', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A03', 'Toán', 'Vật lý', 'Lịch sử', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A04', 'Toán', 'Vật lý', 'Địa lý', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A05', 'Toán', 'Hóa học', 'Lịch sử', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A06', 'Toán', 'Hóa học', 'Địa lý', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A07', 'Toán', 'Lịch sử', 'Địa lý', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A08', 'Toán', 'Lịch sử', 'Giáo dục KT&PL', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A09', 'Toán', 'Địa lý', 'Giáo dục KT&PL', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A10', 'Toán', 'Lý', 'Giáo dục KT&PL', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A11', 'Toán', 'Hóa', 'Giáo dục KT&PL', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A12', 'Toán', 'Khoa học tự nhiên', 'Khoa học xã hội', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A14', 'Toán', 'Khoa học tự nhiên', 'Địa lý', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A15', 'Toán', 'Khoa học tự nhiên', 'Giáo dục KT&PL', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A16', 'Toán', 'Khoa học tự nhiên', 'Ngữ văn', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A17', 'Toán', 'Khoa học xã hội', 'Vật lý', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('A18', 'Toán', 'Khoa học xã hội', 'Hóa học', 'Khối A (Tự nhiên/Kỹ thuật)', NULL, NULL),
('B00', 'Toán', 'Hóa học', 'Sinh học', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B01', 'Toán', 'Sinh học', 'Lịch sử', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B02', 'Toán', 'Sinh học', 'Địa lý', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B03', 'Toán', 'Sinh học', 'Ngữ văn', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B04', 'Toán', 'Sinh học', 'Giáo dục KT&PL', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B05', 'Toán', 'Sinh học', 'Khoa học xã hội', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('B08', 'Toán', 'Sinh học', 'Tiếng Anh', 'Khối B (Sinh - Y dược - Nông lâm)', NULL, NULL),
('C00', 'Ngữ văn', 'Lịch sử', 'Địa lý', 'Khối C (Xã hội)', NULL, NULL),
('C01', 'Ngữ văn', 'Toán', 'Vật lý', 'Khối C (Xã hội)', NULL, NULL),
('C02', 'Ngữ văn', 'Toán', 'Hóa học', 'Khối C (Xã hội)', NULL, NULL),
('C03', 'Ngữ văn', 'Toán', 'Lịch sử', 'Khối C (Xã hội)', NULL, NULL),
('C04', 'Ngữ văn', 'Toán', 'Địa lý', 'Khối C (Xã hội)', NULL, NULL),
('C05', 'Ngữ văn', 'Vật lý', 'Hóa học', 'Khối C (Xã hội)', NULL, NULL),
('C06', 'Ngữ văn', 'Vật lý', 'Sinh học', 'Khối C (Xã hội)', NULL, NULL),
('C07', 'Ngữ văn', 'Vật lý', 'Lịch sử', 'Khối C (Xã hội)', NULL, NULL),
('C08', 'Ngữ văn', 'Hóa học', 'Sinh học', 'Khối C (Xã hội)', NULL, NULL),
('C09', 'Ngữ văn', 'Vật lý', 'Địa lý', 'Khối C (Xã hội)', NULL, NULL),
('C10', 'Ngữ văn', 'Hóa học', 'Lịch sử', 'Khối C (Xã hội)', NULL, NULL),
('C12', 'Ngữ văn', 'Lịch sử', 'Sinh học', 'Khối C (Xã hội)', NULL, NULL),
('C13', 'Ngữ văn', 'Sinh học', 'Địa lý', 'Khối C (Xã hội)', NULL, NULL),
('C14', 'Ngữ văn', 'Toán', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C15', 'Ngữ văn', 'Vật lý', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C16', 'Ngữ văn', 'Hóa học', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C17', 'Ngữ văn', 'Sinh học', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C18', 'Ngữ văn', 'Lịch sử', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C19', 'Ngữ văn', 'Địa lý', 'Giáo dục KT&PL', 'Khối C (Xã hội)', NULL, NULL),
('C20', 'Ngữ văn', 'Khoa học tự nhiên', 'Khoa học xã hội', 'Khối C (Xã hội)', NULL, NULL),
('D01', 'Toán', 'Ngữ văn', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D02', 'Toán', 'Ngữ văn', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D03', 'Toán', 'Ngữ văn', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D04', 'Toán', 'Ngữ văn', 'Tiếng Trung', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D05', 'Toán', 'Ngữ văn', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D06', 'Toán', 'Ngữ văn', 'Tiếng Nhật', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D07', 'Toán', 'Hóa học', 'Tiếng Anh', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D08', 'Toán', 'Sinh học', 'Tiếng Anh', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D09', 'Toán', 'Lịch sử', 'Tiếng Anh', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D10', 'Toán', 'Địa lý', 'Tiếng Anh', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D11', 'Ngữ văn', 'Vật lý', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D12', 'Ngữ văn', 'Hóa học', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D13', 'Ngữ văn', 'Sinh học', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D14', 'Ngữ văn', 'Lịch sử', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D15', 'Ngữ văn', 'Địa lý', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D16', 'Toán', 'Địa lý', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D17', 'Toán', 'Địa lý', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D18', 'Toán', 'Địa lý', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D19', 'Toán', 'Địa lý', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D20', 'Toán', 'Địa lý', 'Tiếng Trung', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D21', 'Toán', 'Hóa học', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D22', 'Toán', 'Hóa học', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D23', 'Toán', 'Hóa học', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D24', 'Toán', 'Hóa học', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D25', 'Toán', 'Hóa học', 'Tiếng Trung', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D26', 'Toán', 'Sinh học', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D27', 'Toán', 'Sinh học', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D28', 'Toán', 'Vật lý', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D29', 'Toán', 'Vật lý', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D30', 'Toán', 'Sinh học', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D31', 'Toán', 'Sinh học', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D32', 'Toán', 'Văn', 'Tiếng Hàn', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D33', 'Toán', 'Sinh học', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D34', 'Toán', 'Sinh học', 'Tiếng Trung', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D35', 'Toán', 'Hóa học', 'Tiếng Hàn', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D36', 'Toán', 'Sinh học', 'Tiếng Hàn', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D37', 'Toán', 'Vật lý', 'Tiếng Hàn', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D38', 'Toán', 'Địa lý', 'Tiếng Hàn', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D39', 'Ngữ văn', 'Địa lý', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D40', 'Ngữ văn', 'Địa lý', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D41', 'Ngữ văn', 'Địa lý', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D42', 'Ngữ văn', 'Địa lý', 'Tiếng Nhật', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D43', 'Ngữ văn', 'Địa lý', 'Tiếng Trung', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D44', 'Ngữ văn', 'Hóa học', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D45', 'Ngữ văn', 'Hóa học', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D46', 'Ngữ văn', 'Hóa học', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D47', 'Ngữ văn', 'Hóa học', 'Tiếng Nhật', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D48', 'Ngữ văn', 'Hóa học', 'Tiếng Trung', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D52', 'Ngữ văn', 'Vật lý', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D53', 'Ngữ văn', 'Vật lý', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D54', 'Ngữ văn', 'Vật lý', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D55', 'Ngữ văn', 'Vật lý', 'Tiếng Nhật', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D56', 'Ngữ văn', 'Vật lý', 'Tiếng Trung', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D57', 'Ngữ văn', 'Lịch sử', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D58', 'Ngữ văn', 'Lịch sử', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D59', 'Ngữ văn', 'Lịch sử', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D60', 'Ngữ văn', 'Lịch sử', 'Tiếng Nhật', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D61', 'Ngữ văn', 'Lịch sử', 'Tiếng Trung', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D62', 'Toán', 'Lịch sử', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D63', 'Toán', 'Lịch sử', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D64', 'Toán', 'Lịch sử', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D65', 'Toán', 'Lịch sử', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D66', 'Ngữ văn', 'Giáo dục công dân', 'Tiếng Anh', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Anh', NULL, NULL),
('D67', 'Toán', 'Ngữ văn', 'Tiếng Nga', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D68', 'Toán', 'Ngữ văn', 'Tiếng Pháp', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D69', 'Toán', 'Ngữ văn', 'Tiếng Đức', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D70', 'Toán', 'Ngữ văn', 'Tiếng Hàn', 'Khối D (Văn + Toán + Ngoại ngữ/xã hội); Ngoại ngữ: Tiếng Hàn', NULL, NULL),
('D71', 'Toán', 'Hóa học', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D72', 'Toán', 'Hóa học', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D73', 'Toán', 'Hóa học', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D74', 'Toán', 'Sinh học', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D75', 'Toán', 'Sinh học', 'Tiếng Đức', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Đức', NULL, NULL),
('D76', 'Toán', 'Sinh học', 'Tiếng Trung', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('D77', 'Toán', 'Địa lý', 'Tiếng Nga', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nga', NULL, NULL),
('D78', 'Toán', 'Địa lý', 'Tiếng Pháp', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Pháp', NULL, NULL),
('D79', 'Toán', 'Địa lý', 'Tiếng Nhật', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Nhật', NULL, NULL),
('D80', 'Toán', 'Địa lý', 'Tiếng Trung', 'Khối D (Toán + môn tự nhiên/xã hội + Ngoại ngữ); Ngoại ngữ: Tiếng Trung', NULL, NULL),
('H00', 'Ngữ văn', 'Năng khiếu vẽ', 'Năng khiếu trang trí', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H01', 'Toán', 'Ngữ văn', 'Năng khiếu vẽ', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H02', 'Ngữ văn', 'Anh', 'Năng khiếu vẽ', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H03', 'Ngữ văn', 'Khoa học xã hội', 'Năng khiếu vẽ', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H04', 'Toán', 'Anh', 'Năng khiếu thiết kế', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H05', 'Ngữ văn', 'Khoa học tự nhiên', 'Năng khiếu vẽ', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('H06', 'Ngữ văn', 'Địa lý', 'Năng khiếu vẽ', 'Khối H (Năng khiếu Mỹ thuật/Trang trí)', NULL, NULL),
('M00', 'Ngữ văn', 'Toán', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('M01', 'Ngữ văn', 'Khoa học tự nhiên', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('M02', 'Ngữ văn', 'Khoa học xã hội', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('M03', 'Ngữ văn', 'Tiếng Anh', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('M05', 'Toán', 'Tiếng Anh', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('M07', 'Ngữ văn', 'Địa lý', 'Năng khiếu mầm non', 'Khối M (Giáo dục Mầm non/tiểu học - năng khiếu)', NULL, NULL),
('N00', 'Ngữ văn', 'Năng khiếu âm nhạc 1', 'Năng khiếu âm nhạc 2', 'Khối N (Âm nhạc - năng khiếu)', NULL, NULL),
('N01', 'Ngữ văn', 'Giáo dục KT&PL', 'Năng khiếu âm nhạc', 'Khối N (Âm nhạc - năng khiếu)', NULL, NULL),
('N02', 'Ngữ văn', 'Tiếng Anh', 'Năng khiếu âm nhạc', 'Khối N (Âm nhạc - năng khiếu)', NULL, NULL),
('N03', 'Ngữ văn', 'Khoa học xã hội', 'Năng khiếu âm nhạc', 'Khối N (Âm nhạc - năng khiếu)', NULL, NULL),
('N05', 'Ngữ văn', 'Toán', 'Năng khiếu âm nhạc', 'Khối N (Âm nhạc - năng khiếu)', NULL, NULL),
('R00', 'Ngữ văn', 'Năng khiếu báo chí', 'Năng khiếu quay phim', 'Khối R (Báo chí, Quay phim - năng khiếu)', NULL, NULL),
('R01', 'Ngữ văn', 'Tiếng Anh', 'Năng khiếu báo chí', 'Khối R (Báo chí, Quay phim - năng khiếu)', NULL, NULL),
('R02', 'Ngữ văn', 'Khoa học xã hội', 'Năng khiếu báo chí', 'Khối R (Báo chí, Quay phim - năng khiếu)', NULL, NULL),
('R03', 'Ngữ văn', 'Lịch sử', 'Năng khiếu báo chí', 'Khối R (Báo chí, Quay phim - năng khiếu)', NULL, NULL),
('R04', 'Ngữ văn', 'Địa lý', 'Năng khiếu báo chí', 'Khối R (Báo chí, Quay phim - năng khiếu)', NULL, NULL),
('S00', 'Ngữ văn', 'Năng khiếu sân khấu', 'Năng khiếu điện ảnh', 'Khối S (Sân khấu - Điện ảnh - năng khiếu)', NULL, NULL),
('S01', 'Ngữ văn', 'Tiếng Anh', 'Năng khiếu điện ảnh', 'Khối S (Sân khấu - Điện ảnh - năng khiếu)', NULL, NULL),
('S02', 'Ngữ văn', 'Khoa học xã hội', 'Năng khiếu điện ảnh', 'Khối S (Sân khấu - Điện ảnh - năng khiếu)', NULL, NULL),
('S03', 'Ngữ văn', 'Lịch sử', 'Năng khiếu sân khấu', 'Khối S (Sân khấu - Điện ảnh - năng khiếu)', NULL, NULL),
('S04', 'Ngữ văn', 'Địa lý', 'Năng khiếu sân khấu', 'Khối S (Sân khấu - Điện ảnh - năng khiếu)', NULL, NULL),
('T00', 'Toán', 'Sinh học', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T01', 'Toán', 'Ngữ văn', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T02', 'Ngữ văn', 'Sinh học', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T03', 'Toán', 'Địa lý', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T04', 'Toán', 'Khoa học xã hội', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T05', 'Toán', 'Tiếng Anh', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T06', 'Toán', 'Khoa học tự nhiên', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T07', 'Ngữ văn', 'Địa lý', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('T08', 'Ngữ văn', 'Tiếng Anh', 'Năng khiếu TDTT', 'Khối T (Thể dục thể thao - năng khiếu)', NULL, NULL),
('V00', 'Toán', 'Vật lý', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V01', 'Toán', 'Ngữ văn', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V02', 'Toán', 'Tiếng Anh', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V03', 'Toán', 'Hóa học', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V05', 'Ngữ văn', 'Vật lý', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V06', 'Toán', 'Địa lý', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V07', 'Toán', 'Tiếng Đức', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V08', 'Toán', 'Tiếng Nga', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V09', 'Toán', 'Tiếng Nhật', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V10', 'Toán', 'Tiếng Pháp', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL),
('V11', 'Toán', 'Tiếng Trung', 'Vẽ mỹ thuật', 'Khối V (Kiến trúc/Mỹ thuật - năng khiếu vẽ)', NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `truongdaihoc`
--

CREATE TABLE `truongdaihoc` (
  `idtruong` int(11) NOT NULL,
  `matruong` varchar(20) NOT NULL,
  `tentruong` varchar(200) NOT NULL,
  `diachi` text DEFAULT NULL,
  `dienthoai` varchar(20) DEFAULT NULL,
  `lienhe` varchar(200) DEFAULT NULL,
  `sodienthoai` varchar(20) DEFAULT NULL,
  `ngaythanhlap` date DEFAULT NULL,
  `motantuong` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `truongdaihoc`
--

INSERT INTO `truongdaihoc` (`idtruong`, `matruong`, `tentruong`, `diachi`, `dienthoai`, `lienhe`, `sodienthoai`, `ngaythanhlap`, `motantuong`) VALUES
(1, 'VNU', 'Đại học Quốc gia Hà Nội', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '024 3754 7506', 'dhqghn@vnu.edu.vn', '024 3754 7506', '1993-01-01', 'Đại học đa ngành hàng đầu Việt Nam, bao gồm nhiều trường thành viên uy tín.'),
(2, 'HUST', 'Trường Đại học Bách khoa Hà Nội', '1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', '024 3868 3008', 'hust@hust.edu.vn', '024 3868 3008', '1956-10-15', 'Trường đại học kỹ thuật hàng đầu Việt Nam, chuyên đào tạo các ngành kỹ thuật và công nghệ.'),
(3, 'VNU-HCM', 'Đại học Quốc gia TP. Hồ Chí Minh', 'Phường Linh Trung, Tp. Thủ Đức, TP. Hồ Chí Minh', '028 3725 4269', 'vnuhcm@vnuhcm.edu.vn', '028 3725 4269', '1995-01-01', 'Đại học đa ngành lớn nhất miền Nam, gồm nhiều trường thành viên chất lượng cao.'),
(4, 'UEH', 'Trường Đại học Kinh tế TP. Hồ Chí Minh', '279 Nguyễn Tri Phương, Q.10, TP. Hồ Chí Minh', '028 3930 9589', 'ueh@ueh.edu.vn', '028 3930 9589', '1976-08-01', 'Trường đại học kinh tế hàng đầu Việt Nam, chuyên đào tạo các ngành kinh tế, quản trị và tài chính.'),
(5, 'NEU', 'Trường Đại học Kinh tế Quốc dân', '207 Giải Phóng, Hai Bà Trưng, Hà Nội', '024 3974 2358', 'neu@neu.edu.vn', '024 3974 2358', '1956-01-01', 'Trường đại học kinh tế công lập uy tín, đào tạo đa ngành về kinh tế và quản trị kinh doanh.'),
(6, 'HCMUT', 'Trường Đại học Bách khoa TP. Hồ Chí Minh', '268 Lý Thường Kiệt, Q.10, TP. Hồ Chí Minh', '028 3865 4999', 'hcmut@hcmut.edu.vn', '028 3865 4999', '1957-10-02', 'Trường đại học kỹ thuật hàng đầu miền Nam, chuyên đào tạo kỹ sư các ngành.'),
(7, 'HMU', 'Trường Đại học Y Hà Nội', '1 Tôn Thất Tùng, Đống Đa, Hà Nội', '024 3852 3798', 'hmu@hmu.edu.vn', '024 3852 3798', '1902-01-01', 'Trường đại học y khoa lâu đời và uy tín nhất Việt Nam.'),
(8, 'UMP', 'Trường Đại học Y Dược TP. Hồ Chí Minh', '217 Hồng Bàng, Q.5, TP. Hồ Chí Minh', '028 3855 4269', 'ump@ump.edu.vn', '028 3855 4269', '1947-01-01', 'Trường đại học y dược hàng đầu miền Nam, đào tạo bác sĩ và dược sĩ chất lượng cao.'),
(9, 'HUE', 'Đại học Huế', '3 Lê Lợi, TP. Huế', '0234 3822 041', 'hueuni@hueuni.edu.vn', '0234 3822 041', '1957-01-01', 'Đại học đa ngành lớn nhất miền Trung, có truyền thống lâu đời và uy tín.'),
(10, 'CTU', 'Trường Đại học Cần Thơ', 'Khu II, đường 3/2, Ninh Kiều, Cần Thơ', '0292 383 1301', 'ctu@ctu.edu.vn', '0292 383 1301', '1966-03-31', 'Trường đại học đa ngành lớn nhất Đồng bằng Sông Cửu Long.'),
(11, 'TNU', 'Đại học Thái Nguyên', 'Tân Thịnh, TP. Thái Nguyên', '0208 3840 238', 'tnu@tnu.edu.vn', '0208 3840 238', '1994-01-01', 'Đại học đa ngành lớn của khu vực miền Bắc, đào tạo nhiều lĩnh vực.'),
(12, 'DTU', 'Trường Đại học Duy Tân', '03 Quang Trung, Hải Châu, Đà Nẵng', '0236 3650 403', 'dtu@duytan.edu.vn', '0236 3650 403', '1994-01-01', 'Trường đại học tư thục uy tín, được công nhận thành Đại học năm 2024.'),
(13, 'FTU', 'Trường Đại học Ngoại thương', '91 Chùa Láng, Đống Đa, Hà Nội', '024 3834 2308', 'ftu@ftu.edu.vn', '024 3834 2308', '1960-01-01', 'Trường đại học chuyên về ngoại thương, kinh tế đối ngoại và ngoại ngữ.'),
(14, 'TDTU', 'Trường Đại học Tôn Đức Thắng', '19 Nguyễn Hữu Thọ, Q.7, TP. Hồ Chí Minh', '028 3775 5037', 'tdtu@tdtu.edu.vn', '028 3775 5037', '1997-09-24', 'Trường đại học tư thục chất lượng cao, có nhiều ngành đào tạo hiện đại.'),
(15, 'DNU', 'Đại học Đà Nẵng', '41 Lê Duẩn, Hải Châu, Đà Nẵng', '0236 3822 041', 'dnu@dnu.edu.vn', '0236 3822 041', '1994-01-01', 'Đại học đa ngành lớn nhất miền Trung, trung tâm giáo dục của khu vực.'),
(16, 'RMIT', 'Trường Đại học RMIT Việt Nam', '702 Nguyễn Văn Linh, Q.7, TP. Hồ Chí Minh', '028 3776 1300', 'rmit@rmit.edu.vn', '028 3776 1300', '2000-01-01', 'Trường đại học quốc tế của Australia tại Việt Nam, chương trình đào tạo chất lượng cao.'),
(17, 'ULaw', 'Trường Đại học Luật Hà Nội', '87 Nguyễn Chí Thanh, Đống Đa, Hà Nội', '024 3734 5cờ506', 'hlu@hlu.edu.vn', '024 3734 5506', '1979-01-01', 'Trường đại học luật hàng đầu Việt Nam, chuyên đào tạo ngành luật.'),
(18, 'AGU', 'Trường Đại học An Giang', '18 Ung Văn Khiêm, Long Xuyên, An Giang', '0296 384 1228', 'agu@agu.edu.vn', '0296 384 1228', '2000-08-11', 'Trường đại học công lập tại Đồng bằng Sông Cửu Long, đa ngành đào tạo.'),
(19, 'UIT', 'Trường Đại học Công nghệ Thông tin', 'Khu phố 6, Linh Trung, Thủ Đức, TP. Hồ Chí Minh', '028 3724 4270', 'uit@uit.edu.vn', '028 3724 4270', '2006-01-01', 'Trường chuyên về công nghệ thông tin thuộc ĐHQG TP.HCM.'),
(20, 'HUS', 'Trường Đại học Khoa học Tự nhiên', '334 Nguyễn Trãi, Thanh Xuân, Hà Nội', '024 3858 4943', 'hus@vnu.edu.vn', '024 3858 4943', '1956-01-01', 'Trường đại học khoa học tự nhiên thuộc ĐHQG Hà Nội, chuyên các ngành khoa học cơ bản.'),
(21, 'IUH', 'Trường Đại học Công nghiệp TP. Hồ Chí Minh', '12 Nguyễn Văn Bảo, P.4, Q. Gò Vấp, TP. Hồ Chí Minh', '028 3894 0390', 'iuh@iuh.edu.vn', '028 3894 0390', '1999-03-01', 'Trường đại học công nghiệp hàng đầu miền Nam, chuyên đào tạo kỹ thuật công nghiệp và công nghệ ứng dụng.'),
(22, 'UEB', 'Trường Đại học Kinh tế - ĐHQG Hà Nội', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '024 3754 7506', 'ueb@vnu.edu.vn', '024 3754 7506', '1974-07-01', 'Trường đào tạo kinh tế chất lượng cao, trực thuộc ĐHQG Hà Nội.'),
(23, 'HANU', 'Trường Đại học Hà Nội', 'Km9, Nguyễn Trãi, Thanh Xuân, Hà Nội', '024 3854 4338', 'hanu@hanu.edu.vn', '024 3854 4338', '1959-05-26', 'Trường đào tạo ngoại ngữ hàng đầu, đa ngành, có nhiều chương trình quốc tế.'),
(24, 'HVCNHN', 'Học viện Công nghệ Bưu chính Viễn thông', 'Km10, Nguyễn Trãi, Hà Nội', '024 3352 7274', 'ptit@ptit.edu.vn', '024 3352 7274', '1997-07-01', 'Trường mạnh về CNTT, viễn thông và công nghệ số.'),
(25, 'HVCNHCM', 'Học viện Công nghệ Bưu chính Viễn thông - Cơ sở TP.HCM', '97 Man Thiện, Q.9, TP. Thủ Đức', '028 3897 0023', 'ptithcm@ptit.edu.vn', '028 3897 0023', '1997-07-01', 'Cơ sở phía Nam của PTIT, đào tạo kỹ sư công nghệ chất lượng cao.'),
(26, 'HVCNH', 'Học viện Ngân hàng', '12 Chùa Bộc, Đống Đa, Hà Nội', '024 3852 5600', 'info@hvnh.edu.vn', '024 3852 5600', '1961-09-13', 'Trường đào tạo về tài chính, ngân hàng, kế toán uy tín tại miền Bắc.'),
(27, 'AOF', 'Học viện Tài chính', '58 Lê Văn Hiến, Đức Thắng, Bắc Từ Liêm, Hà Nội', '024 3854 4264', 'aof@aof.edu.vn', '024 3854 4264', '1963-09-01', 'Trường hàng đầu về tài chính - kế toán - kiểm toán.'),
(28, 'GTVT', 'Trường Đại học Giao thông Vận tải', 'Số 3 Cầu Giấy, Đống Đa, Hà Nội', '024 3766 2761', 'dhgtvt@utc.edu.vn', '024 3766 2761', '1945-03-15', 'Trường kỹ thuật đầu ngành về giao thông vận tải Việt Nam.'),
(29, 'HCMUE', 'Trường Đại học Sư phạm TP. Hồ Chí Minh', '280 An Dương Vương, Q.5, TP.HCM', '028 3835 2020', 'info@hcmue.edu.vn', '028 3835 2020', '1976-10-27', 'Trường sư phạm hàng đầu miền Nam, đào tạo giáo viên chất lượng cao.'),
(30, 'HCMUSSH', 'Trường Đại học KHXH&NV - ĐHQG TP.HCM', '10-12 Đinh Tiên Hoàng, Q.1, TP.HCM', '028 3829 3828', 'info@hcmussh.edu.vn', '028 3829 3828', '1957-03-01', 'Trường đào tạo lĩnh vực khoa học xã hội hàng đầu phía Nam.'),
(31, 'HUP', 'Trường Đại học Dược Hà Nội', '13-15 Lê Thánh Tông, Hoàn Kiếm, Hà Nội', '024 3825 2631', 'hup@hup.edu.vn', '024 3825 2631', '1961-09-13', 'Trường hàng đầu về đào tạo và nghiên cứu Dược học tại Việt Nam.'),
(188, 'HCMUTE', 'Trường Đại học Sư phạm Kỹ thuật TP. Hồ Chí Minh', 'Số 1 Võ Văn Ngân, TP. Thủ Đức, TP.HCM', '028 3897 2020', 'contact@hcmute.edu.vn', '028 3897 2020', '1990-01-01', 'Trường Đại học Sư phạm Kỹ thuật TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(189, 'HNUE', 'Trường Đại học Sư phạm Hà Nội', '136 Xuân Thuỷ, Cầu Giấy, Hà Nội', '024 3754 7823', 'contact@hnue.edu.vn', '024 3754 7823', '1990-01-01', 'Trường Đại học Sư phạm Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(190, 'HUTECH', 'Trường Đại học Công nghệ TP. Hồ Chí Minh', '475A Điện Biên Phủ, Bình Thạnh, TP.HCM', '028 5445 2222', 'contact@hutech.edu.vn', '028 5445 2222', '1990-01-01', 'Trường Đại học Công nghệ TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(191, 'UEF', 'Trường Đại học Kinh tế - Tài chính TP. HCM (UEF)', '141 Điện Biên Phủ, Bình Thạnh, TP.HCM', '028 5422 6666', 'contact@uef.edu.vn', '028 5422 6666', '1990-01-01', 'Trường Đại học Kinh tế - Tài chính TP. HCM (UEF) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(192, 'BUH', 'Trường Đại học Ngân hàng TP. Hồ Chí Minh', '56 Hoàng Diệu 2, TP. Thủ Đức, TP.HCM', '028 3896 1333', 'contact@buh.edu.vn', '028 3896 1333', '1990-01-01', 'Trường Đại học Ngân hàng TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(193, 'UEL', 'Trường Đại học Kinh tế - Luật, ĐHQG-HCM', '669 QL1, Khu phố 3, TP. Thủ Đức, TP.HCM', '028 3724 4555', 'contact@uel.edu.vn', '028 3724 4555', '1990-01-01', 'Trường Đại học Kinh tế - Luật, ĐHQG-HCM đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(194, 'UAH', 'Trường Đại học Kiến trúc TP. Hồ Chí Minh', '196 Pasteur, Quận 3, TP.HCM', '028 3822 3399', 'contact@uah.edu.vn', '028 3822 3399', '1990-01-01', 'Trường Đại học Kiến trúc TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(195, 'HCMUAF', 'Trường Đại học Nông Lâm TP. Hồ Chí Minh', 'Khu phố 6, Linh Trung, TP. Thủ Đức, TP.HCM', '028 3896 6780', 'contact@hcmuaf.edu.vn', '028 3896 6780', '1990-01-01', 'Trường Đại học Nông Lâm TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(196, 'UT-HCM', 'Trường Đại học Giao thông Vận tải TP.HCM', '2 đường D3, Bình Thạnh, TP.HCM', '028 3512 0768', 'contact@ut.edu.vn', '028 3512 0768', '1990-01-01', 'Trường Đại học Giao thông Vận tải TP.HCM đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(197, 'FTU2', 'Trường Đại học Ngoại thương Cơ sở II', '15 D5, Bình Thạnh, TP.HCM', '028 3512 0776', 'contact@ftu.edu.vn', '028 3512 0776', '1990-01-01', 'Trường Đại học Ngoại thương Cơ sở II đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(198, 'UTEHY', 'Trường Đại học Sư phạm Kỹ thuật Hưng Yên', 'Khoái Châu, Hưng Yên', '0221 372 0327', 'contact@utehy.edu.vn', '0221 372 0327', '1990-01-01', 'Trường Đại học Sư phạm Kỹ thuật Hưng Yên đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(199, 'VAA', 'Học viện Hàng không Việt Nam', '104 Nguyễn Văn Trỗi, Phú Nhuận, TP.HCM', '028 3844 6350', 'contact@vaa.edu.vn', '028 3844 6350', '1990-01-01', 'Học viện Hàng không Việt Nam đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(200, 'DUT', 'Trường Đại học Bách khoa - Đại học Đà Nẵng', '54 Nguyễn Lương Bằng, Đà Nẵng', '0236 384 1287', 'contact@dut.udn.vn', '0236 384 1287', '1990-01-01', 'Trường Đại học Bách khoa - Đại học Đà Nẵng đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(201, 'DUE', 'Trường Đại học Kinh tế - Đại học Đà Nẵng', '71 Ngũ Hành Sơn, Đà Nẵng', '0236 395 1111', 'contact@due.udn.vn', '0236 395 1111', '1990-01-01', 'Trường Đại học Kinh tế - Đại học Đà Nẵng đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(202, 'UED', 'Trường Đại học Sư phạm - Đại học Đà Nẵng', '459 Tôn Đức Thắng, Đà Nẵng', '0236 384 1823', 'contact@ued.udn.vn', '0236 384 1823', '1990-01-01', 'Trường Đại học Sư phạm - Đại học Đà Nẵng đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(203, 'DNTU', 'Trường Đại học Công nghệ Đồng Nai', 'Số 206, QL 1A, Biên Hòa, Đồng Nai', '0251 261 0000', 'contact@dntu.edu.vn', '0251 261 0000', '1990-01-01', 'Trường Đại học Công nghệ Đồng Nai đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(204, 'LHU', 'Trường Đại học Lạc Hồng', '10 Huỳnh Văn Nghệ, Biên Hòa, Đồng Nai', '0251 395 1896', 'contact@lhu.edu.vn', '0251 395 1896', '1990-01-01', 'Trường Đại học Lạc Hồng đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(205, 'TLU', 'Trường Đại học Thủy Lợi (CS Hà Nội)', '175 Tây Sơn, Đống Đa, Hà Nội', '024 3852 2201', 'contact@tlu.edu.vn', '024 3852 2201', '1990-01-01', 'Trường Đại học Thủy Lợi (CS Hà Nội) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(206, 'TLU2', 'Trường Đại học Thủy Lợi (CS TP.HCM)', '2 Trường Sa, Bình Thạnh, TP.HCM', '028 3512 6391', 'contact@tlu.edu.vn', '028 3512 6391', '1990-01-01', 'Trường Đại học Thủy Lợi (CS TP.HCM) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(207, 'NUCE', 'Trường Đại học Xây dựng Hà Nội', '55 Giải Phóng, Hai Bà Trưng, Hà Nội', '024 3869 3747', 'contact@nuce.edu.vn', '024 3869 3747', '1990-01-01', 'Trường Đại học Xây dựng Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(208, 'UTC2', 'Trường Đại học Giao thông Vận tải (cơ sở 2)', 'Km9, Quốc lộ 1A, Thủ Đức, TP.HCM', '028 3722 1223', 'contact@utc2.edu.vn', '028 3722 1223', '1990-01-01', 'Trường Đại học Giao thông Vận tải (cơ sở 2) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(209, 'HAUI', 'Trường Đại học Công nghiệp Hà Nội', '298 Cầu Diễn, Bắc Từ Liêm, Hà Nội', '024 3765 5121', 'contact@haui.edu.vn', '024 3765 5121', '1990-01-01', 'Trường Đại học Công nghiệp Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(210, 'VIMARU', 'Trường Đại học Hàng hải Việt Nam', '484 Lạch Tray, Hải Phòng', '0225 3735 069', 'contact@vimaru.edu.vn', '0225 3735 069', '1990-01-01', 'Trường Đại học Hàng hải Việt Nam đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(211, 'HUMG', 'Trường Đại học Mỏ - Địa chất', '18 Phố Viên, Bắc Từ Liêm, Hà Nội', '024 3838 9633', 'contact@humg.edu.vn', '024 3838 9633', '1990-01-01', 'Trường Đại học Mỏ - Địa chất đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(212, 'VNUA', 'Học viện Nông nghiệp Việt Nam', 'TT Trâu Quỳ, Gia Lâm, Hà Nội', '024 6261 7575', 'contact@vnua.edu.vn', '024 6261 7575', '1990-01-01', 'Học viện Nông nghiệp Việt Nam đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(213, 'HAU', 'Trường Đại học Kiến trúc Hà Nội', 'Km10, Nguyễn Trãi, Thanh Xuân, Hà Nội', '024 3854 1616', 'contact@hau.edu.vn', '024 3854 1616', '1990-01-01', 'Trường Đại học Kiến trúc Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(214, 'UFM', 'Trường Đại học Tài chính – Marketing', '306 Nguyễn Trãi, Quận 5, TP.HCM', '028 3950 7755', 'contact@ufm.edu.vn', '028 3950 7755', '1990-01-01', 'Trường Đại học Tài chính – Marketing đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(215, 'HUFI', 'Trường Đại học Công nghiệp Thực phẩm TP.HCM', '140 Lê Trọng Tấn, Tân Phú, TP.HCM', '028 3816 4740', 'contact@hufi.edu.vn', '028 3816 4740', '1990-01-01', 'Trường Đại học Công nghiệp Thực phẩm TP.HCM đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(216, 'HCMOU', 'Trường Đại học Mở TP. Hồ Chí Minh', '97 Võ Văn Tần, Quận 3, TP.HCM', '028 3930 0210', 'contact@ou.edu.vn', '028 3930 0210', '1990-01-01', 'Trường Đại học Mở TP. Hồ Chí Minh đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(217, 'HOU', 'Trường Đại học Mở Hà Nội', 'B101 Nguyễn Hiền, Hai Bà Trưng, Hà Nội', '024 3868 2464', 'contact@hou.edu.vn', '024 3868 2464', '1990-01-01', 'Trường Đại học Mở Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(218, 'HCMUS', 'Trường Đại học Khoa học Tự nhiên, ĐHQG-HCM', '227 Nguyễn Văn Cừ, Quận 5, TP.HCM', '028 3835 3193', 'contact@hcmus.edu.vn', '028 3835 3193', '1990-01-01', 'Trường Đại học Khoa học Tự nhiên, ĐHQG-HCM đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(219, 'USSH-HN', 'Trường Đại học KHXH&NV, ĐHQG-HN', '336 Nguyễn Trãi, Thanh Xuân, Hà Nội', '024 3858 3798', 'contact@ussh.vnu.edu.vn', '024 3858 3798', '1990-01-01', 'Trường Đại học KHXH&NV, ĐHQG-HN đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(220, 'UET', 'Trường Đại học Công nghệ, ĐHQG-HN', '144 Xuân Thuỷ, Cầu Giấy, Hà Nội', '024 3754 7469', 'contact@uet.vnu.edu.vn', '024 3754 7469', '1990-01-01', 'Trường Đại học Công nghệ, ĐHQG-HN đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(221, 'HUBT', 'Trường Đại học Kinh doanh & Công nghệ Hà Nội', '29A Ngõ 124 Vĩnh Tuy, Hai Bà Trưng, Hà Nội', '024 3862 6281', 'contact@hubt.edu.vn', '024 3862 6281', '1990-01-01', 'Trường Đại học Kinh doanh & Công nghệ Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(222, 'HUFLIT', 'Trường Đại học Ngoại ngữ – Tin học TP.HCM', '155 Sư Vạn Hạnh, Quận 10, TP.HCM', '028 3862 9239', 'contact@huflit.edu.vn', '028 3862 9239', '1990-01-01', 'Trường Đại học Ngoại ngữ – Tin học TP.HCM đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(223, 'NAPA-HN', 'Học viện Hành chính Quốc gia (CS Hà Nội)', '77 Nguyễn Chí Thanh, Đống Đa, Hà Nội', '024 3834 3226', 'contact@napa.vn', '024 3834 3226', '1990-01-01', 'Học viện Hành chính Quốc gia (CS Hà Nội) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(224, 'NAPA-HCM', 'Học viện Hành chính Quốc gia (CS TP.HCM)', '10 đường 3/2, Quận 10, TP.HCM', '028 3865 3585', 'contact@napa.vn', '028 3865 3585', '1990-01-01', 'Học viện Hành chính Quốc gia (CS TP.HCM) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(225, 'VNU-IS', 'Trường Quốc tế – ĐHQG Hà Nội', '144 Xuân Thủy, Cầu Giấy, Hà Nội', '024 3754 7670', 'contact@is.vnu.edu.vn', '024 3754 7670', '1990-01-01', 'Trường Quốc tế – ĐHQG Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(226, 'FPT-HN', 'Đại học FPT (Hà Nội)', 'Khu CNC Hòa Lạc, Thạch Thất, Hà Nội', '024 7300 5588', 'contact@fpt.edu.vn', '024 7300 5588', '1990-01-01', 'Đại học FPT (Hà Nội) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(227, 'FPT-HCM', 'Đại học FPT (TP.HCM)', 'Công viên Phần mềm Quang Trung, Q12, TP.HCM', '028 7300 5588', 'contact@fpt.edu.vn', '028 7300 5588', '1990-01-01', 'Đại học FPT (TP.HCM) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(228, 'GIA-DINH', 'Trường Đại học Gia Định', '185-187 Hoàng Văn Thụ, Phú Nhuận, TP.HCM', '028 6257 1166', 'contact@giadinh.edu.vn', '028 6257 1166', '1990-01-01', 'Trường Đại học Gia Định đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(229, 'TDMU', 'Trường Đại học Thủ Dầu Một', 'Số 6 Trần Văn Ơn, Thủ Dầu Một, Bình Dương', '0274 382 2518', 'contact@tdmu.edu.vn', '0274 382 2518', '1990-01-01', 'Trường Đại học Thủ Dầu Một đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(230, 'VLU', 'Trường Đại học Văn Lang', '69/68 Đặng Thùy Trâm, Bình Thạnh, TP.HCM', '028 7105 9999', 'contact@vlu.edu.vn', '028 7105 9999', '1990-01-01', 'Trường Đại học Văn Lang đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(231, 'ISB-UEH', 'Viện ISB – Trường Đại học UEH', '17 Phạm Ngọc Thạch, Quận 3, TP.HCM', '028 3930 9589', 'contact@isb.ueh.edu.vn', '028 3930 9589', '1990-01-01', 'Viện ISB – Trường Đại học UEH đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(232, 'HNMU', 'Trường Đại học Thủ đô Hà Nội', '98 Dương Quảng Hàm, Cầu Giấy, Hà Nội', '024 2219 5555', 'contact@hnmu.edu.vn', '024 2219 5555', '1990-01-01', 'Trường Đại học Thủ đô Hà Nội đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(233, 'PHENIKAA', 'Trường Đại học Phenikaa', 'Yên Nghĩa, Hà Đông, Hà Nội', '024 6262 8999', 'contact@phenikaa-uni.edu.vn', '024 6262 8999', '1990-01-01', 'Trường Đại học Phenikaa đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(234, 'EPU', 'Trường Đại học Điện lực', '235 Hoàng Quốc Việt, Bắc Từ Liêm, Hà Nội', '024 2218 5602', 'contact@epu.edu.vn', '024 2218 5602', '1990-01-01', 'Trường Đại học Điện lực đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(235, 'APD', 'Học viện Chính sách và Phát triển', 'Số 7 Tôn Thất Thuyết, Cầu Giấy, Hà Nội', '024 3795 6217', 'contact@apd.edu.vn', '024 3795 6217', '1990-01-01', 'Học viện Chính sách và Phát triển đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(236, 'TMU', 'Trường Đại học Thương mại', '79 Hồ Tùng Mậu, Cầu Giấy, Hà Nội', '024 3764 3219', 'contact@tmu.edu.vn', '024 3764 3219', '1990-01-01', 'Trường Đại học Thương mại đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(237, 'AOF2', 'Học viện Tài chính (CS mở rộng)', '58 Lê Văn Hiến, Đức Thắng, Bắc Từ Liêm, Hà Nội', '024 3835 4264', 'contact@hvtc.edu.vn', '024 3835 4264', '1990-01-01', 'Học viện Tài chính (CS mở rộng) đào tạo đa ngành, chú trọng thực hành và hợp tác doanh nghiệp.'),
(240, 'TEST01', 'Trường Đại học Test A', '123 Đường Test 1, Quận 1, TP.HCM', '02811112222', 'Phòng Test A', '02811112222', '2020-01-01', 'Trường mô phỏng test import dữ liệu'),
(241, 'TEST02', 'Trường Đại học Test B', '456 Đường Test 2, Quận 3, TP.HCM', '02833334444', 'Phòng Test B', '02833334444', '2021-06-15', 'Trường mô phỏng test import dữ liệu');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `vaitro`
--

CREATE TABLE `vaitro` (
  `idvaitro` int(11) NOT NULL,
  `tenvaitro` varchar(100) NOT NULL,
  `motavaitro` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `vaitro`
--

INSERT INTO `vaitro` (`idvaitro`, `tenvaitro`, `motavaitro`) VALUES
(1, 'Vãng lai', 'Người dùng chưa đăng ký, chỉ có thể tra cứu thông tin cơ bản'),
(2, 'Thành viên', 'Người dùng đã đăng ký tài khoản, có thể đăng ký xét tuyển, thanh toán lệ phí và quản lý hồ sơ'),
(3, 'Admin', 'Quản trị hệ thống, quản lý người dùng, dữ liệu, thông tin web và các vai trò khác'),
(4, 'Tư vấn viên', 'Người thực hiện các buổi tư vấn, ghi chú sau buổi và xem lịch tư vấn'),
(5, 'Người phụ trách', 'Phụ trách sắp xếp, quản lý lịch tư vấn và chuyên gia tư vấn'),
(6, 'Người phân tích dữ liệu', 'Phân tích dữ liệu tuyển sinh, tạo báo cáo, thống kê và hỗ trợ ra quyết định');

-- --------------------------------------------------------

--
-- Cấu trúc đóng vai cho view `v_questions_with_answers`
-- (See below for the actual view)
--


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `xet_tuyen_thang`
--

CREATE TABLE `xet_tuyen_thang` (
  `idxet_tuyen_thang` bigint(20) UNSIGNED NOT NULL,
  `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL,
  `linh_vuc` varchar(200) NOT NULL COMMENT 'VD: Khoa học động vật, Khoa học xã hội và hành vi',
  `linh_vuc_chuyen_sau` text DEFAULT NULL COMMENT 'Lĩnh vực chuyên sâu chi tiết',
  `danh_sach_nganh` text DEFAULT NULL COMMENT 'Danh sách ngành tuyển thẳng (có thể là JSON hoặc text phân cách)',
  `ghi_chu` varchar(500) DEFAULT NULL COMMENT 'VD: Không tuyển, hoặc ghi chú đặc biệt',
  `thu_tu` int(11) DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `xet_tuyen_thang`
--

INSERT INTO `xet_tuyen_thang` (`idxet_tuyen_thang`, `idphuong_thuc_chi_tiet`, `linh_vuc`, `linh_vuc_chuyen_sau`, `danh_sach_nganh`, `ghi_chu`, `thu_tu`, `created_at`, `updated_at`) VALUES
(4, 1, 'Công nghê thông tin', 'hệ thông thông tin', 'hệ thống thông tin', 'chào', 1, '2025-12-01 08:32:31', '2025-12-01 08:32:31');

-- --------------------------------------------------------

--
-- Cấu trúc cho view `v_questions_with_answers`
--

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `bang_diem_boi_duong`
--
ALTER TABLE `bang_diem_boi_duong`
  ADD PRIMARY KEY (`iddiem_boi_duong`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_trang_thai` (`trang_thai`),
  ADD KEY `fk_diem_boi_duong_lichtuvan` (`idlichtuvan`),
  ADD KEY `fk_diem_boi_duong_doilich` (`iddoilich`);

--
-- Chỉ mục cho bảng `bang_quy_doi_diem_ngoai_ngu`
--
ALTER TABLE `bang_quy_doi_diem_ngoai_ngu`
  ADD PRIMARY KEY (`idquy_doi`),
  ADD KEY `idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`),
  ADD KEY `idx_loai_chung_chi` (`loai_chung_chi`);

--
-- Chỉ mục cho bảng `bang_yeucau_doilich`
--
ALTER TABLE `bang_yeucau_doilich`
  ADD PRIMARY KEY (`iddoilich`);

--
-- Chỉ mục cho bảng `cau_hinh_mon_nhan_he_so`
--
ALTER TABLE `cau_hinh_mon_nhan_he_so`
  ADD PRIMARY KEY (`idcauhinh`),
  ADD KEY `idx_thongtin` (`idthongtin`),
  ADD KEY `idx_monhoc` (`idmonhoc`);

--
-- Chỉ mục cho bảng `chi_tiet_diem_thi_tot_nghiep`
--
ALTER TABLE `chi_tiet_diem_thi_tot_nghiep`
  ADD PRIMARY KEY (`idchitiet`),
  ADD KEY `idx_ketqua` (`idketqua`),
  ADD KEY `idx_monthi` (`idmonthi`);

--
-- Chỉ mục cho bảng `coso_truong`
--
ALTER TABLE `coso_truong`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_coso_truong` (`idtruong`,`ten_coso`),
  ADD KEY `coso_truong_idtruong_index` (`idtruong`);

--
-- Chỉ mục cho bảng `danhgia_lichtuvan`
--
ALTER TABLE `danhgia_lichtuvan`
  ADD PRIMARY KEY (`iddanhgia`),
  ADD UNIQUE KEY `uniq_moi_lich_1_danhgia` (`idlichtuvan`),
  ADD KEY `idx_nguoidat` (`idnguoidat`),
  ADD KEY `idx_lichtuvan_ngay` (`idlichtuvan`,`ngaydanhgia`);

--
-- Chỉ mục cho bảng `de_an_tuyen_sinh`
--
ALTER TABLE `de_an_tuyen_sinh`
  ADD PRIMARY KEY (`idde_an`),
  ADD UNIQUE KEY `unique_truong_nam` (`idtruong`,`nam_tuyen_sinh`);

--
-- Chỉ mục cho bảng `diemchuanxettuyen`
--
ALTER TABLE `diemchuanxettuyen`
  ADD PRIMARY KEY (`iddiemchuan`),
  ADD UNIQUE KEY `uq_truong_nganh_ptxt_tohop` (`idtruong`,`manganh`,`idxettuyen`,`tohopmon`),
  ADD UNIQUE KEY `uq_dc_multi` (`idtruong`,`manganh`,`idxettuyen`,`namxettuyen`,`tohopmon`),
  ADD KEY `idx_dcxt_idtruong` (`idtruong`),
  ADD KEY `idx_dcxt_manganh` (`manganh`),
  ADD KEY `idx_dcxt_diemchuan` (`diemchuan`),
  ADD KEY `idx_dcxt_idxettuyen` (`idxettuyen`),
  ADD KEY `idx_dcxt_nam` (`namxettuyen`);

--
-- Chỉ mục cho bảng `diem_hoc_ba`
--
ALTER TABLE `diem_hoc_ba`
  ADD PRIMARY KEY (`iddiem_hb`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_monhoc` (`idmonhoc`),
  ADD KEY `idx_lop_hocky` (`lop`,`hoc_ky`),
  ADD KEY `idx_nguoidung_monhoc` (`idnguoidung`,`idmonhoc`);

--
-- Chỉ mục cho bảng `diem_khuyen_khich`
--
ALTER TABLE `diem_khuyen_khich`
  ADD PRIMARY KEY (`iddiemkk`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_nam_ap_dung` (`nam_ap_dung`);

--
-- Chỉ mục cho bảng `diem_mon_hoc_tot_nghiep`
--
ALTER TABLE `diem_mon_hoc_tot_nghiep`
  ADD PRIMARY KEY (`iddiemmon`),
  ADD UNIQUE KEY `uk_nguoidung_monhoc_lop` (`idnguoidung`,`idmonhoc`,`lop`,`nam_hoc`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_monhoc` (`idmonhoc`),
  ADD KEY `idx_lop` (`lop`),
  ADD KEY `idx_nam_hoc` (`nam_hoc`);

--
-- Chỉ mục cho bảng `diem_thi_tot_nghiep`
--
ALTER TABLE `diem_thi_tot_nghiep`
  ADD PRIMARY KEY (`iddiemthi`),
  ADD UNIQUE KEY `uk_nguoidung_monthi_nam` (`idnguoidung`,`idmonthi`,`nam_thi`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_monthi` (`idmonthi`),
  ADD KEY `idx_nam_thi` (`nam_thi`);

--
-- Chỉ mục cho bảng `dieukien_tuyensinh`
--
ALTER TABLE `dieukien_tuyensinh`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_dk_ts` (`idtruong`,`manganh`,`idxettuyen`,`nam`),
  ADD KEY `dk_ts_idx_truong_nam` (`idtruong`,`nam`),
  ADD KEY `dk_ts_idx_nganh` (`manganh`),
  ADD KEY `dk_ts_idx_pt` (`idxettuyen`);

--
-- Chỉ mục cho bảng `doi_tuong_uu_tien`
--
ALTER TABLE `doi_tuong_uu_tien`
  ADD PRIMARY KEY (`iddoituong`),
  ADD UNIQUE KEY `uk_ma_doi_tuong` (`ma_doi_tuong`);

--
-- Chỉ mục cho bảng `file_de_an_tuyen_sinh`
--
ALTER TABLE `file_de_an_tuyen_sinh`
  ADD PRIMARY KEY (`idfile`),
  ADD KEY `idde_an` (`idde_an`);

--
-- Chỉ mục cho bảng `ghi_chu_buoituvan`
--
ALTER TABLE `ghi_chu_buoituvan`
  ADD PRIMARY KEY (`id_ghichu`),
  ADD UNIQUE KEY `uniq_chot_per_lichtuvan` (`id_lichtuvan`,`is_chot`),
  ADD KEY `idx_ghichu_id_lichtuvan` (`id_lichtuvan`),
  ADD KEY `idx_ghichu_id_tuvanvien` (`id_tuvanvien`);

--
-- Chỉ mục cho bảng `gioi_thieu_truong`
--
ALTER TABLE `gioi_thieu_truong`
  ADD PRIMARY KEY (`idgioi_thieu`),
  ADD UNIQUE KEY `unique_truong` (`idtruong`);

--
-- Chỉ mục cho bảng `hosothanhvien`
--
ALTER TABLE `hosothanhvien`
  ADD PRIMARY KEY (`idhoso`),
  ADD KEY `idx_hosothanhvien_idnguoidung` (`idnguoidung`),
  ADD KEY `fk_hoso_tohop` (`ma_to_hop`);

--
-- Chỉ mục cho bảng `ho_so_xet_tuyen`
--
ALTER TABLE `ho_so_xet_tuyen`
  ADD PRIMARY KEY (`idho_so`),
  ADD KEY `idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`),
  ADD KEY `idx_loai_ho_so` (`loai_ho_so`);

--
-- Chỉ mục cho bảng `ketquatuvan`
--
ALTER TABLE `ketquatuvan`
  ADD PRIMARY KEY (`idketquatuvan`),
  ADD KEY `idlichtuvan` (`idlichtuvan`);

--
-- Chỉ mục cho bảng `ket_qua_tinh_diem_hoc_ba`
--
ALTER TABLE `ket_qua_tinh_diem_hoc_ba`
  ADD PRIMARY KEY (`idketqua`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_phuongthuc` (`idphuongthuc_hb`),
  ADD KEY `idx_thongtin` (`idthongtin`);

--
-- Chỉ mục cho bảng `ket_qua_tinh_diem_tot_nghiep`
--
ALTER TABLE `ket_qua_tinh_diem_tot_nghiep`
  ADD PRIMARY KEY (`idketqua`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_nam_thi` (`nam_thi`);

--
-- Chỉ mục cho bảng `khu_vuc_uu_tien`
--
ALTER TABLE `khu_vuc_uu_tien`
  ADD PRIMARY KEY (`idkhuvuc`),
  ADD UNIQUE KEY `uk_ma_khu_vuc` (`ma_khu_vuc`);

--
-- Chỉ mục cho bảng `kythi_dgnl`
--
ALTER TABLE `kythi_dgnl`
  ADD PRIMARY KEY (`idkythi`),
  ADD UNIQUE KEY `makythi` (`makythi`);

--
-- Chỉ mục cho bảng `kythi_dgnl_attempts`
--
ALTER TABLE `kythi_dgnl_attempts`
  ADD PRIMARY KEY (`idattempt`),
  ADD KEY `idx_attempt_exam` (`idkythi`),
  ADD KEY `idx_attempt_user` (`idnguoidung`);

--
-- Chỉ mục cho bảng `kythi_dgnl_attempt_details`
--
ALTER TABLE `kythi_dgnl_attempt_details`
  ADD PRIMARY KEY (`idattempt_detail`),
  ADD KEY `idx_attempt_detail_attempt` (`idattempt`),
  ADD KEY `idx_attempt_detail_question` (`idquestion`);

--
-- Chỉ mục cho bảng `kythi_dgnl_options`
--
ALTER TABLE `kythi_dgnl_options`
  ADD PRIMARY KEY (`idoption`),
  ADD KEY `idx_option_question` (`idquestion`);

--
-- Chỉ mục cho bảng `kythi_dgnl_questions`
--
ALTER TABLE `kythi_dgnl_questions`
  ADD PRIMARY KEY (`idquestion`),
  ADD KEY `idx_question_section` (`idsection`);

--
-- Chỉ mục cho bảng `kythi_dgnl_sections`
--
ALTER TABLE `kythi_dgnl_sections`
  ADD PRIMARY KEY (`idsection`),
  ADD KEY `idx_section_kythi` (`idkythi`);

--
-- Chỉ mục cho bảng `kythi_dgnl_topics`
--
ALTER TABLE `kythi_dgnl_topics`
  ADD PRIMARY KEY (`idtopic`),
  ADD KEY `idx_topic_section` (`idsection`);

--
-- Chỉ mục cho bảng `lichtuvan`
--
ALTER TABLE `lichtuvan`
  ADD PRIMARY KEY (`idlichtuvan`),
  ADD KEY `idx_lichtuvan_idnguoidung` (`idnguoidung`),
  ADD KEY `fk_lichtuvan_nguoidat` (`idnguoidat`),
  ADD KEY `idx_duyetlich` (`duyetlich`),
  ADD KEY `fk_lichtuvan_nguoiduyet` (`idnguoiduyet`),
  ADD KEY `idx_lichtuvan_ngayhen` (`ngayhen`),
  ADD KEY `idx_lichtuvan_tinhtrang` (`tinhtrang`),
  ADD KEY `idx_lichtuvan_duyetlich` (`duyetlich`);

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Chỉ mục cho bảng `mon_hoc`
--
ALTER TABLE `mon_hoc`
  ADD PRIMARY KEY (`idmonhoc`),
  ADD UNIQUE KEY `uk_ma_mon_hoc` (`ma_mon_hoc`);

--
-- Chỉ mục cho bảng `mon_thi_tot_nghiep`
--
ALTER TABLE `mon_thi_tot_nghiep`
  ADD PRIMARY KEY (`idmonthi`),
  ADD UNIQUE KEY `uk_ma_mon_thi_nam` (`ma_mon_thi`,`nam_ap_dung`),
  ADD KEY `idx_trang_thai` (`trang_thai`);

--
-- Chỉ mục cho bảng `nganhhoc`
--
ALTER TABLE `nganhhoc`
  ADD PRIMARY KEY (`idnganh`),
  ADD UNIQUE KEY `manganh` (`manganh`),
  ADD KEY `idx_nganhhoc_manganh` (`manganh`),
  ADD KEY `idx_nganhhoc_idnhomnganh` (`idnhomnganh`);

--
-- Chỉ mục cho bảng `nganh_theo_phuong_thuc`
--
ALTER TABLE `nganh_theo_phuong_thuc`
  ADD PRIMARY KEY (`idnganh_phuong_thuc`),
  ADD UNIQUE KEY `unique_phuong_thuc_nganh` (`idphuong_thuc_chi_tiet`,`idnganhtruong`),
  ADD KEY `idx_loai_nganh` (`loai_nganh`),
  ADD KEY `idx_idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`),
  ADD KEY `idx_idnganhtruong` (`idnganhtruong`);

--
-- Chỉ mục cho bảng `nganh_truong`
--
ALTER TABLE `nganh_truong`
  ADD PRIMARY KEY (`idnganhtruong`),
  ADD UNIQUE KEY `nganh_truong_unique` (`idtruong`,`manganh`),
  ADD KEY `nganh_truong_idx_major_school` (`manganh`,`idtruong`);

--
-- Chỉ mục cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD PRIMARY KEY (`idnguoidung`),
  ADD UNIQUE KEY `taikhoan` (`taikhoan`),
  ADD KEY `idx_nguoidung_taikhoan` (`taikhoan`),
  ADD KEY `idx_nd_idnhomnganh` (`idnhomnganh`);

--
-- Chỉ mục cho bảng `nguyenvong`
--
ALTER TABLE `nguyenvong`
  ADD PRIMARY KEY (`idnguyenvong`),
  ADD KEY `idx_nguyenvong_idhoso` (`idhoso`);

--
-- Chỉ mục cho bảng `nhomnganh`
--
ALTER TABLE `nhomnganh`
  ADD PRIMARY KEY (`idnhomnganh`),
  ADD UNIQUE KEY `manhom` (`manhom`),
  ADD KEY `idx_nhomnganh_manhom` (`manhom`);

--
-- Chỉ mục cho bảng `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Chỉ mục cho bảng `phong_chat`
--
ALTER TABLE `phong_chat`
  ADD PRIMARY KEY (`idphongchat`),
  ADD UNIQUE KEY `uq_phong_theo_lichtuvan` (`idlichtuvan`,`idtuvanvien`,`idnguoidat`),
  ADD KEY `idx_lichtuvan` (`idlichtuvan`),
  ADD KEY `idx_tuvanvien` (`idtuvanvien`),
  ADD KEY `idx_nguoidat` (`idnguoidat`);

--
-- Chỉ mục cho bảng `phong_chat_support`
--
ALTER TABLE `phong_chat_support`
  ADD PRIMARY KEY (`idphongchat_support`),
  ADD UNIQUE KEY `unique_user_staff` (`idnguoidung`,`idnguoi_phu_trach`),
  ADD KEY `idx_nguoidung` (`idnguoidung`),
  ADD KEY `idx_nguoi_phu_trach` (`idnguoi_phu_trach`),
  ADD KEY `idx_ngay_cap_nhat` (`ngay_cap_nhat`),
  ADD KEY `idx_phongchat_trangthai` (`trang_thai`,`ngay_cap_nhat`);

--
-- Chỉ mục cho bảng `phuong_thuc_tuyen_sinh_chi_tiet`
--
ALTER TABLE `phuong_thuc_tuyen_sinh_chi_tiet`
  ADD PRIMARY KEY (`idphuong_thuc_chi_tiet`),
  ADD KEY `idde_an` (`idde_an`),
  ADD KEY `idx_ma_phuong_thuc` (`ma_phuong_thuc`),
  ADD KEY `idx_thu_tu` (`thu_tu_hien_thi`);

--
-- Chỉ mục cho bảng `phuong_thuc_xet_hoc_ba`
--
ALTER TABLE `phuong_thuc_xet_hoc_ba`
  ADD PRIMARY KEY (`idphuongthuc_hb`),
  ADD UNIQUE KEY `uk_ma_phuong_thuc` (`ma_phuong_thuc`);

--
-- Chỉ mục cho bảng `ptxt`
--
ALTER TABLE `ptxt`
  ADD PRIMARY KEY (`idxettuyen`);

--
-- Chỉ mục cho bảng `quyche_xettuyen`
--
ALTER TABLE `quyche_xettuyen`
  ADD PRIMARY KEY (`idquyche`),
  ADD KEY `idx_truong` (`idtruong`),
  ADD KEY `idx_nganhtruong` (`idnganhtruong`),
  ADD KEY `idx_xettuyen_nam` (`idxettuyen`,`nam_ap_dung`);

--
-- Chỉ mục cho bảng `quy_dinh_diem_uu_tien_de_an`
--
ALTER TABLE `quy_dinh_diem_uu_tien_de_an`
  ADD PRIMARY KEY (`idquy_dinh_de_an`),
  ADD KEY `idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`);

--
-- Chỉ mục cho bảng `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Chỉ mục cho bảng `tep_minhchung_buoituvan`
--
ALTER TABLE `tep_minhchung_buoituvan`
  ADD PRIMARY KEY (`id_file`),
  ADD KEY `idx_tepmc_id_ghichu` (`id_ghichu`),
  ADD KEY `idx_tepmc_id_lichtuvan` (`id_lichtuvan`),
  ADD KEY `idx_tepmc_uploader` (`nguoi_tai_len`);

--
-- Chỉ mục cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  ADD PRIMARY KEY (`id_thanhtoan`),
  ADD UNIQUE KEY `uq_ma_phieu` (`ma_phieu`),
  ADD UNIQUE KEY `uq_ma_giao_dich_app` (`ma_giao_dich_app`),
  ADD UNIQUE KEY `uq_thanh_toan_duy_nhat` (`khoa_thanh_cong`),
  ADD KEY `fk_thanhtoan_nguoidung` (`id_nguoidung`),
  ADD KEY `idx_lichtuvan` (`id_lichtuvan`),
  ADD KEY `idx_trangthai` (`trang_thai`),
  ADD KEY `idx_zp_trans_id` (`ma_giao_dich_zp`);

--
-- Chỉ mục cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD PRIMARY KEY (`idthongbao`),
  ADD KEY `fk_thongbao_nguoidung` (`nguoitao_id`);

--
-- Chỉ mục cho bảng `thongbao_lich`
--
ALTER TABLE `thongbao_lich`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_khoa_idempotent` (`khoa_idempotent`),
  ADD KEY `idx_denhan` (`trangthai`,`thoigian_gui`),
  ADD KEY `idx_lichtuvan` (`idlichtuvan`);

--
-- Chỉ mục cho bảng `thongtintuyensinh`
--
ALTER TABLE `thongtintuyensinh`
  ADD PRIMARY KEY (`idthongtintuyensinh`),
  ADD KEY `idx_thongtintuyensinh_idnganh` (`idnganhtruong`),
  ADD KEY `idx_ttts_idxettuyen` (`idxettuyen`),
  ADD KEY `idx_ttts_idtruong` (`idtruong`),
  ADD KEY `idx_truong_nganh_nam_pt` (`idtruong`,`idnganhtruong`,`namxettuyen`,`idxettuyen`);

--
-- Chỉ mục cho bảng `thong_tin_bo_sung_phuong_thuc`
--
ALTER TABLE `thong_tin_bo_sung_phuong_thuc`
  ADD PRIMARY KEY (`idthong_tin_bo_sung`),
  ADD KEY `idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`),
  ADD KEY `idx_loai_thong_tin` (`loai_thong_tin`);

--
-- Chỉ mục cho bảng `tin_nhan`
--
ALTER TABLE `tin_nhan`
  ADD PRIMARY KEY (`idtinnhan`),
  ADD KEY `idx_phong_thoigian` (`idphongchat`,`ngay_tao`),
  ADD KEY `idx_nguoigui` (`idnguoigui`);

--
-- Chỉ mục cho bảng `tin_nhan_support`
--
ALTER TABLE `tin_nhan_support`
  ADD PRIMARY KEY (`idtinnhan_support`),
  ADD KEY `idx_phongchat` (`idphongchat_support`),
  ADD KEY `idx_nguoigui` (`idnguoigui`),
  ADD KEY `idx_ngay_tao` (`ngay_tao`),
  ADD KEY `idx_da_xem` (`da_xem`),
  ADD KEY `idx_phongchat_ngay_tao` (`idphongchat_support`,`ngay_tao`);

--
-- Chỉ mục cho bảng `tin_tuyensinh`
--
ALTER TABLE `tin_tuyensinh`
  ADD PRIMARY KEY (`id_tin`),
  ADD UNIQUE KEY `uq_maNguon_hash` (`ma_nguon`,`hash_noidung`),
  ADD UNIQUE KEY `uq_nguon_url` (`ma_nguon`,`nguon_bai_viet`),
  ADD KEY `idx_truong` (`id_truong`),
  ADD KEY `idx_loai_ngay` (`loai_tin`,`ngay_dang`),
  ADD KEY `idx_trangthai` (`trang_thai`),
  ADD KEY `fk_tin_nguoidang` (`id_nguoidang`);

--
-- Chỉ mục cho bảng `tohop_xettuyen`
--
ALTER TABLE `tohop_xettuyen`
  ADD PRIMARY KEY (`ma_to_hop`),
  ADD UNIQUE KEY `uq_tohop_ma` (`ma_to_hop`);

--
-- Chỉ mục cho bảng `truongdaihoc`
--
ALTER TABLE `truongdaihoc`
  ADD PRIMARY KEY (`idtruong`),
  ADD UNIQUE KEY `matruong` (`matruong`),
  ADD KEY `idx_truongdaihoc_matruong` (`matruong`),
  ADD KEY `idx_truongdaihoc_tentruong` (`tentruong`),
  ADD KEY `idx_truongdaihoc_diachi` (`diachi`(100));

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Chỉ mục cho bảng `vaitro`
--
ALTER TABLE `vaitro`
  ADD PRIMARY KEY (`idvaitro`);

--
-- Chỉ mục cho bảng `xet_tuyen_thang`
--
ALTER TABLE `xet_tuyen_thang`
  ADD PRIMARY KEY (`idxet_tuyen_thang`),
  ADD KEY `idphuong_thuc_chi_tiet` (`idphuong_thuc_chi_tiet`),
  ADD KEY `idx_linh_vuc` (`linh_vuc`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `bang_diem_boi_duong`
--
ALTER TABLE `bang_diem_boi_duong`
  MODIFY `iddiem_boi_duong` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID điểm bồi đắp', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `bang_quy_doi_diem_ngoai_ngu`
--
ALTER TABLE `bang_quy_doi_diem_ngoai_ngu`
  MODIFY `idquy_doi` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `bang_yeucau_doilich`
--
ALTER TABLE `bang_yeucau_doilich`
  MODIFY `iddoilich` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Khóa chính của yêu cầu đổi lịch', AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `cau_hinh_mon_nhan_he_so`
--
ALTER TABLE `cau_hinh_mon_nhan_he_so`
  MODIFY `idcauhinh` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `chi_tiet_diem_thi_tot_nghiep`
--
ALTER TABLE `chi_tiet_diem_thi_tot_nghiep`
  MODIFY `idchitiet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT cho bảng `coso_truong`
--
ALTER TABLE `coso_truong`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT cho bảng `danhgia_lichtuvan`
--
ALTER TABLE `danhgia_lichtuvan`
  MODIFY `iddanhgia` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID đánh giá', AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `de_an_tuyen_sinh`
--
ALTER TABLE `de_an_tuyen_sinh`
  MODIFY `idde_an` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `diemchuanxettuyen`
--
ALTER TABLE `diemchuanxettuyen`
  MODIFY `iddiemchuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1582;

--
-- AUTO_INCREMENT cho bảng `diem_hoc_ba`
--
ALTER TABLE `diem_hoc_ba`
  MODIFY `iddiem_hb` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=201;

--
-- AUTO_INCREMENT cho bảng `diem_khuyen_khich`
--
ALTER TABLE `diem_khuyen_khich`
  MODIFY `iddiemkk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `diem_mon_hoc_tot_nghiep`
--
ALTER TABLE `diem_mon_hoc_tot_nghiep`
  MODIFY `iddiemmon` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=652;

--
-- AUTO_INCREMENT cho bảng `diem_thi_tot_nghiep`
--
ALTER TABLE `diem_thi_tot_nghiep`
  MODIFY `iddiemthi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT cho bảng `dieukien_tuyensinh`
--
ALTER TABLE `dieukien_tuyensinh`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT cho bảng `doi_tuong_uu_tien`
--
ALTER TABLE `doi_tuong_uu_tien`
  MODIFY `iddoituong` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `file_de_an_tuyen_sinh`
--
ALTER TABLE `file_de_an_tuyen_sinh`
  MODIFY `idfile` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `ghi_chu_buoituvan`
--
ALTER TABLE `ghi_chu_buoituvan`
  MODIFY `id_ghichu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `gioi_thieu_truong`
--
ALTER TABLE `gioi_thieu_truong`
  MODIFY `idgioi_thieu` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `hosothanhvien`
--
ALTER TABLE `hosothanhvien`
  MODIFY `idhoso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `ho_so_xet_tuyen`
--
ALTER TABLE `ho_so_xet_tuyen`
  MODIFY `idho_so` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `ketquatuvan`
--
ALTER TABLE `ketquatuvan`
  MODIFY `idketquatuvan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `ket_qua_tinh_diem_hoc_ba`
--
ALTER TABLE `ket_qua_tinh_diem_hoc_ba`
  MODIFY `idketqua` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT cho bảng `ket_qua_tinh_diem_tot_nghiep`
--
ALTER TABLE `ket_qua_tinh_diem_tot_nghiep`
  MODIFY `idketqua` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `khu_vuc_uu_tien`
--
ALTER TABLE `khu_vuc_uu_tien`
  MODIFY `idkhuvuc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl`
--
ALTER TABLE `kythi_dgnl`
  MODIFY `idkythi` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_attempts`
--
ALTER TABLE `kythi_dgnl_attempts`
  MODIFY `idattempt` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_attempt_details`
--
ALTER TABLE `kythi_dgnl_attempt_details`
  MODIFY `idattempt_detail` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_options`
--
ALTER TABLE `kythi_dgnl_options`
  MODIFY `idoption` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1321;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_questions`
--
ALTER TABLE `kythi_dgnl_questions`
  MODIFY `idquestion` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=227;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_sections`
--
ALTER TABLE `kythi_dgnl_sections`
  MODIFY `idsection` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT cho bảng `kythi_dgnl_topics`
--
ALTER TABLE `kythi_dgnl_topics`
  MODIFY `idtopic` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT cho bảng `lichtuvan`
--
ALTER TABLE `lichtuvan`
  MODIFY `idlichtuvan` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `mon_hoc`
--
ALTER TABLE `mon_hoc`
  MODIFY `idmonhoc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `mon_thi_tot_nghiep`
--
ALTER TABLE `mon_thi_tot_nghiep`
  MODIFY `idmonthi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `nganhhoc`
--
ALTER TABLE `nganhhoc`
  MODIFY `idnganh` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=260;

--
-- AUTO_INCREMENT cho bảng `nganh_theo_phuong_thuc`
--
ALTER TABLE `nganh_theo_phuong_thuc`
  MODIFY `idnganh_phuong_thuc` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `nganh_truong`
--
ALTER TABLE `nganh_truong`
  MODIFY `idnganhtruong` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=160;

--
-- AUTO_INCREMENT cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  MODIFY `idnguoidung` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT cho bảng `nguyenvong`
--
ALTER TABLE `nguyenvong`
  MODIFY `idnguyenvong` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `nhomnganh`
--
ALTER TABLE `nhomnganh`
  MODIFY `idnhomnganh` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT cho bảng `phong_chat`
--
ALTER TABLE `phong_chat`
  MODIFY `idphongchat` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT cho bảng `phong_chat_support`
--
ALTER TABLE `phong_chat_support`
  MODIFY `idphongchat_support` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `phuong_thuc_tuyen_sinh_chi_tiet`
--
ALTER TABLE `phuong_thuc_tuyen_sinh_chi_tiet`
  MODIFY `idphuong_thuc_chi_tiet` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `phuong_thuc_xet_hoc_ba`
--
ALTER TABLE `phuong_thuc_xet_hoc_ba`
  MODIFY `idphuongthuc_hb` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `ptxt`
--
ALTER TABLE `ptxt`
  MODIFY `idxettuyen` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `quyche_xettuyen`
--
ALTER TABLE `quyche_xettuyen`
  MODIFY `idquyche` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `quy_dinh_diem_uu_tien_de_an`
--
ALTER TABLE `quy_dinh_diem_uu_tien_de_an`
  MODIFY `idquy_dinh_de_an` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT cho bảng `tep_minhchung_buoituvan`
--
ALTER TABLE `tep_minhchung_buoituvan`
  MODIFY `id_file` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  MODIFY `id_thanhtoan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  MODIFY `idthongbao` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'Mã thông báo', AUTO_INCREMENT=120;

--
-- AUTO_INCREMENT cho bảng `thongbao_lich`
--
ALTER TABLE `thongbao_lich`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Khóa chính', AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT cho bảng `thongtintuyensinh`
--
ALTER TABLE `thongtintuyensinh`
  MODIFY `idthongtintuyensinh` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `thong_tin_bo_sung_phuong_thuc`
--
ALTER TABLE `thong_tin_bo_sung_phuong_thuc`
  MODIFY `idthong_tin_bo_sung` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `tin_nhan`
--
ALTER TABLE `tin_nhan`
  MODIFY `idtinnhan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT cho bảng `tin_nhan_support`
--
ALTER TABLE `tin_nhan_support`
  MODIFY `idtinnhan_support` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT cho bảng `tin_tuyensinh`
--
ALTER TABLE `tin_tuyensinh`
  MODIFY `id_tin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT cho bảng `truongdaihoc`
--
ALTER TABLE `truongdaihoc`
  MODIFY `idtruong` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=242;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT cho bảng `vaitro`
--
ALTER TABLE `vaitro`
  MODIFY `idvaitro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT cho bảng `xet_tuyen_thang`
--
ALTER TABLE `xet_tuyen_thang`
  MODIFY `idxet_tuyen_thang` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `bang_diem_boi_duong`
--
ALTER TABLE `bang_diem_boi_duong`
  ADD CONSTRAINT `fk_diem_boi_duong_doilich` FOREIGN KEY (`iddoilich`) REFERENCES `bang_yeucau_doilich` (`iddoilich`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_diem_boi_duong_lichtuvan` FOREIGN KEY (`idlichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_diem_boi_duong_nguoidung` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `bang_quy_doi_diem_ngoai_ngu`
--
ALTER TABLE `bang_quy_doi_diem_ngoai_ngu`
  ADD CONSTRAINT `bang_quy_doi_diem_ngoai_ngu_ibfk_1` FOREIGN KEY (`idphuong_thuc_chi_tiet`) REFERENCES `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `coso_truong`
--
ALTER TABLE `coso_truong`
  ADD CONSTRAINT `coso_truong_idtruong_fk` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `danhgia_lichtuvan`
--
ALTER TABLE `danhgia_lichtuvan`
  ADD CONSTRAINT `fk_dg_lichtuvan` FOREIGN KEY (`idlichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_dg_nguoidat` FOREIGN KEY (`idnguoidat`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `de_an_tuyen_sinh`
--
ALTER TABLE `de_an_tuyen_sinh`
  ADD CONSTRAINT `de_an_tuyen_sinh_ibfk_1` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `diemchuanxettuyen`
--
ALTER TABLE `diemchuanxettuyen`
  ADD CONSTRAINT `fk_dcxt_nganh` FOREIGN KEY (`manganh`) REFERENCES `nganhhoc` (`manganh`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_dcxt_ptxt` FOREIGN KEY (`idxettuyen`) REFERENCES `ptxt` (`idxettuyen`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_dcxt_truong` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `diem_hoc_ba`
--
ALTER TABLE `diem_hoc_ba`
  ADD CONSTRAINT `fk_diem_hb_monhoc` FOREIGN KEY (`idmonhoc`) REFERENCES `mon_hoc` (`idmonhoc`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_diem_hb_nguoidung` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `dieukien_tuyensinh`
--
ALTER TABLE `dieukien_tuyensinh`
  ADD CONSTRAINT `fk_dk_ts_nganh` FOREIGN KEY (`manganh`) REFERENCES `nganhhoc` (`manganh`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dk_ts_pt` FOREIGN KEY (`idxettuyen`) REFERENCES `ptxt` (`idxettuyen`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_dk_ts_truong` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `file_de_an_tuyen_sinh`
--
ALTER TABLE `file_de_an_tuyen_sinh`
  ADD CONSTRAINT `file_de_an_tuyen_sinh_ibfk_1` FOREIGN KEY (`idde_an`) REFERENCES `de_an_tuyen_sinh` (`idde_an`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `ghi_chu_buoituvan`
--
ALTER TABLE `ghi_chu_buoituvan`
  ADD CONSTRAINT `fk_ghichu_lichtuvan` FOREIGN KEY (`id_lichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ghichu_tuvanvien` FOREIGN KEY (`id_tuvanvien`) REFERENCES `nguoidung` (`idnguoidung`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `gioi_thieu_truong`
--
ALTER TABLE `gioi_thieu_truong`
  ADD CONSTRAINT `gioi_thieu_truong_ibfk_1` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `hosothanhvien`
--
ALTER TABLE `hosothanhvien`
  ADD CONSTRAINT `fk_hoso_tohop` FOREIGN KEY (`ma_to_hop`) REFERENCES `tohop_xettuyen` (`ma_to_hop`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hosothanhvien_ibfk_1` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `ho_so_xet_tuyen`
--
ALTER TABLE `ho_so_xet_tuyen`
  ADD CONSTRAINT `ho_so_xet_tuyen_ibfk_1` FOREIGN KEY (`idphuong_thuc_chi_tiet`) REFERENCES `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `ketquatuvan`
--
ALTER TABLE `ketquatuvan`
  ADD CONSTRAINT `ketquatuvan_ibfk_1` FOREIGN KEY (`idlichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_attempts`
--
ALTER TABLE `kythi_dgnl_attempts`
  ADD CONSTRAINT `fk_attempt_exam` FOREIGN KEY (`idkythi`) REFERENCES `kythi_dgnl` (`idkythi`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_attempt_user` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_attempt_details`
--
ALTER TABLE `kythi_dgnl_attempt_details`
  ADD CONSTRAINT `fk_attempt_detail_attempt` FOREIGN KEY (`idattempt`) REFERENCES `kythi_dgnl_attempts` (`idattempt`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_attempt_detail_question` FOREIGN KEY (`idquestion`) REFERENCES `kythi_dgnl_questions` (`idquestion`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_options`
--
ALTER TABLE `kythi_dgnl_options`
  ADD CONSTRAINT `fk_option_question` FOREIGN KEY (`idquestion`) REFERENCES `kythi_dgnl_questions` (`idquestion`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_questions`
--
ALTER TABLE `kythi_dgnl_questions`
  ADD CONSTRAINT `fk_question_section` FOREIGN KEY (`idsection`) REFERENCES `kythi_dgnl_sections` (`idsection`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_sections`
--
ALTER TABLE `kythi_dgnl_sections`
  ADD CONSTRAINT `fk_section_kythi` FOREIGN KEY (`idkythi`) REFERENCES `kythi_dgnl` (`idkythi`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `kythi_dgnl_topics`
--
ALTER TABLE `kythi_dgnl_topics`
  ADD CONSTRAINT `fk_topic_section` FOREIGN KEY (`idsection`) REFERENCES `kythi_dgnl_sections` (`idsection`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `lichtuvan`
--
ALTER TABLE `lichtuvan`
  ADD CONSTRAINT `fk_lichtuvan_nguoidat` FOREIGN KEY (`idnguoidat`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_lichtuvan_nguoiduyet` FOREIGN KEY (`idnguoiduyet`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `lichtuvan_ibfk_1` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `nganhhoc`
--
ALTER TABLE `nganhhoc`
  ADD CONSTRAINT `nganhhoc_ibfk_nhomnganh` FOREIGN KEY (`idnhomnganh`) REFERENCES `nhomnganh` (`idnhomnganh`) ON DELETE SET NULL;

--
-- Các ràng buộc cho bảng `nganh_truong`
--
ALTER TABLE `nganh_truong`
  ADD CONSTRAINT `fk_nt_nganh` FOREIGN KEY (`manganh`) REFERENCES `nganhhoc` (`manganh`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_nt_truong` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `nguoidung`
--
ALTER TABLE `nguoidung`
  ADD CONSTRAINT `fk_nd_nhom` FOREIGN KEY (`idnhomnganh`) REFERENCES `nhomnganh` (`idnhomnganh`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `nguyenvong`
--
ALTER TABLE `nguyenvong`
  ADD CONSTRAINT `nguyenvong_ibfk_1` FOREIGN KEY (`idhoso`) REFERENCES `hosothanhvien` (`idhoso`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `phong_chat`
--
ALTER TABLE `phong_chat`
  ADD CONSTRAINT `fk_pc_lichtuvan` FOREIGN KEY (`idlichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pc_nguoidat` FOREIGN KEY (`idnguoidat`) REFERENCES `nguoidung` (`idnguoidung`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pc_tuvanvien` FOREIGN KEY (`idtuvanvien`) REFERENCES `nguoidung` (`idnguoidung`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `phong_chat_support`
--
ALTER TABLE `phong_chat_support`
  ADD CONSTRAINT `fk_chat_support_nguoidung` FOREIGN KEY (`idnguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_chat_support_staff` FOREIGN KEY (`idnguoi_phu_trach`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `phuong_thuc_tuyen_sinh_chi_tiet`
--
ALTER TABLE `phuong_thuc_tuyen_sinh_chi_tiet`
  ADD CONSTRAINT `phuong_thuc_tuyen_sinh_chi_tiet_ibfk_1` FOREIGN KEY (`idde_an`) REFERENCES `de_an_tuyen_sinh` (`idde_an`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `quy_dinh_diem_uu_tien_de_an`
--
ALTER TABLE `quy_dinh_diem_uu_tien_de_an`
  ADD CONSTRAINT `quy_dinh_diem_uu_tien_de_an_ibfk_1` FOREIGN KEY (`idphuong_thuc_chi_tiet`) REFERENCES `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tep_minhchung_buoituvan`
--
ALTER TABLE `tep_minhchung_buoituvan`
  ADD CONSTRAINT `fk_tepmc_ghichu` FOREIGN KEY (`id_ghichu`) REFERENCES `ghi_chu_buoituvan` (`id_ghichu`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tepmc_lichtuvan` FOREIGN KEY (`id_lichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tepmc_uploader` FOREIGN KEY (`nguoi_tai_len`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thanhtoan`
--
ALTER TABLE `thanhtoan`
  ADD CONSTRAINT `fk_thanhtoan_lichtuvan` FOREIGN KEY (`id_lichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_thanhtoan_nguoidung` FOREIGN KEY (`id_nguoidung`) REFERENCES `nguoidung` (`idnguoidung`) ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thongbao`
--
ALTER TABLE `thongbao`
  ADD CONSTRAINT `fk_thongbao_nguoidung` FOREIGN KEY (`nguoitao_id`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thongbao_lich`
--
ALTER TABLE `thongbao_lich`
  ADD CONSTRAINT `fk_thongbao_lich_lichtuvan` FOREIGN KEY (`idlichtuvan`) REFERENCES `lichtuvan` (`idlichtuvan`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `thongtintuyensinh`
--
ALTER TABLE `thongtintuyensinh`
  ADD CONSTRAINT `fk_ttts_ptxt` FOREIGN KEY (`idxettuyen`) REFERENCES `ptxt` (`idxettuyen`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ttts_truong` FOREIGN KEY (`idtruong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE CASCADE,
  ADD CONSTRAINT `thongtintuyensinh_ibfk_1` FOREIGN KEY (`idnganhtruong`) REFERENCES `nganhhoc` (`idnganh`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `thong_tin_bo_sung_phuong_thuc`
--
ALTER TABLE `thong_tin_bo_sung_phuong_thuc`
  ADD CONSTRAINT `thong_tin_bo_sung_phuong_thuc_ibfk_1` FOREIGN KEY (`idphuong_thuc_chi_tiet`) REFERENCES `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tin_nhan`
--
ALTER TABLE `tin_nhan`
  ADD CONSTRAINT `fk_tn_nguoigui` FOREIGN KEY (`idnguoigui`) REFERENCES `nguoidung` (`idnguoidung`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tn_phong` FOREIGN KEY (`idphongchat`) REFERENCES `phong_chat` (`idphongchat`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `tin_nhan_support`
--
ALTER TABLE `tin_nhan_support`
  ADD CONSTRAINT `fk_tinnhan_support_nguoigui` FOREIGN KEY (`idnguoigui`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_tinnhan_support_phongchat` FOREIGN KEY (`idphongchat_support`) REFERENCES `phong_chat_support` (`idphongchat_support`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `tin_tuyensinh`
--
ALTER TABLE `tin_tuyensinh`
  ADD CONSTRAINT `fk_tin_nguoidang` FOREIGN KEY (`id_nguoidang`) REFERENCES `nguoidung` (`idnguoidung`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_tin_truong` FOREIGN KEY (`id_truong`) REFERENCES `truongdaihoc` (`idtruong`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Các ràng buộc cho bảng `xet_tuyen_thang`
--
ALTER TABLE `xet_tuyen_thang`
  ADD CONSTRAINT `xet_tuyen_thang_ibfk_1` FOREIGN KEY (`idphuong_thuc_chi_tiet`) REFERENCES `phuong_thuc_tuyen_sinh_chi_tiet` (`idphuong_thuc_chi_tiet`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
