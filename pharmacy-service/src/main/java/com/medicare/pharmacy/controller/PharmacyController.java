package com.medicare.pharmacy.controller;

import com.medicare.pharmacy.entity.DispenseOrder;
import com.medicare.pharmacy.entity.Inventory;
import com.medicare.pharmacy.entity.Medication;
import com.medicare.pharmacy.repository.DispenseOrderRepository;
import com.medicare.pharmacy.repository.InventoryRepository;
import com.medicare.pharmacy.repository.MedicationRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/pharmacy")
public class PharmacyController {

    private final MedicationRepository medicationRepository;
    private final InventoryRepository inventoryRepository;
    private final DispenseOrderRepository dispenseOrderRepository;

    public PharmacyController(MedicationRepository medicationRepository,
                              InventoryRepository inventoryRepository,
                              DispenseOrderRepository dispenseOrderRepository) {
        this.medicationRepository = medicationRepository;
        this.inventoryRepository = inventoryRepository;
        this.dispenseOrderRepository = dispenseOrderRepository;
    }

    @GetMapping("/medications")
    public List<Medication> getAllMedications() {
        return medicationRepository.findAll();
    }

    @GetMapping("/medications/{id}")
    public ResponseEntity<Medication> getMedicationById(@PathVariable Long id) {
        return medicationRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/inventory/by-medication/{medicationId}")
    public List<Inventory> getInventoryByMedication(@PathVariable Long medicationId) {
        return inventoryRepository.findByMedicationId(medicationId);
    }

    @PostMapping("/dispense-orders")
    public ResponseEntity<DispenseOrder> createDispenseOrder(@RequestBody DispenseOrder order) {
        DispenseOrder saved = dispenseOrderRepository.save(order);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
}
