<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\KyThiDGNL;
use App\Models\KyThiDGNLAttempt;
use App\Models\KyThiDGNLAttemptDetail;
use App\Models\KyThiDGNLOption;
use App\Models\KyThiDGNLQuestion;
use App\Models\KyThiDGNLSection;
use App\Models\KyThiDGNLTopic;

class KyThiDGNLController extends Controller
{
    /**
    * Danh sách kỳ thi ĐGNL.
    */
    public function exams(): JsonResponse
    {
        try {
            $items = KyThiDGNL::orderBy('created_at', 'desc')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách kỳ thi',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Danh sách lượt làm bài.
    */
    public function attempts(): JsonResponse
    {
        try {
            $items = KyThiDGNLAttempt::orderBy('created_at', 'desc')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách lượt làm bài',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Lưu một lượt làm bài mới.
     */
    public function storeAttempt(Request $request): JsonResponse
    {
        try {
            $validator = Validator::make($request->all(), [
                'idkythi' => 'required|integer|exists:kythi_dgnl,idkythi',
                'tong_so_cau' => 'required|integer|min:0',
                'tong_cau_dung' => 'required|integer|min:0',
                'tong_diem' => 'nullable|numeric|min:0',
                'idnguoidung' => 'nullable|integer',
            ]);

            if ($validator->fails()) {
                return response()->json([
                    'success' => false,
                    'message' => 'Dữ liệu không hợp lệ',
                    'errors' => $validator->errors(),
                ], 422);
            }

            $data = $validator->validated();

            // Mặc định mỗi câu đúng 10 điểm nếu không truyền tong_diem
            $defaultScore = $data['tong_cau_dung'] * 10;

            $attempt = KyThiDGNLAttempt::create([
                'idkythi' => $data['idkythi'],
                'idnguoidung' => $data['idnguoidung'] ?? null,
                'tong_diem' => $data['tong_diem'] ?? $defaultScore,
                'tong_so_cau' => $data['tong_so_cau'],
                'tong_cau_dung' => $data['tong_cau_dung'],
                // cột trang_thai trong DB đang dùng enum/dạng ngắn (vd: 'draft','submitted')
                // nên dùng 'submitted' để tránh lỗi data truncated
                'trang_thai' => 'submitted',
                'nhan_xet' => $request->input('nhan_xet'),
                'completed_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'data' => $attempt,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lưu lượt làm bài',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Chi tiết lượt làm bài.
    */
    public function attemptDetails(): JsonResponse
    {
        try {
            $items = KyThiDGNLAttemptDetail::orderBy('idattempt_detail')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy chi tiết lượt làm bài',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Câu hỏi.
    */
    public function questions(): JsonResponse
    {
        try {
            $items = KyThiDGNLQuestion::orderBy('idquestion')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách câu hỏi',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Phương án trả lời.
    */
    public function options(): JsonResponse
    {
        try {
            $items = KyThiDGNLOption::orderBy('idoption')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách phương án',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Section trong đề thi.
    */
    public function sections(): JsonResponse
    {
        try {
            $items = KyThiDGNLSection::orderBy('idsection')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách section',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Chủ đề trong section.
    */
    public function topics(): JsonResponse
    {
        try {
            $items = KyThiDGNLTopic::orderBy('idtopic')->get();
            return response()->json(['success' => true, 'data' => $items]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách chủ đề',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}


