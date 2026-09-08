package com.medicare.medicalrecord.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "prescription_items")
public class PrescriptionItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "prescription_id", nullable = false)
    private Prescription prescription;

    /**
     * Tham chiếu logic tới Pharmacy Service (medication_id)
     */
    @Column(name = "medication_id", nullable = false)
    private Long medicationId;

    /**
     * Phi chuẩn hóa (Denormalization) lưu tên thuốc tại thời điểm kê đơn
     */
    @Column(name = "medication_name", nullable = false, length = 150)
    private String medicationName;

    @Column(nullable = false, length = 100)
    private String dosage;

    @Column(nullable = false)
    private Integer quantity;

    @Column(length = 255)
    private String instructions;

    public PrescriptionItem() {}

    public PrescriptionItem(Prescription prescription, Long medicationId, String medicationName, String dosage, Integer quantity, String instructions) {
        this.prescription = prescription;
        this.medicationId = medicationId;
        this.medicationName = medicationName;
        this.dosage = dosage;
        this.quantity = quantity;
        this.instructions = instructions;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Prescription getPrescription() { return prescription; }
    public void setPrescription(Prescription prescription) { this.prescription = prescription; }

    public Long getMedicationId() { return medicationId; }
    public void setMedicationId(Long medicationId) { this.medicationId = medicationId; }

    public String getMedicationName() { return medicationName; }
    public void setMedicationName(String medicationName) { this.medicationName = medicationName; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public String getInstructions() { return instructions; }
    public void setInstructions(String instructions) { this.instructions = instructions; }
}
