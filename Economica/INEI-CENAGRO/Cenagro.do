clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\352-Modulo229"

usespss 01_IVCENAGRO_REC01.sav

save 29.dta, replace

****************************************************************************************
use 29

egen ubigeo = concat(P001 P002 P003)

keep ubigeo WALTITUD WREGION WPISO WSUP03A WSUP03B WSUP03 WSUP17 

save 29.dta, replace

preserve
collapse (mean) WALTITUD, by(ubigeo)
 save waltitud.dta  
restore

preserve
collapse (sum) WSUP03, by(ubigeo)
 save wsup.dta  
restore

preserve
collapse (sum) WSUP03A, by(ubigeo)
 save wsup1.dta  
restore

preserve
collapse (sum) WSUP03B, by(ubigeo)
 save wsup2.dta  
restore

preserve
collapse (sum) WSUP17 , by(ubigeo)
 save wsup3.dta  
restore

preserve
collapse (mean) WREGION , by(ubigeo)
save wregion.dta
restore

preserve
collapse (median) WPISO , by(ubigeo)
 save wpiso.dta  
restore
    
	
clear all

use waltitud

merge m:1 ubigeo using wsup 
drop _merge
merge m:1 ubigeo using wsup1 
drop _merge
merge m:1 ubigeo using wsup2 
drop _merge
merge m:1 ubigeo using wsup3 
drop _merge
merge m:1 ubigeo using wregion 
drop _merge
merge m:1 ubigeo using wpiso
drop _merge	

save 29.dta, replace

save "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\29.dta"

******************************************************* MODULO 31 ****************************************************

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\352-Modulo231"

usespss 03_IVCENAGRO_REC02.sav

save 31.dta

use 31

egen ubigeo = concat(P001 P002 P003)

gen ventas = 0

replace ventas = 1 if P028 == 1

keep ubigeo ventas

preserve
collapse (mean) ventas , by(ubigeo)
 save "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\ventas.dta"  
restore

*save cusco_31.dta, replace


******************************************************* MODULO 32 ****************************************************

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\352-Modulo232"

usespss 04_IVCENAGRO_REC02A.sav

save 32.dta

use 32

keep if P037_01_03 == 1 | P037_01_03 == 2

egen ubigeo = concat(P001 P002 P003)

keep ubigeo P037_01_02

preserve
collapse (sum) P037_01_02, by(ubigeo)
 save "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\titulos.dta" 
restore

*save cusco_32.dta, replace

******************************************************* MODULO 36 ****************************************************



clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\352-Modulo236"

usespss 08_IVCENAGRO_REC04A.sav

save 36.dta

use 36

egen ubigeo = concat(P001 P002 P003)

keep if P067_01 == 674 | P067_01 == 676

keep ubigeo P067_03

preserve
collapse (sum) P067_03, by(ubigeo)
 save "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto\ganado.dta"  
restore

*save cusco_36.dta, replace
************************************************************ BASE UNIFICADA ****************************************************

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\loreto"

use 29

merge m:1 ubigeo using ventas 
drop _merge

merge m:1 ubigeo using titulos
drop _merge

merge m:1 ubigeo using ganado
drop _merge

rename P037_01_02 titulos
rename P067_03 ganado

save dep15.dta

*******************************************************************************************
clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\w_cenagro"

use dep1

foreach i of num 2/24 {
append using dep`i'
}

save base_cenagro.dta

