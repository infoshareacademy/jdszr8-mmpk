------------------------------------------------CISNIENIE-------------------------------
/*Bledne dane : cisnienie najwyzsze zanotowane na swiecie to 32,0696 a najnizsze 25,691- po przejsciu tajfunu 
 Sprawdzajac dane najnizsze cisnienie w tym okresie to 29,45 in a najwyzsze 30,74 */

select * from eu_unit eu  ;

/*Ilosc dancyh */
select count(*), count(pressure_hpa) ,
((count(*)-count(pressure_hpa))*100/count(*)) brakujace_wartosci_proc
from eu_unit eu  ;	
/*Jest 495 580 rekordow ogolem z czego 479 054 rekordow jest z informacja o cisnieniu atmosferycznym (3% brakujacych rekordow)*/


/*Statystyka*/
select  
max(round(pressure_hpa  ::numeric ,2)) max_cisnienie,
min(round(pressure_hpa  ::numeric ,2)) min_cisnienie,
mode() within group (order by pressure_hpa) moda,
percentile_disc(0.5) within group (order by pressure_hpa) mediana,
avg(pressure_hpa) sredni,
stddev(pressure_hpa) odchylenie_standardowe
from eu_unit eu ;
/*Maksymalne cisnienie wynioslo 1 043,01
  Minimalne cisnienie wynioslo 995,93
  Moda :  1 016,25
  Mediana : 1 016,59
  Srednia: 1 016,96
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
						count(data_wypadku) over (partition by hrabstwo,data_wypadku) as liczba_wypadkow,
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
select sum(liczba_wypadkow), zmiany_cisnienia,
round((sum(liczba_wypadkow) *100/479054),1) as procent
from (
											select *, 
											case 
												when ciaglosc_daty = 'nastepny dzien' and wielkosc_zmian >=10 and  cisnienie > poprzednie_cisnienie then 'Wzroslo' 
												when ciaglosc_daty = 'nastepny dzien' and wielkosc_zmian >=10 and  cisnienie < poprzednie_cisnienie then 'Zmalalo' 
												when ciaglosc_daty = 'nastepny dzien' and (cisnienie = poprzednie_cisnienie or wielkosc_zmian < 10)  then 'Brak zmian' 
												when ciaglosc_daty = 'nie' then  'Brak ciaglosci daty'
											end as zmiany_cisnienia
											from (
														select
														*,
														case
															when data_wypadku -1 = poprzedni_dzien then 'nastepny dzien'
															else 'nie'
														end as ciaglosc_daty,
														abs(cisnienie - poprzednie_cisnienie) as wielkosc_zmian
														from v_cisnienia) x) y 
								group by zmiany_cisnienia;


			
