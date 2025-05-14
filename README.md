# projectofsgn

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


- Requirements
Flutter 3.29.3 • channel stable
Tools • Dart 3.7.2 • DevTools 2.42.3

User Login: admin Password:12345
OTP: 0011

- สถาปัตยกรรมและการออกแบบระบบ
MVC

- ฟีเจอร์ที่พัฒนาและวิธีการทดสอบ
1. สร้างระบบ Authentication ที่รองรับ:
   - Login ด้วย Username/Password
   - การยืนยันตัวตนผ่าน Email (2FA) โดยจำลองการส่ง code ได้
   - การจัดเก็บ Session และกลไก Auto-logout เมื่อไม่มีการใช้งานเกิน 30 นาที
2. พัฒนาฟังก์ชันแจ้งเตือน โดย:
   - แสดงการแจ้งเตือนเมื่อมีการเปลี่ยนแปลงสถานะคำขอ
   - รองรับการกดเพื่อดูรายละเอียดเพิ่มเติม
3. พัฒนาหน้าจอติดตามสถานะที่:
   - แสดงขั้นตอนการพิจารณาทั้งหมดพร้อมสถานะปัจจุบัน
   - มีการแสดงเวลาในแต่ละขั้นตอน
4. สร้างฟังก์ชันการแสดงใบอนุญาตทำงานดิจิทัล โดย:
   - จำลองการแสดงใบอนุญาตทำงานดิจิทัล (Digital Work Permit)
   - รองรับการบันทึกเป็นไฟล์ PDF

- ข้อจำกัดและแนวทางการพัฒนาในอนาคต
ไม่มีระบบ backend สำหรับดึง/บันทึกข้อมูล
    แนวทางการพัฒนาในอนาคต
เชื่อมต่อกับ API/Database เพื่อดึงเวลาแบบ dynamic
เพิ่ม unit test และ widget test เพื่อความถูกต้องของระบบ
