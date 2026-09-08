package com.medicare.appointment;

import com.medicare.appointment.entity.Appointment;
import com.medicare.appointment.repository.AppointmentRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class AppointmentServiceApplicationTests {

    @Autowired
    private AppointmentRepository appointmentRepository;

    @Test
    @DisplayName("Kiểm tra Appointment Service khởi động và lưu trữ Appointment với ID tham chiếu thành công")
    void testCreateAppointmentWithReferenceIds() {
        // patientId=1L và doctorId=2L là logical reference ID, không có foreign key vật lý sang DB khác
        Appointment app = new Appointment("APT-20260908-001", 1L, 2L,
                LocalDate.now(), "09:00 - 09:30", "Kham tim dinh ky");
        Appointment saved = appointmentRepository.save(app);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getPatientId()).isEqualTo(1L);
        assertThat(saved.getDoctorId()).isEqualTo(2L);
        assertThat(saved.getStatus()).isEqualTo(Appointment.AppointmentStatus.PENDING);
    }
}
