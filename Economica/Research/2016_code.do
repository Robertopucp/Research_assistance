clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2016\Bases de Datos\Archivos DTA"

use OSIPTEL_hogares

tostring distri, gen(ubigeo)

replace ubigeo = "0"+substr(ubigeo,1,5) if depa < 10

keep ubigeo ficha_st depart area cong pobreza fact_exp n_pers t1 t2 p133 p134 p136

rename (t1 t2 p133 p134 p136) (fijo conex pc lap tablet)

replace pc = 0 if pc == 2
replace lap = 0 if lap == 2
replace tablet = 0 if tablet == 2

gen tec = 0 if pc == 0 | lap == 0 | tablet == 0

replace tec = 1 if pc ==1 | lap == 1 | tablet == 1

label define tec 0 "Ninguno" 1 "Al menos uno"
label values tec tec 

drop pc lap tablet

label define fijo 1 "Fijo" 2 "Movil" 3 "Ambos" 4 "Ninguno"

label values fijo fijo

replace pobreza = 1 if pobreza == 2

****************************************
gen id_viv = 0

local i = 1	

egen m = max(cong)
local m2 = m[1]
drop m
forval j = 1/`m2' {
local k = 0
while cong[`i'] == `j' {
    local k = `k' + 1  
 replace id_viv = `k' in `i'
 local i = `i' + 1
}
}

***************************

*** falta deflactar los gastos y dividirlos a mensual y por el numero de personas del hogar 

save 2016_hogar, replace 
**************************************** Personas ********************************************
clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2016\Bases de Datos\Archivos DTA"

use OSIPTEL_personas

keep ficha_st cong q3 q4 q5 q6 q9_1 u4_9 u1 u5a_1 u8a_1 u15 u8a_2 u5a_2

rename (q4 q5 q6 q9 u4_9 u1 u5a_1 u5a_2 u8a_1 u8a_2 u15) (sexo edad lengua edu cabina usa_inter uso_fijo_1 uso_fijo_2 uso_movil_1 uso_movil_2 no_inter)

keep if q3 == 1 

drop q3

save jefe_2016.dta, replace

*********************************************

***************************************** unir base *****************************************

clear all 

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2016\Bases de Datos\Archivos DTA"

*use esco

use 2016_hogar

merge m:1 ficha_st using jefe_2016
drop if  _merge == 1

replace lengua = 3 if lengua == 4 | lengua == 8 | lengua == 9 | lengua == 10 | lengua == 11 | lengua == 7

save 2016_base.dta, replace 

****************************************************************************************

use 2016_base

svyset id_viv [pweight = fact_exp], strata(cong)

svy: tab fijo, format(%7.3f) // Acceso (PC,tablet, laptop)

svy: tab tec, format(%7.3f) // Acceso a dispositivos 

svy: tab area fijo, row format(%7.3f) // area y tipo de ecceso a internet

svy: tab pobreza fijo, row  format(%7.3f) // pobreza y conectividad

svy: tab sexo usa_inter,row format(%7.3f) // genero del jefe del hogar y uso de internet  

svy: tab lengua usa_inter, row format(%7.3f) // lengua y acceso a internet  

svy: tab area cabina, row format(%7.3f)  //

svy: tab uso_fijo_1, format(%7.3f)

svy: tab uso_movil_1, format(%7.3f)

svy: tab uso_fijo_2, format(%7.3f)

svy: tab uso_movil_2, format(%7.3f)

svy: tab no_inter, format(%7.3f)


