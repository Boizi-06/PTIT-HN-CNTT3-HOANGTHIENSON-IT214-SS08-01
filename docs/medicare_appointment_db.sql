-- ============================================================================
-- DATABASE: medicare_appointment_db (Appointment Service - Port 8083)
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
