<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KyThiDGNLAttemptDetail extends Model
{
    protected $table = 'kythi_dgnl_attempt_details';
    protected $primaryKey = 'idattempt_detail';
    public $timestamps = true;

    protected $fillable = [
        'idattempt',
        'idquestion',
        'selected_option_ids',
        'cau_tra_loi_tu_luan',
        'diem',
        'is_correct',
    ];
}


