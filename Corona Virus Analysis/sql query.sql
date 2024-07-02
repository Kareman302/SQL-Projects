select *from [Corona Dataset]
-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values

select * from [Corona Dataset]
where	 Province is null OR
		[Country_Region] is null OR
		Latitude is null OR
		Longitude is null OR
		Date is null OR
		Confirmed is null OR
		Deaths is null OR
		Recovered is null 
------------------------------------------------------------


--Q2. If NULL values are present, update them with zeros for all columns.

Update [Corona Dataset]
Set  
		Province = ISNULL(Province , ' ') ,
		Country_Region = ISNULL(Country_Region , ' ') ,
		Latitude = ISNULL (Latitude , 0.0 ) ,
		Longitude = ISNULL(Longitude , 0.0) ,
		Date = ISNULL(Date , GetDate()) ,
		Confirmed = ISNULL(Confirmed , ' ') ,
		Deaths = ISNULL(Deaths , ' ')  ,
		Recovered= ISNULL(Recovered , ' ') 





------------------------------------------------------------------------
-- Q3. check total number of rows
select count(*)   as Total_Rows
from [Corona Dataset] 
------------------------------------------------------------------------------



-- Q4. Check what is start_date and end_date
Select Min (Date) as  start_date , Max (Date) as end_date
from [Corona Dataset]






--------------------------------------------------------------


-- Q5. Number of month present in dataset

select  
	Distinct MONTH( Date)  as month_number , count(*) as Month_count
from [Corona Dataset]
group by  MONTH( Date)
order by  month_number asc 

-- Q5. Number of month present in dataset


select  
	YEAR (Date) AS Year ,
	Count (Distinct MONTH(Date))  as month_number 
from [Corona Dataset]
group by  YEAR (Date)
order by Year asc 



-----------------------------------------------------------------------------

-- Q6. Find monthly average for confirmed, deaths, recovered

Select 
		YEAR (Date) as Year, MONTH( Date)  as month_number , 
		Avg(Confirmed) as Avg_Confirmed  , 
		Avg(Recovered)  as Avg_Recovered ,
		Avg(Deaths) as Avg_Deaths
From [Corona Dataset]
group by  Month (Date), YEAR (Date)
Order by Year ,Month_NUmber  ASC


-------------------------------------------------------------------------------------

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

Select 
		YEAR (Date) as Year ,MONTH( Date)  as month_number ,
		Max(Confirmed) as Most_Frequent_Confirmed ,
		Max (Recovered) as Most_Frequent_Recoverd ,
		Max(Deaths) as Most_Frequent_Deaths

From [Corona Dataset]
Group BY YEAR (Date) , MONTH( Date)
Order By Year  ,  Month_NUmber   asc

-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

With FrequentValues as (
    Select
		MONTH( Date)  as Month_number,
        YEAR (Date) as Year,
        Confirmed,
        Deaths,
        Recovered,
        Rank () over (Partition  By MONTH( Date),  YEAR (Date) ORDER BY COUNT(*) DESC) as RN
    From
        [Corona Dataset]
    Group By
        MONTH( Date)  , YEAR (Date), Confirmed, Deaths, Recovered
)
Select
	Year,
    Month_number,
    Confirmed,
    Deaths,
    Recovered
From
    FrequentValues
Where
    RN = 1
Order By
    YEAR,  month_number ASC;





------------------------------------------------------------------------------

-- Q8. Find minimum values for confirmed, deaths, recovered per year

Select 
		YEAR (Date) as Year ,
		Min(Confirmed) as Min_Confirmed ,
		Min (Recovered) as Min_Recoverd ,
		Min(Deaths) as Min_Deaths

From [Corona Dataset]
Group BY YEAR (Date) 
Order By Year  asc

------------------------------------------------------------------------

-- Q9. Find maximum values of confirmed, deaths, recovered per year

Select 
		YEAR (Date) as Year ,
		Max(Confirmed) as Max_Confirmed ,
		Max (Recovered) as Max_Recoverd ,
		Max(Deaths) as Max_Deaths

From [Corona Dataset]
Group BY YEAR (Date) 
Order By Year  asc
------------------------------------------------------------------------

-- Q10. The total number of case of confirmed, deaths, recovered each month

Select
		YEAR (Date) as Year , Month( Date) as Month_NUmber ,
		Sum(Confirmed) as Sum_Confirmed ,
		Sum(Recovered) as Sum_Recoverd ,
		Sum(Deaths) as Sum_Deaths

From [Corona Dataset]
Group by YEAR (Date)  , Month ( Date)
Order by  1 ,  2
----------------------------------------------------------------------------------

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
	YEAR (Date) as Year,
	MONTH (Date) AS month_num,
	SUM(Confirmed) AS total_confirmed,
	AVG(Confirmed) AS avg_confirmed,
	ROUND(VAR(Confirmed),2) AS variance_confirmed,
	ROUND(STDEV(Confirmed),2) AS standard_dev_confirmed

FROM [Corona Dataset]
GROUP BY YEAR (Date) , MONTH (Date)
ORDER BY year , month_num ASC;

-------------------------------------------------------------------------------
-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
	YEAR (Date) as Year,
	MONTH (Date) AS month_num,
	SUM(Deaths) AS total_Deaths,
	AVG(Deaths) AS avg_Deaths,
	ROUND(VAR(Deaths),2) AS variance_Deaths,
	ROUND(STDEV(Deaths),2) AS standard_dev_Deaths

FROM [Corona Dataset]
GROUP BY YEAR (Date) , MONTH( Date)
ORDER BY year , month_num ASC;
-----------------------------------------------------------------------------------

-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
	YEAR (Date) as Year,
	MONTH (Date) AS month_num,
	SUM(Recovered) AS total_Recovered,
	AVG(Recovered) AS avg_Recovered,
	ROUND(VAR(Recovered),2) AS variance_Recovered,
	ROUND(STDEV(Recovered),2) AS standard_dev_Recovered

FROM [Corona Dataset]
GROUP BY YEAR (Date) , MONTH (Date)
ORDER BY year, month_num ASC;
---------------------------------------------------------------------------------

-- Q14. Find Country having highest number of the Confirmed case

SELECT Top (1 )Country_Region , sum(Confirmed)  as Total_Confirmed
From [Corona Dataset]
group by Country_Region 
order by  Total_Confirmed desc

------------------------------------------------------------------------

-- Q15. Find Country having lowest number of the death case

SELECT Country_Region , Sum(Deaths) as Total_Deaths
From [Corona Dataset]
group by Country_Region
having sum(Deaths )= 0



-----------------------------------------------------------------------------------
-- Q16. Find top 5 countries having highest recovered case

SELECT TOP (5) Country_Region , sum(Recovered) as Highest_Recovered
from [Corona Dataset]
Group By Country_Region
Order By Highest_Recovered desc


















		


















