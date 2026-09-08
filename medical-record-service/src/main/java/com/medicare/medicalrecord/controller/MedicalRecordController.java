package com.medicare.medicalrecord.controller;

import com.medicare.medicalrecord.entity.MedicalRecord;
import com.medicare.medicalrecord.repository.MedicalRecordRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/medical-records")
public class MedicalRecordController {

    private final MedicalRecordRepository medicalRecordRepository;

    public MedicalRecordController(MedicalRecordRepository medicalRecordRepository) {
        this.medicalRecordRepository = medicalRecordRepository;
    }

    @GetMapping
    public List<MedicalRecord> getAllRecords() {
        return medicalRecordRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<MedicalRecord> getRecordById(@PathVariable Long id) {
        return medicalRecordRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/by-patient/{patientId}")
    public List<MedicalRecord> getRecordsByPatient(@PathVariable Long patientId) {
        return medicalRecordRepository.findByPatientId(patientId);
    }

    @GetMapping("/by-appointment/{appointmentId}")
    public ResponseEntity<MedicalRecord> getRecordByAppointment(@PathVariable Long appointmentId) {
        return medicalRecordRepository.findByAppointmentId(appointmentId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<MedicalRecord> createRecord(@RequestBody MedicalRecord record) {
        MedicalRecord saved = medicalRecordRepository.save(record);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
}
