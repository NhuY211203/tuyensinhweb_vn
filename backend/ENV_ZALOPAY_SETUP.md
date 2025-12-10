# Hướng Dẫn Cấu Hình ZaloPay

## 📋 Các bước cấu hình

### 1. Tạo file `.env` trong thư mục `backend/`

Sao chép file `.env.example` (nếu có) hoặc tạo file `.env` mới với nội dung sau:

```env
APP_NAME=TuyenSinhWeb
APP_ENV=production
APP_KEY=base64:your_app_key_here
APP_DEBUG=false
APP_URL=https://hoahoctro.42web.io/laravel

# Database Configuration
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_database
DB_USERNAME=your_username
DB_PASSWORD=your_password

# ZaloPay Configuration
# Lấy từ ZaloPay dashboard: https://business.zalopay.vn
ZALOPAY_APP_ID=2553
ZALOPAY_KEY1=PcY4iZIKFCIDz50pIrXrHD8gJ2WTvMAu9ajQrDJ142SoYvTtQBJ4bIct7p7XH6ix
ZALOPAY_KEY2=trMrHm9yP6yP8O87iC6cq5ESxTEn6m3fIcfP2saGgQG1DQu4GiS9pG8S9thj1xgJ
ZALOPAY_ENDPOINT=https://sb-openapi.zalopay.vn/v2/create
ZALOPAY_CALLBACK_URL=https://hoahoctro.42web.io/laravel/public/api/payments/zalopay/callback

# Mail Configuration
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@example.com
MAIL_FROM_NAME="${APP_NAME}"

# Cache Configuration
CACHE_DRIVER=file

# Session Configuration
SESSION_DRIVER=file
SESSION_LIFETIME=120

# Queue Configuration
QUEUE_CONNECTION=sync
```

### 2. Lấy thông tin từ ZaloPay

1. Đăng nhập vào [ZaloPay Business](https://business.zalopay.vn)
2. Vào **Settings** → **API Keys**
3. Sao chép các giá trị sau:
   - **App ID** → `ZALOPAY_APP_ID`
   - **Key 1** → `ZALOPAY_KEY1`
   - **Key 2** → `ZALOPAY_KEY2`

### 3. Cấu hình Callback URL

1. Trong ZaloPay Dashboard, vào **Settings** → **Webhook**
2. Thêm Callback URL: `https://hoahoctro.42web.io/laravel/public/api/payments/zalopay/callback`
3. Lưu cấu hình

### 4. Kiểm tra cấu hình

Chạy lệnh sau để kiểm tra:

```bash
php artisan config:cache
php artisan config:clear
```

## 🔍 Khắc phục sự cố

### Lỗi: "Dữ liệu yêu cầu không hợp lệ" (sub_return_code: -401)

**Nguyên nhân:**
- Các biến ZaloPay chưa được cấu hình trong `.env`
- Dữ liệu gửi không đúng định dạng (phải là string)
- MAC signature không khớp

**Giải pháp:**
1. ✅ Kiểm tra file `.env` có chứa tất cả biến ZaloPay
2. ✅ Xem logs: `storage/logs/laravel.log`
3. ✅ Đảm bảo `ZALOPAY_CALLBACK_URL` là URL công khai

### Lỗi: "Giao dịch thất bại"

**Kiểm tra:**
1. Xem chi tiết lỗi trong response:
   - `return_code`: Mã lỗi từ ZaloPay
   - `sub_return_code`: Mã lỗi chi tiết
   - `sub_return_message`: Thông báo chi tiết

2. Xem logs trong `storage/logs/laravel.log`

### Lỗi: "Không nhận được order_url"

**Nguyên nhân:**
- ZaloPay API không trả về `order_url`
- Dữ liệu gửi không hợp lệ

**Giải pháp:**
1. Kiểm tra logs để xem response từ ZaloPay
2. Đảm bảo `amount` > 0
3. Kiểm tra `app_trans_id` có đúng format `YYMMDD_xxxxxx`

## 📝 Các trường bắt buộc trong request

```php
[
    'app_id' => string,           // App ID từ ZaloPay
    'app_user' => string,         // User ID
    'app_time' => string,         // Timestamp milliseconds
    'amount' => string,           // Số tiền (VND)
    'app_trans_id' => string,     // Format: YYMMDD_xxxxxx
    'embed_data' => string,       // JSON string
    'item' => string,             // JSON string array
    'description' => string,      // Mô tả giao dịch
    'bank_code' => string,        // 'zalopayapp'
    'callback_url' => string,     // URL callback
    'mac' => string               // HMAC-SHA256 signature
]
```

## 🔐 MAC Signature

MAC được tính từ:
```
data_string = app_id|app_trans_id|app_user|amount|app_time|embed_data|item
mac = HMAC-SHA256(data_string, key1)
```

**Quan trọng:** Tất cả giá trị phải là string và không có khoảng trắng thừa!

## 📊 Kiểm tra trạng thái thanh toán

API: `GET /api/payments/status/{orderId}`

Response:
```json
{
    "success": true,
    "data": {
        "orderId": "ORD_1234567890_123",
        "paymentId": 456,
        "status": "pending|paid|expired|cancelled|failed",
        "paidAt": "2024-01-15T10:30:00Z",
        "paymentMethod": "zalopay"
    }
}
```

## [object Object]ỗ trợ

- ZaloPay Docs: https://docs.zalopay.vn
- ZaloPay Support: https://business.zalopay.vn/support

