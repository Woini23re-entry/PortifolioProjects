select *
from PortifolioProjectsql..CovidDeaths
order by 3, 4

select *
from PortifolioProjectsql..CovidVaccinations
ORDER BY 3,4

select location, date,total_cases, new_cases,total_deaths, population
from PortifolioProjectsql..CovidDeaths
order by 1,2


/*Exploring Toatal case vs Total deaths which is 
the percenatge of people died from the toatl cases per country*/

select location, date,Total_cases, Total_Deaths, (Total_Deaths/total_cases)*100 as Death_Percentage
from PortifolioProjectsql..CovidDeaths
order by 1,2

select location, date,Total_cases, Total_Deaths, (Total_Deaths/total_cases)*100 as Death_Percentage
from PortifolioProjectsql..CovidDeaths
where location Like '%states%'
order by 2,3

-- Total cases vs population

select location, date,Total_cases,population, (total_cases/population)*100 as Cases_Percentage
from PortifolioProjectsql..CovidDeaths
order by 3,5

select location, date,Total_cases,population, (total_cases/population)*100 as Cases_Percentage
from PortifolioProjectsql..CovidDeaths
where location Like '%states%'
order by 2,3

select location, date,Total_cases,population, (total_cases/population)*100 as Cases_Percentage
from PortifolioProjectsql..CovidDeaths
where location = 'Ethiopia'
order by 2,3

--The country with highest and lowest cases and deaths per population

select location, max(Total_cases)as HighestInfectionCount
from PortifolioProjectsql..CovidDeaths
where location = 'ethiopia'
Group by location


select location,population, max(Total_cases)as HighestInfectionCount, max((total_cases/population)*100) 
        as PercentageOfPopulationInfected
from PortifolioProjectsql..CovidDeaths
Group by location, population
order by PercentageOfPopulationInfected desc

-- showing countries and continents with the highest death
 
 select Location, max(cast(Total_Deaths as int))as TotalDeathCount
 from PortifolioProjectsql..CovidDeaths
 where continent is not null
Group by location
order by TotalDeathCount desc

select *
from PortifolioProjectsql..CovidDeaths
order by 3, 4

select  continent, max(cast(Total_Deaths as int))as TotalDeathCount
 from PortifolioProjectsql..CovidDeaths
 where continent is not null
Group by continent
order by TotalDeathCount desc

select  location, max(cast(Total_Deaths as int))as TotalDeathCount
 from PortifolioProjectsql..CovidDeaths
 where continent is null
Group by location
order by TotalDeathCount desc


--Global infection and deaths

select   sum(cast(Total_Deaths as int))as TotalDeathCount,
        sum(cast(new_deaths as int))as TotalNewDeath,
		sum(Total_cases)as TotalCases,
		sum(new_cases)as totalNewCases
 from PortifolioProjectsql..CovidDeaths
 --where continent is null
--Group by location
order by TotalDeathCount desc


select *
from PortifolioProjectsql..CovidVaccinations

--select *
--from PortifolioProjectsql..CovidVaccinations as dea 
--Join PortifolioProjectsql..CovidDeaths as vac
--on dea.iso_code = vac.iso_code
--order by 2,3

select dea.continent,dea.location,dea.date
from PortifolioProjectsql..CovidVaccinations as dea 
Join PortifolioProjectsql..CovidDeaths as vac
on dea.location= vac.location
and dea.date= vac.date
order by 2,3


-- CTE to see the total vaccination over population

With vacOverpop (continent, location, date,population, new_vaccination, OngoingVaccination)
as
(
select dea.continent,dea.location,dea.date, population, vac.new_vaccinations, sum(convert (int,vac.new_vaccinations))
                 over(partition by dea.location order by dea.location,dea.date) as OngoingVaccination
from PortifolioProjectsql..CovidVaccinations as dea 
Join PortifolioProjectsql..CovidDeaths as vac
     on dea.location= vac.location
     and dea.date= vac.date
	 )
select *
from vacOverpop

-- Temp table to see the total vaccination over population

Drop Table if exists #VaccinatedOverPopulation
create Table #VaccinatedOverPopulation
(continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
OngoingVaccination numeric
)
insert into #VaccinatedOverPopulation
select dea.continent,dea.location,dea.date, population, vac.new_vaccinations, sum(convert (int,vac.new_vaccinations))
                 over(partition by dea.location order by dea.location,dea.date) as OngoingVaccination
from PortifolioProjectsql..CovidVaccinations as dea 
Join PortifolioProjectsql..CovidDeaths as vac
     on dea.location= vac.location
     and dea.date= vac.date
	 
select *
from #VaccinatedOverPopulation

-- creating views for data visualization 

create view TotalCaseandDeathvisual as
select  sum(cast(Total_Deaths as int))as TotalDeathCount,
        sum(cast(new_deaths as int))as TotalNewDeath,
		sum(Total_cases)as TotalCases,
		sum(new_cases)as totalNewCases
 from PortifolioProjectsql..CovidDeaths
 --where continent is null
--Group by location
--order by TotalDeathCount desc

Create View TotalNewVaccinationvisual as
select dea.continent,dea.location,dea.date, population, vac.new_vaccinations, sum(convert (int,vac.new_vaccinations))
                 over(partition by dea.location order by dea.location,dea.date) as OngoingVaccination
from PortifolioProjectsql..CovidVaccinations as dea 
Join PortifolioProjectsql..CovidDeaths as vac
     on dea.location= vac.location
     and dea.date= vac.date

Select *
From TotalNewVaccinationvisual


















