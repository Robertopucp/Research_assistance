***************************
***************************
***************************
********************************* ENCUESTA DE HOGARES *********************************

clear all

set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use OSIPTEL_hogares

tostring dist, gen(ubigeo_1)

tostring depa, gen(ubigeo)

** agregando valores
replace ubigeo_1 = "0"+substr(ubigeo_1,1,6) if dist < 100000

** identificando las variables 

keep ubigeo ubigeo_1 dist depa ficha_st conglo area t1 t2 t9 t10 p2 p3 p4 p8 p9 p10 m3_1_2 m3_1_5 r32 nse pobreza fact_exp n_personas gasto_pc_mensual ingreso_total_mensual t2a

gen ingreso_pc_mensual=(ingreso_total_mensual/n_personas)

*********************************************************
* Ordenamos el conglomerado

*sort conglo
*********************************************************

// Identificador de cada hogar por conglomerado 

gen id_viv = 0

local i = 1	

egen m = max(conglo)
local m2 = m[1]
drop m
forval j = 1/`m2' {
local k = 0
while conglo[`i'] == `j' {
    local k = `k' + 1  
 replace id_viv = `k' in `i'
 local i = `i' + 1
}
}


******************************************************************************************

rename (t1 t2 t9 t10 p2 p3 p4 p8 p9 p10 m3_1_2 m3_1_5 r32 t2a) (internet tiempos uso_personas frecuencia pared piso techo agua sshh luz gasto_fijo gasto_movil celular tipo_conex)

*celular (algun miembro del hogar utiene celular)

label define internet 1 "Fijo" 2 "Movil" 3 "Ambos" 4 "Ninguno"

label values internet internet

*preserve 

*rename id_viv num_conglo 
*collapse (count) num_conglo, by(conglo)
*save num_conglo.dta, replace

*restore
preserve 

collapse (count) depa, by(conglo) 

rename depa grupo

save grupo.dta, replace

restore

save estimacion_hogar.dta, replace	


************************************************************************** ENCUESTA A NIVEL PERSONAS ***********************************************************************

clear all

set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use OSIPTEL_personas

tostring dist, gen(ubigeo_1)

** agregando valores
replace ubigeo_1 = "0"+substr(ubigeo,1,6) if dist < 100000

keep cong ficha_st q3 q4 q5 q9 q6 q9_1 q10 v13_3 im2_1 u5_4 u6_4 y5 empleo u4_1 u4_8 u4_10 u5g u5h n_personas

*q3 jefe q4 sexo q5 edad q9 maximo_edu q6 lengua q9_1 ap_edu q10 civil im2_1 movil_cel u5_4 uso_fijo u6_4 uso_movil empleo y5 tipo_de_empleo 

rename (q3 q4 q5 q9 q6 q9_1 q10 im2_1 u5_4 u6_4 y5 u4_1 u4_8 u4_10 u5g u5h) (jefe sexo edad max_edu lengua ap_edu civil movil_cel uso_fijo uso_movil tipo fijo movil cabina banca comercio)

destring ficha_st, gen(hogar)


egen m = max(hogar) 
local m2 = m[1]
drop m

local w = 1

gen educacion_maximo = 0 
gen tiempo = 0

forval j = 2/`m2' {
    local t = `j'
while hogar[`w'] == `j'{
	
egen uno = max(max_edu) if hogar == `t'

local b = uno[`w']

gen bb = ap_edu if hogar == `t' & max_edu == `b'

egen dos = max(bb)

local a = dos[1]

replace educacion_maximo = `b' in `w'
replace tiempo = `a' in `w'

local w = `w' + 1

drop uno bb dos
}


}


preserve 

replace empleo = 0 if empleo == 2

gen trabajo = .

replace trabajo = 1 if uso_fijo == 1 | uso_movil == 1

gen edu = .

replace edu = 1 if uso_fijo == 2 | uso_movil == 2

gen menor = .

replace menor = 1 if (6 < edad) & (edad < 18)

gen len = 0

replace len = 1 if lengua == 2 | lengua == 3 | lengua == 4 | lengua == 7 | lengua == 10 | lengua == 9

collapse (sum) trabajo edu banca comercio menor movil_cel cabina len empleo, by(ficha_st) 

replace cabina = 1 if cabina > 1

replace trabajo = 1 if trabajo > 1

replace edu = 1 if edu > 1

replace banca = 1 if banca > 1

replace movil_cel = 1 if movil_cel > 1

gen wealthy = trabajo + edu

save usos_hogar.dta, replace 

restore

drop banca cabina movil_cel empleo

keep if jefe == 1 

save estimacion_persona.dta, replace

*************************************************** Estimación econométrica ***************************************************************************

clear all

set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019"

*ssc install outreg2

use estimacion_hogar

merge 1:1 ficha_st using estimacion_persona
drop _merge

merge 1:1 ficha_st using usos_hogar
drop _merge

merge m:1 conglo using grupo
drop _merge

merge m:1 ubigeo using deflactor
drop _merge

******************************** Manejo de base de datos
 
replace area = 0 if area == 1
replace area = 1 if area == 2 

gen conex_mo = internet

replace conex_mo = 0 if internet != 2

replace conex_mo = 1 if internet == 2 & movil_cel == 1

replace conex_mo = 0 if conex_mo == 2 

gen conex_ambos = internet 

replace conex_ambos = 0 if internet != 3

replace conex_ambos = 1 if internet == 3 & movil_cel == 1 

replace conex_ambos = 0 if conex_ambos == 3

* Tiempo del uso de internet 

* Servicio básicos

replace luz = 0 if luz != 1

* 0 para estratos C,D Y E; 1 para estratos A y B

replace nse = 1 if nse == 2
replace nse = 0 if nse > 2

* Genro del jefe del hogar

replace sexo = 0 if sexo == 1  // Hombre
replace sexo = 1 if sexo == 2  // Mujer


* Empleo 

*replace empleo = 0 if empleo == 2

* Educación en años
gen edu_t = .

replace edu_t = tiempo if (educacion_maximo == 2 |educacion_maximo == 3 | educacion_maximo == 4)

local primaria = 6

local secundaria = 11

local superior = 16

replace edu_t = (`primaria' + tiempo) if educacion_maximo == 5 | educacion_maximo == 6

replace edu_t = (`secundaria' + tiempo) if educacion_maximo == 7 | educacion_maximo == 8 | educacion_maximo == 9 | educacion_maximo == 10

replace edu_t = (`superior' + tiempo) if educacion_maximo == 11



* INGRESO Y GASTO DEFLACTADOS 

gen lingresos = ln((ingreso_pc_mensual/Deflactor)*100)

gen lgasto = ln((gasto_pc_mensual/Deflactor)*100)

label var lingresos "Ingreso mensual"

label var lgasto "Gasto mensual"

*graph hbox lingresos lgasto, over(internet) nooutside

* Construyendo el instrumento área con acceso a internet fijo y móvil 

preserve 

replace internet = 1 if internet < 4 

replace internet = 0 if internet == 4

collapse (sum) internet, by(ubigeo_1)

rename internet oferta_inter

replace oferta_inter = 1 if oferta_inter > 1

save oferta_inter.dta, replace 

restore

*******************************************

gen leg = len/n_personas

gen costa = 0 

replace costa = 1 if region == 1

gen sierra = 0 

replace sierra = 1 if region == 2

gen selva = 0 

replace selva = 1 if region == 3

gen emp = empleo/n_personas

********** Unir base ***********************

merge m:1 ubigeo_1 using oferta_inter
drop _merge

*save estimacion_hogar, replace

gen cluster = 0

replace cluster = 1 if cabina == 0 & internet == 4

replace cluster = 2 if conex_mo == 1 & wealthy == 0

replace cluster = 3 if conex_ambos == 1

replace cluster = 4 if conex_ambos == 1 & wealthy == 2

drop if cluster == 0

label define cluster 1 "nivel_1" 2 "nivel_2" 3 "nivel_3" 4 "nivel_4"

label values cluster cluster

sort conglo
****************************************

svyset id_viv [pweight = fact_exp], strata(conglo) 

drop if pobreza == -9

svy: tab pobreza cluster,row format(%7.3f)

*****************************************
*findit gologit2

*ssc install gologit2
 
drop oferta_inter

*constraint 1 _cons = 0

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_1)) atmeans post
outreg2 using "$folder1\gologit1.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_2)) atmeans post
outreg2 using "$folder1\gologit2.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_3)) atmeans post
outreg2 using "$folder1\gologit3.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_4)) atmeans post
outreg2 using "$folder1\gologit4.xls", nocons e(all) excel replace 


*********************************************************************************************************
gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_1)) at(sexo=0 area=0 selva=0) atmeans post
outreg2 using "$folder1\gologit1.1.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_2)) at(sexo=0 area=0 selva=0) atmeans post
outreg2 using "$folder1\gologit2.1.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_3)) at(sexo=0 area=0 selva=0) atmeans post
outreg2 using "$folder1\gologit3.1.xls", nocons e(all) excel replace 

gologit2 cluster sexo edad leg lingresos edu_t menor area sierra selva [pweight = fact_exp], vce(robust)
margins, dydx (*) predict(outcome(nivel_4)) at(sexo=0 area=0 selva=0) atmeans post
outreg2 using "$folder1\gologit4.1.xls", nocons e(all) excel replace 


















 ***************************************
 
* Efectos marginales sobre la cuarta categoría 

replace cluster = 0 if cluster < 4

replace cluster = 1 if cluster == 4

* Muestra aleatoria

gen random = runiform()

preserve

drop if cluster == 1

sort random 

gen sample = _n 

keep if sample < 154

save sample.dta, replace

restore

drop if cluster == 0

append using sample

logit cluster sexo edad leg lingresos emp edu_t menor area sierra selva [pweight = fact_exp], vce(robust) // vce(cluster cong)

margins, dydx (*) atmeans post

outreg2 using "$folder1\logit.xls", nocons e(all) excel replace

















 