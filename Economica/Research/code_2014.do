clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2014\Bases de Datos\Archivos DTA"

use OSIPTEL_hogares

tostring distri, gen(ubigeo)

replace ubigeo = "0"+substr(ubigeo,1,5) if depa < 10

keep ubigeo ficha_st depa area pobreza fact_exp n_pers nse g_per1 ingreso_pc t1 t2 e10_2 e10_3 p133 p134 p136 p14_a1 p14_c5 p14_d1 t13_1_5 t13_2_4

rename  (g_per1 t1 t2 e10_2 e10_3 p133 p134 p136 p14_a1 p14_c5 p14_d1 t13_1_5 t13_2_4) (g_per fijo conex gas_mo gas_fijo pc lap tablet alimentos salud educa cel1 cel2)



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

********************************

drop if pobreza == 99

replace pobreza = 1 if pobreza == 2

********************************

save 2014_hogar, replace 

****************************************************************************************************************************************

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2014\Bases de Datos\Archivos DTA"

use OSIPTEL_personas

keep ficha_st cong q3 q4 q5 q6 q9_1 u4_9 u1

rename (q4 q5 q6 q9 u4_9 u1) (sexo edad lengua edu cabina usa_inter)

replace lengua = 3 if lengua == 4 | lengua == 7 | lengua == 8

label  define lengua 1 "castellano" 2 "Quechua" 3 "lengua nativa" 6 "extranjera"

label values lengua lengua 

keep if q3 == 1

save 2014_jefe.dta, replace 

*************************************************** unir bases

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2014\Bases de Datos\Archivos DTA"

use 2014_hogar

merge 1:1 ficha_st using 2014_jefe
drop _merge
drop if fact_exp == .
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

save base_2014.dta, replace


********************************** estadisticas 

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2014\Bases de Datos\Archivos DTA"

use base_2014


svyset id_viv [pweight = fact_exp], strata(cong) 

svy: tab fijo, format(%7.3f) // Acceso (PC,tablet, laptop)

svy: tab tec, format(%7.3f) // Acceso a dispositivos 

svy: tab area fijo, row format(%7.3f) // area y tipo de ecceso a internet

svy: tab pobreza fijo, row  format(%7.3f) // pobreza y conectividad

svy: tab sexo usa_inter,row format(%7.3f) // genero del jefe del hogar y uso de internet  

svy: tab lengua usa_inter, row format(%7.3f) // lengua y acceso a internet  

svy: tab area cabina, row format(%7.3f)  // 





