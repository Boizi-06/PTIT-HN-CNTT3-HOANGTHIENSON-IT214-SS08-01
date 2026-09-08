package com.medicare.doctor;

import com.medicare.doctor.entity.Department;
import com.medicare.doctor.entity.Doctor;
import com.medicare.doctor.repository.DepartmentRepository;
import com.medicare.doctor.repository.DoctorRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class DoctorServiceApplicationTests {

    @Autowired
    private DepartmentRepository departmentRepository;

    @Autowired
    private DoctorRepository doctorRepository;

    @Test
    @DisplayName("Kiểm tra Doctor Service khởi động và lưu trữ Department, Doctor thành công")
    void testCreateDoctorWithDepartment() {
        Department dept = departmentRepository.save(new Department("Khoa Tim Mach", "Chuyen khoa tim mach can thiep", "Tang 3 Nha A"));
        Doctor doc = new Doctor(dept, "TS.BS Tran Van B", "Tim mach", "0912345678", "tranvanb@medicare.vn", "P302");
        Doctor saved = doctorRepository.save(doc);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getDepartment().getName()).isEqualTo("Khoa Tim Mach");
    }
}
