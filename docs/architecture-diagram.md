# SƠ ĐỒ KIẾN TRÚC TỔNG THỂ HỆ THỐNG QUẢN LÝ BỆNH VIỆN MEDICARE

## 1. Sơ đồ Kiến trúc Microservices (Database-per-Service)

```mermaid
flowchart TB
    subgraph Clients["TẦNG NGƯỜI DÙNG & THIẾT BỊ"]
        WebPortal["Web Portal Bệnh Viện<br/>(Bệnh nhân & Bác sĩ)"]
        MobileApp["Medicare Mobile App<br/>(iOS & Android)"]
        AdminPortal["Phần Mềm Quản Trị<br/>(Hành chính & Kho Dược)"]
    end

    subgraph GatewayLayer["TẦNG ĐIỀU PHỐI (API GATEWAY)"]
        APIGateway["API Gateway / Reverse Proxy<br/>(Port 8080)<br/>- Routing & Load Balancing<br/>- Authentication / JWT<br/>- Rate Limiting & SSL"]
    end

    subgraph ServiceLayer["TẦNG DỊCH VỤ MICROSERVICES"]
        direction TB
        
        subgraph S1["Patient Service"]
            PS["Patient Service<br/>Port: 8081<br/>(Spring Boot 3)"]
        end

        subgraph S2["Doctor Service"]
            DS["Doctor Service<br/>Port: 8082<br/>(Spring Boot 3)"]
        end

        subgraph S3["Appointment Service"]
            AS["Appointment Service<br/>Port: 8083<br/>(Spring Boot 3)"]
        end

        subgraph S4["Medical Record Service"]
            MRS["Medical Record Service<br/>Port: 8084<br/>(Spring Boot 3)"]
        end

        subgraph S5["Pharmacy Service"]
            PHS["Pharmacy Service<br/>Port: 8085<br/>(Spring Boot 3)"]
        end
    end

    subgraph DatabaseLayer["TẦNG DỮ LIỆU ĐỘC LẬP (DATABASE-PER-SERVICE)"]
        DB1[("medicare_patient_db<br/>(MySQL Port 3306)")]
        DB2[("medicare_doctor_db<br/>(MySQL Port 3306)")]
        DB3[("medicare_appointment_db<br/>(MySQL Port 3306)")]
        DB4[("medicare_medical_record_db<br/>(MySQL Port 3306)")]
        DB5[("medicare_pharmacy_db<br/>(MySQL Port 3306)")]
    end

    %% Client to Gateway
    WebPortal --> APIGateway
    MobileApp --> APIGateway
    AdminPortal --> APIGateway

    %% Gateway to Services
    APIGateway -->|/api/patients/**| PS
    APIGateway -->|/api/doctors/**| DS
    APIGateway -->|/api/appointments/**| AS
    APIGateway -->|/api/medical-records/**| MRS
    APIGateway -->|/api/pharmacy/**| PHS

    %% Service to Dedicated Database
    PS === DB1
    DS === DB2
    AS === DB3
    MRS === DB4
    PHS === DB5

    %% Cross-Service Logical Communications (REST / gRPC / Events)
    AS -.->|"1. Tra cứu thông tin bệnh nhân (patientId)"| PS
    AS -.->|"2. Kiểm tra lịch làm việc bác sĩ (doctorId)"| DS
    MRS -.->|"3. Tham chiếu lịch khám (appointmentId)"| AS
    MRS -.->|"4. Tra cứu danh mục thuốc kê đơn"| PHS
    PHS -.->|"5. Lấy thông tin đơn thuốc xuất kho (prescriptionId)"| MRS

    classDef client fill:#f8f9fa,stroke:#343a40,stroke-width:2px;
    classDef gateway fill:#e3f2fd,stroke:#1976d2,stroke-width:2px;
    classDef service fill:#e8f5e9,stroke:#388e3c,stroke-width:2px;
    classDef db fill:#fff3e0,stroke:#f57c00,stroke-width:2px;

    class WebPortal,MobileApp,AdminPortal client;
    class APIGateway gateway;
    class PS,DS,AS,MRS,PHS service;
    class DB1,DB2,DB3,DB4,DB5 db;
```

---

## 2. Bảng Danh mục Microservices & Cơ sở Dữ liệu

| STT | Tên Microservice | Cổng (Port) | Tên Database MySQL | Nhiệm vụ chính |
|:---:|---|:---:|---|---|
| 1 | `patient-service` | **8081** | `medicare_patient_db` | Quản lý hồ sơ nhân khẩu học, thông tin liên lạc và bảo hiểm y tế của bệnh nhân. |
| 2 | `doctor-service` | **8082** | `medicare_doctor_db` | Quản lý hồ sơ bác sĩ, phân khoa chuyên môn, phòng làm việc và lịch trực khám. |
| 3 | `appointment-service` | **8083** | `medicare_appointment_db` | Quản lý việc đặt lịch hẹn khám bệnh, điều phối khung giờ và trạng thái lịch hẹn. |
| 4 | `medical-record-service` | **8084** | `medicare_medical_record_db` | Quản lý hồ sơ bệnh án, các chỉ số sinh tồn, chẩn đoán bệnh lý và kê đơn thuốc. |
| 5 | `pharmacy-service` | **8085** | `medicare_pharmacy_db` | Quản lý danh mục thuốc, quản lý tồn kho theo lô, hạn dùng và phiếu xuất kho dược. |
