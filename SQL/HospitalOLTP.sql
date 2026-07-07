
-- HOSPITAL OLTP DATABASE


IF DB_ID('Hospital_OLTP') IS NOT NULL
BEGIN
    DROP DATABASE Hospital_OLTP;
END;
GO

CREATE DATABASE Hospital_OLTP;
GO

USE Hospital_OLTP;
GO


-- 1. DEPARTMENT

CREATE TABLE Department
(
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL
);
GO


-- 2. DOCTOR

CREATE TABLE Doctor
(
    DoctorID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    DepartmentID INT NOT NULL,
    CONSTRAINT FK_Doctor_Department
        FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
GO


-- 3. PATIENT

CREATE TABLE Patient
(
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    Address VARCHAR(150) NOT NULL,
    City VARCHAR(50) NOT NULL
);
GO


-- 4. ROOM

CREATE TABLE Room
(
    RoomID INT PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    RoomType VARCHAR(50) NOT NULL,
    DailyCharge DECIMAL(10,2) NOT NULL
);
GO


-- 5. APPOINTMENT

CREATE TABLE Appointment
(
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Reason VARCHAR(200) NOT NULL,
    Status VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Appointment_Patient
        FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT FK_Appointment_Doctor
        FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID)
);
GO

-- 6. ADMISSION

CREATE TABLE Admission
(
    AdmissionID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    RoomID INT NOT NULL,
    AdmissionDate DATE NOT NULL,
    DischargeDate DATE NULL,
    AdmissionReason VARCHAR(200) NOT NULL,
    CONSTRAINT FK_Admission_Patient
        FOREIGN KEY (PatientID) REFERENCES Patient(PatientID),
    CONSTRAINT FK_Admission_Doctor
        FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorID),
    CONSTRAINT FK_Admission_Room
        FOREIGN KEY (RoomID) REFERENCES Room(RoomID)
);
GO


-- 7. TREATMENT

CREATE TABLE Treatment
(
    TreatmentID INT PRIMARY KEY,
    AdmissionID INT NOT NULL,
    TreatmentDate DATE NOT NULL,
    TreatmentType VARCHAR(100) NOT NULL,
    TreatmentCost DECIMAL(10,2) NOT NULL,
    Notes VARCHAR(255) NULL,
    CONSTRAINT FK_Treatment_Admission
        FOREIGN KEY (AdmissionID) REFERENCES Admission(AdmissionID)
);
GO


-- 8. BILL

CREATE TABLE Bill
(
    BillID INT PRIMARY KEY,
    AdmissionID INT NOT NULL UNIQUE,
    BillDate DATE NOT NULL,
    TotalAmount DECIMAL(10,2) NOT NULL,
    PaymentStatus VARCHAR(30) NOT NULL,
    PaymentMethod VARCHAR(30) NOT NULL,
    CONSTRAINT FK_Bill_Admission
        FOREIGN KEY (AdmissionID) REFERENCES Admission(AdmissionID)
);
GO


-- INSERT DATA INTO DEPARTMENT

INSERT INTO Department (DepartmentID, DepartmentName, Location, Phone)
VALUES
(1, 'Cardiology', 'Block A', '09-111-1001'),
(2, 'Orthopaedics', 'Block B', '09-111-1002'),
(3, 'Paediatrics', 'Block C', '09-111-1003'),
(4, 'General Medicine', 'Block D', '09-111-1004');
GO


-- INSERT DATA INTO DOCTOR

INSERT INTO Doctor (DoctorID, FirstName, LastName, Specialty, Phone, Email, DepartmentID)
VALUES
(101, 'Arjun', 'Sharma', 'Cardiologist', '021-500-101', 'arjun.sharma@hospital.co.nz', 1),
(102, 'Meera', 'Patel', 'Cardiologist', '021-500-102', 'meera.patel@hospital.co.nz', 1),
(103, 'Rohan', 'Verma', 'Orthopaedic Surgeon', '021-500-103', 'rohan.verma@hospital.co.nz', 2),
(104, 'Sneha', 'Iyer', 'Orthopaedic Specialist', '021-500-104', 'sneha.iyer@hospital.co.nz', 2),
(105, 'Kavya', 'Nair', 'Paediatrician', '021-500-105', 'kavya.nair@hospital.co.nz', 3),
(106, 'Daniel', 'Thomas', 'General Physician', '021-500-106', 'daniel.thomas@hospital.co.nz', 4);
GO


-- INSERT DATA INTO PATIENT

INSERT INTO Patient (PatientID, FirstName, LastName, Gender, DateOfBirth, Phone, Address, City)
VALUES
(201, 'Aman', 'Singh', 'Male', '1995-02-14', '022-100-2001', '12 Queen Street', 'Auckland'),
(202, 'Pooja', 'Mehta', 'Female', '1988-07-22', '022-100-2002', '45 Dominion Road', 'Auckland'),
(203, 'Liam', 'Wilson', 'Male', '2001-01-09', '022-100-2003', '78 King Street', 'Hamilton'),
(204, 'Emma', 'Brown', 'Female', '2015-11-18', '022-100-2004', '23 Lake Road', 'Auckland'),
(205, 'Noah', 'Taylor', 'Male', '1979-05-30', '022-100-2005', '90 High Street', 'Wellington'),
(206, 'Isha', 'Kapoor', 'Female', '1992-09-03', '022-100-2006', '15 Albert Street', 'Auckland'),
(207, 'Mia', 'Johnson', 'Female', '1985-12-11', '022-100-2007', '10 Hillcrest Ave', 'Tauranga'),
(208, 'Ethan', 'Davis', 'Male', '1998-03-25', '022-100-2008', '66 Beach Road', 'Auckland');
GO


-- INSERT DATA INTO ROOM

INSERT INTO Room (RoomID, RoomNumber, RoomType, DailyCharge)
VALUES
(301, 'R101', 'General Ward', 250.00),
(302, 'R102', 'General Ward', 250.00),
(303, 'R201', 'Private Room', 450.00),
(304, 'R202', 'ICU', 900.00),
(305, 'R203', 'Private Room', 450.00);
GO


-- INSERT DATA INTO APPOINTMENT

INSERT INTO Appointment (AppointmentID, PatientID, DoctorID, AppointmentDate, AppointmentTime, Reason, Status)
VALUES
(401, 201, 101, '2026-01-10', '09:00:00', 'Chest pain consultation', 'Completed'),
(402, 202, 103, '2026-01-12', '10:30:00', 'Knee injury follow-up', 'Completed'),
(403, 203, 106, '2026-01-15', '11:00:00', 'Fever and body pain', 'Completed'),
(404, 204, 105, '2026-01-18', '14:00:00', 'Child vaccination review', 'Completed'),
(405, 205, 101, '2026-02-02', '09:30:00', 'Heart check-up', 'Completed'),
(406, 206, 104, '2026-02-04', '15:00:00', 'Back pain consultation', 'Completed'),
(407, 207, 106, '2026-02-08', '13:00:00', 'General health review', 'Cancelled'),
(408, 208, 102, '2026-02-10', '16:00:00', 'Blood pressure review', 'Completed');
GO


-- INSERT DATA INTO ADMISSION

INSERT INTO Admission (AdmissionID, PatientID, DoctorID, RoomID, AdmissionDate, DischargeDate, AdmissionReason)
VALUES
(501, 201, 101, 304, '2026-01-11', '2026-01-15', 'Cardiac monitoring'),
(502, 202, 103, 303, '2026-01-13', '2026-01-17', 'Knee surgery recovery'),
(503, 204, 105, 301, '2026-01-19', '2026-01-21', 'Paediatric observation'),
(504, 205, 102, 305, '2026-02-03', '2026-02-06', 'Heart rhythm investigation'),
(505, 206, 104, 302, '2026-02-05', '2026-02-09', 'Spine pain treatment'),
(506, 208, 106, 303, '2026-02-11', '2026-02-13', 'Severe flu treatment');
GO


-- INSERT DATA INTO TREATMENT

INSERT INTO Treatment (TreatmentID, AdmissionID, TreatmentDate, TreatmentType, TreatmentCost, Notes)
VALUES
(601, 501, '2026-01-11', 'ECG', 150.00, 'Initial heart assessment'),
(602, 501, '2026-01-12', 'Blood Test', 80.00, 'Routine cardiac blood work'),
(603, 501, '2026-01-13', 'Angiography', 1200.00, 'Further diagnosis required'),

(604, 502, '2026-01-13', 'X-Ray', 120.00, 'Knee imaging'),
(605, 502, '2026-01-14', 'Knee Surgery', 3500.00, 'Arthroscopic procedure'),
(606, 502, '2026-01-16', 'Physiotherapy', 200.00, 'Recovery mobility session'),

(607, 503, '2026-01-19', 'Observation', 100.00, 'Monitoring fever and hydration'),
(608, 503, '2026-01-20', 'Medication', 60.00, 'Paediatric antibiotics'),

(609, 504, '2026-02-03', 'ECG', 150.00, 'Heart rhythm check'),
(610, 504, '2026-02-04', 'Stress Test', 300.00, 'Exercise-induced heart response'),

(611, 505, '2026-02-05', 'MRI Scan', 900.00, 'Spinal imaging'),
(612, 505, '2026-02-07', 'Pain Management', 180.00, 'Medication and monitoring'),
(613, 505, '2026-02-08', 'Physiotherapy', 220.00, 'Back strengthening support'),

(614, 506, '2026-02-11', 'IV Fluids', 90.00, 'Rehydration'),
(615, 506, '2026-02-12', 'Medication', 75.00, 'Antiviral and supportive care');
GO


-- INSERT DATA INTO BILL

INSERT INTO Bill (BillID, AdmissionID, BillDate, TotalAmount, PaymentStatus, PaymentMethod)
VALUES
(701, 501, '2026-01-15', 5030.00, 'Paid', 'Card'),
(702, 502, '2026-01-17', 5620.00, 'Paid', 'Bank Transfer'),
(703, 503, '2026-01-21', 660.00, 'Pending', 'Cash'),
(704, 504, '2026-02-06', 1800.00, 'Paid', 'Card'),
(705, 505, '2026-02-09', 2550.00, 'Pending', 'Insurance'),
(706, 506, '2026-02-13', 1115.00, 'Paid', 'Card');
GO