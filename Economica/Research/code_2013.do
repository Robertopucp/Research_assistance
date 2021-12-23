clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2013\Bases_de_Datos\Archivos DTA"

use OSIPTEL_hogares

tostring distri, gen(ubigeo)

replace ubigeo = "0"+substr(ubigeo,1,5) if depa < 10

//*
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


keep ubigeo ficha depa cong id_viv area p2 p3 p4 p8 p9 p10 p133 p134 p135 p15_a1 p15_c5 p15_d1 q1 r18 t1 t2 t4_2 t14_2 fact_exp pobreza gasto_me nse t13

rename (p2 p3 p4 p8 p9 p10 p133 p134 p135 p15_a1 p15_c5 p15_d1 q1 t1 t2 t4_2 t14_2 t13) (pared piso techo agua sshh luz pc lap tablet alimentos salud educa n_pers fijo conex gas_inter gas_movil conex_mo)

replace pc = 0 if pc == 2
replace lap = 0 if lap == 2
replace tablet = 0 if tablet == 2

gen tec = 0 if pc == 0 | lap == 0 | tablet == 0

replace tec = 1 if pc ==1 | lap == 1 | tablet == 1

label define tec 0 "Ninguno" 1 "Al menos uno"
label values tec tec 

drop pc lap tablet

drop if fact_exp == .

drop if pobreza == -9 

replace pobreza = 1 if pobreza == 2

label define fijo 1 "Fijo" 2 "Movil" 3 "Ambos" 4 "Ninguno"

label values fijo fijo

save 2013_hogar.dta, replace

***********************************************************************************************

use 2013_hogar

** Declarando la base como una encuesta 

svyset id_viv [pweight = fact_exp], strata(cong) 

svy: tab fijo, format(%7.3f) // Acceso (PC,tablet, laptop)

svy: tab tec, format(%7.3f) // Acceso a dispositivos 

svy: tab area fijo, row format(%7.3f) // area y tipo de ecceso a internet

svy: tab pobreza fijo, row  format(%7.3f) // pobreza y conectividad

svy: tab depart fijo, row format(%7.3f)  // departamento y acceso a internet

svy: tab area_est ve_fijo, row format(%7.3f) // satisfacción fijo velocidad 

svy: tab area_est con_fijo, row  format(%7.3f)  // satisfacción fijo continuidad

svy: tab area_est ve_movil, row  format(%7.3f) // satisfacción movil velocidad 

svy: tab area_est con_movil, row  format(%7.3f)  // satisfacción movil cintinuidad

replace gas_inter = 0 if gas_inter == -9

replace gas_movil = 0 if gas_movil == -9


*replace gas_cel = 0 if gas_cel == -9

label variable gas_inter "Gasto mensual (internet fijo)"

label variable gas_movil "Gasto mensual (internet movil)"

graph box gas_inter gas_movil

graph export "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\Graficos\gasto_mensual_internet.png", as(png) name("Graph") replace



**************************** Nivel personas ************************************************

clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2013\Bases_de_Datos\Archivos DTA"

use OSIPTEL_personas


********************** USO INTERNET FIJO ********************************

** uso de banca electronica
gen uso_banca_fi = 0 if acce_fijo == 1
replace uso_banca_fi = 1 if u5_7 == 7
** uso de compra y venta
gen uso_cv_fi = 0 if acce_fijo == 1
replace uso_cv_fi = 1 if u5_8 == 8
** busqueda de empleo 
gen uso_em_fi = 0 if acce_fijo == 1
replace uso_em_fi = 1 if u5_13 == 13

gen usos_fi = 0 if acce_fijo == 1

replace usos_fi =1 if uso_banca_fi == 1 | uso_cv_fi == 1 | uso_em_fi == 1

label define usos_fi 0 "No uso" 1 "Uso en banca, compra, venta y busqueda de empleo"

label values usos_fi usos_fi

***********************USO INTERNET MOVIL *******************************
** uso de banca electronica
gen uso_banca_mo = 0 if acce_mo == 1
replace uso_banca_mo = 1 if u8_7 == 7
** uso de compra y venta
gen uso_cv_mo = 0 if acce_mo == 1
replace uso_cv_mo = 1 if u8_8 == 8
** busqueda de empleo 
gen uso_em_mo = 0 if acce_mo == 1
replace uso_em_mo = 1 if u8_13 == 13

gen usos_mo = 0 if acce_mo == 1

replace usos_mo =1 if uso_banca_mo == 1 | uso_cv_mo == 1 | uso_em_mo == 1

label define usos_mo 0 "No uso" 1 "Uso en banca, compra, venta y busqueda de empleo"

label values usos_mo usos_mo

*************************************************************************

keep ficha q3 q4 q5 q6 q9 u1 u15 ocupacio v145_a u4_1a u4_1 u4_2 u4_3 u4_4 u4_5 u4_6
 

rename (q4 q5 q6 q9 u1 u15 v145_a u4_1a) (sexo edad lengua edu usa_inter no_inter ing_men acceso)


label define no_inter 1 "Sin servicio" 2 "No sabe usar internet" 3 "No sabe usar computadora" 4 "Caro" 5 "Desinterés" 6 "No necesita" 7 "Servicio lento" 8 "Tiempo" 9 "Padres" 10 "Sin computadora" 11 "Sin luz" 12 "Discapacidad"
label values no_inter no_inter

replace lengua = 3 if lengua == 4 | lengua == 7

label  define lengua 1 "castellano" 2 "Quechua" 3 "lengua nativa" 6 "extranjera"

label values lengua lengua 

keep if q3 == 1 

drop q3

gen cabina = .

replace cabina = 0 if usa_inter == 1

replace cabina = 1 if u4_1 == 9 | u4_2 == 9 | u4_3 == 9 | u4_4 == 9 | u4_5 == 9 | u4_6 == 9   

save 2013_jefe.dta, replace
***************************************** unir base *****************************************

clear all 

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2013\Bases_de_Datos\Archivos DTA"

use 2013_hogar

merge 1:1 ficha using 2013_jefe
drop _merge

save base_2013.dta, replace

use base_2013

svyset id_viv [pweight = fact_exp], strata(cong) 

svy: tab sexo usa_inter,row format(%7.3f) // genero del jefe del hogar y uso de internet  

svy: tab lengua usa_inter, row format(%7.3f) // lengua y acceso a internet  

svy: tab area cabina, row format(%7.3f)  // 





