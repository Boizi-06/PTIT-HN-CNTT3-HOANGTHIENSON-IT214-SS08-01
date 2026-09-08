package com.medicare.medicalrecord;

import com.medicare.medicalrecord.entity.MedicalRecord;
import com.medicare.medicalrecord.entity.Prescription;
import com.medicare.medicalrecord.entity.PrescriptionItem;
import com.medicare.medicalrecord.repository.MedicalRecordRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class MedicalRecordServiceApplicationTests {

    @Autowired
    private MedicalRecordRepository medicalRecordRepository;

    @Test
    @DisplayName("Kiểm tra Medical Record Service khởi động và lưu trữ hồ sơ bệnh án kèm đơn thuốc thành công")
    void testCreateMedicalRecordWithPrescription() {
        MedicalRecord record = new MedicalRecord(101L, 1L, 2L,
                "Tang huyet ap vo can (I10)", "Nghi ngoi, kieng muoi, uong thuoc deu dan");
        record.setBloodPressure("140/90");
        record.setHeartRate(85);

        Prescription pres = new Prescription(record, "Uong sau bua an");
        PrescriptionItem item = new PrescriptionItem(pres, 501L, "Amlodipine 5mg", "1 vien/ngay", 30, "Uong buoi sang");
        pres.getItems().add(item);
        record.getPrescriptions().add(pres);

        MedicalRecord saved = medicalRecordRepository.save(record);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getPrescriptions()).hasSize(1);
        assertThat(saved.getPrescriptions().get(0).getItems().get(0).getMedicationName()).isEqualTo("Amlodipine 5mg");
    }
}
