CREATE DATABASE ITI_Sql_Project
GO
--------------------------------------------------------------------
USE ITI_Sql_Project
GO
--------------------------------------------------------------------
CREATE TABLE Demographics (
    CustomerID INT IDENTITY PRIMARY KEY,
    Gender VARCHAR(6),
    Age INT,
    Senior_Citizen AS (CASE WHEN Age >= 65 THEN 'Yes' ELSE 'No' END),
    Married VARCHAR(3),
    Number_of_Dependents INT,
    Zip_Code INT NOT NULL
);
----------------------------------
-----------------------------------
--Rules on Demographocs table------

create rule GenderRule 
as @gender in('Male', 'Female')

sp_bindrule GenderRule, '[dbo].[Demographics].[Gender]'
------------------------------
create rule Married 
as @married IN ('Yes', 'No')

sp_bindrule Married, '[dbo].[Demographics].[Married]'
------------------------------------------------
------------------------------------------------
------ Create the INSTEAD OF DELETE trigger----
CREATE or alter TRIGGER PreventDeleteFromDemographics
ON Demographics
INSTEAD OF DELETE
AS
BEGIN
   SELECT 'Delete operation is not allowed for table Demographics to user ' + SUSER_NAME() AS 'Announcement';
END;

---Try to PreventDelete 
delete from Demographics 
where CustomerID = 1
-----------------Trigger for update in Zip_Code----------------------------
CREATE OR ALTER TRIGGER AfterUpdateDemographics
ON [dbo].[Demographics]
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Zip_Code)
    BEGIN
        SELECT 'Location updated successfully, using Zip_Code column by ' + SUSER_NAME() AS Announcement;
    END
END;
------------------------------------
INSERT INTO Demographics (Gender, Age, Married, Number_of_Dependents, Zip_Code)
VALUES   ('Male', 20, 'Yes', 1, 100),
	('Male', 37, 'Yes', 3, 100),
	('Male', 20, 'Yes', 8, 101),
	('Male', 23, 'Yes', 3, 102),
	('Male', 20, 'Yes', 2, 101),
	('Male', 80, 'Yes', 7, 102),
	('Male', 20, 'Yes', 9, 100),
	('Male', 11, 'Yes', 0, 101),
	('Male', 20, 'No', 7, 100),
	('Male', 20, 'No', 1, 101),
	('Male', 20, 'No', 1, 100),
	('Male', 21, 'No', 1, 100),
	('Female', 87, 'Yes', 0, 103),
	('Male', 65, 'Yes', 4, 100),
	('Female', 50, 'No', 3, 104),
	('Male', 30, 'Yes', 8, 105),
	('Female', 20, 'Yes', 9, 104),
	('Female', 20, 'No', 1, 101),
	('Female', 20, 'Yes', 3, 101),
	('Female', 20, 'No', 2, 100),
	('Female', 20, 'No', 8, 102),
	('Female', 20, 'No', 3, 103),
	('Female', 77, 'Yes', 8, 104),
	('Female', 20, 'No', 2, 105),
	('Female', 88, 'No', 1, 105),
	('Female', 20, 'Yes', 1, 106),
	('Female', 83, 'No', 0, 103),
	('Female', 20, 'No', 1, 103),
	('Female', 36, 'Yes', 1, 104),
	('Female', 20, 'No', 8, 102);

---------------Check added data---------------------------
select * from Demographics 
-----------------------------------------------------------
-----------------------------------------------------------
CREATE TABLE Location (
    Zip_Code int PRIMARY KEY,
    Country VARCHAR(50),
    State VARCHAR(50),
    City VARCHAR(50)
);
-------------------------------------------------------------
INSERT INTO Location (Zip_Code, Country, State, City)
VALUES
    ('100', 'USA', 'California', 'Los Angeles'),
    ('101', 'Canada', 'Ontario', 'Toronto'),
    ('102', 'UK', 'London', 'London'),
    ('103', 'Germany', 'Bavaria', 'Munich'),
    ('104', 'France', 'Île-de-France', 'Paris'),
    ('105', 'Australia', 'New South Wales', 'Sydney'),
    ('106', 'Japan', 'Tokyo', 'Tokyo'),
    ('107', 'Australia', 'New South Wales', 'Tokyo');  

-- Verify the data-----------------------------------
SELECT * FROM Location;
--------------------------------------------------------
------ Create the INSTEAD OF DELETE trigger from ----
CREATE or alter TRIGGER PreventDeleteFromLocation
ON Location
INSTEAD OF DELETE
AS
BEGIN
   SELECT 'Delete operation is not allowed for table Location to user ' + SUSER_NAME() AS Announcement;
END;

---------------------Try to PreventDelete----------------------- 
delete from Location 
where Zip_Code = 100
---------------------------------------------------------
-----------------------------------------------------------
CREATE TABLE Service (
    CustomerID INT,
    Quar VARCHAR(3),
    Tenure_in_Months INT,
    Offer VARCHAR(6),
    Phone_Service VARCHAR(3),
    Internet_Service VARCHAR(11),
    Streaming_TV VARCHAR(3),
    Streaming_Movies VARCHAR(3),
    Streaming_Music VARCHAR(3),
    Avg_Monthly_GB_Download FLOAT,
    Contract VARCHAR(25) ,
    Payment_Method VARCHAR(25),
    Monthly_Charge DECIMAL(10, 2),
    Total_Charges AS (Monthly_Charge * Tenure_in_Months) PERSISTED,
    constraint PrimaryKey PRIMARY KEY (CustomerID, Quar),
    constraint ContractConstr CHECK (Contract IN ('Month-to-Month', 'One_Year', 'Two_Year')),
    constraint streamMusic CHECK (Streaming_Music IN ('Yes', 'No')),
    constraint StreamingMovies CHECK (Streaming_Movies IN ('Yes', 'No')),
    constraint StreamingTV CHECK (Streaming_TV IN ('Yes', 'No')),
    constraint PaymentMethod CHECK (Payment_Method IN ('Bank_Withdrawal', 'Credit_Card', 'Mailed_Check')),
    constraint InternetService CHECK (Internet_Service IN ('No', 'DSL', 'Fiber Optic', 'Cable'))
    
);
-----------------------------------------------------
------ Create the INSTEAD OF DELETE trigger from ----
CREATE or alter TRIGGER PreventDeleteFromService
ON Service
INSTEAD OF DELETE
AS
BEGIN
   SELECT 'Delete operation is not allowed for table Location to user ' + SUSER_NAME() + ' Just insert is allowed' AS Announcement;
END;

------------------------------------------------------
---Try to PreventDelete 
delete from Service 
where CustomerID = 2
------------------------------------------------------
create rule Offer_rule as
@offer IN ('None', 'A', 'B', 'C', 'D', 'E', 'Coupon')

sp_bindrule Offer_rule, '[dbo].[Service].[Offer]'
-----------------------------------------------------
create rule Phone_Service_Rule
as
@Phone_Service IN ('Yes', 'No')
go
sp_bindrule Phone_Service_Rule, '[dbo].[Service].[Phone_Service]'
-----------------------------------------------------
--==============================Constrains==============
ALTER TABLE Demographics
ADD CONSTRAINT FK_Demographics_Location
FOREIGN KEY (Zip_Code) REFERENCES Location(Zip_Code);
--------------------------------------------------------------
--------------------------------------------------------------

INSERT INTO Service (CustomerID, Quar, Tenure_in_Months, Offer, Phone_Service, Internet_Service, 
                    Streaming_TV, Streaming_Movies, Streaming_Music, Avg_Monthly_GB_Download, 
                    Contract, Payment_Method, Monthly_Charge)
VALUES
    (1, 1, 12, 'A', 'Yes', 'DSL', 'Yes', 'No', 'Yes', 100, 'One_Year', 'Credit_Card', 50.0),
    (2, 1, 24, 'B', 'Yes', 'Fiber Optic', 'Yes', 'Yes', 'No', 150, 'Two_Year', 'Bank_Withdrawal', 75.0),
    (3, 1, 12, 'C', 'No', 'DSL', 'No', 'No', 'Yes', 80, 'Month-to-Month', 'Credit_Card', 45.0),
    (4, 2, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'Yes', 120, 'One_Year', 'Bank_Withdrawal', 65.0),
    (5, 2, 12, 'D', 'Yes', 'Fiber Optic', 'No', 'Yes', 'No', 90, 'Month-to-Month', 'Mailed_Check', 55.0),
    (6, 3, 18, 'C', 'No', 'Cable', 'No', 'Yes', 'Yes', 200, 'Month-to-Month', 'Mailed_Check', 90.0),
    (7, 4, 12, 'D', 'Yes', 'DSL', 'No', 'Yes', 'No', 120, 'Month-to-Month', 'Credit_Card', 60.0),
    (8, 4, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (9, 2, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0),
    (10, 3, 12, 'B', 'Yes', 'DSL', 'Yes', 'Yes', 'No', 100, 'Two_Year', 'Credit_Card', 50.0),
    (11, 4, 24, 'D', 'No', 'Fiber Optic', 'No', 'Yes', 'Yes', 160, 'Month-to-Month', 'Bank_Withdrawal', 80.0),
    (12, 4, 12, 'D', 'Yes', 'DSL', 'No', 'Yes', 'No', 120, 'Month-to-Month', 'Credit_Card', 60.0),
    (13, 4, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (14, 2, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0),
    (15, 3, 18, 'C', 'No', 'Cable', 'No', 'Yes', 'Yes', 200, 'Month-to-Month', 'Mailed_Check', 90.0),
    (16, 1, 12, 'D', 'Yes', 'DSL', 'No', 'Yes', 'No', 120, 'Month-to-Month', 'Credit_Card', 60.0),
    (17, 2, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (18, 3, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0),
    (19, 4, 12, 'B', 'Yes', 'DSL', 'Yes', 'Yes', 'No', 100, 'Two_Year', 'Credit_Card', 50.0),
    (20, 1, 18, 'C', 'No', 'Cable', 'No', 'Yes', 'Yes', 200, 'Month-to-Month', 'Mailed_Check', 90.0),
    (21, 2, 12, 'D', 'Yes', 'DSL', 'No', 'Yes', 'No', 120, 'Month-to-Month', 'Credit_Card', 60.0),
    (22, 3, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (23, 4, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0),
    (24, 1, 18, 'C', 'No', 'Cable', 'No', 'Yes', 'Yes', 200, 'Month-to-Month', 'Mailed_Check', 90.0),
    (25, 3, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (26, 4, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0),
    (27, 1, 18, 'C', 'No', 'Cable', 'No', 'Yes', 'Yes', 200, 'Month-to-Month', 'Mailed_Check', 90.0),
    (28, 2, 12, 'D', 'Yes', 'DSL', 'No', 'Yes', 'No', 120, 'Month-to-Month', 'Credit_Card', 60.0),
    (29, 3, 24, 'E', 'No', 'Fiber Optic', 'Yes', 'No', 'Yes', 180, 'Two_Year', 'Bank_Withdrawal', 85.0),
    (30, 4, 18, 'A', 'Yes', 'Cable', 'Yes', 'No', 'No', 150, 'One_Year', 'Mailed_Check', 70.0)
   ;

------------------------Verify the data---------------------
select * from Service
-------------------------------------------------------------
CREATE TABLE Status (
    CustomerID INT,
    Quar VARCHAR(3),
    Satisfaction_Score INT,
    Customer_Status VARCHAR(10),
    Churn_Category VARCHAR(20) ,

    PRIMARY KEY (CustomerID, Quar),
    constraint CustomerStatus CHECK (Customer_Status IN ('Churned', 'Stayed', 'Joined')),
    constraint SatisfactionScore CHECK (Satisfaction_Score >= 1 AND Satisfaction_Score <= 5),
    constraint ChurnCategory CHECK (Churn_Category IN ('Attitude', 'Competitor', 'Dissatisfaction', 'Other', 'Price')),
    constraint Satisfaction_Score CHECK (Satisfaction_Score >= 1 AND Satisfaction_Score <= 5)
);
------------------------------------------------------------------

INSERT INTO Status (CustomerID, Quar, Satisfaction_Score, Customer_Status, Churn_Category)
VALUES
    (1, 1, 4, 'Stayed', 'Attitude'),
    (2, 1, 3, 'Churned', 'Competitor'),
    (3, 1, 5, 'Stayed', 'Other'),
    (4, 2, 2, 'Churned', 'Dissatisfaction'),
    (5, 2, 4, 'Stayed', 'Price'),
    (6, 2, 5, 'Stayed', 'Attitude'),
    (7, 3, 3, 'Churned', 'Competitor'),
    (8, 3, 5, 'Stayed', 'Other'),
    (9, 3, 2, 'Churned', 'Dissatisfaction'),
    (10, 4, 4, 'Stayed', 'Price'),
    (11, 4, 1, 'Churned', 'Attitude'),
    (12, 4, 4, 'Stayed', 'Competitor'),
    (13, 1, 5, 'Stayed', 'Other'),
    (14, 1, 2, 'Churned', 'Dissatisfaction'),
    (15, 1, 4, 'Stayed', 'Price'),
    (16, 2, 3, 'Churned', 'Attitude'),
    (17, 2, 5, 'Stayed', 'Competitor'),
    (18, 2, 2, 'Churned', 'Other'),
    (19, 3, 4, 'Stayed', 'Dissatisfaction'),
    (20, 3, 5, 'Stayed', 'Price'),
    (21, 3, 3, 'Churned', 'Attitude'),
    (22, 4, 5, 'Stayed', 'Competitor'),
    (23, 4, 2, 'Churned', 'Other'),
    (24, 4, 4, 'Stayed', 'Dissatisfaction'),
    (25, 1, 1, 'Churned', 'Price'),
    (26, 1, 4, 'Stayed', 'Attitude'),
    (27, 1, 3, 'Churned', 'Competitor'),
    (28, 2, 5, 'Stayed', 'Other'),
    (29, 2, 2, 'Churned', 'Dissatisfaction'),
    (30, 2, 4, 'Stayed', 'Price');
------------------------------
-----Verify the data
SELECT * FROM Status
-------------------------------------------------------------
--------------------Validate all data Together---------------
select d.*, c.*,s.*,st.* from  Demographics d
join Location c 
on  c.Zip_Code = d.Zip_Code
join Service s
on d.CustomerID  = s.CustomerID 
join Status st
on d.CustomerID = st.CustomerID
--------------------------------------------------------------
