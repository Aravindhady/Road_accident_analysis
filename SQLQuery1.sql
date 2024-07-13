use [road_accident];

select * from accident;



use [road_accident];

select * from accident;


-- Current Year Casualties:
select sum(number_of_casualties) as CY_Casualties
from accident
where year(accident_date) = 2021;

-- Count of Accidents - 2022:
select round(count(distinct accident_index),1) as Count_Casualties_CY
from accident
where year(accident_date) = 2022;

-- CY Fatal Casualties(2022):
select accident_severity, count(*) as 'Count of Fatal'
from accident
where accident_severity = 'Fatal' 
group by accident_severity;

select sum(number_of_casualties) as CY_fatal_Casualties
from accident
where accident_severity = 'Fatal' and year(accident_date) = 2022;


-------------------------------------------------------------------
-- CY Serious Casualties:
select sum(number_of_casualties) as CY_fatal_Casualties
from accident
where accident_severity = 'Serious' and year(accident_date) = 2022;

----------------------------------------------------------------------

-- CY Slight Casualties:
select sum(number_of_casualties) as CY_fatal_Casualties
from accident
where accident_severity = 'Slight' and year(accident_date) = 2022;

------------------------------------------------------------------------

-- Total Number of Casualties:

with fatal_Casualties as (
           select sum(number_of_casualties) as CY_Casualties_Fatal
		   from accident
		   where accident_severity = 'Fatal'
),

Slight_casualties as (
           select sum(number_of_casualties) as CY_Casualties_Fatal
		   from accident
		   where accident_severity = 'Slight'
),

Serious_casualties as (
           select sum(number_of_casualties) as CY_Casualties_Fatal
		   from accident
		   where accident_severity = 'Serious'
)
select * from fatal_casualties, slight_casualties, Serious_casualties;



---------------------------------------------------------------------------------------------------------

-- Percentage(%) of Accidents that got - Fatal:

select cast(sum(number_of_casualties) as decimal(10,2))*100 / 
(select(cast(sum(number_of_casualties) as decimal(10,2))) from accident) as 'Percentage (%)'
from accident
where accident_severity = 'Fatal';


select cast(sum(number_of_casualties) as decimal(10,2))*100 / 
(select(cast(sum(number_of_casualties) as decimal(10,2))) from accident) as 'Percentage (%)'
from accident
where accident_severity = 'Serious';

select cast(sum(number_of_casualties) as decimal(10,2))*100 / 
(select(cast(sum(number_of_casualties) as decimal(10,2))) from accident) as 'Percentage (%)'
from accident
where accident_severity = 'Slight';

--------------------------------------------------------------------------------------------

-- Vehicle Groups:

select 
     case 
	     when vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		 when vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		 when vehicle_type IN ('Motorcycle 125cc and under', 
		                       'Motorcycle over 125cc and up to 500cc',
							   'Motorcycle over 500cc',
							   'Motorcycle 50cc and under') THEN 'Bikes'
		when vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Bus'
		when vehicle_type IN ('Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under',
		                        'Goods 7.5 tonnes mgw and over') THEN 'Van'
		else 'other'
end as Vehicle_group,
sum(number_of_casualties) as 'CY - Casualties - 2022'
from accident
where year(accident_date) = 2022
group by 
case 
	     when vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		 when vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Cars'
		 when vehicle_type IN ('Motorcycle 125cc and under', 
		                       'Motorcycle over 125cc and up to 500cc',
							   'Motorcycle over 500cc',
							   'Motorcycle 50cc and under') THEN 'Bikes'
		when vehicle_type IN ('Bus or coach (17 or more pass seats)','Minibus (8 - 16 passenger seats)') THEN 'Bus'
		when vehicle_type IN ('Goods over 3.5t. and under 7.5t','Van / Goods 3.5 tonnes mgw or under',
		                        'Goods 7.5 tonnes mgw and over') THEN 'Van'
		else 'other'
end;

----------------------------------------------------------------------------------------------------------------

-- Current year Casualties Monthly Trend:

select datename(month, accident_date) as 'Monthly Trend', sum(number_of_casualties) as 'CY-Casualties-Monthly-Trend'
from accident
where year(accident_date) = 2022
group by datename(month, accident_date);

------------------------------------------------------------------------------------------------------------

-- Types of Roads - Total Number of Casualties:
select road_type, sum(number_of_casualties) as 'Total Number of Casualties'
from accident
where year(accident_date) = 2022
group by road_type
order by sum(number_of_casualties) desc;

-- Area wise percentage and Total number of Casualties:
select Urban_or_Rural_Area, count(*) as 'Count',
       sum(number_of_casualties) as 'Total number of Casualties'
from accident
where year(accident_date) = 2022
group by Urban_or_Rural_Area;

select Urban_or_Rural_Area,
       sum(number_of_casualties) as 'Total number of Casualties',
	   cast(cast(sum(number_of_casualties) as decimal(10,2)) * 100 / 
	   (select(cast(sum(number_of_casualties) as decimal(10,2)))
	           from accident) as decimal(10,2)) as '% of Casualties in rural / urban areas'
from accident
where year(accident_date) = 2022
group by Urban_or_Rural_Area;

with case1 as(
 select cast(sum(number_of_casualties) as decimal(10,2))*100 / 
(select(cast(sum(number_of_casualties) as decimal(10,2))) from accident) as Percentage_rural,
count(number_of_casualties) as 'Count of Casualties'
from accident
where Urban_or_Rural_Area = 'Rural'
),
case2 as(
select cast(sum(number_of_casualties) as decimal(10,2))*100 / 
(select(cast(sum(number_of_casualties) as decimal(10,2))) from accident) as Percentage_urban,
count(number_of_casualties) as 'Count of Casualties'
from accident
where Urban_or_Rural_Area = 'Urban'
)
select *, Percentage_rural + Percentage_urban from  case1, case2;

select datename(month, accident_date) as Month, sum(number_of_casualties) 'Total Number of Cas'
from accident
where datename(year,accident_date) = 2021
group by datename(month, accident_date)
order by sum(number_of_casualties) desc;

select Urban_or_Rural_Area,sum(number_of_casualties) as 'Total number of Casualties',
	   cast(cast(sum(number_of_casualties) as decimal(10,2)) * 100 / 
	   (select cast(sum(number_of_casualties) as decimal(10,2))
	           from accident) as decimal(10,2)) as '% of Casualties in rural / urban areas'
from accident
-- where year(accident_date) = 2022
group by Urban_or_Rural_Area;

---------------------------------------------------------------------------
-- Count of Casualties by Light Conditions:
select light_conditions, count(*) as 'Count of Light Conditions'
from accident
group by light_conditions;


select 
     case 
	     when light_conditions like '%Darkness%' then 'Darkness'
		 else 'Day Light'
	end as Light_Conditions,
	count(number_of_casualties) as 'Count -of'
from accident
group by 
     case 
	     when light_conditions like '%Darkness%' then 'Darkness'
		 else 'Day Light'
end;

----------------------------------------------------------------------------------
select 
     case 
	     when light_conditions like '%Darkness%' then 'Darkness'
		 else 'Day Light'
	end as Light_Conditions,
	ceiling(sum(number_of_casualties) *100 / 
	(select sum(number_of_casualties) from accident))
	
from accident
-- where year(accident_date) = 2021
group by 
          case 
	     when light_conditions like '%Darkness%' then 'Darkness'
		 else 'Day Light'
end;

-------------------------------------------------------------------------------------------------
--- top 10 Local Authority with Total number of Casualties:

select top 10 local_authority, sum(number_of_casualties) as 'Total Number of Casualties'
from accident 
group by local_authority
order by 'Total Number of Casualties' desc;
     







