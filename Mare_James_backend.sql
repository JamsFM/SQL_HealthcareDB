--References:
--https://www.geeksforgeeks.org/sql-ddl-dql-dml-dcl-tcl-commands/
--https://www.w3schools.com/sql/sql_datatypes.asp

/*
https://stackoverflow.com/questions/36045875/constraint-for-phone-number-in-sql-server
https://stackoverflow.com/questions/75105/what-datatype-should-be-used-for-storing-phone-numbers-in-sql-server-2005/17784147
https://www.sqlservercentral.com/forums/topic/how-to-format-phone-number
https://stackoverflow.com/questions/75105/what-datatype-should-be-used-for-storing-phone-numbers-in-sql-server-2005
https://www.google.com/search?client=firefox-b-1-d&q=zip+code+length
*/


/*USE master
GO
DROP DATABASE Mare_James_db
GO*/
CREATE DATABASE Mare_James_db
GO
USE Mare_James_db
GO

--DROP TABLE Healthcare_Service_Providers
CREATE TABLE Healthcare_Service_Providers(
	HSP_Id int NOT NULL IDENTITY(1000,1), --increment
	HSP_Name VARCHAR(100),
	HSP_Type VARCHAR(15) CONSTRAINT HSP_TypeValues CHECK (HSP_Type IN ('Private', 'State')),
	PRIMARY KEY (HSP_Id)
)
INSERT INTO Healthcare_Service_Providers VALUES('Kaiser Permanente', 'Private');
INSERT INTO Healthcare_Service_Providers VALUES('Providence', 'Private');
SELECT * FROM Healthcare_Service_Providers

--DROP TABLE Healthcare_Institutions
CREATE TABLE Healthcare_Institutions(
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int NOT NULL IDENTITY(10000000,1), --increment
	PRIMARY KEY (LocationId),
	InstitutionType VARCHAR(25) CONSTRAINT InstTypeValues CHECK (InstitutionType IN ('Private', 'State')),
	PhoneNumber CHAR(10),
	FaxNumber CHAR(10),
	StreetAddr VARCHAR(50),
	CityAddr VARCHAR(25),
	StateAbbreviationAddr VARCHAR(5),
	ZipCodeAddr VARCHAR(9), --add constraint for it being 6 or 9 ints long
	CONSTRAINT HIPhoneCheck CHECK (PhoneNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT HIFaxCheck CHECK (FaxNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT HIUC_Numbers UNIQUE (PhoneNumber, FaxNumber) 
)
INSERT INTO Healthcare_Institutions VALUES(1000, 'Private', '3609237000', '3221568245', '700 Lilly Rd NE', 'Olympia', 'WA', '98506');
INSERT INTO Healthcare_Institutions VALUES(1000, 'Private', '5038132000', '3254685217', '1230 7th Ave', 'Longview', 'WA', '98632');
INSERT INTO Healthcare_Institutions VALUES(1001, 'Private', '3607362803', '3586522486', '914 S Scheuber Rd', 'Centralia', 'WA', '98531');
INSERT INTO Healthcare_Institutions VALUES(1001, 'Private', '3604919480', '2411095271', '413 Lilly Rd NE', 'Olympia', 'WA', '98506');
SELECT * FROM Healthcare_Institutions

--DROP TABLE Hospitals
CREATE TABLE Hospitals(
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	HospitalName VARCHAR(100),
)
INSERT INTO Hospitals VALUES(1001, 10000002, 'Providence Centralia Hospital');
INSERT INTO Hospitals VALUES(1001, 10000003, 'Providence St. Peter Hospital');
SELECT * FROM Hospitals

--DROP TABLE HospitalWings
CREATE TABLE HospitalWings(
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	HospitalWing VARCHAR(100) CONSTRAINT HospitalWingValues CHECK (HospitalWing IN ('Physical Therapy', 'Imaging/Radiology', 'Emergency Room', 'Trauma Center', 'Psychiatric', 'Cancer', 'Maternity', 'Intensive Care Units', 'Non-Intensive Care Units'))
)
INSERT INTO HospitalWings VALUES(1001, 10000002, 'Maternity');
INSERT INTO HospitalWings VALUES(1001, 10000002, 'Psychiatric');
INSERT INTO HospitalWings VALUES(1001, 10000002, 'Imaging/Radiology');
INSERT INTO HospitalWings VALUES(1001, 10000002, 'Emergency Room');
INSERT INTO HospitalWings VALUES(1001, 10000003, 'Imaging/Radiology');
INSERT INTO HospitalWings VALUES(1001, 10000003, 'Emergency Room');
INSERT INTO HospitalWings VALUES(1001, 10000003, 'Physical Therapy');
INSERT INTO HospitalWings VALUES(1001, 10000003, 'Maternity');
SELECT * FROM HospitalWings

--DROP TABLE Clinics
CREATE TABLE Clinics(
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	ClinicName VARCHAR(100),
	ClinicType VARCHAR(25) CONSTRAINT ClinicTypeValues CHECK (ClinicType IN ('Primary Care', 'Specialized', 'Mental Health', 'Sexual Health'))
)
INSERT INTO Clinics VALUES(1000, 10000000, 'Kaiser Permanente Olympia Medical Center', 'Specialized');
INSERT INTO Clinics VALUES(1000, 10000001, 'Kaiser Permanente Longview-Kelso Medical Office', 'Primary Care');
SELECT * FROM Clinics



--DROP TABLE Insurances_Accepted
CREATE TABLE Insurances_Accepted(
	InsuranceId int NOT NULL IDENTITY(1000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (InsuranceId),
	InsuranceName VARCHAR(50),
	InsuranceType VARCHAR(15) CONSTRAINT InsuranceTypeValues CHECK (InsuranceType IN ('Private', 'State', 'Government', 'Workers'' Comp')),
	PhoneNumber CHAR(10),
	FaxNumber CHAR(10),
	CONSTRAINT IAPhoneCheck CHECK (PhoneNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT IAFaxCheck CHECK (FaxNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT IAUC_Numbers UNIQUE (PhoneNumber, FaxNumber) 
)
INSERT INTO Insurances_Accepted VALUES(1000, 10000000, 'Medicare', 'Government', '8089776422', '8543308407');
INSERT INTO Insurances_Accepted VALUES(1000, 10000000, 'Community Health Plan of Washington', 'State', '1615342512', '8881916745');
INSERT INTO Insurances_Accepted VALUES(1000, 10000001, 'Medicade', 'Government', '4594285413', '7840891618');
INSERT INTO Insurances_Accepted VALUES(1000, 10000001, 'Labor & Industries', 'Workers'' Comp', '4455203574', '9868419291');
INSERT INTO Insurances_Accepted VALUES(1000, 10000001, 'State Accident Insurance Fund', 'Workers'' Comp', '7291157276', '6711541274')
INSERT INTO Insurances_Accepted VALUES(1000, 10000001, 'Kaiser Permanente', 'Private', '3582671549', '3852691228');
SELECT * FROM Insurances_Accepted

--DROP TABLE Local_Pharmacies
CREATE TABLE Local_Pharmacies(
	PharmacyId int NOT NULL IDENTITY(1000000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (PharmacyId),
	PharmacyName VARCHAR(50),
	PhoneNumber CHAR(10),
	FaxNumber CHAR(10),
	StreetAddr VARCHAR(50),
	CityAddr VARCHAR(25),
	StateAbbreviationAddr VARCHAR(5),
	ZipCodeAddr VARCHAR(9),
	CONSTRAINT LPPhoneCheck CHECK (PhoneNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT LPFaxCheck CHECK (FaxNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT LPUC_Numbers UNIQUE (PhoneNumber, FaxNumber) 
)
INSERT INTO Local_Pharmacies VALUES(1000, 10000000, 'Rite Aid', '3607548014', '2631932360', '305 Cooper Point Rd NW Suite 103', 'Olympia', 'WA', '98502');
INSERT INTO Local_Pharmacies VALUES(1000, 10000001, 'Walgreens', '3602321021', '6117573984', '2939 Ocean Beach Hwy', 'Longview', 'WA', '98632');
SELECT * FROM Local_Pharmacies


/*TRUNCATE TABLE Employments
DROP TABLE Employments*/
CREATE TABLE Employments(
	EmployeeId int NOT NULL IDENTITY(10000000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (EmployeeId),
	HireDate date,
	isInTraining VARCHAR(3) CONSTRAINT isInTrainingCheck CHECK(isInTraining IN ('Yes', 'No'))
)
INSERT INTO Employments VALUES(1000, 10000000, '2008-11-11', 'No');
INSERT INTO Employments VALUES(1001, 10000002, '2008-10-29', 'No');
INSERT INTO Employments VALUES(1000, 10000000, '2011-11-11', 'Yes');
INSERT INTO Employments VALUES(1001, 10000002, '2004-12-29', 'No');
SELECT * FROM Employments

--DROP TABLE Employees
CREATE TABLE Employees(
	EmployeeId int REFERENCES Employments(EmployeeId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	NameSuffix VARCHAR(5) NULL,
	FName VARCHAR(50),
	MName VARCHAR(50) NULL,
	LName VARCHAR(50),
	SSN CHAR(9) NULL, --CHECK(DATALENGTH(SSN)=9),
	Position VARCHAR(25),
	SalaryPerHr smallmoney,
	PrimaryPhone CHAR(10),
	SecondaryPhone CHAR(10),
	EmergencyContactPhone CHAR(10),
	StreetAddr VARCHAR(50),
	CityAddr VARCHAR(25),
	StateAbbreviationAddr VARCHAR(5),
	ZipCodeAddr VARCHAR(9),
	CONSTRAINT ESSNCheck CHECK (SSN not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT EPhone1Check CHECK (PrimaryPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT EPhone2Check CHECK (SecondaryPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT EPhoneEmergencyCheck CHECK (EmergencyContactPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT EUC_Numbers UNIQUE (PrimaryPhone, SecondaryPhone, EmergencyContactPhone) 
)
INSERT INTO Employees VALUES(10000000, 1000, 10000000, NULL, 'Jake', 'Sara', 'Smith', '816931801', 'Doctor', 18, '4591332968', '8808526953', '8219212163', '35 Cooper Rd', 'Olympia', 'WA', '98502');
INSERT INTO Employees VALUES(10000001, 1000, 10000001, 'Jr', 'John', NULL, 'Jameson', '672818094', 'Doctor', 19, '6884045825', '9633720007', '4777713533', '299 Ocean Beach Hwy', 'Longview', 'WA', '98632');
INSERT INTO Employees VALUES(10000001, 1000, 10000001, NULL, 'Micheal', 'Sara', 'Jameson', '672818094', 'Nurse', 21, '6542311882', '9846538741', '6864352248', '3557 Blackberry Ave', 'Kelso', 'WA', '98182');
INSERT INTO Employees VALUES(10000001, 1000, 10000001, NULL, 'Larry', 'Jebb', 'Livingston', NULL, 'Technician', 18, '2325572965', '3216813585', '3545468211', '1259 Oakland St', 'Longview', 'WA', '98225');
SELECT * FROM Employees

--DROP TABLE Doctor
CREATE TABLE Doctor(
	EmployeeId int REFERENCES Employments(EmployeeId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Rating int,
	CONSTRAINT RatingCheck CHECK (Rating like '[1-5]'), -- check that only ints between 1-5
)
INSERT INTO Doctor VALUES(10000000, 1000, 10000000, 5);
INSERT INTO Doctor VALUES(10000001, 1000, 10000001, 4);
SELECT * FROM Doctor

--DROP TABLE Openings
CREATE TABLE Openings(
	EmployeeId int REFERENCES Employments(EmployeeId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	WorkDate date,
	StartTime time,
	EndTime time
)
INSERT INTO Openings VALUES(10000000, 1000, 10000000, '2021-6-10', '11:00:00', '16:59:59');
INSERT INTO Openings VALUES(10000001, 1000, 10000001, '2021-6-18', '12:00:00', '13:59:59');
SELECT * FROM Openings

--DROP TABLE Work_Schedules
CREATE TABLE Work_Schedules(
	ScheduleId int NOT NULL IDENTITY(10000000,1), --increment
	EmployeeId int REFERENCES Employments(EmployeeId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (ScheduleId),
	WorkDate date,
	ShiftStartTime time,
	ShiftEndTime time
)
INSERT INTO Work_Schedules VALUES(10000000, 1000, 10000000, '2020-10-6', '7:00:00', '13:59:59');
INSERT INTO Work_Schedules VALUES(10000001, 1000, 10000001, '2020-10-8', '8:00:00', '15:59:59');
SELECT * FROM Work_Schedules



/*TRUNCATE TABLE Patients
DROP TABLE Patients*/
CREATE TABLE Patients(
	PatientId int NOT NULL IDENTITY(10000000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (PatientId),
	NameSuffix VARCHAR(5) NULL,
	FName VARCHAR(50),
	MName VARCHAR(50) NULL,
	LName VARCHAR(50),
	SSN CHAR(9) NULL, --CONSTRAINT SSNLengthCheck CHECK(DATALENGTH(SSN)=9),
	Gender VARCHAR(25),
	Age int,
	DOB date,
	WeightInLbs int,
	HeightOnlyInInches int,
	Insurance VARCHAR(50),
	DOD date NULL,
	PrimaryPhone CHAR(10),
	SecondaryPhone CHAR(10),
	EmergencyContactPhone CHAR(10),
	StreetAddr VARCHAR(50),
	CityAddr VARCHAR(25),
	StateAbbreviationAddr VARCHAR(6),
	ZipCodeAddr VARCHAR(9),
	CONSTRAINT PSSNCheck CHECK (SSN not like '%[^0-9]%'), -- check that only ints
	--CONSTRAINT PBirthValuesCheck CHECK (DOB LIKE '[0-999]'),
	CONSTRAINT PDeathValuesCheck CHECK (DOB < DOD),
	--CONSTRAINT PValidBirthYear CHECK (DOB LIKE '[1890-2100]-[0-12]-[1-31]'), -- check if reasonable year
	--CONSTRAINT PValidDeathYear CHECK (DOD LIKE '[1-2][8-9][0-9][0-9]-[0-12]-[1-31]'), -- check if reasonable year
	CONSTRAINT PPhone1Check CHECK (PrimaryPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT PPhone2Check CHECK (SecondaryPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT PPhoneEmergencyCheck CHECK (EmergencyContactPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT PUC_Numbers UNIQUE (PrimaryPhone, SecondaryPhone, EmergencyContactPhone)
)
INSERT INTO Patients VALUES(1000, 10000000, NULL, 'James', 'Mark', 'Smith', '381150715', 'Nonbinary', 18, '2001-2-15', 181, 72, 'Medicare', NULL, '4591332968', '8808526953', '8219212163', '545 Cooper Rd', 'Olympia', 'WA', '98502')
INSERT INTO Patients VALUES(1000, 10000001, 'Jr', 'Luke', NULL, 'Johnson', NULL, 'Male', 19, '2000-6-15', 153, 70, 'Medicade', '2019-09-05', '6884045825', '9633720007', '4777713533', '534 Ocean Beach Hwy', 'Longview', 'WA', '98632')
SELECT * FROM Patients

--DROP TABLE Allergies
CREATE TABLE Allergies(
	AllergyId int NOT NULL IDENTITY(1000000,1), --increment
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (AllergyId),
	Allergen VARCHAR(100),
	ReactionDescription VARCHAR(500)
)
INSERT INTO Allergies VALUES(10000000, 1000, 10000000, 'Benadryl', 'Rash on arms; Use EpiPen');
INSERT INTO Allergies VALUES(10000001, 1000, 10000001, 'Peanut', 'Oral swelling; Use EpiPen');
SELECT * FROM Allergies

--DROP TABLE Perscriptions
CREATE TABLE Perscriptions(
	PerscriptionId int NOT NULL IDENTITY(1000000000,1), --increment
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (PerscriptionId),
	DateGiven date,
	ItemName VARCHAR(100),
	Dosage VARCHAR(50),
	UsageDescription VARCHAR(250),
	isCurrent VARCHAR(3) CONSTRAINT isCurrentCheck CHECK(isCurrent IN ('Yes', 'No'))
)
INSERT INTO Perscriptions VALUES(10000000, 1000, 10000000, '2005-6-8', 'Naproxen', '500 mg tablet', '1 by mouth every 12 hrs', 'No');
INSERT INTO Perscriptions VALUES(10000001, 1000, 10000001, '2015-2-11', 'Xanax', '250 mg tablet', '1 by mouth every 8 hrs', 'Yes');
SELECT * FROM Perscriptions

--DROP TABLE Relatives
CREATE TABLE Relatives(
	--Patient
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Relation VARCHAR(100),
	--Family Member
	RelativeId int REFERENCES Patients(PatientId)
)
INSERT INTO Relatives VALUES(10000001, 1000, 10000000, 'Cousin on mother''s side', 10000000);
INSERT INTO Relatives VALUES(10000000, 1000, 10000001, 'Cousin on father''s side', 10000001);
SELECT * FROM Relatives

--DROP TABLE GeneralPractitioners
CREATE TABLE GeneralPractitioners(
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	GPLName VARCHAR(50),
	ClinicNameToSeeGP VARCHAR(100),
)
INSERT INTO GeneralPractitioners VALUES(10000001, 1000, 10000000, 'Landrum', 'Valley View Health Center - Walk-In Clinic');
INSERT INTO GeneralPractitioners VALUES(10000000, 1000, 10000001, 'Miller', 'Olympia Integrative Medicine-Family Practice Clinic');
SELECT * FROM GeneralPractitioners

--DROP TABLE Visits
CREATE TABLE Visits(
	VisitId int NOT NULL IDENTITY(1000000000,1), --increment
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (VisitId),
	VisitDay date,
	VisitStartTime time,
	VisitEndTime time,
	VisitDescription VARCHAR(2000)
)
INSERT INTO Visits VALUES(10000000, 1000, 10000000, '2021-12-20', '17:00:00', '16:59:59', 'Check up, Rash on lower back, steroid cream prescribed');
INSERT INTO Visits VALUES(10000001, 1000, 10000001, '2020-1-18', '10:00:00', '10:29:59', 'Check up, No symptoms, Slightly stessed');
SELECT * FROM Visits

--DROP TABLE EmployeesSeen
CREATE TABLE EmployeesSeen(
	VisitId int REFERENCES Visits(VisitId),
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	EmployeeSeenId int REFERENCES Employments(EmployeeId) --CHECK (EmployeeSeenId IN (SELECT EmployeeId FROM Employments))
)
INSERT INTO EmployeesSeen VALUES(1000000000, 10000000, 1000, 10000000, 10000001);
INSERT INTO EmployeesSeen VALUES(1000000001, 10000001, 1000, 10000001, 10000000);
SELECT * FROM EmployeesSeen

--DROP TABLE Referrals
CREATE TABLE Referrals(
	ReferralId int NOT NULL IDENTITY(100000,1), --increment
	VisitId int REFERENCES Visits(VisitId),
	PatientId int REFERENCES Patients(PatientId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (ReferralId),
	ReferrerId int REFERENCES Employments(EmployeeId),
	DateGiven date,
	ReferralDescription VARCHAR(2000),
	DestinationName VARCHAR(100),
	DestPhone CHAR(10),
	DestFaxNumber CHAR(10),
	DestStreet VARCHAR(50),
	DestCity VARCHAR(25),
	DestStateAbbreviation VARCHAR(5),
	DestZipCode VARCHAR(9),
	CONSTRAINT RPhoneCheck CHECK (DestPhone not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT RFaxCheck CHECK (DestFaxNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT RUC_Numbers UNIQUE (DestPhone, DestFaxNumber) 
)
INSERT INTO Referrals VALUES(1000000000, 10000000, 1000, 10000000, 10000001, '2020-5-10', 'Having difficulty controlling temper; recommend mental therepy', 'Cascade Counseling', '3608667406', '1297899479', '2100 Caton Way SW', 'Olympia', 'WA', '98502');
INSERT INTO Referrals VALUES(1000000001, 10000001, 1000, 10000001, 10000001, '2020-5-10', 'Sudden symptoms of carpal tunnel; recommend physical therepy', 'Penrose & Associates Physical Therapy', '3604561444', '6535004962', '1445 Galaxy Dr NE', 'Lacey', 'WA', '98516');
SELECT * FROM Referrals



--DROP TABLE Supplies_Stocked
CREATE TABLE Supplies_Stocked(
	ItemId int NOT NULL IDENTITY(1000000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (ItemId),
	ItemName VARCHAR(100) NOT NULL,
	SupplyType VARCHAR(50) CONSTRAINT SupplyTypeCheck CHECK(SupplyType IN ('Medication', 'Medical', 'Lab', 'Office'))
)
INSERT INTO Supplies_Stocked VALUES(1001, 10000003,'Clip Boards', 'Office');
INSERT INTO Supplies_Stocked VALUES(1001, 10000003,'O Negative Blood Bags', 'Medical');
INSERT INTO Supplies_Stocked VALUES(1001, 10000002,'Centrifuge Test Tubes', 'Lab');
INSERT INTO Supplies_Stocked VALUES(1001, 10000002,'Advil 200 mg Tablets', 'Medication');
INSERT INTO Supplies_Stocked VALUES(1001, 10000003,'Black Printer Toner', 'Office');
INSERT INTO Supplies_Stocked VALUES(1001, 10000003,'U-100 Insulin Syringe Needles', 'Medical');
INSERT INTO Supplies_Stocked VALUES(1001, 10000002,'Covid-19 Test Kits', 'Lab');
SELECT * FROM Supplies_Stocked

--DROP TABLE Medication_Supplies
CREATE TABLE Medication_Supplies(
	ItemId int REFERENCES Supplies_Stocked(ItemId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Quantity int,
	UseDescription VARCHAR(250) NULL,
	StorageLocation VARCHAR(50),
	--CONSTRAINT MedicationValidQuantity CHECK (Quantity LIKE '[0000-9999]')
)
INSERT INTO Medication_Supplies VALUES(1000003, 1000, 10000002, 1065, 'Take oraly only as directed', 'shelf 5 in medicine locker');
SELECT * FROM Medication_Supplies

--DROP TABLE Office_Supplies
CREATE TABLE Office_Supplies(
	ItemId int REFERENCES Supplies_Stocked(ItemId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Quantity int,
	UseDescription VARCHAR(250) NULL,
	StorageLocation VARCHAR(50),
	--CONSTRAINT MedicationValidQuantity CHECK (Quantity LIKE '[0000-9999]')
)
INSERT INTO Office_Supplies VALUES(1000000, 1001, 10000003, 50, NULL, 'General Storage Closet 4');
INSERT INTO Office_Supplies VALUES(1000004, 1001, 10000003, 10, 'For Canon lazer printers in the reception area', 'General Storage Closet 2');
SELECT * FROM Office_Supplies

--DROP TABLE Lab_Supplies
CREATE TABLE Lab_Supplies(
	ItemId int REFERENCES Supplies_Stocked(ItemId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Quantity int,
	UseDescription VARCHAR(250) NULL,
	StorageLocation VARCHAR(50),
	--CONSTRAINT MedicationValidQuantity CHECK (Quantity LIKE '[0000-9999]')
)
INSERT INTO Lab_Supplies VALUES(1000001, 1001, 10000003, 43, 'For blood transfusions', 'Blood Bank refrigerator In ICU');
INSERT INTO Lab_Supplies VALUES(1000006, 1001, 10000002, 650, 'For testing if an individual has Covid-19', 'Labratory Storage Closet 2');
SELECT * FROM Lab_Supplies

--DROP TABLE Medical_Supplies
CREATE TABLE Medical_Supplies(
	ItemId int REFERENCES Supplies_Stocked(ItemId),
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	Quantity int,
	UseDescription VARCHAR(250) NULL,
	StorageLocation VARCHAR(50),
	--CONSTRAINT MedicationValidQuantity CHECK (Quantity LIKE '[0000-9999]')
)
INSERT INTO Medical_Supplies VALUES(1000002, 1000, 10000002, 172, 'For use in centrifuge', 'Medical Storage Closet 2');
INSERT INTO Medical_Supplies VALUES(1000005, 1001, 10000003, 875, 'For administering various fluids', 'Medical Storage Closet 3');
SELECT * FROM Medical_Supplies

--DROP TABLE Suppliers
CREATE TABLE Suppliers(
	SupplierId int NOT NULL IDENTITY(1000,1), --increment
	HSP_Id int REFERENCES Healthcare_Service_Providers(HSP_Id),
	LocationId int REFERENCES Healthcare_Institutions(LocationId),
	PRIMARY KEY (SupplierId),
	SupplierName VARCHAR(100),
	PhoneNumber CHAR(10),
	FaxNumber CHAR(10),
	CONSTRAINT SPhoneCheck CHECK (PhoneNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT SFaxCheck CHECK (FaxNumber not like '%[^0-9]%'), -- check that only ints
	CONSTRAINT SUC_Numbers UNIQUE (PhoneNumber, FaxNumber) 
)
INSERT INTO Suppliers VALUES(1000, 10000002, 'Med Inc.', '8886542541', '1783094112');
INSERT INTO Suppliers VALUES(1001, 10000003, 'Blood Corp.', '3015075007', '1087662538');
SELECT * FROM Suppliers
