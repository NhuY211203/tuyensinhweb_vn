<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Log;

class DebugPaymentController extends Controller
{
    /**
     * Kiểm tra cấu hình ZaloPay
     * GET /api/debug/zalopay-config
     */
    public function checkZaloPayConfig(): JsonResponse
    {
        $appId = env('ZALOPAY_APP_ID');
        $key1 = env('ZALOPAY_KEY1');
        $key2 = env('ZALOPAY_KEY2');
        $endpoint = env('ZALOPAY_ENDPOINT');
        $callbackUrl = env('ZALOPAY_CALLBACK_URL');
        
        $config = [
            'ZALOPAY_APP_ID' => [
                'configured' => !empty($appId),
                'value' => $appId ? substr($appId, 0, 4) . '***' : 'NOT SET',
                'status' => !empty($appId) ? '✅' : '❌'
            ],
            'ZALOPAY_KEY1' => [
                'configured' => !empty($key1),
                'value' => $key1 ? substr($key1, 0, 10) . '***' : 'NOT SET',
                'status' => !empty($key1) ? '✅' : '❌'
            ],
            'ZALOPAY_KEY2' => [
                'configured' => !empty($key2),
                'value' => $key2 ? substr($key2, 0, 10) . '***' : 'NOT SET',
                'status' => !empty($key2) ? '✅' : '❌'
            ],
            'ZALOPAY_ENDPOINT' => [
                'configured' => !empty($endpoint),
                'value' => $endpoint ?: 'NOT SET',
                'status' => !empty($endpoint) ? '✅' : '❌'
            ],
            'ZALOPAY_CALLBACK_URL' => [
                'configured' => !empty($callbackUrl),
                'value' => $callbackUrl ?: 'NOT SET',
                'status' => !empty($callbackUrl) ? '✅' : '❌'
            ]
        ];
        
        $allConfigured = $appId && $key1 && $key2 && $endpoint && $callbackUrl;
        
        return response()->json([
            'success' => true,
            'message' => $allConfigured ? 'ZaloPay configuration is complete' : 'ZaloPay configuration is incomplete',
            'all_configured' => $allConfigured,
            'config' => $config,
            'next_steps' => $allConfigured ? [
                'ZaloPay is ready to use',
                'Test payment by clicking "Thanh toán" button'
            ] : [
                'Add missing environment variables to .env file',
                'Run: php artisan config:cache',
                'Run: php artisan config:clear'
            ]
        ]);
    }
    
    /**
     * Kiểm tra kết nối đến ZaloPay API
     * GET /api/debug/zalopay-connection
     */
    public function checkZaloPayConnection(): JsonResponse
    {
        try {
            $appId = env('ZALOPAY_APP_ID');
            $key1 = env('ZALOPAY_KEY1');
            $endpoint = env('ZALOPAY_ENDPOINT', 'https://sb-openapi.zalopay.vn/v2/create');
            
            if (!$appId || !$key1) {
                return response()->json([
                    'success' => false,
                    'message' => 'ZaloPay not configured',
                    'error' => 'Missing ZALOPAY_APP_ID or ZALOPAY_KEY1'
                ], 500);
            }
            
            // Test data
            $appTransId = date('ymd') . '_' . str_pad(rand(0, 999999), 6, '0', STR_PAD_LEFT);
            $appTime = round(microtime(true) * 1000);
            $amount = 1000; // 1000 VND
            $appUser = 'test_user';
            $embedData = json_encode(['test' => true]);
            $item = json_encode([['item_name' => 'Test', 'item_quantity' => 1, 'item_price' => 1000]]);
            
            $dataString = implode('|', [
                (string) $appId,
                (string) $appTransId,
                (string) $appUser,
                (string) $amount,
                (string) $appTime,
                (string) $embedData,
                (string) $item
            ]);
            
            $mac = hash_hmac('sha256', $dataString, $key1);
            
            Log::info('Testing ZaloPay Connection', [
                'endpoint' => $endpoint,
                'app_id' => $appId,
                'app_trans_id' => $appTransId
            ]);
            
            return response()->json([
                'success' => true,
                'message' => 'ZaloPay connection test data prepared',
                'test_data' => [
                    'endpoint' => $endpoint,
                    'app_id' => $appId,
                    'app_trans_id' => $appTransId,
                    'app_time' => $appTime,
                    'amount' => $amount,
                    'mac_calculated' => $mac
                ],
                'instructions' => [
                    'Use this data to test ZaloPay API connection',
                    'Check storage/logs/laravel.log for detailed logs'
                ]
            ]);
            
        } catch (\Exception $e) {
            Log::error('ZaloPay Connection Test Error', [
                'error' => $e->getMessage()
            ]);
            
            return response()->json([
                'success' => false,
                'message' => 'Error testing ZaloPay connection',
                'error' => $e->getMessage()
            ], 500);
        }
    }
    
    /**
     * Xem logs thanh toán gần đây
     * GET /api/debug/payment-logs?limit=50
     */
    public function getPaymentLogs(): JsonResponse
    {
        try {
            $logFile = storage_path('logs/laravel.log');
            
            if (!file_exists($logFile)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Log file not found'
                ], 404);
            }
            
            $limit = request()->integer('limit', 50);
            $lines = file($logFile);
            $lines = array_reverse($lines);
            $lines = array_slice($lines, 0, $limit);
            
            // Filter payment-related logs
            $paymentLogs = array_filter($lines, function($line) {
                return stripos($line, 'zalopay') !== false || 
                       stripos($line, 'payment') !== false ||
                       stripos($line, 'thanhtoan') !== false;
            });
            
            return response()->json([
                'success' => true,
                'message' => 'Payment logs retrieved',
                'total_lines' => count($lines),
                'payment_logs_count' => count($paymentLogs),
                'logs' => array_values($paymentLogs)
            ]);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error reading logs',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}

