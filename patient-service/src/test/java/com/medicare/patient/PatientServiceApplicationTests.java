package com.medicare.patient;

import com.medicare.patient.entity.Patient;
import com.medicare.patient.repository.PatientRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class PatientServiceApplicationTests {

    @Autowired
    private PatientRepository patientRepository;

    @Test
    @DisplayName("Kiểm tra Context Patient Service khởi động và lưu trữ dữ liệu Patient thành công")
    void testCreateAndFindPatient() {
        Patient p = new Patient("Nguyen Van An", LocalDate.of(1990, 5, 20),
                Patient.Gender.MALE, "0901234567", "Ha Noi", "DN12345678");
        Patient saved = patientRepository.save(p);

        assertThat(saved.getId()).isNotNull();
        assertThat(patientRepository.findById(saved.getId())).isPresent();
    }
}
