use sakila;
show tables from sakila;
select * from coviddeaths  ;

select location, date,total_cases,new_cases,total_deaths,population
from coviddeaths
order by 1,2;

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 death_percentage
from coviddeaths
where location like "india"
order by location;

select location,date,population,total_cases,(total_cases/population)*100 as "infected_percentage in india"
from coviddeaths
where location like "india"
order by location;

select location,date,population,total_cases,(total_cases/population)*100 as "infected_percentage"
from coviddeaths
order by location;

select location,population,max(total_cases) as "highest infection count",max((total_cases/population))*100 as infected_percentage
from coviddeaths
group by location,population
order by infected_percentage desc;

select continent,max(cast(total_deaths as unsigned)) as "total_death_count_across_world"
from coviddeaths
where continent is not null
group by location
order by total_death_count_across_world desc;

select sum(new_cases) as total_cases,sum(cast(new_deaths as unsigned)) as total_deaths, sum(cast(new_deaths as unsigned))/sum(new_cases)*100 as death_percentage,
from coviddeaths
order by 1,2;

select * from covidvaccinations;

select coviddeaths.continent,coviddeaths.location,coviddeaths.date,coviddeaths.population,covidvaccinations.new_vaccinations,
sum(new_vaccinations)
from coviddeaths join covidvaccinations
on coviddeaths.location=covidvaccinations.location
and coviddeaths.date=covidvaccinations.date
order by 1,2,3;

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

DROP Table if exists #PercentPopulationVaccinated
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
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 












 