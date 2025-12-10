<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Models\ThanhToan;

class PaymentController extends Controller
{
    /**
     * Tạo QR code thanh toán ZaloPay
     * POST /api/payments/generate-zalopay-qr
     */
    public function generateZaloPayQR(Request $request): JsonResponse
    {
        try {
            $request->validate([
                'invoiceId' => 'required|integer',
                'scheduleId' => 'required|integer', // id_lichtuvan
                'userId' => 'required|integer', // id_nguoidung
                'pointsUsed' => 'nullable|integer|min:0',
                'discountAmount' => 'nullable|integer|min:0'
            ]);

            $invoiceId = $request->integer('invoiceId');
            $scheduleId = $request->integer('scheduleId');
            $userId = $request->integer('userId');
            $pointsUsed = $request->integer('pointsUsed', 0);
            $discountAmount = $request->integer('discountAmount', 0);
            
            // Tạo orderId từ schedule ID
            $orderId = 'ORD_' . time() . '_' . $scheduleId;
            
            // Cấu hình ZaloPay từ .env
            $appId = env('ZALOPAY_APP_ID');
            $key1 = env('ZALOPAY_KEY1');
            $key2 = env('ZALOPAY_KEY2');
            $endpoint = env('ZALOPAY_ENDPOINT', 'https://sb-openapi.zalopay.vn/v2/create');
            $callbackUrl = env('ZALOPAY_CALLBACK_URL');
            
            if (!$appId || !$key1 || !$key2) {
                return response()->json([
                    'success' => false,
                    'message' => 'ZaloPay chưa được cấu hình. Vui lòng kiểm tra file .env',
                    'debug' => [
                        'appId' => $appId ? 'configured' : 'missing',
                        'key1' => $key1 ? 'configured' : 'missing',
                        'key2' => $key2 ? 'configured' : 'missing'
                    ]
                ], 500);
            }

            // Tính toán số tiền
            $consultationFee = 5000; // Phí tư vấn
            $serviceFee = 5000; // Phí dịch vụ
            $subtotal = $consultationFee + $serviceFee; // Tổng: 550000
            $amount = max(0, $subtotal - $discountAmount); // Tổng sau giảm giá
            
            // Tạo app_trans_id theo format ZaloPay: YYMMDD_xxxxxx
            $date = date('ymd');
            $random = str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
            $appTransId = $date . '_' . $random;
            
            // Tạo record trong bảng thanhtoan trước khi gọi ZaloPay
            $thanhToan = ThanhToan::create([
                'id_lichtuvan' => $scheduleId,
                'id_nguoidung' => $userId,
                'phuongthuc' => 'ZaloPayOA',
                'ma_phieu' => $orderId,
                'so_tien' => $amount,
                'don_vi_tien' => 'VND',
                'so_tien_giam' => $discountAmount,
                'phi_giao_dich' => $serviceFee,
                'trang_thai' => 'KhoiTao',
                'ma_giao_dich_app' => $appTransId,
                'du_lieu_yeu_cau' => json_encode([
                    'pointsUsed' => $pointsUsed,
                    'discountAmount' => $discountAmount,
                    'subtotal' => $subtotal
                ])
            ]);
            
            Log::info('Created ThanhToan record', [
                'id_thanhtoan' => $thanhToan->id_thanhtoan,
                'ma_phieu' => $orderId,
                'ma_giao_dich_app' => $appTransId,
                'amount' => $amount,
                'discount' => $discountAmount
            ]);
            
            // Tạo embed_data (phải là JSON string)
            $embedDataObj = [
                'orderId' => $orderId,
                'invoiceId' => $invoiceId,
                'id_thanhtoan' => $thanhToan->id_thanhtoan,
                'userId' => $userId,
                'pointsUsed' => $pointsUsed
            ];
            $embedData = json_encode($embedDataObj, JSON_UNESCAPED_UNICODE);
            
            // Tạo item (phải là JSON string array)
            $itemObj = [
                [
                    'item_name' => 'Phí tư vấn tuyển sinh',
                    'item_quantity' => 1,
                    'item_price' => $amount
                ]
            ];
            $item = json_encode($itemObj, JSON_UNESCAPED_UNICODE);
            
            // Tạo app_time (timestamp milliseconds)
            $appTime = round(microtime(true) * 1000);
            
            // app_user: Dùng user ID từ request
            $appUser = (string) $userId;
            
            // Tạo data string để ký MAC theo format: app_id|app_trans_id|app_user|amount|app_time|embed_data|item
            // QUAN TRỌNG: Tất cả giá trị phải là string và không có khoảng trắng thừa
            $dataString = implode('|', [
                (string) $appId,
                (string) $appTransId,
                (string) $appUser,
                (string) $amount,
                (string) $appTime,
                (string) $embedData,
                (string) $item
            ]);
            
            // Ký MAC bằng HMAC-SHA256 với key1
            $mac = hash_hmac('sha256', $dataString, $key1);
            
            // Gọi API ZaloPay với format đúng
            // QUAN TRỌNG: Tất cả giá trị phải là string
            $requestData = [
                'app_id' => (string) $appId,
                'app_user' => (string) $appUser,
                'app_time' => (string) $appTime,
                'amount' => (string) $amount,
                'app_trans_id' => (string) $appTransId,
                'embed_data' => (string) $embedData,
                'item' => (string) $item,
                'description' => 'Consultation fee payment',
                'bank_code' => 'zalopayapp',
                'callback_url' => (string) $callbackUrl,
                'mac' => (string) $mac
            ];
            
            Log::info('ZaloPay Request Details', [
                'endpoint' => $endpoint,
                'app_id' => $appId,
                'app_trans_id' => $appTransId,
                'app_user' => $appUser,
                'amount' => $amount,
                'app_time' => $appTime,
                'embed_data' => $embedData,
                'item' => $item,
                'data_string_for_mac' => $dataString,
                'calculated_mac' => $mac,
                'callback_url' => $callbackUrl
            ]);
            
            // Gửi request với Content-Type: application/x-www-form-urlencoded
            $response = Http::asForm()->post($endpoint, $requestData);
            
            $result = null;
            $return_code = null;
            $return_message = 'Không có response từ ZaloPay';
            
            if ($response->successful()) {
                $result = $response->json();
                $return_code = $result['return_code'] ?? null;
                $return_message = $result['return_message'] ?? 'Không có thông báo lỗi';
                
                Log::info('ZaloPay Response', [
                    'response' => $result,
                    'return_code' => $return_code,
                    'return_message' => $return_message,
                    'sub_return_code' => $result['sub_return_code'] ?? null,
                    'sub_return_message' => $result['sub_return_message'] ?? null
                ]);
            } else {
                Log::error('ZaloPay HTTP Error', [
                    'status' => $response->status(),
                    'body' => $response->body(),
                    'headers' => $response->headers()
                ]);
                
                return response()->json([
                    'success' => false,
                    'message' => 'Lỗi kết nối đến ZaloPay API: HTTP ' . $response->status(),
                    'error' => [
                        'status' => $response->status(),
                        'body' => $response->body()
                    ]
                ], 500);
            }
            
            // Cập nhật response từ ZaloPay vào database
            $thanhToan->update([
                'du_lieu_phan_hoi' => json_encode($result, JSON_UNESCAPED_UNICODE)
            ]);
            
            if ($return_code !== 1) {
                // Cập nhật trạng thái thất bại
                $thanhToan->update([
                    'trang_thai' => 'KhoiTao',
                    'ly_do_that_bai' => $return_message ?: 'Giao dịch thất bại từ ZaloPay'
                ]);
                
                Log::error('ZaloPay API Error', [
                    'return_code' => $return_code,
                    'return_message' => $return_message,
                    'sub_return_code' => $result['sub_return_code'] ?? null,
                    'sub_return_message' => $result['sub_return_message'] ?? null,
                    'full_response' => $result,
                    'orderId' => $orderId,
                    'app_trans_id' => $appTransId,
                    'id_thanhtoan' => $thanhToan->id_thanhtoan,
                    'request_data' => $requestData
                ]);
                
                return response()->json([
                    'success' => false,
                    'message' => $return_message ?: 'Giao dịch thất bại',
                    'error' => $result,
                    'debug' => [
                        'return_code' => $return_code,
                        'return_message' => $return_message,
                        'sub_return_code' => $result['sub_return_code'] ?? null,
                        'sub_return_message' => $result['sub_return_message'] ?? null
                    ]
                ], 500);
            }
            
            // Lấy order_url từ ZaloPay
            $orderUrl = $result['order_url'] ?? null;
            
            if (!$orderUrl) {
                $thanhToan->update([
                    'trang_thai' => 'KhoiTao',
                    'ly_do_that_bai' => 'Không nhận được order_url từ ZaloPay'
                ]);
                
                return response()->json([
                    'success' => false,
                    'message' => 'Không nhận được order_url từ ZaloPay'
                ], 500);
            }
            
            // Tính thời gian hết hạn (15 phút)
            $expiryAt = now()->addMinutes(15);
            
            // Cập nhật thông tin QR và trạng thái vào database
            // Lấy enum values từ database để đảm bảo giá trị đúng
            $enumValues = DB::select("SHOW COLUMNS FROM thanhtoan WHERE Field = 'trang_thai'");
            $enumStr = $enumValues[0]->Type ?? '';
            
            // Parse enum values từ string như: enum('KhoiTao','Cho Thanh Toan','DaThanh Toan',...)
            preg_match("/enum\((.*)\)/", $enumStr, $matches);
            $validStatuses = [];
            if (!empty($matches[1])) {
                $validStatuses = array_map(function($val) {
                    return trim($val, "'\"");
                }, explode(',', $matches[1]));
            }
            
            // Sử dụng giá trị enum hợp lệ (thử 'Cho Thanh Toan' hoặc 'ChoThanhToan')
            $statusToUse = 'KhoiTao'; // Default
            if (in_array('Cho Thanh Toan', $validStatuses)) {
                $statusToUse = 'Cho Thanh Toan';
            } elseif (in_array('ChoThanhToan', $validStatuses)) {
                $statusToUse = 'ChoThanhToan';
            } elseif (!empty($validStatuses)) {
                // Sử dụng giá trị đầu tiên khác 'KhoiTao' nếu có
                foreach ($validStatuses as $status) {
                    if ($status !== 'KhoiTao') {
                        $statusToUse = $status;
                        break;
                    }
                }
            }
            
            // Cập nhật thông tin
            $thanhToan->update([
                'trang_thai' => $statusToUse,
                'duong_dan_qr' => $orderUrl,
                'duong_dan_thanh_toan' => $orderUrl,
                'noi_dung' => 'Thanh toán phí tư vấn tuyển sinh'
            ]);
            
            Log::info('ZaloPay QR Created Successfully', [
                'id_thanhtoan' => $thanhToan->id_thanhtoan,
                'ma_phieu' => $orderId,
                'order_url' => $orderUrl,
                'amount' => $amount
            ]);
            
            // Trả về response với QR code data
            return response()->json([
                'success' => true,
                'message' => 'Tạo QR code thành công',
                'data' => [
                    'orderId' => $orderId,
                    'paymentId' => $thanhToan->id_thanhtoan,
                    'qrCodeUrl' => $orderUrl,
                    'qrCodeData' => $orderUrl, // Frontend sẽ tạo QR từ URL này
                    'expiryAt' => $expiryAt->toISOString(),
                    'amount' => $amount,
                    'isZaloPayQR' => true,
                    'zalopayAppTransId' => $appTransId
                ]
            ]);
            
        } catch (\Illuminate\Validation\ValidationException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Dữ liệu không hợp lệ',
                'errors' => $e->errors()
            ], 422);
        } catch (\Exception $e) {
            Log::error('Generate ZaloPay QR Error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'success' => false,
                'message' => 'Có lỗi xảy ra khi tạo QR code: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Kiểm tra trạng thái thanh toán
     * GET /api/payments/status/:orderId
     */
    public function checkPaymentStatus(string $orderId): JsonResponse
    {
        try {
            // Query từ database theo ma_phieu (orderId)
            $thanhToan = ThanhToan::where('ma_phieu', $orderId)->first();
            
            if (!$thanhToan) {
                return response()->json([
                    'success' => false,
                    'message' => 'Không tìm thấy giao dịch với orderId: ' . $orderId
                ], 404);
            }
            
            // Map trạng thái từ database sang frontend
            $statusMap = [
                'KhoiTao' => 'pending',
                'ChoThanhToan' => 'pending',
                'Cho Thanh Toan' => 'pending',
                'DaThanhToan' => 'paid',
                'Da Thanh Toan' => 'paid',
                'ThatBai' => 'failed',
                'Thất Bại' => 'failed',
                'Huy' => 'cancelled',
                'Hủy' => 'cancelled'
            ];
            
            $status = $statusMap[$thanhToan->trang_thai] ?? 'pending';
            
            return response()->json([
                'success' => true,
                'data' => [
                    'orderId' => $orderId,
                    'paymentId' => $thanhToan->id_thanhtoan,
                    'status' => $status, // pending | paid | expired | cancelled | failed
                    'paidAt' => $thanhToan->thoi_gian_thanh_toan ? $thanhToan->thoi_gian_thanh_toan->toISOString() : null,
                    'paymentMethod' => 'zalopay',
                    'trang_thai' => $thanhToan->trang_thai
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Check Payment Status Error', [
                'error' => $e->getMessage(),
                'orderId' => $orderId
            ]);
            
            return response()->json([
                'success' => false,
                'message' => 'Có lỗi xảy ra khi kiểm tra trạng thái: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Callback từ ZaloPay
     * POST /api/payments/zalopay/callback
     */
    public function zalopayCallback(Request $request): JsonResponse
    {
        try {
            $key2 = env('ZALOPAY_KEY2');
            
            if (!$key2) {
                return response()->json([
                    'return_code' => -1,
                    'return_message' => 'ZaloPay KEY2 chưa được cấu hình'
                ]);
            }
            
            // Lấy data và mac từ request
            $dataStr = $request->input('data'); // String JSON, KHÔNG parse trước
            $receivedMac = $request->input('mac');
            $type = $request->integer('type', 0);
            
            // Verify MAC bằng key2
            $calculatedMac = hash_hmac('sha256', $dataStr, $key2);
            
            if ($receivedMac !== $calculatedMac) {
                Log::warning('ZaloPay Callback MAC Mismatch', [
                    'received' => $receivedMac,
                    'calculated' => $calculatedMac
                ]);
                
                return response()->json([
                    'return_code' => -1,
                    'return_message' => 'mac not equal'
                ]);
            }
            
            // Parse JSON sau khi verify MAC
            $paymentData = json_decode($dataStr, true);
            
            if (!$paymentData) {
                return response()->json([
                    'return_code' => -1,
                    'return_message' => 'Invalid data format'
                ]);
            }
            
            $appTransId = $paymentData['app_trans_id'] ?? null;
            $amount = $paymentData['amount'] ?? 0;
            $transactionId = $paymentData['zp_trans_id'] ?? null;
            
            if (!$appTransId) {
                Log::warning('ZaloPay Callback missing app_trans_id', [
                    'payment_data' => $paymentData
                ]);
                
                return response()->json([
                    'return_code' => -1,
                    'return_message' => 'Missing app_trans_id'
                ]);
            }
            
            // Tìm thanh toán theo ma_giao_dich_app (app_trans_id)
            $thanhToan = ThanhToan::where('ma_giao_dich_app', $appTransId)->first();
            
            if (!$thanhToan) {
                Log::warning('ZaloPay Callback: Payment not found', [
                    'app_trans_id' => $appTransId,
                    'payment_data' => $paymentData
                ]);
                
                return response()->json([
                    'return_code' => -1,
                    'return_message' => 'Payment not found'
                ]);
            }
            
            // Cập nhật response vào database
            $thanhToan->update([
                'du_lieu_phan_hoi' => $dataStr
            ]);
            
            // Kiểm tra type: 1 = thanh toán thành công
            if ($type === 1) {
                // Lấy enum values để tìm giá trị 'DaThanhToan' hoặc 'Da Thanh Toan'
                $enumValues = DB::select("SHOW COLUMNS FROM thanhtoan WHERE Field = 'trang_thai'");
                $enumStr = $enumValues[0]->Type ?? '';
                preg_match("/enum\((.*)\)/", $enumStr, $matches);
                $validStatuses = [];
                if (!empty($matches[1])) {
                    $validStatuses = array_map(function($val) {
                        return trim($val, "'\"");
                    }, explode(',', $matches[1]));
                }
                
                // Tìm giá trị enum cho "Đã thanh toán"
                $paidStatus = 'KhoiTao';
                if (in_array('DaThanhToan', $validStatuses)) {
                    $paidStatus = 'DaThanhToan';
                } elseif (in_array('Da Thanh Toan', $validStatuses)) {
                    $paidStatus = 'Da Thanh Toan';
                } else {
                    // Tìm giá trị có chứa "Thanh" hoặc "Da"
                    foreach ($validStatuses as $status) {
                        if (stripos($status, 'da') !== false || stripos($status, 'thanh') !== false) {
                            $paidStatus = $status;
                            break;
                        }
                    }
                }
                
                // Cập nhật trạng thái thanh toán thành công
                $thanhToan->update([
                    'trang_thai' => $paidStatus,
                    'ma_giao_dich_zp' => $transactionId,
                    'thoi_gian_thanh_toan' => now()
                ]);
                
                Log::info('ZaloPay Payment Success - Updated Database', [
                    'id_thanhtoan' => $thanhToan->id_thanhtoan,
                    'app_trans_id' => $appTransId,
                    'amount' => $amount,
                    'transaction_id' => $transactionId,
                    'trang_thai' => $paidStatus
                ]);
                
                // TODO: Có thể trigger event để tự động đặt lịch tư vấn ở đây
            } else {
                // Type khác 1: thanh toán thất bại hoặc pending
                Log::info('ZaloPay Payment Not Success', [
                    'id_thanhtoan' => $thanhToan->id_thanhtoan,
                    'type' => $type,
                    'app_trans_id' => $appTransId
                ]);
            }
            
            return response()->json([
                'return_code' => 1,
                'return_message' => 'OK'
            ]);
            
        } catch (\Exception $e) {
            Log::error('ZaloPay Callback Error', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);
            
            return response()->json([
                'return_code' => -1,
                'return_message' => 'Server error: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Lịch sử thanh toán rút gọn cho người dùng
     * GET /api/payments/history?userId=...
     */
    public function history(Request $request): JsonResponse
    {
        try {
            $userId = (int) $request->input('userId');
            $sessionUserId = (int) (session('user_id') ?? 0);

            $query = ThanhToan::query()->orderByDesc('thoi_gian_tao');
            if ($userId) {
                $query->where('id_nguoidung', $userId);
            } elseif ($sessionUserId) {
                $query->where('id_nguoidung', $sessionUserId);
            }

            $rows = $query->limit(50)->get();

            $mapStatus = function ($dbStatus) {
                return match ($dbStatus) {
                    'DaThanhToan', 'Da Thanh Toan' => 'Đã thanh toán',
                    'ThatBai', 'Thất Bại' => 'Thất bại',
                    'Huy', 'Hủy' => 'Đã hủy',
                    default => 'Chờ thanh toán',
                };
            };

            $data = $rows->map(function ($r) use ($mapStatus) {
                $code = $r->ma_giao_dich_zp ?: $r->ma_giao_dich_app ?: $r->ma_phieu;
                return [
                    'ma_giao_dich' => $code,
                    'ngay_thanh_toan' => optional($r->thoi_gian_thanh_toan)->format('Y-m-d H:i:s'),
                    'so_tien' => (float) $r->so_tien,
                    'phuong_thuc' => $r->phuongthuc,
                    'trang_thai' => $mapStatus($r->trang_thai),
                    'noi_dung' => $r->noi_dung,
                ];
            });

            return response()->json([
                'success' => true,
                'data' => $data,
            ]);
        } catch (\Exception $e) {
            Log::error('Payments history error', ['error' => $e->getMessage()]);
            return response()->json([
                'success' => false,
                'message' => 'Không thể lấy lịch sử thanh toán',
            ], 500);
        }
    }
}

