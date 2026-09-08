-- ============================================================================
-- DATABASE: medicare_doctor_db (Doctor Service - Port 8082)
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
