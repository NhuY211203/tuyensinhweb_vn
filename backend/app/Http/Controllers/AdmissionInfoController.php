<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Models\ThongTinTuyenSinh;
use App\Models\QuyCheXetTuyen;
use App\Models\NganhTruong;
use App\Models\NganhHoc;
use App\Models\TruongDaiHoc;
use App\Models\Ptxt;

class AdmissionInfoController extends Controller
{
    /**
     * Danh sách thông tin tuyển sinh (có filter cơ bản).
     */
    public function index(Request $request): JsonResponse
    {
        try {
            $query = ThongTinTuyenSinh::query()
                ->select([
                    'thongtintuyensinh.*',
                    'nganh_truong.manganh',
                    'nganh_truong.hinhthuc as chuong_trinh_nt',
                    'nganh_truong.nam as nam_nganh_truong',
                    'nganh_truong.thoiluong_nam',
                    'nganh_truong.mota_tomtat',
                    'nganhhoc.tennganh',
                    'truongdaihoc.tentruong',
                    'ptxt.tenptxt',
                ])
                ->join('nganh_truong', 'nganh_truong.idnganhtruong', '=', 'thongtintuyensinh.idnganhtruong')
                ->join('truongdaihoc', 'truongdaihoc.idtruong', '=', 'thongtintuyensinh.idtruong')
                ->join('nganhhoc', 'nganhhoc.manganh', '=', 'nganh_truong.manganh')
                ->leftJoin('ptxt', 'ptxt.idxettuyen', '=', 'thongtintuyensinh.idxettuyen');

            if ($request->filled('idtruong')) {
                $query->where('thongtintuyensinh.idtruong', $request->integer('idtruong'));
            }

            if ($request->filled('idnganhtruong')) {
                $query->where('thongtintuyensinh.idnganhtruong', $request->integer('idnganhtruong'));
            }

            if ($request->filled('nam')) {
                $query->where('thongtintuyensinh.namxettuyen', $request->integer('nam'));
            }

            if ($request->filled('idxettuyen')) {
                $query->where('thongtintuyensinh.idxettuyen', $request->integer('idxettuyen'));
            }

            if ($request->filled('keyword')) {
                $kw = '%' . $request->get('keyword') . '%';
                $query->where(function ($q) use ($kw) {
                    $q->where('nganhhoc.tennganh', 'like', $kw)
                      ->orWhere('truongdaihoc.tentruong', 'like', $kw)
                      ->orWhere('nganh_truong.mota_tomtat', 'like', $kw);
                });
            }

            // Chỉ lấy các dòng đang hoạt động
            $query->where('thongtintuyensinh.trangthai', 1);

            $items = $query
                ->orderByDesc('thongtintuyensinh.namxettuyen')
                ->orderBy('truongdaihoc.tentruong')
                ->orderBy('nganhhoc.tennganh')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $items,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy thông tin tuyển sinh',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Lấy quy chế / cách tính điểm cho một dòng tuyển sinh.
     */
    public function quyChe(Request $request): JsonResponse
    {
        try {
            $idtruong = $request->integer('idtruong');
            $idnganhtruong = $request->integer('idnganhtruong');
            $idxettuyen = $request->integer('idxettuyen');
            $nam = $request->integer('nam');

            $query = QuyCheXetTuyen::query()
                ->where('idxettuyen', $idxettuyen)
                ->where('nam_ap_dung', $nam);

            // ưu tiên quy chế riêng cho ngành_truong -> trường -> chung
            if ($idnganhtruong) {
                $query->where(function ($q) use ($idnganhtruong, $idtruong) {
                    $q->where('idnganhtruong', $idnganhtruong)
                      ->orWhereNull('idnganhtruong');

                    if ($idtruong) {
                        $q->orWhere('idtruong', $idtruong);
                    }
                });
            } elseif ($idtruong) {
                $query->where(function ($q) use ($idtruong) {
                    $q->where('idtruong', $idtruong)
                      ->orWhereNull('idtruong');
                });
            }

            $items = $query
                ->orderByDesc('idnganhtruong')
                ->orderByDesc('idtruong')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $items,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy quy chế xét tuyển',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}


