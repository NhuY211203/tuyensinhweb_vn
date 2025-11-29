<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TinTuyenSinh extends Model
{
    protected $table = 'tin_tuyensinh';
    protected $primaryKey = 'id_tin';
    public $timestamps = false;

    protected $fillable = [
        'id_truong',
        'id_nguoidang',
        'tieu_de',
        'tom_tat',
        'hinh_anh_dai_dien',
        'nguon_bai_viet',
        'loai_tin',
        'trang_thai',
        'ngay_dang',
        'ma_nguon',
        'hash_noidung'
    ];

    protected $casts = [
        'ngay_dang' => 'datetime',
        'ngay_cap_nhat' => 'datetime',
    ];

    public function truong()
    {
        return $this->belongsTo(TruongDaiHoc::class, 'id_truong', 'idtruong');
    }

    public function nguoiDang()
    {
        return $this->belongsTo(NguoiDung::class, 'id_nguoidang', 'idnguoidung');
    }
}














