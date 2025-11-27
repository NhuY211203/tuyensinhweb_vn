<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KyThiDGNL extends Model
{
    protected $table = 'kythi_dgnl';
    protected $primaryKey = 'idkythi';

    // Bảng dùng created_at / updated_at
    public $timestamps = true;

    protected $fillable = [
        'makythi',
        'tenkythi',
        'to_chuc',
        'so_cau',
        'thoi_luong_phut',
        'hinh_thuc',
        'mo_ta_tong_quat',
        'ghi_chu',
    ];
}


