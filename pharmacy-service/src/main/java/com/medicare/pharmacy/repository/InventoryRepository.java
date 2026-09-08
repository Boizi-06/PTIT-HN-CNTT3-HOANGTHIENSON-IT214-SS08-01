package com.medicare.pharmacy.repository;

import com.medicare.pharmacy.entity.Inventory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InventoryRepository extends JpaRepository<Inventory, Long> {
    List<Inventory> findByMedicationId(Long medicationId);
    Optional<Inventory> findByMedicationIdAndBatchNumber(Long medicationId, String batchNumber);
}
