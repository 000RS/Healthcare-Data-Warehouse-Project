-- HOSPITAL OLAP DATABASE

IF DB_ID('Hospital_OLAP') IS NOT NULL
BEGIN
    DROP DATABASE Hospital_OLAP;
END;
GO

CREATE DATABASE Hospital_OLAP;
GO

USE Hospital_OLAP;
GO


-- DIMENSION TABLES


CREATE TABLE DimPatient
(
    PatientKey INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    DateOfBirth DATE NOT NULL,
    City VARCHAR(50) NOT NULL
);
GO

CREATE TABLE DimDoctor
(
    DoctorKey INT IDENTITY(1,1) PRIMARY KEY,
    DoctorID INT NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(100) NOT NULL
);
GO

CREATE TABLE DimDepartment
(
    DepartmentKey INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentID INT NOT NULL,
    DepartmentName VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL
);
GO

CREATE TABLE DimRoom
(
    RoomKey INT IDENTITY(1,1) PRIMARY KEY,
    RoomID INT NOT NULL,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomType VARCHAR(50) NOT NULL,
    DailyCharge DECIMAL(10,2) NOT NULL
);
GO

CREATE TABLE DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    DayNumber INT NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    QuarterNumber INT NOT NULL,
    YearNumber INT NOT NULL
);
GO


-- FACT TABLE


CREATE TABLE FactAdmission
(
    FactAdmissionKey INT IDENTITY(1,1) PRIMARY KEY,
    AdmissionID INT NOT NULL,
    PatientKey INT NOT NULL,
    DoctorKey INT NOT NULL,
    DepartmentKey INT NOT NULL,
    RoomKey INT NOT NULL,
    DateKey INT NOT NULL,
    TreatmentCount INT NOT NULL,
    TreatmentCost DECIMAL(10,2) NOT NULL,
    BillAmount DECIMAL(10,2) NOT NULL,
    LengthOfStay INT NOT NULL,

    CONSTRAINT FK_FactAdmission_DimPatient
        FOREIGN KEY (PatientKey) REFERENCES DimPatient(PatientKey),

    CONSTRAINT FK_FactAdmission_DimDoctor
        FOREIGN KEY (DoctorKey) REFERENCES DimDoctor(DoctorKey),

    CONSTRAINT FK_FactAdmission_DimDepartment
        FOREIGN KEY (DepartmentKey) REFERENCES DimDepartment(DepartmentKey),

    CONSTRAINT FK_FactAdmission_DimRoom
        FOREIGN KEY (RoomKey) REFERENCES DimRoom(RoomKey),

    CONSTRAINT FK_FactAdmission_DimDate
        FOREIGN KEY (DateKey) REFERENCES DimDate(DateKey)
);
GO

select *
from DimDepartment;