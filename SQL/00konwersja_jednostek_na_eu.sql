create table ue_unit as 
select "ID" , "Severity" , "Start_Time" ,"End_Time" , "Start_Lat" ,"Start_Lng" ,"End_Lat" ,"End_Lng" , "City" , "State" , "Zipcode" ,"Airport_Code" ,"Weather_Timestamp" ,
(("Temperature(F)" -32)*5/9) as Temperature_C, 
"Humidity(%)" ,
("Pressure(in)" *33.86389) as Pressure_hPa,
("Visibility(mi)" * 1.6093) as Visibility_km,
("Wind_Speed(mph)" * 1.6109344) as Wind_Speed_kmh ,
("Precipitation(in)" * 16.387 ) as Precipitation_ml,
"Nautical_Twilight" 
from accidents_us au  ;