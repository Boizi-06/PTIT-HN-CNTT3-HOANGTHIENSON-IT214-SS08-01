package com.medicare.pharmacy;

import com.medicare.pharmacy.entity.DispenseOrder;
import com.medicare.pharmacy.entity.Inventory;
import com.medicare.pharmacy.entity.Medication;
import com.medicare.pharmacy.repository.DispenseOrderRepository;
import com.medicare.pharmacy.repository.InventoryRepository;
import com.medicare.pharmacy.repository.MedicationRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class PharmacyServiceApplicationTests {

    @Autowired
    private MedicationRepository medicationRepository;

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private DispenseOrderRepository dispenseOrderRepository;

    @Test
    @DisplayName("Kiểm tra Pharmacy Service khởi động, quản lý kho thuốc và tạo đơn xuất dược thành công")
    void testMedicationAndInventoryFlow() {
        Medication med = medicationRepository.save(
                new Medication("MED-PAR-500", "Paracetamol 500mg", "Vỉ", BigDecimal.valueOf(15000), "Dược Hậu Giang"));

        Inventory inv = inventoryRepository.save(
                new Inventory(med, "BATCH-2026-001", LocalDate.of(2028, 12, 31), 500, 50));

        DispenseOrder order = new DispenseOrder(1L, 100L, "Dược sĩ Tran B");
        DispenseOrder savedOrder = dispenseOrderRepository.save(order);

        assertThat(med.getId()).isNotNull();
        assertThat(inv.getId()).isNotNull();
        assertThat(savedOrder.getId()).isNotNull();
        assertThat(savedOrder.getPrescriptionId()).isEqualTo(1L);
    }
}
