
USE Mare_James_db
GO

/*Healthcare_Service_Providers(HSP_Id, HSP_Name, HSP_Type)
Healthcare_Institutions(HSP_Id, LocationId, InstitutionType, PhoneNumber, FaxNumber, StreetAddr, CityAddr, StateAbbreviationAddr, ZipCodeAddr)
Hospitals(HSP_Id, LocationId, HospitalName)
HospitalWings(HSP_Id, LocationId, HospitalWing)
Clinics(HSP_Id, LocationId, ClinicName, ClinicType)
Insurances_Accepted(InsuranceId, HSP_Id, LocationId, InsuranceName, InsuranceType, PhoneNumber, FaxNumber)
Local_Pharmacies(PharmacyId, HSP_Id, LocationId, PharmacyName, PhoneNumber, FaxNumber, StreetAddr, CityAddr, StateAbbreviationAddr, ZipCodeAddr)
Employments(EmployeeId, HSP_Id, LocationId, HireDate, isInTraining)
Employees(EmployeeId, HSP_Id, LocationId, NameSuffix, FName, MName, LName, SSN, Position, SalaryPerHr, PrimaryPhone, SecondaryPhone, EmergencyContactPhone, StreetAddr, CityAddr, StateAbbreviationAddr, ZipCodeAddr)
Doctor(EmployeeId, HSP_Id, LocationId, Rating)
Openings(EmployeeId, HSP_Id, LocationId, WorkDate, StartTime, EndTime)
Work_Schedules(ScheduleId, EmployeeId, HSP_Id, LocationId, WorkDate, ShiftStartTime, ShiftEndTime)
Patients(PatientId, HSP_Id, LocationId, NameSuffix, FName, MName, LName, SSN, Gender, Age, DOB, WeightInLbs, HeightOnlyInInches, Insurance, DOD, PrimaryPhone, SecondaryPhone, EmergencyContactPhone, StreetAddr, CityAddr, StateAbbreviationAddr, ZipCodeAddr)
Allergies(AllergyId, PatientId, HSP_Id, LocationId, Allergen, ReactionDescription)
Perscriptions(PerscriptionId, PatientId, HSP_Id, LocationId, DateGiven, ItemName, Dosage, UsageDescription, isCurrent)
Relatives(PatientId, HSP_Id, LocationId, Relation, RelativeId)
GeneralPractitioners(PatientId, HSP_Id, LocationId, GPLName, ClinicNameToSeeGP)
Visits(VisitId, PatientId, HSP_Id, LocationId, VisitDay, VisitStartTime, VisitEndTime, VisitDescription)
EmployeesSeen(VisitId, PatientId, HSP_Id, LocationId, EmployeeSeenId)
Referrals(ReferralId, VisitId, PatientId, HSP_Id, LocationId, ReferrerId, DateGiven, ReferralDescription, DestinationName, DestPhone, DestFaxNumber, DestStreet, DestCity, DestStateAbbreviation, DestZipCode)
Supplies_Stocked(ItemId, HSP_Id, LocationId, ItemName, SupplyType)
Medication_Supplies(ItemId, HSP_Id, LocationId, Quantity, UseDescription, StorageLocation)
Office_Supplies(ItemId, HSP_Id, LocationId, Quantity, UseDescription, StorageLocation)
Lab_Stocked(ItemId, HSP_Id, LocationId, Quantity, UseDescription, StorageLocation)
Medical_Stocked(ItemId, HSP_Id, LocationId, Quantity, UseDescription, StorageLocation)
Suppliers(SupplierId, HSP_Id, LocationId, SupplierName, PhoneNumber, FaxNumber)*/

--7 scenarios and 5 analytical queries that were described in the project proposal (an updated version of the scenarios/analytical queries would be also accepted )

-- SEVEN Scenarios~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 1 - Updating medical history of patient anytime
INSERT INTO Allergies VALUES(10000000, 1000, 10000001, 'Peanut', 'Hives on chest and neck; Use EpiPen');
DELETE FROM Allergies WHERE AllergyId = '1000001';
INSERT INTO EmployeesSeen VALUES(1000000001, 10000001, 1000, 10000001, 10000000);
UPDATE GeneralPractitioners SET GPLName = 'Jackson' WHERE PatientId = '10000000';

-- 2 - View/Add/remove patient from database
SELECT * FROM Patients WHERE PatientId = '10000000'; -- shows data for the 1st patient in database
INSERT INTO Patients VALUES(1000, 10000001, NULL, 'Hazel', 'Christine', 'Johnson', NULL, 'Female', 22, '1999-6-15', 115, 62, 'Medicade', NULL, '8321572352', '2872129650', '4036573930', '5914 Huntington St', 'Kelso', 'WA', '98435');
DELETE FROM Patients WHERE PatientId = '10000000'; -- deletes the 1st patient in database

-- 3 - Record symptoms of patient during visit
INSERT INTO Visits VALUES(10000000, 1000, 10000001, '2021-2-12', '13:00:00', '13:59:59', 'Check up, Severe headaches persisting for 10 days, Slightly stessed');

-- 4 - Filing a prescription for patient
INSERT INTO Perscriptions VALUES(10000001, 1000, 10000000, '2021-06-18', 'Acyclovir', '400 mg tablet', 'Take 1 tablet by mouth 3 tiems a day for 5 to 7 days if needed', 'Yes');

-- 5 - Looking up all the doctors in a location with a rating equal to 5
SELECT * FROM Doctor WHERE Rating = 5;

-- 6 - Look up the contact information of a given insurance
SELECT * FROM Insurances_Accepted
SELECT InsuranceName, PhoneNumber, FaxNumber FROM Insurances_Accepted WHERE InsuranceId = 1003;

-- 7 - Veiw/Update Supply quantity
SELECT * FROM Medication_Supplies WHERE ItemId = '1000002';
UPDATE Medication_Supplies SET Quantity = 212 WHERE ItemId = '1000002';

/* Other Options:
	Add new employee to schedule
	Enter referral for patient to go to a specialized clinic
	Schedule a nurse for the next two weeks
	Grab patient contact info*/


-- FIVE Analytical Queries**********************************
-- 1 - How many Supplies in stock below a set minimum [ex: 100 O Negative Blood bags]
SELECT ItemId FROM ((SELECT ItemId, Quantity FROM Medication_Supplies)
	UNION (SELECT ItemId, Quantity FROM Lab_Supplies) 
	UNION (SELECT ItemId, Quantity FROM Medical_Supplies)) AS All_Supplies
	WHERE Quantity < 100;

-- 2 - All doctors with a rating of 4-5 stars, and who have openings in the future (let today = 2021-6-4) at a specific location
SELECT * FROM Doctor INNER JOIN Openings ON Doctor.EmployeeId = Openings.EmployeeId WHERE Rating >= 4 AND WorkDate > 2021-6-4 AND LocationId = 10000000;

-- 3 - All contact info for the institution that a g
SELECT TOP 1 RelativeId, CONCAT(FName, MName, LName) AS RelativeName, 
	PrimaryPhone, SecondaryPhone, StreetAddr, CityAddr, StateAbbreviationAddr, ZipCodeAddr
	FROM Patients INNER JOIN Relatives ON Patients.PatientId = RelativeId 
	WHERE Relatives.PatientId = 10000000;

-- 4 - Check if the patient’s insurance is accepted (IF SO then return insurance info)(IF NOT then nothing returned)
SELECT PatientId, Insurances_Accepted.* FROM Patients INNER JOIN Insurances_Accepted ON Patients.LocationId = Insurances_Accepted.LocationId 
	WHERE Patients.LocationId = 10000001 AND PatientId = 10000001 AND Insurance = InsuranceName;

-- 5 - All patients who are female and who are over 50 yrs old out of a given location with a 
--		filter on which insurance they have to offer available benefit plan through institution
SELECT * FROM Patients WHERE LocationId = 10000001 AND Insurance IN ('Medicade', 'Group Health') AND Age >= 50;

/* Other Options:
	All doctors on night shift last week
	Search all patients administered a particular drug in the last week (for drug recall)
	What other Locations a particular Orthopedic Surgeon works out of, and get their contact info
	All doctors with a rating of 1-2 stars who haven’t worked in over a month*/






















