------------------------------------------------CISNIENIE-------------------------------
/*B³êdne dane : ciœnienie najwy¿sze zanotowane na œwiecie to 32,0696 a najni¿sze 25,691- po przejœciu tajfunu 
 Sprawdzaj¹æ dane najni¿sze ciœnienie w tym okresie to 29,45 in a najwyzsze 30,74 */

select * from eu_unit eu  ;

/*Iloœæ dancyh */
select count(*), count(pressure_hpa) ,
((count(*)-count(pressure_hpa))*100/count(*)) brakujace_wartosci_proc
from eu_unit eu  ;	
/*Jest 495 580 rekordów ogó³em z czego 479 054 rekordów jest z informacj¹ o ciœnieniu atmosferycznym (3% brakuj¹cych rekordów)*/


/*Statystyka*/
select  
max(round(pressure_hpa  ::numeric ,2)) max_cisnienie,
min(round(pressure_hpa  ::numeric ,2)) min_cisnienie,
mode() within group (order by pressure_hpa) moda,
percentile_disc(0.5) within group (order by pressure_hpa) mediana,
avg(pressure_hpa) sredni,
stddev(pressure_hpa) odchylenie_standardowe
from eu_unit eu ;
/*Maksymalne ciœnienie wynios³a 1 043,01
  Minimalne ciœnienie wynios³a 995,93
  Moda :  1 016,25
  Mediana : 1 016,59
  Œrednia: 1 016,96
  Odchylenie standardowe : 6,666 */
		
			
----------------------------------------------------------------------------------





---------------przygotowanie danych ------------------
create view v_cisnienia as 
select  *,
lag (data_wypadku) over (partition by hrabstwo order by data_wypadku ) as poprzedni_dzien,
lag (cisnienie) over (partition by hrabstwo order by data_wypadku ) as poprzednie_cisnienie
from (select
						distinct 
						hrabstwo,
						data_wypadku,
						count(data_wypadku) over (partition by hrabstwo,data_wypadku) as liczba_wypadków,
						round(avg(pressure_hpa) over (partition by hrabstwo , data_wypadku)) as cisnienie
					from
						(
						select 
									"Severity",
									hrabstwo , 
									cast("Weather_Timestamp" as DATE) as data_wypadku,
									pressure_hpa
						from
							eu_unit eu
							where pressure_hpa is not null) x) y 
		order by hrabstwo, data_wypadku;
			
-----------------wyliczenia ---------------------------------------------
select sum(liczba_wypadków), zmiany_cisnienia,
(sum(liczba_wypadków) *100/479054) as procent
from (
											select *, 
											case 
												when ciaglosc_daty = 'nastepny dzien' and cisnienie > poprzednie_cisnienie then 'Wzros³o' 
												when ciaglosc_daty = 'nastepny dzien' and cisnienie < poprzednie_cisnienie then 'Zmala³o' 
												when ciaglosc_daty = 'nastepny dzien' and cisnienie = poprzednie_cisnienie then 'Brak zmian' 
												when ciaglosc_daty = 'nie' then  'Brak ci¹g³oœci daty'
											end as zmiany_cisnienia
											from (
															select
															*,
														case
															when data_wypadku -1 = poprzedni_dzien then 'nastepny dzien'
															else 'nie'
														end as ciaglosc_daty
															from v_cisnienia) x) y 
								group by zmiany_cisnienia;


			
