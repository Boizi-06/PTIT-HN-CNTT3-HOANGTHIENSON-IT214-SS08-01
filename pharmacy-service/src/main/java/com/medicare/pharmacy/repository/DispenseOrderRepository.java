package com.medicare.pharmacy.repository;

import com.medicare.pharmacy.entity.DispenseOrder;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface DispenseOrderRepository extends JpaRepository<DispenseOrder, Long> {
    List<DispenseOrder> findByPatientId(Long patientId);
    List<DispenseOrder> findByPrescriptionId(Long prescriptionId);
}
