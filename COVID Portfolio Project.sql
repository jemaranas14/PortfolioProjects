Select * 
From PorfolioProject..CovidDeaths

order by 3,4

--Select * 
--From PorfolioProject..CovidVaccinations
--order by 3,4


-- Select Data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject..CovidDeaths
order by 1,2

-- looking at total cases vs Total Deaths 
-- shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (cast(total_deaths as float) / cast(total_cases as float)) * 100 as DeathPercentage
From PorfolioProject..CovidDeaths
WHERE location like '%states%'
order by 1,2


-- Looking at Total cases vs popuplation


Select Location, date, total_cases, population, (cast(total_cases as float) / cast(population as float)) * 100 as PercentPopulation
From PorfolioProject..CovidDeaths
--WHERE location like '%states%'
order by 1,2


--Looking at countries with highest infection rate compared to population 

Select Location, population, MAX(total_cases) as HighestInfectionCount , MAX((cast(total_cases as float) / cast(population as float)) * 100) as PercentPopulationInfected
From PorfolioProject..CovidDeaths
--WHERE location like '%states%'
Group by location, population
order by PercentPopulationInfected desc

-- Looking at Countries with Hight Enfect



--Showing countries with highest death count per population 

Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by location
order by TotalDeathCount desc


-- Let's break things down by continent 
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is not null
Group by continent 
order by TotalDeathCount desc 


--showing the continent with the highest death count per population
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
From PorfolioProject..CovidDeaths
-- Where location like '%states%'
Where continent is not null
Group by continent 
order by TotalDeathCount desc 

--Global numbers 

Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases) * 100 as DeathPercentage			--total_deaths, (cast(total_deaths as float) / cast(total_cases as float)) * 100 as DeathPercentage
From PorfolioProject..CovidDeaths
WHERE continent is not null and new_cases <> 0
--group by date
order by 1,2


--looking at total population vs vaccinations 
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100 
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is  not null 
order by 2,3

-- Use CTE 

with PopvsVac (Continent, Location, Date, Population,new_vaccinations ,RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100 
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is  not null 
--order by 2,3
)

select *, (RollingPeopleVaccinated/Population) * 100 
from PopvsVac 

--TEMP Table 

drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100 
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is  not null 
--order by 2,3

select *, (RollingPeopleVaccinated/Population) * 100 
from #PercentPopulationVaccinated 


--showing the worlds total population and worlds total cases 
SELECT 
* 
FROM
(select sum(population) WorldsPopulation
from (select distinct location, population
		from PorfolioProject..CovidDeaths
		where continent is not null
		) totalWorldspopulation) t1
JOIN
(select sum(cast(TotalCasesOfEachLocation.maxTotal as int)) Worlds_TotalCases
from (select distinct location, MAX(total_cases) maxTotal
		from PorfolioProject..CovidDeaths
		where total_cases is not null
		group by location) TotalCasesOfEachLocation)  t2
		on t1.WorldsPopulation <> t2.Worlds_TotalCases	



-- Creating view to store data for later visualation

Create View PercentsPopulationVaccinated as 
Select dea.continent, dea.location,  dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.Location order by dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population) * 100 
from PorfolioProject..CovidDeaths dea
join PorfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is  not null 
--order by 2,3


select * 
from PercentsPopulationVaccinated

		


 

