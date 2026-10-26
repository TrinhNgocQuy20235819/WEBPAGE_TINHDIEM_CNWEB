# HỆ THỐNG TÍNH ĐIỂM BÀI TẬP LỚN (BTL) - CÔNG NGHỆ WEB

Ứng dụng Web tính điểm BTL xây dựng bằng **React**, sử dụng cơ chế **`setState`** để quản lý trạng thái và tự động **re-render** bảng điểm khi người dùng nhập liệu, tuân thủ 100% yêu cầu đề bài.

---

## 📌 1. Cấu Trúc Bảng Giao Diện

Bảng tính điểm gồm 7 cột chính xác theo mô tả đề bài:

| # nhóm | MSSV | Họ tên | Điểm nhóm | Đóng góp | Điểm cộng | Điểm BTL |
|:---:|:---:|:---|:---:|:---:|:---:|:---:|
| **1** | 20122 | Nakaji | ______/20 | ___% | ___ | **[Tính tự động]** |
| (Gộp) | 20133 | Shin | (Gộp theo nhóm) | ___% | ___ | **[Tính tự động]** |
| **2** | 20455 | An | ______/20 | ___% | ___ | **[Tính tự động]** |
| (Gộp) | 20311 | Bảo | (Gộp theo nhóm) | ___% | ___ | **[Tính tự động]** |

- Cột **# nhóm** và **Điểm nhóm** được gộp dòng (`rowSpan`) theo từng nhóm.
- Các ô input bắt sự kiện `onChange` để cập nhật trạng thái qua `setState`.

---

## 🧮 2. Công Thức Tính Điểm Chi Tiết

1. **Quy đổi điểm nhóm sang hệ 10**:
   $$S_{10} = \frac{\text{Điểm nhóm}}{20} \times 10 = \frac{\text{Điểm nhóm}}{2}$$
   *(Điểm nhóm tối đa 20, có thể lẻ đến 0.5).*

2. **Tính điểm trung bình đóng góp của nhóm**:
   $$x = \frac{100\%}{N}$$
   *(với $N$ là tổng số thành viên trong nhóm).*

3. **Phân loại thành viên theo mức đóng góp $y$**:
   - Nếu $y > x$: Xếp vào **Nhóm được cộng điểm**.
   - Nếu $y < x$: Xếp vào **Nhóm bị trừ điểm**.
   - Nếu $y = x$: Không cộng, không trừ.

4. **Tính điểm trừ $z$ của từng bạn bị trừ**:
   $$z = |y - x| \times \frac{10}{x}$$
   Tổng điểm trừ của cả nhóm:
   $$Z = \sum z_i \quad (\text{với tất cả các bạn có } y_i < x)$$

5. **Tính điểm cộng $T$ cho các bạn được cộng**:
   $$T = \frac{Z}{M}$$
   *(với $M$ là số lượng các bạn trong nhóm được cộng điểm).*

6. **Tính Điểm BTL cuối cùng**:
   - Bạn được cộng: $\text{Điểm BTL} = S_{10} + T + \text{Điểm cộng}$
   - Bạn bị trừ: $\text{Điểm BTL} = S_{10} - z + \text{Điểm cộng}$
   - Bạn bằng mức TB: $\text{Điểm BTL} = S_{10} + \text{Điểm cộng}$
   - **Quy tắc làm tròn & Chặn trên**: Điểm nào vượt quá 10 sẽ được làm tròn/chặn thành **10.00**.

---

## ⚡ 3. Cơ Chế Quản Lý Trạng Thái (setState) & Xử Lý Sự Kiện

Theo yêu cầu đặc biệt của đề bài:
> *"Nếu người dùng điền sai giá trị thì điểm không bị cập nhật.*  
> *Nếu tổng đóng góp là 100% rồi, nhóm trưởng sửa bạn A, làm tổng không đạt 100% thì giao diện điểm chưa cập nhật. Khi nhóm trưởng sửa cho thêm 1 bạn nữa, tổng đạt 100% thì giao diện điểm cập nhật lại."*

### Cách thức hoạt động trong mã nguồn:
- **`groups`**: Quản lý mảng dữ liệu input hiện tại của các nhóm (người dùng nhập số nào thì hiển thị số đó).
- **`savedScores`**: Chỉ lưu kết quả tính điểm của các nhóm **hợp lệ** (có tổng đóng góp $\sum y = 100\%$ và điểm nhóm $\in [0, 20]$).
- Khi người dùng thay đổi giá trị (sự kiện `onChange`):
  1. Component gọi `this.setState` để cập nhật dữ liệu nhập vào `groups`.
  2. Hàm `calculateGroupBTL(group)` được gọi để kiểm tra tính hợp lệ của nhóm.
  3. **Nếu tổng $\ne 100\%$ hoặc nhập sai**: `savedScores` **hoàn toàn giữ nguyên không đổi** $\implies$ Giao diện điểm BTL tiếp tục hiển thị điểm hợp lệ trước đó, đồng thời hiển thị huy hiệu cảnh báo (màu vàng/đỏ) thông báo tổng % hiện tại.
  4. **Khi người dùng sửa bạn tiếp theo làm tổng đạt đúng 100%**: `savedScores` được cập nhật $\implies$ React kích hoạt re-render hiển thị điểm BTL mới ngay lập tức.

---

## 🚀 4. Hướng Dẫn Khởi Chạy

Bạn có thể chạy dự án theo 2 cách cực kỳ đơn giản:

### Cách 1: Chạy trực tiếp (Không cần cài đặt gì thêm)
- Nhấp đúp chuột trực tiếp vào file **`index.html`** để mở trên trình duyệt (Chrome, Edge, Firefox,...).

### Cách 2: Chạy qua Local Web Server
- Nhấp đúp vào file **`start_server.bat`**, hoặc mở terminal chạy:
  ```bash
  python -m http.server 3000 --bind 127.0.0.1
  ```
- Mở trình duyệt truy cập: **`http://127.0.0.1:3000`** (hoặc `http://localhost:3000`)

---

## 🧪 5. Ví Dụ Kiểm Thử Nhanh Trên Giao Diện

1. **Khởi tạo ban đầu**:
   - **Nhóm 1**: Điểm nhóm = 16 ($S_{10} = 8.0$).
     - Nakaji: Đóng góp 50%, Điểm cộng 1 $\implies$ Điểm BTL = **9.00**.
     - Shin: Đóng góp 50%, Điểm cộng 0 $\implies$ Điểm BTL = **8.00**.
2. **Nhóm trưởng sửa Nakaji lên 60%**:
   - Tổng đóng góp thành $60\% + 50\% = 110\% \ne 100\%$.
   - Bảng hiển thị cảnh báo màu vàng: `Tổng hiện tại: 110% (chưa bằng 100%)`.
   - Cột Điểm BTL **vẫn giữ nguyên** 9.00 và 8.00 (có chú thích `Điểm cũ`).
3. **Nhóm trưởng sửa Shin giảm xuống 40%**:
   - Tổng đóng góp thành $60\% + 40\% = 100\%$.
   - $x = 50\%$. Shin bị trừ $z = |40 - 50| \times 10 / 50 = 2.0$.
   - $Z = 2.0$. Nhóm cộng có Nakaji ($M = 1$) $\implies T = 2.0 / 1 = 2.0$.
   - Shin: $8.0 - 2.0 + 0 =$ **6.00**.
   - Nakaji: $8.0 + 2.0 + 1 = 11.0 \implies$ Chặn max thành **10.00**.
   - Điểm BTL được cập nhật lập tức!
