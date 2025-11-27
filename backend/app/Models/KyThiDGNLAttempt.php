<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KyThiDGNLAttempt extends Model
{
    protected $table = 'kythi_dgnl_attempts';
    protected $primaryKey = 'idattempt';
    public $timestamps = true;

    protected $fillable = [
        'idkythi',
        'idnguoidung',
        'tong_diem',
        'tong_so_cau',
        'tong_cau_dung',
        'trang_thai',
        'nhan_xet',
        'completed_at',
    ];
}


