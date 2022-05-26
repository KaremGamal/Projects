
-- Covid-19 Data Exploration Project
 

SELECT * 
	FROM Portfolio..coviddeaths

SELECT * 
	FROM Portfolio..CovidVaccination

SELECT location, date, total_cases,new_cases, total_deaths, population 
	FROM Portfolio..CovidDeaths 
	ORDER BY 1,2

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
	FROM Portfolio..CovidDeaths 
	Where location like '%Egypt%'
	ORDER BY 1,2

SELECT location , date ,population, total_cases ,(total_cases/population)*100 as population_percentage
	FROM portfolio..coviddeaths
	WHERE location like '%Egypt%'
	ORDER BY 1,2


SELECT location  ,population, MAX(total_cases) AS HighestInfectionCount  ,MAX((total_cases/population))*100 as PercentPopulationInfected
	FROM portfolio..coviddeaths
	GROUP BY location  ,population
	ORDER BY PercentPopulationInfected desc

SELECT location  ,MAX(Cast(total_deaths as int)) as TotalDeathCount
	FROM portfolio..coviddeaths
	WHERE continent is NOT null
	GROUP BY location  ,population
	ORDER BY 2 desc

SELECT continent  ,MAX(Cast(total_deaths as int)) as TotalDeathCount
	FROM portfolio..coviddeaths
	WHERE continent is not null
	GROUP BY continent
	ORDER BY 2 desc

SELECT continent, location, total_cases,new_cases, total_deaths, population 
	FROM Portfolio..coviddeaths
	GROUP BY continent,location
	ORDER BY continent

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths , SUM(CAST(new_deaths as int))/SUM (new_cases)*100 as deathpercentage
	FROM Portfolio..coviddeaths
	WHERE continent is not null
	GROUP BY date
	ORDER BY 1,2

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths , SUM(CAST(new_deaths as int))/SUM (new_cases)*100 as deathpercentage
	FROM Portfolio..coviddeaths
	WHERE continent is not null
	ORDER BY 1,2

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	FROM Portfolio..coviddeaths dea
	JOIN Portfolio..CovidVaccination vac
		 ON dea.location = vac.location
		 and dea.date = vac.date
	WHERE dea.continent is not null
	ORDER BY 1,2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations,
  (vac.total_vaccinations/dea.population)*100 as Vac_Percentage
	FROM Portfolio..coviddeaths dea
	JOIN Portfolio..CovidVaccination vac
		 ON dea.location = vac.location
		 and dea.date = vac.date
	WHERE dea.continent is not null
	ORDER BY 1,2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
	FROM Portfolio..coviddeaths dea
	JOIN Portfolio..CovidVaccination vac
		ON dea.location = vac.location
		and dea.date = vac.date
	 WHERE dea.continent is not null
	ORDER BY 2,3

WITH POPvsVAC (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinted)
as 
(
	SELECT dea.continent, dea.Location, dea.Date, dea.population, vac.new_vaccinations,
	SUM(CONVERT(int, vac.new_vaccinations))OVER (PARTITION BY dea.Location ORDER BY dea.location,
	dea.Date) as RollingPeopleVaccinted
		FROM portfolio..coviddeaths dea
		JOIN portfolio..CovidVaccination vac
			ON dea.location = vac.location
			AND dea.date = vac.date
		WHERE dea.continent is not null
)
SELECT * ,(RollingPeopleVaccinted/Population)*100
	FROM POPvsVAC

--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--	(
--		Continent nvarchar(255),
--		Location nvarchar(255),
--		Date datetime,
--		Population numeric,
--		New_vaccinations numeric,
--		RollingPeopleVaccinted numeric
--	)
--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.Location, dea.Date, dea.population, vac.new_vaccinations,
--	SUM(CONVERT(int, vac.new_vaccinations))OVER (PARTITION BY dea.Location ORDER BY dea.location,
--	dea.Date) as RollingPeopleVaccinted
--		FROM portfolio..coviddeaths dea
--		JOIN portfolio..CovidVaccination vac
--			ON dea.location = vac.location
--			AND dea.date = vac.date
		

--SELECT * ,(RollingPeopleVaccinted/Population)*100
--	FROM #PercentPopulationVaccinated


Create View PercentPopulationVaccinatedview as
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
		From Portfolio..CovidDeaths dea
		Join Portfolio..CovidVaccination vac
			On dea.location = vac.location
			and dea.date = vac.date
		WHERE dea.continent is not null 

-- THIS IS FOR VISUALIZATION USING TABLEAU
--1
SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths , SUM(CAST(new_deaths as int))/SUM (new_cases)*100 as deathpercentage
	FROM Portfolio..coviddeaths
	WHERE continent is not null
	ORDER BY 1,2

--2
SELECT location, SUM(CAST(new_deaths as int)) as TotalDeathCount
	FROM Portfolio..coviddeaths
	WHERE continent is null
	AND location not in ('World','European Union','International')
	GROUP BY location
	ORDER BY TotalDeathCount

--3
SELECT location  ,population, MAX(total_cases) AS HighestInfectionCount  ,MAX((total_cases/population))*100 as PercentPopulationInfected
	FROM portfolio..coviddeaths
	GROUP BY location  ,population
	ORDER BY PercentPopulationInfected desc

--4
SELECT location  ,population,Date, MAX(total_cases) AS HighestInfectionCount  ,MAX((total_cases/population))*100 as PercentPopulationInfected
	FROM portfolio..coviddeaths
	GROUP BY location  ,population, date
	ORDER BY PercentPopulationInfected desc


-- The End of Data Exploration Project

-- This is the Link for Visualizing the Data using a Tableau
--> https://public.tableau.com/app/profile/karem.gamal/viz/Covid-19DashboardProject_16532932895200/Dashboard1
