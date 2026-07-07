USE Hospital_OLTP;
GO

-- Rule 1 Reject: TreatmentCost cannot be zero or negative
UPDATE Treatment
SET TreatmentCost = -50.00
WHERE TreatmentID = 608;

-- Rule 2 Reject: Bill TotalAmount cannot be zero or negative
UPDATE Bill
SET TotalAmount = -100.00
WHERE BillID = 703;

-- Rule 3 Fix: Gender should be Male/Female, not M/F
UPDATE Patient
SET Gender = 'M'
WHERE PatientID = 203;

UPDATE Patient
SET Gender = 'F'
WHERE PatientID = 206;

-- Rule 4 Fix: City should not have extra spaces
UPDATE Patient
SET City = '  Auckland  '
WHERE PatientID = 201;

-- Rule 5 Allow: Missing phone is allowed but logged
UPDATE Patient
SET Phone = ''
WHERE PatientID = 208;
GO





USE Hospital_OLAP;
GO

IF OBJECT_ID('DQLog', 'U') IS NOT NULL
DROP TABLE DQLog;
GO

CREATE TABLE DQLog
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    RowID VARBINARY(32),
    DBName VARCHAR(50),
    TableName VARCHAR(50),
    RuleNo SMALLINT,
    Action VARCHAR(10) CHECK (Action IN ('allow', 'fix', 'reject')),
    Reason VARCHAR(255),
    LogDate DATETIME DEFAULT GETDATE()
);
GO




USE Hospital_OLAP;
GO

DELETE FROM DQLog;
GO

-- Rule 1: Reject TreatmentCost <= 0

INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action, Reason)
SELECT t.%%physloc%%, 'Hospital_OLTP', 'Treatment', 1, 'reject',
       'TreatmentCost is zero or negative'
FROM Hospital_OLTP.dbo.Treatment t
WHERE t.TreatmentCost <= 0;
GO

-- Rule 2: Reject TotalAmount <= 0

INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action, Reason)
SELECT b.%%physloc%%, 'Hospital_OLTP', 'Bill', 2, 'reject',
       'Bill TotalAmount is zero or negative'
FROM Hospital_OLTP.dbo.Bill b
WHERE b.TotalAmount <= 0;
GO

-- Rule 3: Fix Gender M/F

INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action, Reason)
SELECT p.%%physloc%%, 'Hospital_OLTP', 'Patient', 3, 'fix',
       'Gender should be converted from M/F to Male/Female'
FROM Hospital_OLTP.dbo.Patient p
WHERE p.Gender IN ('M', 'F');
GO

-- Rule 4: Fix City spaces

INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action, Reason)
SELECT p.%%physloc%%, 'Hospital_OLTP', 'Patient', 4, 'fix',
       'City contains leading or trailing spaces'
FROM Hospital_OLTP.dbo.Patient p
WHERE p.City <> LTRIM(RTRIM(p.City));
GO

-- Rule 5: Allow missing phone

INSERT INTO DQLog (RowID, DBName, TableName, RuleNo, Action, Reason)
SELECT p.%%physloc%%, 'Hospital_OLTP', 'Patient', 5, 'allow',
       'Phone is missing but allowed'
FROM Hospital_OLTP.dbo.Patient p
WHERE LTRIM(RTRIM(p.Phone)) = '';
GO



USE Hospital_OLAP;
GO

SELECT * FROM DQLog

