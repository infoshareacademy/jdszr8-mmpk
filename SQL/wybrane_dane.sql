create table accidents as
select 
"ID" ,
"Severity" ,
"Start_Time" ,
"End_Time" ,
"Start_Lat" ,
"Start_Lng" ,
"End_Lat" ,
"End_Lng" ,
"Distance(mi)" ,
"Street" ,
"City" ,
"State" ,
"Zipcode" ,
"Airport_Code" ,
"Weather_Timestamp" ,
"Temperature(F)" ,
"Humidity(%)" ,
"Pressure(in)" ,
"Visibility(mi)" ,
"Wind_Speed(mph)" ,
"Precipitation(in)" ,
"Weather_Condition" ,
"Nautical_Twilight" 
from us_accidents_dec21_updated uadu
where to_char("Start_Time", 'YYYY-MM') BETWEEN '2016-04' and '2019-03';
 
