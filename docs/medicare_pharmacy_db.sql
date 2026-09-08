-- ============================================================================
-- DATABASE: medicare_pharmacy_db (Pharmacy Service - Port 8085)
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
