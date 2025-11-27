<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KyThiDGNLTopic extends Model
{
    protected $table = 'kythi_dgnl_topics';
    protected $primaryKey = 'idtopic';
    public $timestamps = true;

    protected $fillable = [
        'idsection',
        'ten_chu_de',
        'mo_ta',
    ];
}


