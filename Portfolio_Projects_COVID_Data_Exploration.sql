-- SELECT Covid_Deaths Table 
SELECT *
FROM portfolioproject.covid_deaths;

-- SELECT Covid_Vaccinations Table
SELECT *
FROM portfolioproject.covid_vaccinations;


-- Selecting the data that are going to be used for querying from the covid_deaths table
SELECT dea.location, str_to_date(dea.date,'%m/%d/%Y') AS date, dea.total_cases, dea.new_cases, dea.new_deaths, dea.population
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Looking at Total Cases vs Total Deaths
-- Shows the Percentage of dying if you contract covid in a specific location
SELECT dea.location, str_to_date(dea.date,'%m/%d/%Y') AS date, 
dea.total_cases, dea.total_deaths, (dea.total_deaths/ dea.total_cases) * 100 AS Death_Percentage
FROM portfolioproject.covid_deaths dea
-- WHERE dea.location LIKE '%states%'
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Looking at Total cases vs Population
-- Showing what Percentege of Population got covid
SELECT dea.location,str_to_date(dea.date,'%m/%d/%Y') AS date, 
dea.total_cases, dea.population, (dea.total_cases/dea.population)*100 AS Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
-- WHERE dea.location LIKE '%states%'
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');

-- Looking at Countries with Highest infection rate compared to Population
SELECT dea.location, dea.population, MAX(dea.total_cases) AS Highest_Infection_Rate, 
(MAX( dea.total_cases)/ dea.population) * 100 AS Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
GROUP BY dea.location, dea.population
ORDER BY Infected_Population_Percentage DESC;


-- Showing Countries with Highest Death Count per Population
SELECT dea.location, MAX(cast(dea.total_deaths AS UNSIGNED )) AS Total_Death_Count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.location
ORDER BY Total_Death_Count DESC;


-- Breaking down by Continent
SELECT sq.continent, sum(sq.total_death_count)
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent
ORDER BY sum(sq.total_death_count) DESC;


-- Breaking down the numbers based on the Continent - North America, with it's Countries.
SELECT sq.continent,sq.location, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE '%North America%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;
 

-- Breaking down the numbers based on the Continent - South America, with it's Countries.
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE 'South America%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;


-- Breaking down the numbers based on the Continent - Europe, with it's Countries.
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE '%Europe%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;

-- Breaking down the numbers based on the Continent - Asia  with it's countries
SELECT sq.continent,sq.location AS country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE 'Asia%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;


-- Breaking down the numbers based on the Continent - Africa, with it's Countries.
SELECT sq.continent,sq.location AS country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE '%Africa%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;

-- Breaking down the numbers based on the Continent - Oceania, with it's Countries
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.continent LIKE '%Oceania%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
ORDER BY sum(sq.total_death_count) DESC;

-- Global Numbers based on Date.
SELECT str_to_date(dea.date,'%m/%d/%Y') AS Date, SUM(dea.new_cases) AS Total_cases, 
SUM(CAST(dea.new_deaths AS UNSIGNED)) AS Total_deaths, sum( dea.new_deaths) / sum( dea.new_cases) * 100 AS Global_Death_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY date
ORDER BY date, Total_cases;

-- Total Global Numbers.
SELECT SUM(dea.new_cases) AS Total_cases, SUM(CAST(dea.new_deaths AS UNSIGNED)) AS Total_deaths, 
sum( dea.new_deaths) / sum( dea.new_cases) * 100 AS Global_Death_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY Date,Total_cases;


-- Covid_Vaccinations table
SELECT *
FROM portfolioproject.covid_vaccinations;
 
-- Looking at Total Population Vs Vaccinations
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')AS date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY vacc.location ORDER BY vacc.location, 
(str_to_date(vacc.date,'%m/%d/%Y'))) AS Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN  ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Using CTE
-- Rolling people Vaccinated
WITH PopvsVacc(Location, Continent, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
AS      
(
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')AS date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) AS Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y')
)
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopvsVacc;

--  Using Temp Table  
DROP TABLE IF EXISTS PercentPopulationVaccinated;
CREATE TEMPORARY TABLE PercentPopulationVaccinated
(
Continent mediumtext,
Location mediumtext,
Date mediumtext,
Population bigint,
New_Vaccinations mediumtext,
RollingPeopleVaccinated mediumtext
);
-- SELECT * from PercentPopulationVaccinated;
INSERT INTO PercentPopulationVaccinated
(
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')AS date,
dea.population, vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,
(str_to_date(vacc.date,'%m/%d/%Y'))) AS RollingPeopleVaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
AND vacc.new_vaccinations > 0
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
);
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated;

-- Creating Views to store data for later Visualizations.
-- View for PercentPopulationVaccinated.
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')AS date,
dea.population, vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,
(str_to_date(vacc.date,'%m/%d/%Y'))) AS RollingPeopleVaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
AND vacc.new_vaccinations > 0
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania');



-- Creating View for total population vs Vaccinations.
CREATE VIEW Total_Population_Vs_Vaccinations AS
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')AS date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations AS UNSIGNED)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,
(str_to_date(vacc.date,'%m/%d/%Y'))) AS Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent IS NOT NULL
and dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Creating View for Breaking down by Continents.
CREATE VIEW Total_Deaths_by_Continents AS 
SELECT sq.continent, sum(sq.total_death_count)
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths AS UNSIGNED )) AS total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent IS NOT NULL
-- and dea.continent like '%North America%'
AND dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent
ORDER BY sum(sq.total_death_count) DESC;


-- Creating View for Highest infection rate by location and Percentage of the total population infected by location.
CREATE VIEW HIGHEST_INFECTION_RATE AS
SELECT dea.location, dea.population, MAX(dea.total_cases) AS Highest_Infection_Rate, 
(MAX( dea.total_cases)/ dea.population) * 100 AS Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.location, dea.population
ORDER BY Infected_Population_Percentage DESC;


-- Creating View for Highest infection rate by location and Percentage of the total population infected by location with date
CREATE VIEW Highest_Infection_Rate_with_Date as
SELECT dea.location, dea.population,dea.date, MAX(dea.total_cases) AS Highest_Infection_Rate, 
(MAX( dea.total_cases)/ dea.population) * 100 AS Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.location NOT IN ('High income','Europe','North America','South America','European Union',
'Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.location, dea.population, str_to_date(dea.date,'%m/%d/%Y')
ORDER BY Infected_Population_Percentage DESC;






