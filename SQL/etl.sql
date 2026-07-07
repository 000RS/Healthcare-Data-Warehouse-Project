-- Hospital_ETL.sql

-- This script loads data from Hospital_OLTP into Hospital_OLAP.
-- Dimensions are loaded first, followed by the FactAdmission table.


USE Hospital_OLAP;
GO

-- ETL Process: Load Dimension Table

MERGE INTO DimPatient AS dp
USING
(
    SELECT;
        PatientID,
        FirstName,
        LastName,
        CASE
            WHEN Gender = 'M' THEN 'Male'
            WHEN Gender = 'F' THEN 'Female'
            ELSE Gender
        END AS Gender,
        DateOfBirth,
        LTRIM(RTRIM(City)) AS City
    FROM Hospital_OLTP.dbo.Patient
) AS p
ON dp.PatientID = p.PatientID

WHEN MATCHED THEN
    UPDATE SET
        dp.FirstName = p.FirstName,
        dp.LastName = p.LastName,
        dp.Gender = p.Gender,
        dp.DateOfBirth = p.DateOfBirth,
        dp.City = p.City

WHEN NOT MATCHED THEN
    INSERT (PatientID, FirstName, LastName, Gender, DateOfBirth, City)
    VALUES (p.PatientID, p.FirstName, p.LastName, p.Gender, p.DateOfBirth, p.City);
GO



MERGE INTO DimDoctor AS dd
USING
(
    SELECT DoctorID, FirstName, LastName, Specialty
    FROM Hospital_OLTP.dbo.Doctor
) AS d
ON dd.DoctorID = d.DoctorID

WHEN MATCHED THEN
    UPDATE SET
        dd.FirstName = d.FirstName,
        dd.LastName = d.LastName,
        dd.Specialty = d.Specialty

WHEN NOT MATCHED THEN
    INSERT (DoctorID, FirstName, LastName, Specialty)
    VALUES (d.DoctorID, d.FirstName, d.LastName, d.Specialty);
GO


MERGE INTO DimDepartment AS dd
USING
(
    SELECT DepartmentID, DepartmentName, Location
    FROM Hospital_OLTP.dbo.Department
) AS d
ON dd.DepartmentID = d.DepartmentID

WHEN MATCHED THEN
    UPDATE SET
        dd.DepartmentName = d.DepartmentName,
        dd.Location = d.Location

WHEN NOT MATCHED THEN
    INSERT (DepartmentID, DepartmentName, Location)
    VALUES (d.DepartmentID, d.DepartmentName, d.Location);
GO


MERGE INTO DimRoom AS dr
USING
(
    SELECT RoomID, RoomNumber, RoomType, DailyCharge
    FROM Hospital_OLTP.dbo.Room
) AS r
ON dr.RoomID = r.RoomID

WHEN MATCHED THEN
    UPDATE SET
        dr.RoomNumber = r.RoomNumber,
        dr.RoomType = r.RoomType,
        dr.DailyCharge = r.DailyCharge

WHEN NOT MATCHED THEN
    INSERT (RoomID, RoomNumber, RoomType, DailyCharge)
    VALUES (r.RoomID, r.RoomNumber, r.RoomType, r.DailyCharge);
GO


MERGE INTO DimDate AS dd
USING
(
    SELECT DISTINCT
        CONVERT(INT, FORMAT(DateValue, 'yyyyMMdd')) AS DateKey,
        DateValue AS FullDate,
        DAY(DateValue) AS DayNumber,
        MONTH(DateValue) AS MonthNumber,
        DATENAME(MONTH, DateValue) AS MonthName,
        DATEPART(QUARTER, DateValue) AS QuarterNumber,
        YEAR(DateValue) AS YearNumber
    FROM
    (
        SELECT AdmissionDate AS DateValue FROM Hospital_OLTP.dbo.Admission
        UNION
        SELECT DischargeDate FROM Hospital_OLTP.dbo.Admission WHERE DischargeDate IS NOT NULL
        UNION
        SELECT TreatmentDate FROM Hospital_OLTP.dbo.Treatment
        UNION
        SELECT BillDate FROM Hospital_OLTP.dbo.Bill
    ) AS Dates
) AS src
ON dd.DateKey = src.DateKey

WHEN MATCHED THEN
    UPDATE SET
        dd.FullDate = src.FullDate,
        dd.DayNumber = src.DayNumber,
        dd.MonthNumber = src.MonthNumber,
        dd.MonthName = src.MonthName,
        dd.QuarterNumber = src.QuarterNumber,
        dd.YearNumber = src.YearNumber

WHEN NOT MATCHED THEN
    INSERT (DateKey, FullDate, DayNumber, MonthNumber, MonthName, QuarterNumber, YearNumber)
    VALUES (src.DateKey, src.FullDate, src.DayNumber, src.MonthNumber, src.MonthName, src.QuarterNumber, src.YearNumber);
GO


USE Hospital_OLAP;
GO

-- Load Fact Table

MERGE INTO FactAdmission AS fa
USING
(
    SELECT
        a.AdmissionID,
        dp.PatientKey,
        ddoc.DoctorKey,
        ddep.DepartmentKey,
        dr.RoomKey,
        ddate.DateKey,

        COUNT(t.TreatmentID) AS TreatmentCount,
        ISNULL(SUM(t.TreatmentCost), 0) AS TreatmentCost,
        b.TotalAmount AS BillAmount,
        DATEDIFF(DAY, a.AdmissionDate, a.DischargeDate) AS LengthOfStay

    FROM Hospital_OLTP.dbo.Admission a

    INNER JOIN Hospital_OLTP.dbo.Patient p
        ON a.PatientID = p.PatientID
    INNER JOIN DimPatient dp
        ON p.PatientID = dp.PatientID

    INNER JOIN Hospital_OLTP.dbo.Doctor doc
        ON a.DoctorID = doc.DoctorID
    INNER JOIN DimDoctor ddoc
        ON doc.DoctorID = ddoc.DoctorID

    INNER JOIN Hospital_OLTP.dbo.Department dep
        ON doc.DepartmentID = dep.DepartmentID
    INNER JOIN DimDepartment ddep
        ON dep.DepartmentID = ddep.DepartmentID

    INNER JOIN Hospital_OLTP.dbo.Room r
        ON a.RoomID = r.RoomID
    INNER JOIN DimRoom dr
        ON r.RoomID = dr.RoomID

    INNER JOIN DimDate ddate
        ON ddate.FullDate = a.AdmissionDate

    INNER JOIN Hospital_OLTP.dbo.Bill b
        ON a.AdmissionID = b.AdmissionID
        AND b.%%physloc%% NOT IN
        (
            SELECT RowID
            FROM DQLog
            WHERE TableName = 'Bill'
              AND RuleNo = 2
              AND Action = 'reject'
        )

    LEFT JOIN Hospital_OLTP.dbo.Treatment t
        ON a.AdmissionID = t.AdmissionID
        AND t.%%physloc%% NOT IN
        (
            SELECT RowID
            FROM DQLog
            WHERE TableName = 'Treatment'
              AND RuleNo = 1
              AND Action = 'reject'
        )

    GROUP BY
        a.AdmissionID,
        dp.PatientKey,
        ddoc.DoctorKey,
        ddep.DepartmentKey,
        dr.RoomKey,
        ddate.DateKey,
        b.TotalAmount,
        a.AdmissionDate,
        a.DischargeDate
) AS src
ON fa.AdmissionID = src.AdmissionID

WHEN MATCHED THEN
    UPDATE SET
        fa.PatientKey = src.PatientKey,
        fa.DoctorKey = src.DoctorKey,
        fa.DepartmentKey = src.DepartmentKey,
        fa.RoomKey = src.RoomKey,
        fa.DateKey = src.DateKey,
        fa.TreatmentCount = src.TreatmentCount,
        fa.TreatmentCost = src.TreatmentCost,
        fa.BillAmount = src.BillAmount,
        fa.LengthOfStay = src.LengthOfStay

WHEN NOT MATCHED THEN
    INSERT
    (
        AdmissionID,
        PatientKey,
        DoctorKey,
        DepartmentKey,
        RoomKey,
        DateKey,
        TreatmentCount,
        TreatmentCost,
        BillAmount,
        LengthOfStay
    )
    VALUES
    (
        src.AdmissionID,
        src.PatientKey,
        src.DoctorKey,
        src.DepartmentKey,
        src.RoomKey,
        src.DateKey,
        src.TreatmentCount,
        src.TreatmentCost,
        src.BillAmount,
        src.LengthOfStay
    );
GO

SELECT * FROM DimPatient;
SELECT * FROM DimDoctor;
SELECT * FROM DimDepartment;
SELECT * FROM DimRoom;
SELECT * FROM DimDate;

USE Hospital_OLAP
GO
SELECT * FROM FactAdmission