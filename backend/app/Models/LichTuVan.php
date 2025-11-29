<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class LichTuVan extends Model
{
    protected $table = 'lichtuvan';
    protected $primaryKey = 'idlichtuvan';
    public $timestamps = false;

    protected $fillable = [
        'idnguoidung',
        'idnguoidat',
        'tieude',
        'noidung',
        'chudetuvan',
        'molavande',
        'ngayhen',
        'giohen',
        'giobatdau',
        'ketthuc',
        'tinhtrang',
        'trangthai',
        'danhdanhgiadem',
        'nhanxet',
        'duyetlich',
        'idnguoiduyet',
        'ngayduyet',
        'ghichu'
    ];

    protected $casts = [
        'ngayhen' => 'date',
        'giohen' => 'datetime:H:i',
        'giobatdau' => 'datetime:H:i',
        'ketthuc' => 'datetime:H:i',
        'duyetlich' => 'integer',
        'ngayduyet' => 'datetime',
    ];

    // Relationships
    public function nguoiDung()
    {
        return $this->belongsTo(NguoiDung::class, 'idnguoidung', 'idnguoidung');
    }

    public function nguoiDat()
    {
        return $this->belongsTo(NguoiDung::class, 'idnguoidat', 'idnguoidung');
    }

    public function nguoiDuyet()
    {
        return $this->belongsTo(NguoiDung::class, 'idnguoiduyet', 'idnguoidung');
    }

    public function ghiChu()
    {
        return $this->hasMany(GhiChuBuoiTuVan::class, 'id_lichtuvan', 'idlichtuvan');
    }

    public function ghiChuChot()
    {
        return $this->hasOne(GhiChuBuoiTuVan::class, 'id_lichtuvan', 'idlichtuvan')
                    ->where('trang_thai', 'CHOT');
    }

    public function tepMinhChung()
    {
        return $this->hasMany(TepMinhChungBuoiTuVan::class, 'id_lichtuvan', 'idlichtuvan');
    }

    // Scopes
    public function scopeByConsultant($query, $consultantId)
    {
        return $query->where('idnguoidung', $consultantId);
    }

    public function scopeByDate($query, $date)
    {
        return $query->where('ngayhen', $date);
    }

    public function scopeUpcoming($query)
    {
        return $query->where('ngayhen', '>=', Carbon::today());
    }

    public function scopeAvailable($query)
    {
        return $query->where('trangthai', '1'); // 1 = lịch trống
    }

    public function scopeBooked($query)
    {
        return $query->where('trangthai', '2'); // 2 = đã đặt
    }

    // Lịch đã được duyệt bởi staff
    public function scopeApproved($query)
    {
        return $query->where('duyetlich', 2);
    }

    // Lịch thuộc về người dùng đã đặt
    public function scopeForUser($query, $userId)
    {
        return $query->where('idnguoidat', $userId);
    }

    // Lịch đã hoàn thành (đã qua thời điểm kết thúc)
    public function scopeCompleted($query)
    {
        return $query->where(function($q) {
            $q->where('ngayhen', '<', Carbon::today()->toDateString())
              ->orWhere(function($q2) {
                  $q2->where('ngayhen', Carbon::today()->toDateString())
                     ->where('ketthuc', '<=', Carbon::now()->format('H:i:s'));
              });
        });
    }

    // Lịch sắp tới hoặc đang diễn ra
    public function scopeUpcomingOrOngoing($query)
    {
        return $query->where(function($q) {
            $q->where('ngayhen', '>', Carbon::today()->toDateString())
              ->orWhere(function($q2) {
                  $q2->where('ngayhen', Carbon::today()->toDateString())
                     ->where('ketthuc', '>', Carbon::now()->format('H:i:s'));
              });
        });
    }

    // Lịch trong tuần này
    public function scopeThisWeek($query)
    {
        $startOfWeek = Carbon::now()->startOfWeek();
        $endOfWeek = Carbon::now()->endOfWeek();
        return $query->whereBetween('ngayhen', [$startOfWeek, $endOfWeek]);
    }

    // Lịch trong tháng này
    public function scopeThisMonth($query)
    {
        return $query->whereMonth('ngayhen', Carbon::now()->month)
                     ->whereYear('ngayhen', Carbon::now()->year);
    }

    // Lịch đã qua (ngày < hôm nay)
    public function scopePast($query)
    {
        return $query->where('ngayhen', '<', Carbon::today());
    }

    // Lịch sắp tới (ngày >= hôm nay)
    public function scopeFuture($query)
    {
        return $query->where('ngayhen', '>=', Carbon::today());
    }

    // Lọc theo khoảng ngày (bao gồm cả 2 đầu)
    public function scopeBetweenDates($query, $startDate = null, $endDate = null)
    {
        if ($startDate && $endDate) {
            return $query->whereBetween('ngayhen', [Carbon::parse($startDate)->startOfDay(), Carbon::parse($endDate)->endOfDay()]);
        }
        if ($startDate) {
            return $query->where('ngayhen', '>=', Carbon::parse($startDate)->startOfDay());
        }
        if ($endDate) {
            return $query->where('ngayhen', '<=', Carbon::parse($endDate)->endOfDay());
        }
        return $query;
    }

    // Accessors
    public function getTimeSlotAttribute()
    {
        return $this->giobatdau->format('H:i') . ' - ' . $this->ketthuc->format('H:i');
    }

    public function getIsAvailableAttribute()
    {
        return $this->trangthai === '1';
    }

    public function getIsBookedAttribute()
    {
        return $this->trangthai === '2';
    }

    public function getStatusTextAttribute()
    {
        $statusMap = [
            '1' => 'Trống',
            '2' => 'Đã đặt',
            '3' => 'Đã hủy',
            '4' => 'Hoàn thành'
        ];
        return $statusMap[$this->trangthai] ?? 'Không xác định';
    }
}
