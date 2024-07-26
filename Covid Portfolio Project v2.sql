--A glance at the Dataset
Select *
From portfolioproject..CovidDeaths

--Selecting six columns needed
Select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject..CovidDeaths
Order by 1, 2;

-- A look at Total Cases vs Total Deaths(calculate % and rename % column)
--Likelyhood of dying if you contacted Covid (United States Data)

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From portfolioproject..CovidDeaths
Where location like '%states%'
Order by 1, 2;


--A looked at the Total Cases Vs Population
--What percetage of the population got Covid? (Unite States Data)

Select location, date,Population, total_cases, (total_cases/Population)*100 as CasesPercentage
From portfolioproject..CovidDeaths
Where location like '%states%'
Order by 1, 2;



-- A looked at country with highest infection rate compare to population

Select location, Population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as InfectionPercentage
From portfolioproject..CovidDeaths
--where location like '%states%'
Group by location, Population
Order by InfectionPercentage desc


-- A look at country with highest Death counts per population
-- Removed "null" from the continent to filter out what I dont need

Select location, MAX(cast(total_deaths as int)) as DeathCount
From portfolioproject..CovidDeaths
Where continent is not null
Group by location
Order by DeathCount desc



--Broke this down by continent "location" column using "continent" column to isolate location needed

Select location, MAX(cast(total_deaths as int)) as DeathCount
From portfolioproject..CovidDeaths
Where continent is  null
Group by location
Order by DeathCount desc


--A look at the start of case, death count and likelyhood of Death (%)
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM((new_cases))*100  as DeathPercentage
From portfolioproject..CovidDeaths
Where continent is not null
Group by date
Order by 1, 2;



--Global Counts of Cases/Death and DeathPercentage

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM((new_cases))*100  as DeathPercentage
From portfolioproject..CovidDeaths
Where continent is not null
Order by 1, 2;


--Joined CovidDeaths and CovidVaccination together.
--Looking at Total population vs Vaccinations
--CTE
With PopvsVac (continent,Location, Date, Population, new_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations  vac
   On dea.location = vac.location
   and dea.date = vac.date
   Where dea.continent is not null
 --Order By 2,3;
 )
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE to check different count
DROP Table #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric, 
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
Join portfolioproject..CovidVaccinations  vac
   On dea.location = vac.location
   and dea.date = vac.date
   Where dea.continent is not null
 --Order By 2,3;

Select*, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated



--Create view for later Visualizations script example
--Create View <Name the view>  as
--<Past the script here>







