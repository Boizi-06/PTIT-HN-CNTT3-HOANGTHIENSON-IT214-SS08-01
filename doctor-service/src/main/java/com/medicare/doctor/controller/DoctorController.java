package com.medicare.doctor.controller;

import com.medicare.doctor.entity.Doctor;
import com.medicare.doctor.entity.DoctorSchedule;
import com.medicare.doctor.repository.DoctorRepository;
import com.medicare.doctor.repository.DoctorScheduleRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/doctors")
public class DoctorController {

    private final DoctorRepository doctorRepository;
    private final DoctorScheduleRepository scheduleRepository;

    public DoctorController(DoctorRepository doctorRepository, DoctorScheduleRepository scheduleRepository) {
        this.doctorRepository = doctorRepository;
        this.scheduleRepository = scheduleRepository;
    }

    @GetMapping
    public List<Doctor> getAllDoctors() {
        return doctorRepository.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Doctor> getDoctorById(@PathVariable Long id) {
        return doctorRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/{id}/schedules")
    public List<DoctorSchedule> getDoctorSchedules(@PathVariable Long id) {
        return scheduleRepository.findByDoctorId(id);
    }

    @PostMapping
    public ResponseEntity<Doctor> createDoctor(@RequestBody Doctor doctor) {
        Doctor saved = doctorRepository.save(doctor);
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }
}
