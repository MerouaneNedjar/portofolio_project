SELECT *
FROM portofolioproject .. CovidDeaths
where continent is not null 

ORDER BY 3,4

--SELECT *
--FROM portofolioproject .. CovidVaccinations
--ORDER BY 3,4

--select data that we will using 

select location , date, total_cases,new_cases,total_deaths,population
FROM portofolioproject .. CovidDeaths
ORDER BY 1,2

--loking total deaths VS total cases 
--choose likelihood dying if you contract covid in a contry 

select location , date, total_cases,total_deaths,population,(total_deaths/total_cases)*100 as deathpercentage_
FROM portofolioproject .. CovidDeaths
where location like '%states%'
ORDER BY 1,2

--loking total cases Vs population 
--what percentage of population got covid 
select location , date,total_deaths, population,total_cases,(total_cases/population)*100 as casespercentage_
FROM portofolioproject .. CovidDeaths
where location like '%states%'
ORDER BY 1,2


--looking at countries with highst infection rate compared to population without see the date 

select  location , population ,MAX(total_cases)as highstinfectioncountry,MAX(total_cases/population)*100 as casespercentageinfected
FROM portofolioproject .. CovidDeaths
--where location like '%states%'
group by location,population
ORDER BY casespercentageinfected desc

--showing country with highst depth count per population 

select  location , MAX(Cast (total_deaths as int ))as totaldeathscount
FROM portofolioproject .. CovidDeaths

where continent is  null 

group by location
ORDER BY totaldeathscount desc



--showing continent with highst depth count  per population 

select  continent  , MAX(Cast (total_deaths as int ))as totaldeathscount
FROM portofolioproject .. CovidDeaths
where continent is not  null 
group by continent
ORDER BY totaldeathscount desc

--showing continent with highst depth count  per population 


select  continent  , MAX(Cast (total_deaths as int ))as totaldeathscount
FROM portofolioproject .. CovidDeaths
where continent is not  null 
group by continent
ORDER BY totaldeathscount desc

--global numbers 


select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
FROM portofolioproject .. CovidDeaths
--where continent is not null 
--group By location
ORDER BY deathpercentage desc

--try join 

select *
from portofolioproject .. CovidDeaths dea
join portofolioproject .. CovidVaccinations vac 
on dea.location=vac.location
and dea.date=vac.date

-- lokking total population vs Vaccination 
select dea.date,dea.continent,dea.location,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations  ))over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100 that an error because we create that columme now the solution is cte
from portofolioproject .. CovidDeaths dea
join portofolioproject .. CovidVaccination vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--and vac.new_vaccinations is not null
--and dea.location like '%states%'
--order by 2,3

--use CTE
with popVSvac (continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as 
(
select dea.date,dea.continent,dea.location,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations  ))over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from portofolioproject .. CovidDeaths dea
join portofolioproject .. CovidVaccination vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
)
select * , (rolling_people_vaccinated/population)*100
from popVSvac





--temp table 
create table #percent_population_vaccented
(
continent nvarchar(255),
location  nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric,
)
insert into #percent_population_vaccented
-- lokking total population vs Vaccination 
select dea.date,dea.continent,dea.location,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations  ))over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated/population)*100 that an error because we create that columme now the solution is cte
from portofolioproject .. CovidDeaths dea
join portofolioproject .. CovidVaccination vac 
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--and vac.new_vaccinations is not null
--and dea.location like '%states%'
--order by 2,3
select * , (rolling_people_vaccinated/population)*100
from #percent_population_vaccented





DROP TABLE IF EXISTS #percent_population_vaccented;

CREATE TABLE #percent_population_vaccented
(
    continent NVARCHAR(255),
    location NVARCHAR(255),
    date DATETIME,
    population NUMERIC,
    new_vaccinations NUMERIC,
    rolling_people_vaccinated NUMERIC
);

INSERT INTO #percent_population_vaccented
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM portofolioproject..CovidDeaths dea
JOIN portofolioproject..CovidVaccination vac 
ON dea.location = vac.location
AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL;

---- Sélection des résultats
--SELECT *, (rolling_people_vaccinated / population) * 100 AS percent_population_vaccinated
--FROM #percent_population_vaccented;



----create view to store data for later visualization
--DROP VIEW IF EXISTS percent_population_vaccented;
--GO  -- Sépare les commandes

--CREATE VIEW percent_population_vaccented AS 
--SELECT 
--    dea.date,
--    dea.continent,
--    dea.location,
--    dea.population,
--    vac.new_vaccinations,
--    SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS rolling_people_vaccinated
--FROM portofolioproject..CovidDeaths dea
--JOIN portofolioproject..CovidVaccination vac 
--ON dea.location = vac.location
--AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL;


--SELECT * FROM sys.views WHERE name = 'percent_population_vaccented';


--SELECT TABLE_SCHEMA, TABLE_NAME 
--FROM INFORMATION_SCHEMA.VIEWS 
--WHERE TABLE_NAME = 'percent_population_vaccented';


--SELECT * FROM dbo.percent_population_vaccented;

--SELECT * FROM sys.views WHERE name = 'percent_population_vaccented';

--SELECT * 
--FROM INFORMATION_SCHEMA.VIEWS 
--WHERE TABLE_NAME = 'percent_population_vaccented';






USE master;
DROP VIEW IF EXISTS dbo.percent_population_vaccented;




USE portofolioproject;
GO

CREATE VIEW dbo.percent_population_vaccented AS 
SELECT dea.date, dea.continent, dea.location, dea.population, vac.new_vaccinations,
SUM(CONVERT(INT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_people_vaccinated
FROM portofolioproject..CovidDeaths dea
JOIN portofolioproject..CovidVaccination vac 
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;


select *
from percent_population_vaccented