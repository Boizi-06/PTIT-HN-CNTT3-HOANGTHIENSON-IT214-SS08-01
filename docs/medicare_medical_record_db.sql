-- ============================================================================
-- DATABASE: medicare_medical_record_db (Medical Record Service - Port 8084)
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
