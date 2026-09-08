-- ============================================================================
-- HỆ THỐNG QUẢN LÝ BỆNH VIỆN MEDICARE (MICROSERVICES ARCHITECTURE)
-- TỔNG HỢP SQL DDL KHỞI TẠO 5 CƠ SỞ DỮ LIỆU ĐỘC LẬP (DATABASE-PER-SERVICE)
-- ============================================================================

-- ============================================================================
-- 1. DATABASE: medicare_patient_db (Dành cho Patient Service - Port 8081)
-- ============================================================================
CREATE DATABASE IF NOT EXISTS medicare_patient_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicare_patient_db;

DROP TABLE IF EXISTS patients;
CREATE TABLE patients (
    id                      BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name               VARCHAR(100) NOT NULL COMMENT 'Họ và tên bệnh nhân',
    date_of_birth           DATE NOT NULL COMMENT 'Ngày sinh',
    gender                  ENUM('MALE','FEMALE','OTHER') NOT NULL COMMENT 'Giới tính',
    phone                   VARCHAR(15) COMMENT 'Số điện thoại liên hệ',
    address                 VARCHAR(255) COMMENT 'Địa chỉ cư trú',
    insurance_id            VARCHAR(20) COMMENT 'Mã số Bảo hiểm y tế (BHYT)',
    emergency_contact_phone VARCHAR(15) COMMENT 'Số điện thoại người thân khi khẩn cấp',
    created_at              DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at              DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_patient_phone (phone),
    INDEX idx_patient_insurance (insurance_id)
) ENGINE=InnoDB COMMENT='Bảng lưu trữ thông tin định danh và hành chính của bệnh nhân';

-- Dữ liệu mẫu
INSERT INTO patients (full_name, date_of_birth, gender, phone, address, insurance_id) VALUES
('Nguyễn Văn An', '1988-03-15', 'MALE', '0901234567', 'Số 12 Chùa Bộc, Đống Đa, Hà Nội', 'DN4010123456789'),
('Trần Thị Bình', '1995-07-22', 'FEMALE', '0912345678', 'Số 45 Nguyễn Trãi, Thanh Xuân, Hà Nội', 'GD4010987654321');


-- ============================================================================
-- 2. DATABASE: medicare_doctor_db (Dành cho Doctor Service - Port 8082)
-- ============================================================================
CREATE DATABASE IF NOT EXISTS medicare_doctor_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicare_doctor_db;

DROP TABLE IF EXISTS doctor_schedules;
DROP TABLE IF EXISTS doctors;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE COMMENT 'Tên khoa/phòng ban',
    description TEXT COMMENT 'Mô tả chức năng chuyên môn',
    location    VARCHAR(100) COMMENT 'Vị trí phòng làm việc/tòa nhà'
) ENGINE=InnoDB COMMENT='Bảng danh mục các chuyên khoa trong bệnh viện';

CREATE TABLE doctors (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    department_id  BIGINT COMMENT 'Khóa ngoại nội bộ trỏ tới khoa',
    full_name      VARCHAR(100) NOT NULL COMMENT 'Họ và tên bác sĩ',
    specialty      VARCHAR(100) COMMENT 'Chuyên khoa sâu',
    phone          VARCHAR(15),
    email          VARCHAR(100),
    room_number    VARCHAR(20) COMMENT 'Số phòng khám bệnh',
    status         ENUM('ACTIVE', 'ON_LEAVE', 'RETIRED') DEFAULT 'ACTIVE',
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_doctor_department FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
    INDEX idx_doctor_specialty (specialty)
) ENGINE=InnoDB COMMENT='Bảng thông tin hồ sơ bác sĩ';

CREATE TABLE doctor_schedules (
    id                    BIGINT AUTO_INCREMENT PRIMARY KEY,
    doctor_id             BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới bác sĩ',
    day_of_week           ENUM('MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY','SUNDAY') NOT NULL,
    shift_start           TIME NOT NULL COMMENT 'Giờ bắt đầu ca',
    shift_end             TIME NOT NULL COMMENT 'Giờ kết thúc ca',
    max_patients_per_shift INT DEFAULT 20 COMMENT 'Số lượng bệnh nhân tối đa trong ca',
    status                ENUM('AVAILABLE','BUSY') DEFAULT 'AVAILABLE',
    CONSTRAINT fk_schedule_doctor FOREIGN KEY (doctor_id) REFERENCES doctors(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Bảng lịch trực và ca làm việc của bác sĩ';

-- Dữ liệu mẫu
INSERT INTO departments (name, description, location) VALUES
('Khoa Tim Mạch', 'Khám, chẩn đoán và điều trị bệnh lý tim mạch can thiệp', 'Tầng 3 Nhà A'),
('Khoa Nội Tổng Quát', 'Chẩn đoán và điều trị các bệnh nội khoa tổng quát', 'Tầng 2 Nhà B');

INSERT INTO doctors (department_id, full_name, specialty, phone, email, room_number) VALUES
(1, 'PGS.TS Lê Quang Cường', 'Tim Mạch Can Thiệp', '0988776655', 'cuong.lq@medicare.vn', 'P301'),
(2, 'ThS.BS Vũ Thị Dung', 'Nội Tiêu Hóa', '0977665544', 'dung.vt@medicare.vn', 'P205');

INSERT INTO doctor_schedules (doctor_id, day_of_week, shift_start, shift_end, max_patients_per_shift) VALUES
(1, 'MONDAY', '08:00:00', '12:00:00', 20),
(1, 'WEDNESDAY', '13:30:00', '17:30:00', 20),
(2, 'TUESDAY', '08:00:00', '12:00:00', 25);


-- ============================================================================
-- 3. DATABASE: medicare_appointment_db (Dành cho Appointment Service - Port 8083)
-- ============================================================================
CREATE DATABASE IF NOT EXISTS medicare_appointment_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicare_appointment_db;

DROP TABLE IF EXISTS appointments;
CREATE TABLE appointments (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_code VARCHAR(30) NOT NULL UNIQUE COMMENT 'Mã phiếu khám định danh duy nhất',
    
    -- THAM CHIẾU DỮ LIỆU LIÊN DỊCH VỤ (CROSS-SERVICE REFERENCE ID)
    -- Tuyệt đối KHÔNG sử dụng FOREIGN KEY vật lý sang cơ sở dữ liệu khác!
    patient_id       BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_patient_db.patients',
    doctor_id        BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_doctor_db.doctors',
    
    appointment_date DATE NOT NULL COMMENT 'Ngày khám',
    time_slot        VARCHAR(30) NOT NULL COMMENT 'Khung giờ khám (ví dụ: 08:00 - 08:30)',
    reason           VARCHAR(255) COMMENT 'Lý do khám / Triệu chứng ban đầu',
    status           ENUM('PENDING','CONFIRMED','COMPLETED','CANCELLED') DEFAULT 'PENDING' COMMENT 'Trạng thái lịch khám',
    notes            TEXT COMMENT 'Ghi chú thêm',
    created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at       DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_appointment_patient (patient_id),
    INDEX idx_appointment_doctor (doctor_id),
    INDEX idx_appointment_date (appointment_date)
) ENGINE=InnoDB COMMENT='Bảng quản lý vòng đời lịch đặt khám';

-- Dữ liệu mẫu
INSERT INTO appointments (appointment_code, patient_id, doctor_id, appointment_date, time_slot, reason, status) VALUES
('APT-20260908-001', 1, 1, '2026-09-09', '08:30 - 09:00', 'Tức ngực, khó thở khi gắng sức', 'CONFIRMED'),
('APT-20260908-002', 2, 2, '2026-09-09', '09:00 - 09:30', 'Đau dạ dày vùng thượng vị', 'PENDING');


-- ============================================================================
-- 4. DATABASE: medicare_medical_record_db (Dành cho Medical Record Service - Port 8084)
-- ============================================================================
CREATE DATABASE IF NOT EXISTS medicare_medical_record_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicare_medical_record_db;

DROP TABLE IF EXISTS prescription_items;
DROP TABLE IF EXISTS prescriptions;
DROP TABLE IF EXISTS medical_records;

CREATE TABLE medical_records (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_id    BIGINT NOT NULL UNIQUE COMMENT 'Logical ID tham chiếu từ medicare_appointment_db',
    patient_id        BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_patient_db',
    doctor_id         BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_doctor_db',
    examination_date  DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Thời điểm khám',
    blood_pressure    VARCHAR(20) COMMENT 'Huyết áp (mmHg)',
    heart_rate        INT COMMENT 'Nhịp tim (lần/phút)',
    weight_kg         DECIMAL(5,2) COMMENT 'Cân nặng (kg)',
    temperature_c     DECIMAL(4,2) COMMENT 'Thân nhiệt (°C)',
    diagnosis         TEXT NOT NULL COMMENT 'Chẩn đoán bệnh lý (ICD-10)',
    doctor_conclusion TEXT COMMENT 'Lời dặn dò và kết luận của bác sĩ',
    status            ENUM('IN_PROGRESS','FINALIZED') DEFAULT 'IN_PROGRESS',
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_record_patient (patient_id),
    INDEX idx_record_appointment (appointment_id)
) ENGINE=InnoDB COMMENT='Bảng lưu trữ hồ sơ bệnh án khám chữa bệnh';

CREATE TABLE prescriptions (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    medical_record_id BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới medical_records',
    notes             VARCHAR(255) COMMENT 'Ghi chú tổng quát cho đơn thuốc',
    created_at        DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_prescription_record FOREIGN KEY (medical_record_id) REFERENCES medical_records(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Bảng quản lý đơn thuốc theo bệnh án';

CREATE TABLE prescription_items (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    prescription_id   BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới prescriptions',
    
    -- THAM CHIẾU DỮ LIỆU SANG PHARMACY SERVICE:
    medication_id     BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_pharmacy_db.medications',
    medication_name   VARCHAR(150) NOT NULL COMMENT 'Phi chuẩn hóa: Lưu snapshot tên thuốc tại thời điểm kê',
    dosage            VARCHAR(100) NOT NULL COMMENT 'Liều dùng (ví dụ: 1 viên/lần, ngày 2 lần)',
    quantity          INT NOT NULL COMMENT 'Số lượng thuốc kê',
    instructions      VARCHAR(255) COMMENT 'Hướng dẫn sử dụng (uống trước/sau ăn)',
    CONSTRAINT fk_item_prescription FOREIGN KEY (prescription_id) REFERENCES prescriptions(id) ON DELETE CASCADE
) ENGINE=InnoDB COMMENT='Bảng chi tiết các thuốc trong đơn';

-- Dữ liệu mẫu
INSERT INTO medical_records (appointment_id, patient_id, doctor_id, blood_pressure, heart_rate, weight_kg, temperature_c, diagnosis, doctor_conclusion, status) VALUES
(1, 1, 1, '135/85', 78, 68.5, 36.6, 'Tăng huyết áp nguyên phát (I10)', 'Hạn chế ăn mặn, uống thuốc đều đặn vào buổi sáng', 'FINALIZED');

INSERT INTO prescriptions (medical_record_id, notes) VALUES
(1, 'Đơn thuốc điều trị tăng huyết áp 30 ngày');

INSERT INTO prescription_items (prescription_id, medication_id, medication_name, dosage, quantity, instructions) VALUES
(1, 1, 'Amlodipine 5mg', '1 viên / lần / ngày', 30, 'Uống vào buổi sáng sau ăn'),
(1, 2, 'Aspirin 81mg', '1 viên / lần / ngày', 30, 'Uống sau bữa ăn no');


-- ============================================================================
-- 5. DATABASE: medicare_pharmacy_db (Dành cho Pharmacy Service - Port 8085)
-- ============================================================================
CREATE DATABASE IF NOT EXISTS medicare_pharmacy_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE medicare_pharmacy_db;

DROP TABLE IF EXISTS dispense_order_items;
DROP TABLE IF EXISTS dispense_orders;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS medications;

CREATE TABLE medications (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    code         VARCHAR(50) NOT NULL UNIQUE COMMENT 'Mã định danh thuốc',
    name         VARCHAR(150) NOT NULL COMMENT 'Tên thương mại và hoạt chất',
    unit         VARCHAR(20) NOT NULL COMMENT 'Đơn vị tính (Viên, Hộp, Chai, Vỉ)',
    unit_price   DECIMAL(12,2) NOT NULL COMMENT 'Đơn giá niêm yết (VNĐ)',
    manufacturer VARCHAR(100) COMMENT 'Hãng sản xuất',
    description  TEXT COMMENT 'Mô tả công dụng và chống chỉ định',
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_medication_code (code),
    INDEX idx_medication_name (name)
) ENGINE=InnoDB COMMENT='Bảng danh mục thuốc của bệnh viện';

CREATE TABLE inventory (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    medication_id     BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới medications',
    batch_number      VARCHAR(50) NOT NULL COMMENT 'Số lô nhập',
    expiry_date       DATE NOT NULL COMMENT 'Hạn sử dụng',
    quantity_in_stock INT NOT NULL DEFAULT 0 COMMENT 'Số lượng tồn kho thực tế',
    reorder_level     INT DEFAULT 50 COMMENT 'Ngưỡng cảnh báo cần đặt thêm',
    updated_at        DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_medication FOREIGN KEY (medication_id) REFERENCES medications(id) ON DELETE CASCADE,
    INDEX idx_inventory_expiry (expiry_date)
) ENGINE=InnoDB COMMENT='Bảng quản lý tồn kho theo từng lô thuốc';

CREATE TABLE dispense_orders (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    prescription_id BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_medical_record_db',
    patient_id      BIGINT NOT NULL COMMENT 'Logical ID tham chiếu từ medicare_patient_db',
    dispensed_by    VARCHAR(100) COMMENT 'Tên dược sĩ thực hiện phát thuốc',
    status          ENUM('PENDING','DISPENSED','CANCELLED') DEFAULT 'PENDING',
    dispensed_at    DATETIME COMMENT 'Thời điểm xuất kho',
    total_amount    DECIMAL(12,2) DEFAULT 0.00 COMMENT 'Tổng giá trị đơn thuốc xuất kho',
    INDEX idx_dispense_prescription (prescription_id),
    INDEX idx_dispense_patient (patient_id)
) ENGINE=InnoDB COMMENT='Bảng phiếu xuất kho dược theo đơn';

CREATE TABLE dispense_order_items (
    id                BIGINT AUTO_INCREMENT PRIMARY KEY,
    dispense_order_id BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới dispense_orders',
    medication_id     BIGINT NOT NULL COMMENT 'Khóa ngoại nội bộ trỏ tới medications',
    quantity          INT NOT NULL COMMENT 'Số lượng thuốc xuất kho',
    unit_price        DECIMAL(12,2) NOT NULL COMMENT 'Đơn giá xuất kho tại thời điểm bán',
    amount            DECIMAL(12,2) NOT NULL COMMENT 'Thành tiền = quantity * unit_price',
    CONSTRAINT fk_item_order FOREIGN KEY (dispense_order_id) REFERENCES dispense_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_item_medication FOREIGN KEY (medication_id) REFERENCES medications(id)
) ENGINE=InnoDB COMMENT='Bảng chi tiết các mặt hàng thuốc trong phiếu xuất';

-- Dữ liệu mẫu
INSERT INTO medications (code, name, unit, unit_price, manufacturer) VALUES
('MED-AML-005', 'Amlodipine 5mg', 'Viên', 2500.00, 'Dược Hậu Giang'),
('MED-ASP-081', 'Aspirin 81mg', 'Viên', 1200.00, 'Sanofi Aventis'),
('MED-PAR-500', 'Paracetamol 500mg', 'Viên', 800.00, 'Dược Domesco');

INSERT INTO inventory (medication_id, batch_number, expiry_date, quantity_in_stock, reorder_level) VALUES
(1, 'LOT-2026-A1', '2028-06-30', 5000, 200),
(2, 'LOT-2026-B2', '2027-12-31', 3000, 150),
(3, 'LOT-2026-C3', '2028-10-15', 10000, 500);

INSERT INTO dispense_orders (prescription_id, patient_id, dispensed_by, status, dispensed_at, total_amount) VALUES
(1, 1, 'DS. Nguyễn Thu Hà', 'DISPENSED', '2026-09-09 10:15:00', 111000.00);

INSERT INTO dispense_order_items (dispense_order_id, medication_id, quantity, unit_price, amount) VALUES
(1, 1, 30, 2500.00, 75000.00),
(1, 2, 30, 1200.00, 36000.00);
