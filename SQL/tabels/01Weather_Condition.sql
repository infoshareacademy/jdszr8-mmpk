------------------------------------Podzai³ na warunki atmosferyczne-----------------------------------------
create view v_Weather_Condition as
select 
	"ID" ,	
	"Severity" ,
	"City" ,
	"State" ,
	"Zipcode" ,
	"Airport_Code" ,
	kraj ,
	hrabstwo ,
	"Weather_Condition" ,
	"Weather_Timestamp" ,
case
	when "Weather_Condition" like '%Clear%' then 1
	when "Weather_Condition" like '%Fair%'then 1
	when "Weather_Condition" like '%N/A Precipitation%'then 1
	else 0
end as Clear,
case 
	when "Weather_Condition" like '%Snow%' then 1
	when "Weather_Condition" like '%Freez%' then 1
	when "Weather_Condition" like 'Wintry%' then 1
	when "Weather_Condition" like '%Ice Pellets%' then 1
	when "Weather_Condition" like '%Sleet%' then 1
	else 0
end as Snow,
case
	when "Weather_Condition" like '%Dust%' then 1
	else 0
end as Dust,
case
	when "Weather_Condition" like '%Fog%' then 1
	when "Weather_Condition" like '%Haze%'then 1
	when "Weather_Condition" like '%Smoke%'then 1
	when "Weather_Condition" like '%Mist%'then 1
	else 0
end as Fog,
case
	when "Weather_Condition" like '%Cloud%' then 1
	when "Weather_Condition" like '%Overcast%'then 1
	when "Weather_Condition" like '%Squalls%'then 1
	else 0
end as Clouds,
case
	when "Weather_Condition" like '%Drizzle%' then 1
	when "Weather_Condition" like '%Rain%'then 1
	when "Weather_Condition" like '%Shower%'then 1
	else 0
end as Rain,
case
	when "Weather_Condition" like '%torm%' then 1
	when "Weather_Condition" like '%Thunder%'then 1
	when "Weather_Condition" like '%Hail%' then 1
	else 0
end as Storm,
case
	when "Weather_Condition" like '%Wind%' then 1
	else 0
end as Wind
from eu_unit eu 
where "Weather_Condition"  != '' ;

----------------------------Suma ze wzg na opis pogody------------------------------------------------


create table t_procent_z_opisu as
with suma as (select 
	"Severity" ,
	sum(clear) as sum_clear,
	sum(snow) as sum_snow,
	sum(dust ) as sum_dust,
	sum(fog) as sum_fog,
	sum(clouds) as sum_clouds, 
	sum(rain) as sum_rain,
	sum(storm) as sum_storm, 
	sum(wind) as sum_wind
from v_Weather_Condition 
group by "Severity")

select 
"Severity",
round(sum_clear*100/481763.0,1) as clear,
round(sum_snow*100/481763.0,1) as snow,
round(sum_fog*100/481763.0,1) as fog,
round(sum_clouds*100/481763.0,1) as cloud,
round(sum_rain*100/481763.0,1) as rain,
round((sum_wind+sum_dust+sum_storm)*100/481763.0,1) as other
from suma;
	
