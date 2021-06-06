#### *James F. Mare`*
#### *TCSS 445*
#### *Final Submission*

# **Healthcare Database**
#### *by* **~James FM**

SQL Backend &amp; C#/Dapper Frontend GUI for TCSS445 Database Systems Design (Spring 2021)

 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

##### Assumptions: User can run an sql file type to set up database with SQL Sever

1. Take updated database creation using "Mare_James_backend.sql" and run it in SQL Sever.
		 2. Extract the files from "Mare_James_Final_Submission.zip"
		 3. Run the extracted *Executable*
		 4. You can now either SEARCH using the features found in the top left of the "Patients Search/Insert" window 
			that should have popped up under the header **"Search For Existing Patient(s)"** or althernatively you 
			can INSERT using the remaing features. **The following will give more information**
			1. SEARCH
				1. As long as you are correctly connected to the database then the search button will search for any 
					patient as with matching "Last Name" so as to be able to find all people with the same last name
					who may or may not be related who is also in the database.
				2. Two existing patients have the last names "Smith" and "Johnson"
				3. Capitalization is relevant.
				4. The output will be a list of patients depending on how many patients match your search criteria 
					and they should be order by PatientId in ascending order and should have the following format:
					"[PatientId] (Suffix) FirstName MiddleName LastName"
			2. INSERT
				1. Any TextBoxes with BLUE labels can be left empty for null values to take their place.
				2. Date format is (YYYY-MM-DD) and *must* be followed even in the case 0001-01-09 although any years 
					before 1880 would be unlikely.
				3. Phone # format is (##########) that is 10 digits without dashes and *must* also be followed.
				4. Gender can be any on the spectrum.
				5. Location ID's in the database are 10000000 & 10000001
				6. HSP ID's in the database are 1000 & 1001
				7. State abbrivation can be that of the USPS convention of being 2 characters but can also be the 
					longer territory abbrivation convention that allows states like Hawaii and Maine to be without
					an abbrivation.
				8. Zip Code allows for both 5 & the 9 digit versions. The 9 digit one follows the USPS convention and 
					the extra digits are supposed to tell the most efficient path.
				9. The age is a whole number
				10. The weight is in pounds as a whole number
				11. The height is in inches as a whole number
				12. The SSN is 9 digits****
					
			
 **** ***BUG*** - The only bug found was when leaving the SSN textbox empty in the UI *only from the ".exe". When ran from
the IDE it properly accepts an empty entry. In the SQL database the SSN is nullable but for some reason
only in the ".exe" version does it show an error that the SSN can't be nullable do to it also having a 
constraint attached to SSN. *Again, the Bug is in the Executable version, not the IDE version.


 *** Addithionally the raw source files for the project will be incledded in "Mare_James_SQLHeathcareDatabaseAccess.zip"
	The project uses classes, is written in C# and needed the Dapper package installed for programming it. ** The 
	Executable does not need an IDE or the Dapper package installed, this was tested. The IDE used was Microsoft
	Visual Studio 2017 Community editiom (not VS Code). 

##### Referenced: https://youtu.be/Et2khGnrIqc

====================================================================================================================
##### Lastly 4 screenshots show the before & after shots of 2 senarios
	Senario 1#	a & b
	Senario 2#	a & b


##### Below is some values to readily INSERT some patients

	~For Executable Version: (w/ SSN just in case)
	10000001				10000001
	1001					1001
	Sir						Lizbeth
	Steven					Melany
	Murphy					31
	Smith					385962475
	26						120
	123987852				1990-01-01
	205						61
	1993-06-30				Female
	68						Kaiser Permanente
	2019-03-07				2238502512
	Male					4096105595
	Medicade				2530499476
	3608549625				381 Appleton Ave
	1352486192				Tumwater
	9382961754				WA
	5156 Plum St			98511
	Olympia					
	Wa						
	98805					

	~For IDE Version: (w/out SSN to prove it works other than with the screenshots)
	10000001				10000001
	1001					1001
	Meredith				Hazel
	Rodolph					Christine
	25						Johnson
	173						Female
	1997-10-24				22
	63						115
	Female					1999-6-15
	Labor & Industries		62
	7707417723				Medicade
	4261513865				8321572352
	5549302447				2872129650
	3289 Alder Lane			4036573930
	Tumwater				5914 Huntington St
	WA						Kelso
	98216					WA
							98435

====================================================================================================================

