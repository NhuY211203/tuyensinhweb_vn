# Tính năng Gợi ý Ngành học và Trường

## Mô tả
Sau khi tính điểm học bạ, hệ thống sẽ tự động gợi ý các ngành học và trường đại học phù hợp với điểm số của bạn dựa trên điểm chuẩn của các năm trước.

## Tính năng chính

### 1. Tự động gợi ý
- Sau khi nhấn "Xem kết quả", hệ thống tự động tìm kiếm các ngành học phù hợp
- Dựa trên điểm xét tuyển và tổ hợp môn đã chọn
- So sánh với điểm chuẩn của các trường trong 1-2 năm gần nhất

### 2. Phân loại theo mức độ phù hợp
Các gợi ý được chia thành 4 nhóm:

#### **An toàn** (màu xanh lá)
- Điểm của bạn cao hơn điểm chuẩn từ 3 điểm trở lên
- Khả năng đỗ rất cao
- Nên ưu tiên các ngành này

#### **Rất phù hợp** (màu xanh dương)
- Điểm của bạn cao hơn điểm chuẩn từ 1.5 đến 3 điểm
- Khả năng đỗ cao
- Lựa chọn tốt cho nguyện vọng chính

#### **Phù hợp** (màu vàng)
- Điểm của bạn cao hơn điểm chuẩn từ 0.5 đến 1.5 điểm
- Có cơ hội đỗ
- Nên cân nhắc kỹ trước khi chọn

#### **Cần cân nhắc** (màu cam)
- Điểm của bạn chỉ cao hơn điểm chuẩn dưới 0.5 điểm
- Rủi ro cao
- Chỉ nên chọn nếu rất yêu thích ngành

### 3. Thông tin hiển thị
Mỗi gợi ý bao gồm:
- **Tên ngành học**: Tên đầy đủ của ngành
- **Tên trường**: Trường đại học tuyển sinh
- **Điểm chuẩn**: Điểm chuẩn năm gần nhất
- **Năm xét tuyển**: Năm của điểm chuẩn
- **Khoảng cách điểm**: Điểm của bạn cao hơn điểm chuẩn bao nhiêu
- **Mức lương**: Mức lương trung bình của ngành (nếu có)
- **Tổ hợp môn**: Các tổ hợp môn được chấp nhận

## Cách sử dụng

### Bước 1: Tính điểm học bạ
1. Chọn phương thức xét học bạ
2. Chọn đối tượng và khu vực ưu tiên (nếu có)
3. Nhập điểm các môn học
4. Chọn môn nhân hệ số 2 (nếu có)
5. Nhấn "Xem kết quả"

### Bước 2: Xem gợi ý
- Sau khi tính điểm xong, hệ thống tự động hiển thị gợi ý
- Cuộn xuống để xem danh sách các ngành học phù hợp
- Các ngành được sắp xếp theo mức độ phù hợp

### Bước 3: Lựa chọn ngành
- Xem kỹ thông tin từng ngành
- Ưu tiên các ngành ở nhóm "An toàn" và "Rất phù hợp"
- Cân nhắc mức lương và xu hướng nghề nghiệp
- Kiểm tra tổ hợp môn có phù hợp không

## Lưu ý quan trọng

### 1. Điểm chuẩn tham khảo
- Điểm chuẩn hiển thị là của các năm trước
- Điểm chuẩn có thể thay đổi mỗi năm
- Nên cộng thêm 0.5-1 điểm để an toàn

### 2. Tổ hợp môn
- Kiểm tra kỹ tổ hợp môn của từng ngành
- Một số ngành có thể yêu cầu môn cụ thể
- Đảm bảo bạn đã thi đủ các môn trong tổ hợp

### 3. Điều kiện bổ sung
- Một số ngành có thể có điều kiện bổ sung:
  - Chứng chỉ ngoại ngữ (IELTS, TOEFL...)
  - Chứng chỉ tin học
  - Phỏng vấn
  - Kiểm tra sức khỏe
- Liên hệ trường để biết chi tiết

### 4. Số lượng gợi ý
- Hệ thống hiển thị tối đa 50 gợi ý
- Ưu tiên các ngành có điểm chuẩn cao hơn
- Nếu không có gợi ý, thử với tổ hợp môn khác

## API Backend

### Endpoint
```
POST /api/tinh-diem-hoc-ba/goi-y-nganh-truong
```

### Request Body
```json
{
  "diem_xet_tuyen": 25.5,
  "to_hop_mon": "A00",
  "limit": 50
}
```

### Response
```json
{
  "success": true,
  "message": "Gợi ý ngành học và trường thành công",
  "data": {
    "tong_so_goi_y": 45,
    "diem_xet_tuyen": 25.5,
    "to_hop_mon": "A00",
    "goi_y_theo_muc_do": {
      "an_toan": [...],
      "rat_phu_hop": [...],
      "phu_hop": [...],
      "can_can_nhac": [...]
    },
    "tat_ca_goi_y": [...]
  }
}
```

## Cải tiến trong tương lai

### 1. Lọc nâng cao
- Lọc theo khu vực (Hà Nội, TP.HCM, Đà Nẵng...)
- Lọc theo loại trường (công lập, tư thục)
- Lọc theo học phí
- Lọc theo nhóm ngành

### 2. So sánh ngành
- So sánh nhiều ngành cùng lúc
- Xem chi tiết chương trình đào tạo
- Xem tỷ lệ việc làm sau tốt nghiệp

### 3. Lưu danh sách yêu thích
- Lưu các ngành quan tâm
- Theo dõi thay đổi điểm chuẩn
- Nhận thông báo khi có cập nhật

### 4. Tư vấn AI
- Gợi ý dựa trên sở thích và năng lực
- Phân tích xu hướng nghề nghiệp
- Dự đoán điểm chuẩn năm tới

## Hỗ trợ
Nếu có thắc mắc hoặc cần hỗ trợ, vui lòng:
- Liên hệ tư vấn viên qua tính năng Chat
- Đặt lịch tư vấn trực tiếp
- Gọi hotline: 1900-xxxx

---

**Chúc bạn tìm được ngành học phù hợp và đạt kết quả cao trong kỳ thi!** 🎓
