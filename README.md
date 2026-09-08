# Hệ thống Quản lý Bệnh viện MediCare (Microservices Architecture)

Dự án thực hành môn **IT214: Microservice in Action**  
**Session 04 — Bài 1: Phân tích chia module Service và thiết kế Database cho hệ thống Quản lý Bệnh viện**  
Cấp độ: Vận dụng cơ bản | Tổng hợp kiến thức Session 02 & 03

---

## 1. Danh sách Microservices & Cơ sở Dữ liệu Độc lập

| STT | Microservice | Port | Database MySQL | Chức năng chính |
|:---:|---|:---:|---|---|
| 1 | `patient-service` | **8081** | `medicare_patient_db` | Quản lý thông tin cá nhân, liên lạc và thẻ BHYT của bệnh nhân. |
| 2 | `doctor-service` | **8082** | `medicare_doctor_db` | Quản lý thông tin bác sĩ, khoa phòng, ca trực và lịch làm việc. |
| 3 | `appointment-service` | **8083** | `medicare_appointment_db` | Quản lý vòng đời lịch đặt khám (PENDING, CONFIRMED, COMPLETED, CANCELLED). |
| 4 | `medical-record-service` | **8084** | `medicare_medical_record_db` | Quản lý hồ sơ bệnh án, chỉ số sinh tồn, chẩn đoán và đơn thuốc. |
| 5 | `pharmacy-service` | **8085** | `medicare_pharmacy_db` | Quản lý danh mục thuốc, tồn kho theo lô, hạn dùng và phiếu xuất kho dược. |

---

## 2. Cấu trúc Thư mục Dự án

```
IT214/Session 04/Bai 1/
├── build.gradle                                            # Root Multi-project Gradle build
├── settings.gradle                                         # Khai báo 5 submodules
├── gradlew, gradlew.bat, gradle/                           # Gradle Wrapper 8.14.3
├── .gitignore
├── push_github.bat, push_github.ps1                        # Script tự động push code lên GitHub
├── README.md                                               # Hướng dẫn tổng quan
├── BAO_CAO_BAI_1.md                                        # Báo cáo chuyên sâu theo 4 yêu cầu đề bài
├── docs/                                                   # Thư mục chứa sơ đồ & tài liệu
│   ├── architecture-diagram.md                             # Sơ đồ kiến trúc tổng thể Mermaid
│   ├── erd-diagrams.md                                     # Chi tiết ERD từng service và sơ đồ toàn cảnh
│   ├── init_all_databases.sql                              # SQL DDL tổng hợp khởi tạo 5 DBs
│   ├── medicare_patient_db.sql                             # SQL DDL DB Patient
│   ├── medicare_doctor_db.sql                              # SQL DDL DB Doctor
│   ├── medicare_appointment_db.sql                         # SQL DDL DB Appointment
│   ├── medicare_medical_record_db.sql                      # SQL DDL DB Medical Record
│   └── medicare_pharmacy_db.sql                            # SQL DDL DB Pharmacy
├── patient-service/                                        # Submodule 1 (Port 8081)
├── doctor-service/                                         # Submodule 2 (Port 8082)
├── appointment-service/                                    # Submodule 3 (Port 8083)
├── medical-record-service/                                 # Submodule 4 (Port 8084)
└── pharmacy-service/                                       # Submodule 5 (Port 8085)
```

---

## 3. Hướng dẫn Chạy & Kiểm thử Dự án

### A. Kiểm thử toàn bộ 5 Microservices (25/25 tasks pass 100%):
```bash
./gradlew test
# Hoặc trên Windows:
.\gradlew.bat test
```

### B. Khởi tạo Cơ sở Dữ liệu MySQL (khi chạy với MySQL Server):
Chạy file script tổng hợp tại: [`docs/init_all_databases.sql`](docs/init_all_databases.sql)
```bash
mysql -u root -p < docs/init_all_databases.sql
```

### C. Khởi chạy từng Microservice độc lập:
```bash
# Khởi chạy Patient Service (Port 8081):
.\gradlew.bat :patient-service:bootRun

# Khởi chạy Doctor Service (Port 8082):
.\gradlew.bat :doctor-service:bootRun

# Khởi chạy Appointment Service (Port 8083):
.\gradlew.bat :appointment-service:bootRun

# Khởi chạy Medical Record Service (Port 8084):
.\gradlew.bat :medical-record-service:bootRun

# Khởi chạy Pharmacy Service (Port 8085):
.\gradlew.bat :pharmacy-service:bootRun
```

---

## 4. Hướng dẫn Nộp bài lên GitHub

Chạy trực tiếp file script:
- Trên CMD: `push_github.bat`
- Trên PowerShell: `.\push_github.ps1`

Nhập link GitHub repository của bạn (ví dụ: `https://github.com/Boizi-06/PTIT-HN-CNTT3-HOANGTHIENSON-IT214-SS04-01.git`), script sẽ tự động thực hiện quy trình `git init`, `add`, `commit` và `push` lên nhánh `main`.
