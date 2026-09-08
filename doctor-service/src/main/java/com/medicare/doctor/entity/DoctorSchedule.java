package com.medicare.doctor.entity;

import jakarta.persistence.*;
import java.time.LocalTime;

@Entity
@Table(name = "doctor_schedules")
public class DoctorSchedule {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "doctor_id", nullable = false)
    private Doctor doctor;

    @Enumerated(EnumType.STRING)
    @Column(name = "day_of_week", nullable = false, length = 15)
    private DayOfWeek dayOfWeek;

    @Column(name = "shift_start", nullable = false)
    private LocalTime shiftStart;

    @Column(name = "shift_end", nullable = false)
    private LocalTime shiftEnd;

    @Column(name = "max_patients_per_shift", nullable = false)
    private Integer maxPatientsPerShift = 20;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 15)
    private ScheduleStatus status = ScheduleStatus.AVAILABLE;

    public enum DayOfWeek {
        MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY
    }

    public enum ScheduleStatus {
        AVAILABLE, BUSY
    }

    public DoctorSchedule() {}

    public DoctorSchedule(Doctor doctor, DayOfWeek dayOfWeek, LocalTime shiftStart, LocalTime shiftEnd, Integer maxPatientsPerShift) {
        this.doctor = doctor;
        this.dayOfWeek = dayOfWeek;
        this.shiftStart = shiftStart;
        this.shiftEnd = shiftEnd;
        this.maxPatientsPerShift = maxPatientsPerShift;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public DayOfWeek getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(DayOfWeek dayOfWeek) { this.dayOfWeek = dayOfWeek; }

    public LocalTime getShiftStart() { return shiftStart; }
    public void setShiftStart(LocalTime shiftStart) { this.shiftStart = shiftStart; }

    public LocalTime getShiftEnd() { return shiftEnd; }
    public void setShiftEnd(LocalTime shiftEnd) { this.shiftEnd = shiftEnd; }

    public Integer getMaxPatientsPerShift() { return maxPatientsPerShift; }
    public void setMaxPatientsPerShift(Integer maxPatientsPerShift) { this.maxPatientsPerShift = maxPatientsPerShift; }

    public ScheduleStatus getStatus() { return status; }
    public void setStatus(ScheduleStatus status) { this.status = status; }
}
