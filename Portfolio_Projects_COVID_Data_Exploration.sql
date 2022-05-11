-- SELECT Covid_Deaths Table 


SELECT *
FROM portfolioproject.covid_deaths;

-- SELECT Covid_Vaccinations Table

SELECT *
FROM portfolioproject.covid_vaccinations;


-- Selecting the data that are going to be used for querying from the covid_deaths table
SELECT dea.location, str_to_date(dea.date,'%m/%d/%Y') as date, dea.total_cases, dea.new_cases, dea.new_deaths, dea.population
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
order by dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Looking at Total Cases vs Total Deaths
-- Shows the Percentage of dying if you contract covid in a specific location

SELECT dea.location, str_to_date(dea.date,'%m/%d/%Y') as date, dea.total_cases, dea.total_deaths, (dea.total_deaths/ dea.total_cases) * 100 as Death_Percentage
FROM portfolioproject.covid_deaths dea
-- WHERE dea.location like '%states%'
order by dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Looking at Total cases vs Population
-- Showing what Percentege of Population got covid

SELECT dea.location,str_to_date(dea.date,'%m/%d/%Y') as date, dea.total_cases, dea.population, (dea.total_cases/dea.population)*100 as Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
-- WHERE dea.location like '%states%'
order by dea.location, str_to_date(dea.date,'%m/%d/%Y');

-- Looking at Countries with Highest infection rate compared to Population

SELECT dea.location, dea.population, MAX(dea.total_cases) as Highest_Infection_Rate, (MAX( dea.total_cases)/ dea.population) * 100 as Infected_Population_Percentage
FROM portfolioproject.covid_deaths dea
GROUP BY dea.location, dea.population
ORDER BY Infected_Population_Percentage desc;


-- Showing Countries with Highest Death Count per Population

SELECT dea.location, MAX(cast(dea.total_deaths as signed )) as Total_Death_Count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.location
ORDER BY Total_Death_Count desc;


-- Breaking down by Continent
SELECT sq.continent, sum(sq.total_death_count)
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
-- and dea.continent like '%North America%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent
order by sum(sq.total_death_count) desc;


-- Breaking down the numbers based on the Continent - North America, with it's Countries.
SELECT sq.continent,sq.location, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like '%North America%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;
 

-- Breaking down the numbers based on the Continent - South America, with it's Countries.
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like 'South America%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;


-- Breaking down the numbers based on the Continent - Europe, with it's Countries.
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like '%Europe%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;

-- Breaking down the numbers based on the Continent - Asia  with it's countries
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like 'Asia%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;


-- Breaking down the numbers based on the Continent - Africa, with it's Countries.
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like '%Africa%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;

-- Breaking down the numbers based on the Continent - Oceania, with it's Countries
SELECT sq.continent,sq.location as country, sum(sq.total_death_count) 
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.continent like '%Oceania%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent,sq.location
order by sum(sq.total_death_count) desc;

-- Global Numbers based on Date.
SELECT str_to_date(dea.date,'%m/%d/%Y') as Date, SUM(dea.new_cases) as Total_cases, SUM(CAST(dea.new_deaths as unsigned)) as Total_deaths, sum( dea.new_deaths) / sum( dea.new_cases) * 100 as Global_Death_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY date
ORDER BY date, Total_cases;

-- Total Global Numbers.
SELECT SUM(dea.new_cases) as Total_cases, SUM(CAST(dea.new_deaths as unsigned)) as Total_deaths, sum( dea.new_deaths) / sum( dea.new_cases) * 100 as Global_Death_Percentage
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY Date,Total_cases;


-- Covid_Vaccinations table
SELECT *
FROM portfolioproject.covid_vaccinations;
 
-- Looking at Total Population Vs Vaccinations
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')as date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations as unsigned)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) as Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
and dea.date = vacc.date
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Using CTE
-- Rolling people Vaccinated
WITH PopvsVacc(Location, Continent, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as       
(
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')as date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations as unsigned)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) as Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
and dea.date = vacc.date
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y')
)
SELECT *, (Rolling_People_Vaccinated/Population)*100
FROM PopvsVacc;

--  Using Temp Table  
DROP TABLE if exists PercentPopulationVaccinated;
CREATE temporary table PercentPopulationVaccinated
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
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')as date,
dea.population, vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations as unsigned)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) as RollingPeopleVaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
and dea.date = vacc.date
WHERE dea.continent is not null
and vacc.new_vaccinations > 0
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
);
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PercentPopulationVaccinated;

-- Creating View to store data for later visualizations
-- VIEW for PercentPopulationVaccinated
CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')as date,
dea.population, vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations as signed)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) as RollingPeopleVaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
and dea.date = vacc.date
WHERE dea.continent is not null
and vacc.new_vaccinations > 0
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania');



-- Creating View for total population vs Vaccinations
CREATE VIEW Total_Population_Vs_Vaccinations as
SELECT dea.continent, dea.location, str_to_date(dea.date,'%m/%d/%Y')as date, -- str_to_date(vacc.date,'%m/%d/%Y')as date, 
dea.population,vacc.new_vaccinations, 
SUM(cast(vacc.new_vaccinations as unsigned)) OVER (PARTITION BY vacc.location ORDER BY vacc.location,(str_to_date(vacc.date,'%m/%d/%Y'))) as Rolling_People_Vaccinated
FROM portfolioproject.covid_deaths dea
JOIN portfolioproject.covid_vaccinations vacc
ON dea.location = vacc.location
and dea.date = vacc.date
WHERE dea.continent is not null
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
ORDER BY dea.location, str_to_date(dea.date,'%m/%d/%Y');


-- Creating VIEW for Breaking down by Continents
CREATE VIEW Total_Deaths_by_Continents as
SELECT sq.continent, sum(sq.total_death_count)
FROM 
(SELECT dea.continent, dea.location, MAX(cast(total_deaths as unsigned )) as total_death_count
FROM portfolioproject.covid_deaths dea
WHERE dea.continent is not null
-- and dea.continent like '%North America%'
and dea.location not in ('High income','Europe','North America','South America','European Union','Africa','Low income','International','Northern Cyprus','Oceania')
GROUP BY dea.continent, dea.location
) sq
GROUP BY sq.continent
order by sum(sq.total_death_count) desc;






