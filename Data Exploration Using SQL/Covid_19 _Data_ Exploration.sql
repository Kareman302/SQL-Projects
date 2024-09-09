select*
from Covid_Deaths
--------------------------
select*
from Covid_Vaccination
------------------------------------------
--select Data that we are going to use

Select Location, date, total_cases, new_cases, total_deaths, population
From Covid_Deaths
---------------------------------------------
---- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths ,
 (convert(float,total_deaths)/nullif(convert(float,total_cases),0)) *100 as TotalDeaths_persentage
From Covid_Deaths
where location like '%states%' and continent is not null 
order by 1,2
-------------------------------------------------------------------------------
-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location,date,population, total_cases , 
(convert(float,total_cases)/ population)*100 as percentage_of_infectgedcases
from Covid_Deaths
where location like '%states%'
order by 1,2
--------------------------------------------------------------------
-- Countries with Highest Infection Rate compared to Population

select location, population, max(total_cases) as  HighestInfectioncount ,
max((convert(float,total_cases)/ population)*100) as percentage_of_infectgedcases
from Covid_Deaths
Where continent is not null 
group by location , population 
order by percentage_of_infectgedcases desc
------------------------------------------------------------------
-- Countries with Highest Death Count per Population

select location,  max(convert(float,total_deaths)) as Hieghestdeathsnum
from Covid_Deaths
where continent is not  null
group by location  
order by Hieghestdeathsnum desc
------------------------------------------------------------
-- GLOBAL NUMBERS

Select SUM(convert(float,new_cases)) as total_cases, SUM(convert(float,new_deaths)) as total_deaths,
SUM(convert(float,new_deaths))/SUM(convert(float,new_cases))*100 as DeathPercentage
From Covid_Deaths
where continent is not null 
order by 1,2
------------------------------------------------------------------

-- Total Population vs Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_Deaths dea
Join Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From Covid_Deaths dea
Join Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac
order by 2,3
-------------------------------------------------------------
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(50),
Location varchar(50),
Date varchar(50),
Population varchar(50),
New_vaccinations varchar(50),
RollingPeopleVaccinated varchar(50)
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From Covid_Deaths dea
Join  Covid_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *
From #PercentPopulationVaccinated
order by 2,3 
-------------------------------------------------------------------------------------------------
