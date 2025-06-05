-- MediCore+ Hospital Management System
DROP DATABASE IF EXISTS medicore_plus;
CREATE DATABASE medicore_plus;
USE medicore_plus;

-- Table: Departments
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    floor INT NOT NULL,
    contact_extension VARCHAR(10)
);

-- Table: Staff
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    role ENUM('Doctor', 'Nurse', 'Receptionist', 'Technician', 'Janitor', 'Pharmacist'),
    department_id INT,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    salary DECIMAL(10,2),
    hire_date DATE,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Table: Patients
CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    blood_type VARCHAR(3),
    emergency_contact VARCHAR(100)
);

-- Table: Wards
CREATE TABLE wards (
    ward_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50),
    department_id INT,
    capacity INT,
    current_occupancy INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Table: Admissions
CREATE TABLE admissions (
    admission_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    ward_id INT,
    admit_date DATE,
    discharge_date DATE,
    diagnosis TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (ward_id) REFERENCES wards(ward_id)
);

-- Table: Appointments
CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATETIME,
    reason TEXT,
    status ENUM('Scheduled', 'Completed', 'Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES staff(staff_id)
);

-- Table: Prescriptions
CREATE TABLE prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    medicine_name VARCHAR(100),
    dosage VARCHAR(50),
    frequency VARCHAR(50),
    duration VARCHAR(50),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);

-- Table: Medical Tests
CREATE TABLE medical_tests (
    test_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    cost DECIMAL(8,2)
);

-- Table: Test Results
CREATE TABLE test_results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    test_id INT,
    patient_id INT,
    result TEXT,
    date_taken DATE,
    FOREIGN KEY (test_id) REFERENCES medical_tests(test_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- Table: Inventory
CREATE TABLE inventory (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(8,2),
    supplier VARCHAR(100),
    reorder_level INT
);

-- Table: Billing
CREATE TABLE billing (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    admission_id INT,
    total_amount DECIMAL(10,2),
    payment_status ENUM('Paid', 'Pending', 'Cancelled'),
    payment_date DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (admission_id) REFERENCES admissions(admission_id)
);

-- Table: Feedback
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    staff_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    date_submitted DATE,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
);

-- Table: Ambulance
CREATE TABLE ambulance (
    ambulance_id INT AUTO_INCREMENT PRIMARY KEY,
    driver_name VARCHAR(100),
    phone VARCHAR(15),
    status ENUM('Available', 'On Duty', 'Under Maintenance')
);

-- Table: Transport Requests
CREATE TABLE transport_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT,
    ambulance_id INT,
    request_time DATETIME,
    pickup_location TEXT,
    drop_location TEXT,
    status ENUM('Requested', 'Completed', 'Cancelled'),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (ambulance_id) REFERENCES ambulance(ambulance_id)
);

-- INSERT Sample Departments
INSERT INTO departments (name, floor, contact_extension)
VALUES 
('Cardiology', 2, '1001'),
('Neurology', 3, '1002'),
('Orthopedics', 1, '1003'),
('Emergency', 0, '1004');

-- Add Sample Staff
INSERT INTO staff (first_name, last_name, role, department_id, phone, email, salary, hire_date)
VALUES
('Arjun', 'Mehra', 'Doctor', 1, '9876543210', 'arjun@medicore.com', 120000.00, '2021-01-10'),
('Sita', 'Patel', 'Nurse', 2, '9988776655', 'sita@medicore.com', 45000.00, '2022-02-15');

-- Add Sample Patients
INSERT INTO patients (first_name, last_name, dob, gender, phone, email, address, blood_type, emergency_contact)
VALUES
('Rahul', 'Sharma', '1990-05-01', 'Male', '9123456780', 'rahul@gmail.com', 'Delhi, India', 'B+', 'Anita Sharma'),
('Sneha', 'Desai', '1985-08-21', 'Female', '9988776655', 'sneha@gmail.com', 'Mumbai, India', 'O+', 'Kiran Desai');

-- Sample Appointments
INSERT INTO appointments (patient_id, doctor_id, appointment_date, reason, status)
VALUES
(1, 1, '2025-06-10 10:00:00', 'Chest pain', 'Scheduled'),
(2, 1, '2025-06-11 11:30:00', 'Follow-up', 'Scheduled');

-- Sample Prescriptions
INSERT INTO prescriptions (appointment_id, medicine_name, dosage, frequency, duration)
VALUES
(1, 'Aspirin', '100mg', 'Twice a day', '5 days');

-- Sample Inventory
INSERT INTO inventory (item_name, quantity, unit_price, supplier, reorder_level)
VALUES
('Paracetamol', 1000, 1.50, 'HealthSupplies Ltd.', 200),
('Syringes', 500, 2.00, 'MedEquip Inc.', 100);

-- Sample Billing
INSERT INTO billing (patient_id, admission_id, total_amount, payment_status, payment_date)
VALUES
(1, NULL, 5000.00, 'Paid', '2025-06-01');

-- Sample Feedback
INSERT INTO feedback (patient_id, staff_id, rating, comments, date_submitted)
VALUES
(1, 1, 5, 'Excellent care and friendly staff.', '2025-06-03');

-- Sample Medical Tests
INSERT INTO medical_tests (name, description, cost)
VALUES
('Blood Test', 'Basic blood test', 300.00),
('X-Ray', 'Chest x-ray', 600.00);

-- Sample Test Results
INSERT INTO test_results (test_id, patient_id, result, date_taken)
VALUES
(1, 1, 'Normal', '2025-06-01');

-- Sample Ambulance
INSERT INTO ambulance (driver_name, phone, status)
VALUES
('Ramesh Kumar', '9999988888', 'Available');

-- Sample Transport Request
INSERT INTO transport_requests (patient_id, ambulance_id, request_time, pickup_location, drop_location, status)
VALUES
(2, 1, '2025-06-04 14:00:00', 'Home', 'MediCore+ Emergency', 'Requested');

DELIMITER $$
CREATE PROCEDURE bulk_patients()
BEGIN
  DECLARE i INT DEFAULT 0;
  WHILE i < 150 DO
    INSERT INTO patients (first_name, last_name, dob, gender, phone, email, address, blood_type, emergency_contact)
    VALUES (CONCAT('TestFirst', i), CONCAT('TestLast', i), '1995-01-01', 'Male', '9000000000', CONCAT('test', i, '@mail.com'), 'Test City', 'A+', 'Test Contact');
    SET i = i + 1;
  END WHILE;
END $$
DELIMITER ;

CALL bulk_patients();

-- 1. Search all patients
SELECT * FROM patients;

-- 2. Search patients with B+ blood type
SELECT * FROM patients WHERE blood_type = 'B+';

-- 3. Get all doctors in Cardiology
SELECT s.first_name, s.last_name FROM staff s
JOIN departments d ON s.department_id = d.department_id
WHERE s.role = 'Doctor' AND d.name = 'Cardiology';

-- 4. Get appointment history for a patient
SELECT a.*, s.first_name AS doctor_name FROM appointments a
JOIN staff s ON a.doctor_id = s.staff_id
WHERE a.patient_id = 1;

-- 5. Get wards that are full
SELECT * FROM wards WHERE current_occupancy >= capacity;

-- 6. Get unpaid bills
SELECT * FROM billing WHERE payment_status = 'Pending';

-- 7. Search inventory items that need restocking
SELECT * FROM inventory WHERE quantity < reorder_level;

-- 8. Average rating of each staff
SELECT staff_id, AVG(rating) as avg_rating FROM feedback GROUP BY staff_id;

-- 9. Search test results by patient
SELECT p.first_name, t.name, r.result
FROM test_results r
JOIN medical_tests t ON r.test_id = t.test_id
JOIN patients p ON r.patient_id = p.patient_id;

-- 10. Total billing amount for a patient
SELECT SUM(total_amount) AS total_due FROM billing WHERE patient_id = 1;
