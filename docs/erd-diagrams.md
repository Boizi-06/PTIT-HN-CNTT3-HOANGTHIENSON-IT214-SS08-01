# THIẾT KẾ ENTITY-RELATIONSHIP DIAGRAM (ERD) TỪNG MICROSERVICE

Hệ thống quản lý bệnh viện **MediCare** áp dụng triệt để nguyên tắc **Database-per-Service**. Mỗi Microservice sở hữu hoàn toàn schema và cơ sở dữ liệu MySQL riêng biệt.

---

## 1. ERD: Patient Service (`medicare_patient_db`)

```mermaid
erDiagram
    PATIENTS {
        BIGINT id PK "Khóa chính tự tăng"
        VARCHAR full_name "Họ và tên bệnh nhân"
        DATE date_of_birth "Ngày sinh"
        ENUM gender "MALE, FEMALE, OTHER"
        VARCHAR phone "Số điện thoại liên lạc (Index)"
        VARCHAR address "Địa chỉ cư trú"
        VARCHAR insurance_id "Mã số BHYT (Index)"
        VARCHAR emergency_contact_phone "Số ĐT người thân khi cấp cứu"
        DATETIME created_at "Thời điểm tạo"
        DATETIME updated_at "Thời điểm cập nhật"
    }
```

---

## 2. ERD: Doctor Service (`medicare_doctor_db`)

```mermaid
erDiagram
    DEPARTMENTS ||--o{ DOCTORS : "thuộc về"
    DOCTORS ||--o{ DOCTOR_SCHEDULES : "có lịch trực"

    DEPARTMENTS {
        BIGINT id PK "Khóa chính"
        VARCHAR name "Tên chuyên khoa (Unique)"
        TEXT description "Mô tả chức năng chuyên môn"
        VARCHAR location "Vị trí tầng / tòa nhà"
    }

    DOCTORS {
        BIGINT id PK "Khóa chính"
        BIGINT department_id FK "Khóa ngoại nội bộ -> DEPARTMENTS.id"
        VARCHAR full_name "Họ tên bác sĩ"
        VARCHAR specialty "Chuyên khoa sâu"
        VARCHAR phone "Số điện thoại"
        VARCHAR email "Email liên lạc"
        VARCHAR room_number "Số phòng khám"
        ENUM status "ACTIVE, ON_LEAVE, RETIRED"
        DATETIME created_at "Thời điểm tạo"
        DATETIME updated_at "Thời điểm cập nhật"
    }

    DOCTOR_SCHEDULES {
        BIGINT id PK "Khóa chính"
        BIGINT doctor_id FK "Khóa ngoại nội bộ -> DOCTORS.id"
        ENUM day_of_week "MONDAY, TUESDAY... SUNDAY"
        TIME shift_start "Giờ bắt đầu ca"
        TIME shift_end "Giờ kết thúc ca"
        INT max_patients_per_shift "Số lượng bệnh nhân tối đa"
        ENUM status "AVAILABLE, BUSY"
    }
```

---

## 3. ERD: Appointment Service (`medicare_appointment_db`)

```mermaid
erDiagram
    APPOINTMENTS {
        BIGINT id PK "Khóa chính"
        VARCHAR appointment_code UK "Mã phiếu khám duy nhất (Unique)"
        BIGINT patient_id "Logical ID tham chiếu -> medicare_patient_db"
        BIGINT doctor_id "Logical ID tham chiếu -> medicare_doctor_db"
        DATE appointment_date "Ngày hẹn khám"
        VARCHAR time_slot "Khung giờ hẹn (vd: 08:00 - 08:30)"
        VARCHAR reason "Lý do khám / Triệu chứng"
        ENUM status "PENDING, CONFIRMED, COMPLETED, CANCELLED"
        TEXT notes "Ghi chú thêm"
        DATETIME created_at "Thời điểm tạo"
        DATETIME updated_at "Thời điểm cập nhật"
    }
```

> **Ghi chú quan trọng:** `patient_id` và `doctor_id` trong bảng `APPOINTMENTS` là **Logical Reference ID**, không có ràng buộc Foreign Key vật lý (Physical Foreign Key) sang Database của `patient-service` hay `doctor-service`.

---

## 4. ERD: Medical Record Service (`medicare_medical_record_db`)

```mermaid
erDiagram
    MEDICAL_RECORDS ||--o{ PRESCRIPTIONS : "chứa các đơn thuốc"
    PRESCRIPTIONS ||--|{ PRESCRIPTION_ITEMS : "chi tiết từng vị thuốc"

    MEDICAL_RECORDS {
        BIGINT id PK "Khóa chính"
        BIGINT appointment_id "Logical ID tham chiếu -> medicare_appointment_db"
        BIGINT patient_id "Logical ID tham chiếu -> medicare_patient_db"
        BIGINT doctor_id "Logical ID tham chiếu -> medicare_doctor_db"
        DATETIME examination_date "Thời điểm khám"
        VARCHAR blood_pressure "Huyết áp (mmHg)"
        INT heart_rate "Nhịp tim (lần/phút)"
        DECIMAL weight_kg "Cân nặng (kg)"
        DECIMAL temperature_c "Thân nhiệt (°C)"
        TEXT diagnosis "Chẩn đoán bệnh lý (ICD-10)"
        TEXT doctor_conclusion "Lời dặn & Kết luận của bác sĩ"
        ENUM status "IN_PROGRESS, FINALIZED"
        DATETIME created_at "Thời điểm tạo"
        DATETIME updated_at "Thời điểm cập nhật"
    }

    PRESCRIPTIONS {
        BIGINT id PK "Khóa chính"
        BIGINT medical_record_id FK "Khóa ngoại nội bộ -> MEDICAL_RECORDS.id"
        VARCHAR notes "Ghi chú đơn thuốc"
        DATETIME created_at "Thời điểm tạo"
    }

    PRESCRIPTION_ITEMS {
        BIGINT id PK "Khóa chính"
        BIGINT prescription_id FK "Khóa ngoại nội bộ -> PRESCRIPTIONS.id"
        BIGINT medication_id "Logical ID tham chiếu -> medicare_pharmacy_db"
        VARCHAR medication_name "Snapshot tên thuốc tại thời điểm kê"
        VARCHAR dosage "Liều dùng (vd: Sáng 1 viên, Tối 1 viên)"
        INT quantity "Số lượng cấp phát"
        VARCHAR instructions "Hướng dẫn uống trước/sau ăn"
    }
```

---

## 5. ERD: Pharmacy Service (`medicare_pharmacy_db`)

```mermaid
erDiagram
    MEDICATIONS ||--o{ INVENTORY : "có tồn kho theo lô"
    DISPENSE_ORDERS ||--|{ DISPENSE_ORDER_ITEMS : "chi tiết mặt hàng xuất"
    MEDICATIONS ||--o{ DISPENSE_ORDER_ITEMS : "được xuất theo mặt hàng"

    MEDICATIONS {
        BIGINT id PK "Khóa chính"
        VARCHAR code UK "Mã định danh thuốc (Unique)"
        VARCHAR name "Tên biệt dược & hoạt chất"
        VARCHAR unit "Đơn vị tính (Viên, Hộp, Chai)"
        DECIMAL unit_price "Đơn giá niêm yết"
        VARCHAR manufacturer "Nhà sản xuất"
        TEXT description "Công dụng & Chống chỉ định"
        DATETIME created_at "Thời điểm tạo"
        DATETIME updated_at "Thời điểm cập nhật"
    }

    INVENTORY {
        BIGINT id PK "Khóa chính"
        BIGINT medication_id FK "Khóa ngoại nội bộ -> MEDICATIONS.id"
        VARCHAR batch_number "Số lô nhập"
        DATE expiry_date "Hạn sử dụng"
        INT quantity_in_stock "Số lượng tồn kho thực tế"
        INT reorder_level "Ngưỡng cảnh báo đặt hàng"
        DATETIME updated_at "Thời điểm cập nhật"
    }

    DISPENSE_ORDERS {
        BIGINT id PK "Khóa chính"
        BIGINT prescription_id "Logical ID tham chiếu -> medicare_medical_record_db"
        BIGINT patient_id "Logical ID tham chiếu -> medicare_patient_db"
        VARCHAR dispensed_by "Dược sĩ thực hiện phát thuốc"
        ENUM status "PENDING, DISPENSED, CANCELLED"
        DATETIME dispensed_at "Thời điểm xuất kho"
        DECIMAL total_amount "Tổng số tiền thanh toán"
    }

    DISPENSE_ORDER_ITEMS {
        BIGINT id PK "Khóa chính"
        BIGINT dispense_order_id FK "Khóa ngoại nội bộ -> DISPENSE_ORDERS.id"
        BIGINT medication_id FK "Khóa ngoại nội bộ -> MEDICATIONS.id"
        INT quantity "Số lượng xuất"
        DECIMAL unit_price "Đơn giá tại thời điểm xuất"
        DECIMAL amount "Thành tiền (quantity * unit_price)"
    }
```

---

## 6. Sơ đồ Quan hệ Dữ liệu Toàn cảnh (Cross-Service Data Relationships)

```mermaid
flowchart LR
    subgraph PatientDB["medicare_patient_db"]
        P["patients<br/>PK: id"]
    end

    subgraph DoctorDB["medicare_doctor_db"]
        D["doctors<br/>PK: id"]
        DEP["departments<br/>PK: id"]
        SCH["doctor_schedules<br/>PK: id"]
        DEP -->|FK| D
        D -->|FK| SCH
    end

    subgraph AppointmentDB["medicare_appointment_db"]
        A["appointments<br/>PK: id<br/>Ref: patient_id<br/>Ref: doctor_id"]
    end

    subgraph MedicalRecordDB["medicare_medical_record_db"]
        MR["medical_records<br/>PK: id<br/>Ref: appointment_id<br/>Ref: patient_id<br/>Ref: doctor_id"]
        PR["prescriptions<br/>PK: id"]
        PRI["prescription_items<br/>PK: id<br/>Ref: medication_id"]
        MR -->|FK| PR
        PR -->|FK| PRI
    end

    subgraph PharmacyDB["medicare_pharmacy_db"]
        MED["medications<br/>PK: id"]
        INV["inventory<br/>PK: id"]
        DO["dispense_orders<br/>PK: id<br/>Ref: prescription_id<br/>Ref: patient_id"]
        DOI["dispense_order_items<br/>PK: id"]
        MED -->|FK| INV
        DO -->|FK| DOI
        MED -->|FK| DOI
    end

    %% Logical References across databases (Dashed Lines)
    P -.->|"Logical ID (patient_id)"| A
    D -.->|"Logical ID (doctor_id)"| A
    A -.->|"Logical ID (appointment_id)"| MR
    P -.->|"Logical ID (patient_id)"| MR
    D -.->|"Logical ID (doctor_id)"| MR
    MED -.->|"Logical ID (medication_id)"| PRI
    PR -.->|"Logical ID (prescription_id)"| DO
    P -.->|"Logical ID (patient_id)"| DO

    classDef physicalFk fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
    classDef logicalRef fill:#fff3e0,stroke:#f57c00,stroke-width:2px,stroke-dasharray: 5 5;
```
