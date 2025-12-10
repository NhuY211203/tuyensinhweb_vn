<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Tạo bảng môn học (không có foreign key)
        Schema::create('mon_hoc', function (Blueprint $table) {
            $table->id('idmonhoc');
            $table->string('ma_mon_hoc', 20)->unique()->comment('Mã môn học (VD: TOAN, VAN, ANH)');
            $table->string('ten_mon_hoc')->comment('Tên môn học');
            $table->string('ten_viet_tat', 50)->nullable()->comment('Tên viết tắt (VD: Toán, Văn, T.Anh)');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('ma_mon_hoc');
        });

        // 2. Tạo bảng phương thức xét học bạ (không có foreign key)
        Schema::create('phuong_thuc_xet_hoc_ba', function (Blueprint $table) {
            $table->id('idphuongthuc_hb');
            $table->string('ten_phuong_thuc')->comment('Tên phương thức (VD: Xét học bạ 3 năm)');
            $table->string('ma_phuong_thuc', 50)->unique()->comment('Mã phương thức (VD: HB_3_NAM)');
            $table->text('mo_ta')->nullable()->comment('Mô tả chi tiết phương thức');
            $table->text('cach_tinh')->nullable()->comment('Cách tính điểm (VD: (Điểm lớp 10 + 11 + 12)/3)');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('ma_phuong_thuc');
        });

        // 3. Tạo bảng đối tượng ưu tiên (không có foreign key)
        Schema::create('doi_tuong_uu_tien', function (Blueprint $table) {
            $table->id('iddoituong');
            $table->string('ma_doi_tuong', 20)->unique()->comment('Mã đối tượng (VD: DT01, DT02)');
            $table->string('ten_doi_tuong')->comment('Tên đối tượng ưu tiên');
            $table->text('mo_ta')->nullable()->comment('Mô tả đối tượng');
            $table->decimal('diem_uu_tien', 4, 2)->default(0)->comment('Mức điểm ưu tiên (theo quy định)');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('ma_doi_tuong');
        });

        // 4. Tạo bảng khu vực ưu tiên (không có foreign key)
        Schema::create('khu_vuc_uu_tien', function (Blueprint $table) {
            $table->id('idkhuvuc');
            $table->string('ma_khu_vuc', 20)->unique()->comment('Mã khu vực (VD: KV1, KV2, KV2-NT, KV3)');
            $table->string('ten_khu_vuc')->comment('Tên khu vực');
            $table->text('mo_ta')->nullable()->comment('Mô tả khu vực');
            $table->decimal('diem_uu_tien', 4, 2)->default(0)->comment('Mức điểm ưu tiên');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('ma_khu_vuc');
        });

        // 5. Tạo bảng quy định điểm ưu tiên (không có foreign key)
        Schema::create('quy_dinh_diem_uu_tien', function (Blueprint $table) {
            $table->id('idquydinh');
            $table->string('ten_quy_dinh')->comment('Tên quy định');
            $table->text('mo_ta')->nullable()->comment('Mô tả quy định');
            $table->decimal('nguong_diem', 5, 2)->default(22.50)->comment('Ngưỡng điểm (VD: 22.5)');
            $table->text('cong_thuc')->nullable()->comment('Công thức tính điểm ưu tiên');
            $table->integer('nam_ap_dung')->comment('Năm áp dụng');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('nam_ap_dung');
        });

        // 6. Tạo bảng điểm học bạ (có foreign key đến nguoidung và mon_hoc)
        Schema::create('diem_hoc_ba', function (Blueprint $table) {
            $table->bigIncrements('iddiem_hb')->comment('ID điểm học bạ');
            $table->unsignedBigInteger('idnguoidung')->comment('ID người dùng (học sinh)');
            $table->unsignedBigInteger('idmonhoc')->comment('ID môn học');
            $table->tinyInteger('lop')->comment('Lớp (10, 11, 12)');
            $table->tinyInteger('hoc_ky')->nullable()->comment('Học kỳ (1, 2) - NULL nếu là cả năm');
            $table->decimal('diem_trung_binh', 4, 2)->comment('Điểm trung bình');
            $table->integer('nam_hoc')->nullable()->comment('Năm học (VD: 2024)');
            $table->timestamps();
            $table->index('idnguoidung');
            $table->index('idmonhoc');
            $table->index(['lop', 'hoc_ky']);
            $table->index(['idnguoidung', 'idmonhoc']);
            
            // Foreign keys
            $table->foreign('idnguoidung')
                ->references('idnguoidung')
                ->on('nguoidung')
                ->onDelete('cascade');
            $table->foreign('idmonhoc')
                ->references('idmonhoc')
                ->on('mon_hoc')
                ->onDelete('cascade');
        });

        // 7. Tạo bảng kết quả tính điểm học bạ (có nhiều foreign key)
        Schema::create('ket_qua_tinh_diem_hoc_ba', function (Blueprint $table) {
            $table->id('idketqua');
            $table->unsignedBigInteger('idnguoidung')->comment('ID người dùng (học sinh)');
            $table->unsignedBigInteger('idphuongthuc_hb')->comment('ID phương thức xét học bạ');
            $table->unsignedBigInteger('idthongtin')->nullable()->comment('ID thông tin tuyển sinh (ngành/trường)');
            $table->string('tohopmon', 200)->nullable()->comment('Tổ hợp môn xét tuyển');
            $table->unsignedBigInteger('mon_nhan_he_so_2')->nullable()->comment('ID môn nhân hệ số 2 (nếu có)');
            $table->unsignedBigInteger('iddoituong')->nullable()->comment('ID đối tượng ưu tiên');
            $table->unsignedBigInteger('idkhuvuc')->nullable()->comment('ID khu vực ưu tiên');
            $table->decimal('diem_to_hop', 5, 2)->default(0)->comment('Điểm tổ hợp môn (chưa cộng ưu tiên)');
            $table->decimal('diem_uu_tien_doi_tuong', 4, 2)->default(0)->comment('Điểm ưu tiên đối tượng');
            $table->decimal('diem_uu_tien_khu_vuc', 4, 2)->default(0)->comment('Điểm ưu tiên khu vực');
            $table->decimal('tong_diem_uu_tien', 4, 2)->default(0)->comment('Tổng điểm ưu tiên (sau khi áp dụng công thức)');
            $table->decimal('tong_diem_xet_tuyen', 5, 2)->default(0)->comment('Tổng điểm xét tuyển (điểm tổ hợp + điểm ưu tiên)');
            $table->json('chi_tiet_tinh_toan')->nullable()->comment('Chi tiết tính toán (lưu dạng JSON)');
            $table->timestamps();
            $table->index('idnguoidung');
            $table->index('idphuongthuc_hb');
            $table->index('idthongtin');
        });

        // 8. Tạo bảng cấu hình môn nhân hệ số
        Schema::create('cau_hinh_mon_nhan_he_so', function (Blueprint $table) {
            $table->id('idcauhinh');
            $table->unsignedBigInteger('idthongtin')->comment('ID thông tin tuyển sinh');
            $table->unsignedBigInteger('idmonhoc')->comment('ID môn học được nhân hệ số');
            $table->decimal('he_so', 3, 2)->default(2.00)->comment('Hệ số nhân (thường là 2.0)');
            $table->tinyInteger('trang_thai')->default(1)->comment('1: Hoạt động, 0: Không hoạt động');
            $table->timestamps();
            $table->index('idthongtin');
            $table->index('idmonhoc');
        });

        // Thêm dữ liệu mẫu cho bảng quy_dinh_diem_uu_tien
        DB::table('quy_dinh_diem_uu_tien')->insert([
            [
                'ten_quy_dinh' => 'Quy định tính điểm ưu tiên 2024',
                'mo_ta' => 'Quy định áp dụng cho năm 2024',
                'nguong_diem' => 22.50,
                'cong_thuc' => '[(30 - Tổng điểm đạt được)/7.5] x Tổng điểm ưu tiên được xác định thông thường',
                'nam_ap_dung' => 2024,
                'trang_thai' => 1,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Thêm dữ liệu mẫu cho bảng mon_hoc
        $monHocData = [
            ['ma_mon_hoc' => 'TOAN', 'ten_mon_hoc' => 'Toán', 'ten_viet_tat' => 'Toán', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'VAN', 'ten_mon_hoc' => 'Ngữ văn', 'ten_viet_tat' => 'Văn', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'ANH', 'ten_mon_hoc' => 'Tiếng Anh', 'ten_viet_tat' => 'T.Anh', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'SU', 'ten_mon_hoc' => 'Lịch sử', 'ten_viet_tat' => 'Sử', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'DIA', 'ten_mon_hoc' => 'Địa lý', 'ten_viet_tat' => 'Địa', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'GDKTPL', 'ten_mon_hoc' => 'Giáo dục kinh tế và pháp luật', 'ten_viet_tat' => 'GDKTPL', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'LI', 'ten_mon_hoc' => 'Vật lý', 'ten_viet_tat' => 'Lí', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'HOA', 'ten_mon_hoc' => 'Hóa học', 'ten_viet_tat' => 'Hóa', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'SINH', 'ten_mon_hoc' => 'Sinh học', 'ten_viet_tat' => 'Sinh', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'TIN', 'ten_mon_hoc' => 'Tin học', 'ten_viet_tat' => 'Tin học', 'trang_thai' => 1],
            ['ma_mon_hoc' => 'CN', 'ten_mon_hoc' => 'Công nghệ', 'ten_viet_tat' => 'Công nghệ', 'trang_thai' => 1],
        ];

        foreach ($monHocData as $mon) {
            $mon['created_at'] = now();
            $mon['updated_at'] = now();
            DB::table('mon_hoc')->insert($mon);
        }

        // Thêm dữ liệu mẫu cho bảng phuong_thuc_xet_hoc_ba
        $phuongThucData = [
            [
                'ten_phuong_thuc' => 'Xét học bạ 3 năm',
                'ma_phuong_thuc' => 'HB_3_NAM',
                'mo_ta' => 'Xét điểm trung bình cả năm của lớp 10, 11, 12',
                'cach_tinh' => '(Điểm lớp 10 + 11 + 12) / 3',
                'trang_thai' => 1,
            ],
            [
                'ten_phuong_thuc' => 'Xét học bạ lớp 12',
                'ma_phuong_thuc' => 'HB_12_NAM',
                'mo_ta' => 'Xét điểm trung bình cả năm lớp 12',
                'cach_tinh' => 'Điểm lớp 12',
                'trang_thai' => 1,
            ],
            [
                'ten_phuong_thuc' => 'Xét học bạ 6 học kỳ',
                'ma_phuong_thuc' => 'HB_6_HK',
                'mo_ta' => 'Xét điểm trung bình 6 học kỳ (lớp 10, 11, 12)',
                'cach_tinh' => '(HK1 lớp 10 + HK2 lớp 10 + HK1 lớp 11 + HK2 lớp 11 + HK1 lớp 12 + HK2 lớp 12) / 6',
                'trang_thai' => 1,
            ],
            [
                'ten_phuong_thuc' => 'Xét học bạ lớp 10, 11 và HK1 lớp 12',
                'ma_phuong_thuc' => 'HB_10_11_HK1_12',
                'mo_ta' => 'Xét điểm lớp 10, 11 cả năm và HK1 lớp 12',
                'cach_tinh' => '(Điểm lớp 10 + Điểm lớp 11 + Điểm HK1 lớp 12) / 3',
                'trang_thai' => 1,
            ],
            [
                'ten_phuong_thuc' => 'Xét học bạ 3 học kỳ',
                'ma_phuong_thuc' => 'HB_3_HK',
                'mo_ta' => 'Xét điểm 3 học kỳ gần nhất (HK2 lớp 11, HK1 và HK2 lớp 12)',
                'cach_tinh' => '(HK2 lớp 11 + HK1 lớp 12 + HK2 lớp 12) / 3',
                'trang_thai' => 1,
            ],
            [
                'ten_phuong_thuc' => 'Xét học bạ 5 học kỳ',
                'ma_phuong_thuc' => 'HB_5_HK',
                'mo_ta' => 'Xét điểm 5 học kỳ (HK2 lớp 10, HK1 và HK2 lớp 11, HK1 và HK2 lớp 12)',
                'cach_tinh' => '(HK2 lớp 10 + HK1 lớp 11 + HK2 lớp 11 + HK1 lớp 12 + HK2 lớp 12) / 5',
                'trang_thai' => 1,
            ],
        ];

        foreach ($phuongThucData as $pt) {
            $pt['created_at'] = now();
            $pt['updated_at'] = now();
            DB::table('phuong_thuc_xet_hoc_ba')->insert($pt);
        }

        // Thêm dữ liệu mẫu cho bảng doi_tuong_uu_tien
        $doiTuongData = [
            ['ma_doi_tuong' => 'DT01', 'ten_doi_tuong' => 'Không ưu tiên', 'mo_ta' => 'Không có ưu tiên', 'diem_uu_tien' => 0, 'trang_thai' => 1],
            ['ma_doi_tuong' => 'DT02', 'ten_doi_tuong' => 'Đối tượng ưu tiên 1', 'mo_ta' => 'Ưu tiên 1 điểm', 'diem_uu_tien' => 1.0, 'trang_thai' => 1],
            ['ma_doi_tuong' => 'DT03', 'ten_doi_tuong' => 'Đối tượng ưu tiên 2', 'mo_ta' => 'Ưu tiên 1.5 điểm', 'diem_uu_tien' => 1.5, 'trang_thai' => 1],
        ];

        foreach ($doiTuongData as $dt) {
            $dt['created_at'] = now();
            $dt['updated_at'] = now();
            DB::table('doi_tuong_uu_tien')->insert($dt);
        }

        // Thêm dữ liệu mẫu cho bảng khu_vuc_uu_tien
        $khuVucData = [
            ['ma_khu_vuc' => 'KV1', 'ten_khu_vuc' => 'Khu vực 1', 'mo_ta' => 'Thành phố, tỉnh lớn', 'diem_uu_tien' => 0, 'trang_thai' => 1],
            ['ma_khu_vuc' => 'KV2', 'ten_khu_vuc' => 'Khu vực 2', 'mo_ta' => 'Tỉnh, thành phố khác', 'diem_uu_tien' => 1.0, 'trang_thai' => 1],
            ['ma_khu_vuc' => 'KV2NT', 'ten_khu_vuc' => 'Khu vực 2 - Nông thôn', 'mo_ta' => 'Nông thôn khu vực 2', 'diem_uu_tien' => 1.5, 'trang_thai' => 1],
            ['ma_khu_vuc' => 'KV3', 'ten_khu_vuc' => 'Khu vực 3', 'mo_ta' => 'Vùng sâu, vùng xa', 'diem_uu_tien' => 2.0, 'trang_thai' => 1],
        ];

        foreach ($khuVucData as $kv) {
            $kv['created_at'] = now();
            $kv['updated_at'] = now();
            DB::table('khu_vuc_uu_tien')->insert($kv);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cau_hinh_mon_nhan_he_so');
        Schema::dropIfExists('ket_qua_tinh_diem_hoc_ba');
        Schema::dropIfExists('diem_hoc_ba');
        Schema::dropIfExists('quy_dinh_diem_uu_tien');
        Schema::dropIfExists('khu_vuc_uu_tien');
        Schema::dropIfExists('doi_tuong_uu_tien');
        Schema::dropIfExists('phuong_thuc_xet_hoc_ba');
        Schema::dropIfExists('mon_hoc');
    }
};

