@echo off
chcp 65001 >nul
echo ========================================================
echo   KHỞI CHẠY HỆ THỐNG TÍNH ĐIỂM BTL (MÔN CÔNG NGHỆ WEB)
echo ========================================================
echo.
echo Đang mở trình duyệt tại: http://127.0.0.1:3000
echo (Nếu trình duyệt không tự mở, vui lòng truy cập: http://127.0.0.1:3000)
echo.
start http://127.0.0.1:3000
python -m http.server 3000 --bind 127.0.0.1
pause
