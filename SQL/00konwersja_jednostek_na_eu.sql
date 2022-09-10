create table eu_unit as 
select
	"ID" ,
	"Severity" ,
	"Start_Time" ,
	"End_Time" ,
	"Start_Lat" ,
	"Start_Lng" ,
	"End_Lat" ,
	"End_Lng" ,
	("Distance(mi)" * 1.6093) as Distance_km,
	"Street" 
	"City" ,
	"State" ,
	"Zipcode" ,
	"Airport_Code" ,
	"Country" ,
	"Weather_Timestamp" ,
	(("Temperature(F)" -32)* 5 / 9) as Temperature_C,
	"Humidity(%)" ,
	("Pressure(in)" * 33.8638) as Pressure_hpa,
	("Visibility(mi)" * 1.6093) as Visibility_km,
	("Wind_Speed(mph)" * 1.6109344) as Wind_Speed_kmh ,
	("Precipitation(in)" * 16.387 ) as Precipitation_ml,
	"Weather_Condition" ,
	"Nautical_Twilight"
from
	accidents a  ;