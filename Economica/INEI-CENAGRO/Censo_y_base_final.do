clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\z_censo" 

use CPV2017_POB

gen seguro = c5_p8_1 + c5_p8_2

replace area = 0 if area == 1
replace area = 1 if area == 2 

replace seguro = 1 if seguro == 2 

replace c5_p12 = 0 if c5_p12 == 1

replace c5_p12 = 1 if c5_p12 == 2 

keep ubigeo2019 area id_pob_imp_f c5_p1 c5_p2 c5_p4_1 thogar seguro c5_p12 c5_p13_anio_pri c5_p13_anio_sec c5_p14 c5_p27 c5_p28 

rename (ubigeo2019 id_pob_imp_f c5_p1 c5_p2 c5_p4_1 c5_p12 c5_p13_anio_pri c5_p13_anio_sec c5_p14 c5_p27 c5_p28) (ubigeo personas jefe sex edad analfa pri sec asis num_hijo lif_hijo)


preserve
collapse (count) personas, by(ubigeo)
 save num_poblacion.dta, replace   
restore

preserve
collapse (mean) seguro, by(ubigeo)
 save base2.dta, replace  
restore

preserve
collapse (mean) area, by(ubigeo)
 save base3.dta, replace  
restore

preserve
collapse (mean) analfa, by(ubigeo)
 save base4.dta, replace  
restore


************************************************** Hogares ********************************************************************

clear all


cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\z_censo" 

use CPV2017_HOG

replace c3_p2_10 = 0 if c3_p2_10 == 2

replace c3_p2_13 = 0 if c3_p2_13 == 2

keep ubigeo2019 c3_p2_10 c3_p2_13 c4_p1

rename (ubigeo2019 c3_p2_10 c3_p2_13 c4_p1) (ubigeo cel inter total_per)

preserve
collapse (mean) cel, by(ubigeo)
 save base5.dta, replace  
restore

preserve
collapse (mean) inter, by(ubigeo)
 save base6.dta, replace  
restore

************************************************** Viviendas ********************************************************************

clear all


cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\z_censo" 

use CPV2017_VIV

replace c2_p3 = 0 if c2_p3 > 2

replace c2_p3 = 1 if c2_p3 == 2

replace c2_p4 = 0 if c2_p4 > 1

replace c2_p11 = 0 if c2_p11 == 2

replace c2_p6 = 0 if c2_p6 > 3 

replace c2_p6 = 1 if c2_p6 == 2 | c2_p6 == 3

replace c2_p10 = 0 if c2_p10 > 2 

replace c2_p10 = 1 if c2_p10 == 2 

gen material = 0

replace material = 1 if c2_p3 == 1 | c2_p4 == 1

keep ubigeo2019 c2_p11 c2_p6 c2_p10 material id_viv_imp_f

rename (ubigeo2019 c2_p11 c2_p6 c2_p10 id_viv_imp_f) (ubigeo luz agua desa hogares)


preserve
collapse (mean) luz, by(ubigeo)
 save base7.dta, replace  
restore

preserve
collapse (mean) agua, by(ubigeo)
 save base8.dta, replace 
restore

preserve
collapse (mean) desa, by(ubigeo)
 save base9.dta, replace  
restore

preserve
collapse (mean) material, by(ubigeo)
 save base10.dta, replace  
restore

preserve
collapse (count) hogares, by(ubigeo)
 save base11.dta, replace  
restore


*************************** Base final **********************************************

clear all

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\z_censo" 

use num_poblacion

foreach i of num 2/11 {
merge m:1 ubigeo using base`i'
drop _merge 
}

save base_censo.dta, replace

use base_censo 

merge 1:1 ubigeo using base_cenagro 
drop if _merge == 1 | _merge ==2

drop _merge
save base_completa.dta, replace 


*************************** Base final ********************************************
clear all

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

use base_completa

foreach i of num 1/9 {
merge 1:1 ubigeo using base`i'
drop if _merge == 2
drop _merge
}

replace monto = 0 if monto == .

replace otro_minero = 0 if otro_minero == .

save base_completa_final.dta, replace 


