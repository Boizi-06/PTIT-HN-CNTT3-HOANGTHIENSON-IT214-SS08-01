package com.medicare.pharmacy.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "dispense_order_items")
public class DispenseOrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dispense_order_id", nullable = false)
    private DispenseOrder dispenseOrder;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "medication_id", nullable = false)
    private Medication medication;

    @Column(nullable = false)
    private Integer quantity;

    @Column(name = "unit_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal unitPrice;

    @Column(nullable = false, precision = 12, scale = 2)
    private BigDecimal amount;

    public DispenseOrderItem() {}

    public DispenseOrderItem(DispenseOrder dispenseOrder, Medication medication, Integer quantity, BigDecimal unitPrice) {
        this.dispenseOrder = dispenseOrder;
        this.medication = medication;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.amount = unitPrice.multiply(BigDecimal.valueOf(quantity));
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public DispenseOrder getDispenseOrder() { return dispenseOrder; }
    public void setDispenseOrder(DispenseOrder dispenseOrder) { this.dispenseOrder = dispenseOrder; }

    public Medication getMedication() { return medication; }
    public void setMedication(Medication medication) { this.medication = medication; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
}
