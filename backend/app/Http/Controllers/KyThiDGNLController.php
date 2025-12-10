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
    * Danh sách kỳ thi ĐGNL (chuẩn hóa field cho frontend).
    */
    public function exams(): JsonResponse
    {
        try {
            $items = KyThiDGNL::orderBy('created_at', 'desc')->get();
            $data = $items->map(function ($r) {
                return [
                    'idkythi'          => (int)($r->idkythi ?? $r->id ?? 0),
                    'makythi'          => (string)($r->makythi ?? $r->code ?? ''),
                    'tenkythi'         => (string)($r->tenkythi ?? $r->name ?? $r->title ?? ''),
                    'to_chuc'          => (string)($r->to_chuc ?? $r->organization ?? ''),
                    'so_cau'           => (int)($r->so_cau ?? $r->total_questions ?? 0),
                    'thoi_luong_phut'  => (int)($r->thoi_luong_phut ?? $r->duration ?? 0),
                ];
            });
            return response()->json(['success' => true, 'data' => $data]);
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
    * Danh sách câu hỏi (chuẩn hóa field).
    */
    public function questions(): JsonResponse
    {
        try {
            $items = KyThiDGNLQuestion::orderBy('idquestion')->get();
            $data = $items->map(function ($q) {
                $type = $q->loai_cau ?? $q->type ?? null;
                if (!$type && isset($q->is_multiple)) {
                    $type = $q->is_multiple ? 'multiple_choice' : 'single_choice';
                }
                return [
                    'idquestion'   => (int)($q->idquestion ?? $q->id ?? $q->question_id ?? 0),
                    'idsection'    => (int)($q->idsection ?? $q->section_id ?? $q->id_section ?? 0),
                    'noi_dung'     => (string)($q->noi_dung ?? $q->content ?? $q->title ?? ''),
                    'loai_cau'     => (string)($type ?? 'single_choice'),
                    'thu_tu'       => (int)($q->thu_tu ?? $q->order ?? 0),
                    // Backend có thể lưu dạng "A,B"; giữ nguyên để frontend map sang id đáp án
                    'dap_an_dung'  => (string)($q->dap_an_dung ?? $q->correct_letters ?? ''),
                    'giai_thich'   => (string)($q->giai_thich ?? $q->explain ?? ''),
                ];
            });
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách câu hỏi',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Phương án trả lời (chuẩn hóa field).
    */
    public function options(): JsonResponse
    {
        try {
            $items = KyThiDGNLOption::orderBy('idoption')->get();
            $data = $items->map(function ($o) {
                return [
                    'idoption'   => (int)($o->idoption ?? $o->id ?? $o->option_id ?? 0),
                    'idquestion' => (int)($o->idquestion ?? $o->question_id ?? $o->id_question ?? 0),
                    'noi_dung'   => (string)($o->noi_dung ?? $o->content ?? ''),
                    'is_correct' => (int)($o->is_correct ?? $o->correct ?? 0),
                    'thu_tu'     => (int)($o->thu_tu ?? $o->order ?? 0),
                ];
            });
            return response()->json(['success' => true, 'data' => $data]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy danh sách phương án',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
    * Section trong đề thi (chuẩn hóa field).
    */
    public function sections(): JsonResponse
    {
        try {
            $items = KyThiDGNLSection::orderBy('idsection')->get();
            $data = $items->map(function ($s) {
                return [
                    'idsection'       => (int)($s->idsection ?? $s->id ?? $s->section_id ?? 0),
                    'idkythi'         => (int)($s->idkythi ?? $s->kythi_id ?? $s->exam_id ?? 0),
                    'ten_section'     => (string)($s->ten_section ?? $s->name ?? $s->title ?? ''),
                    'nhom_nang_luc'   => (string)($s->nhom_nang_luc ?? $s->group ?? ''),
                    'so_cau'          => (int)($s->so_cau ?? $s->total_questions ?? 0),
                    'thoi_luong_phut' => (int)($s->thoi_luong_phut ?? $s->duration ?? 0),
                    'thu_tu'          => (int)($s->thu_tu ?? $s->order ?? 0),
                ];
            });
            return response()->json(['success' => true, 'data' => $data]);
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
