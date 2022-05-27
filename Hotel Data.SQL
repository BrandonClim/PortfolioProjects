--Combining data tables and making new columns for analysis

with hotels as (
Select *
From project.dbo.['2018$']
union 
Select *
From project.dbo.['2019$']
union
Select *
From project.dbo.['2020$'])

Select
arrival_date_year,
hotel,
round(SUM ((stays_in_week_nights+stays_in_weekend_nights)*adr), 2) as revenue 
from hotels
Group by arrival_date_year, hotel

with hotels as (
Select *
From project.dbo.['2018$']
union 
Select *
From project.dbo.['2019$']
union
Select *
From project.dbo.['2020$'])

select *
from hotels
left join project.dbo.market_segment$
on hotels.market_segment = market_segment$.market_segment
left join project.dbo.meal_cost$
on meal_cost$.meal = hotels.meal
