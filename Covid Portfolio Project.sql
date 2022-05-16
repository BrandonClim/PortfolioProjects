select*
from PorfolioProject..['CovidDeaths']
Where continent is not null
Order by 3,4

--select*
--from PorfolioProject..CovidVaccinations
--Order by 3,4

--Select data that we are going to be using

select location, date, total_cases, new_cases, total_deaths, population
From PorfolioProject..['CovidDeaths']
order by 1,2

--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as deathpercentage
From PorfolioProject..['CovidDeaths']
Where location like '%states%' 
order by 1,2

--Looking at Total cases vs Population
--Shows what percentage of population got covid

select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From PorfolioProject..['CovidDeaths']
Where location like '%states%' 
order by 1,2


--Looking at countries with highest infection rate compared to population

select location, MAX(total_cases) as highestInfectionCount, population, MAX((total_cases/population))*100 as PercentPopulationInfected
From PorfolioProject..['CovidDeaths']
--Where location like '%states%' 
Group by location, population
order bY PercentPopulationInfected DESC 

--showing Countries with Highest Death Count per population  

select location, MAX(cast(total_deaths as int)) totalDeathCount
From PorfolioProject..['CovidDeaths']
--Where location like '%states%'
Where continent is not null
Group by location, population
order bY totalDeathCount DESC 

--Break down by continent

select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PorfolioProject..['CovidDeaths']
--Where location like '%states%'
Where continent is not null
Group by continent
order bY totalDeathCount DESC 


-- Showing the continents with the highest death count

select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From PorfolioProject..['CovidDeaths']
--Where location like '%states%'
Where continent is not null
Group by continent, population
order bY totalDeathCount DESC 


--Global numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_death, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as deathpercentage
From PorfolioProject..['CovidDeaths']
--Where location like '%states%'
where continent is not null
--Group by date
order by 1,2

--Looking at total population vs vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast (vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/populatio)*100
From PorfolioProject..['CovidDeaths'] dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
Order by 2,3

--Use CTE

With popvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast (vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/populatio)*100
From PorfolioProject..['CovidDeaths'] dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast (vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/populatio)*100
From PorfolioProject..['CovidDeaths'] dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast (vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.Location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/populatio)*100
From PorfolioProject..['CovidDeaths'] dea
Join PorfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null	
--Order by 2,3

