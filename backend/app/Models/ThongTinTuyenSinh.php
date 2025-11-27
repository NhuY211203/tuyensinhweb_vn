<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ThongTinTuyenSinh extends Model
{
    protected $table = 'thongtintuyensinh';
    protected $primaryKey = 'idthongtintuyensinh';
    public $timestamps = false; // bảng hiện tại không có created_at/updated_at

    protected $fillable = [
        'idnganhtruong',
        'idtruong',
        'chuong_trinh',
        'namxettuyen',
        'idxettuyen',
        'tohopmon',
        'diemchuan',
        'diem_san',
        'chitieu',
        'hocphidaitra',
        'hocphitientien',
        'ghichu',
        'trangthai',
    ];
}


