-- ============================================================================
-- DATABASE: medicare_patient_db (Patient Service - Port 8081)
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
