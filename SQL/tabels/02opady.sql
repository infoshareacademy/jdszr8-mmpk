--------------------------------------------opady---------------------------------------------------

select count(*), count(precipitation_ml) ,
((count(*)-count(precipitation_ml))*100/count(*)) brakujace_wartosci_proc
from eu_unit eu  ;	
/*Jest 495 580 rekordów ogó³em z czego 68 033 rekordów jest z informacj¹ o opadach atmosferycznych (brakuje 86% danych)*/

/*statystyka*/
select  
max(round(precipitation_ml ::numeric ,2)) max_opad,
min(round(precipitation_ml ::numeric ,2)) min_opad,
mode() within group (order by precipitation_ml) moda,
percentile_disc(0.5) within group (order by precipitation_ml) mediana,
stddev(precipitation_ml) odchylenie_standardowe
from eu_unit eu  ;
/*Maksymalne opady wyniosza 164,69
  Minimalne opady wyniosza 0
  Moda :  0
  Mediana : 0,16
  Odchylenie standardowe : 7,14 */


-------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------
select * from eu_unit eu ;
-- poniewa¿ dane numeryczne z opadów s¹ niekompletne trzeba pos³u¿yæ siê opisem

create view v_opady as
select *,
lag (data_wypadku) over (partition by hrabstwo order by data_wypadku ) as poprzednia_data, 
lag (opady_deszczu) over (partition by hrabstwo order by data_wypadku ) as poprzedni_opad
from (
		select 
			distinct 
			hrabstwo , 
			data_wypadku,
			count("Severity") over (partition by hrabstwo ,	data_wypadku) as liczba_wypadkow,
			sum(Rain) over (partition by hrabstwo,	data_wypadku) as opady_deszczu
		from 	(
					select 
					"Severity" ,
					hrabstwo , 
					cast("Weather_Timestamp" as DATE) as data_wypadku,
					case
						when "Weather_Condition" like '%Drizzle%' then 1
						when "Weather_Condition" like '%Rain%' then 1
						when "Weather_Condition" like '%Shower%' then 1
													else 0
												end as Rain
											from
												eu_unit eu)x
		order by
			hrabstwo,
			data_wypadku
		)y;				
				
			
select * from v_opady;

						
select sum(liczba_wypadkow), ciagi_opadowe,
round((sum(liczba_wypadkow) *100/495580),1) as procent
from (
											select *, 
											case 
												when ciaglosc_daty = 'nastepny dzien' and opady_deszczu > 0 and poprzedni_opad >0  then ' Opady i ci¹g³oœæ' 
												when ciaglosc_daty = 'nastepny dzien' and opady_deszczu > 0 and poprzedni_opad = 0 then 'Pierwszy dzien opadów (ciag w dacie)'
												when (ciaglosc_daty = 'nastepny dzien' and opady_deszczu = 0 and poprzedni_opad = 0)
												or (ciaglosc_daty = 'nastepny dzien' and opady_deszczu = 0 and poprzedni_opad > 0) then 'Brak opadów w ciagu ale ci¹g³oœæ w dacie '
												when (ciaglosc_daty = 'nie' and opady_deszczu > 0) or (ciaglosc_daty = 'nie' and opady_deszczu = 0 ) then 'Brak ciag³oœci daty '
											end as ciagi_opadowe
											from (
															select
															*,
														case
															when data_wypadku -1 = poprzednia_data then 'nastepny dzien'
															else 'nie'
														end as ciaglosc_daty
															from v_opady vo) x) y 
								group by ciagi_opadowe;
