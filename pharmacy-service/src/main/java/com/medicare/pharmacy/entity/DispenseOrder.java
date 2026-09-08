package com.medicare.pharmacy.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "dispense_orders")
public class DispenseOrder {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /**
     * Tham chiếu logic tới Medical Record Service
     */
    @Column(name = "prescription_id", nullable = false)
    private Long prescriptionId;

    /**
     * Tham chiếu logic tới Patient Service
     */
    @Column(name = "patient_id", nullable = false)
    private Long patientId;

    @Column(name = "dispensed_by", length = 100)
    private String dispensedBy;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private DispenseStatus status = DispenseStatus.PENDING;

    @Column(name = "dispensed_at")
    private LocalDateTime dispensedAt;

    @Column(name = "total_amount", precision = 12, scale = 2)
    private BigDecimal totalAmount = BigDecimal.ZERO;

    @OneToMany(mappedBy = "dispenseOrder", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DispenseOrderItem> items = new ArrayList<>();

    public enum DispenseStatus {
        PENDING, DISPENSED, CANCELLED
    }

    public DispenseOrder() {}

    public DispenseOrder(Long prescriptionId, Long patientId, String dispensedBy) {
        this.prescriptionId = prescriptionId;
        this.patientId = patientId;
        this.dispensedBy = dispensedBy;
        this.status = DispenseStatus.PENDING;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getPrescriptionId() { return prescriptionId; }
    public void setPrescriptionId(Long prescriptionId) { this.prescriptionId = prescriptionId; }

    public Long getPatientId() { return patientId; }
    public void setPatientId(Long patientId) { this.patientId = patientId; }

    public String getDispensedBy() { return dispensedBy; }
    public void setDispensedBy(String dispensedBy) { this.dispensedBy = dispensedBy; }

    public DispenseStatus getStatus() { return status; }
    public void setStatus(DispenseStatus status) { this.status = status; }

    public LocalDateTime getDispensedAt() { return dispensedAt; }
    public void setDispensedAt(LocalDateTime dispensedAt) { this.dispensedAt = dispensedAt; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public List<DispenseOrderItem> getItems() { return items; }
    public void setItems(List<DispenseOrderItem> items) { this.items = items; }
}
