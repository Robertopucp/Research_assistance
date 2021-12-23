

clear all

set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use OSIPTEL_hogares

tostring prov, gen(ubigeo)

** agregando valores
replace ubigeo = "0"+substr(ubigeo,1,3) if prov < 1000

** identificando las variables 

keep ubigeo depa ficha_st conglo p2 p3 p4 p8 p9 p10 p13_2_02 p13_2_03 p13_2_05 p14a_1 p14c_5 p14d_1 t1 t2a t3a o5_4 fact_exp area pobreza fact_exp n_personas gasto_pc_mensual ingreso_total_mensual

gen ingreso_pc_mensual=(ingreso_total_mensual/n_personas)


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

rename (p2 p3 p4 p8 p9 p10 p13_2_02 p13_2_03  p13_2_05 p14a_1 p14c_5 p14d_1 t1 t2a t3a o5_4) (pared piso techo agua sshh luz pc lap tablet alimentos salud geducación fijo conex ve_fijo con_fijo)

gen alimentos_m = (alimentos*2)/n_personas
gen salud_m = (salud/3)/n_personas
gen educac_m = (geducación/12)/n_personas
******************************************************************************************************************************************************************************

label define fijo 1 "Fijo" 2 "Movil" 3 "Ambos" 4 "Ninguno"

label values fijo fijo

replace pobreza = 1 if pobreza == 2
******************************************************************************************************************************************************************************

replace pc = 0 if pc == 2
replace lap = 0 if lap == 2
replace tablet = 0 if tablet == 2

gen tec = 0 if pc == 0 | lap == 0 | tablet == 0

replace tec = 1 if pc ==1 | lap == 1 | tablet == 1

label define tec 0 "Ninguno" 1 "Al menos uno"
label values tec tec 

drop pc lap tablet

*****************************************


*****************************************

save 2019_hogar.dta, replace

use 2019_hogar

** Declarando la base como una encuesta 

svyset id_viv [pweight = fact_exp], strata(conglo) 

svy: tab fijo, format(%7.3f) // Acceso (PC,tablet, laptop)

svy: tab tec, format(%7.3f) // Acceso a dispositivos 

svy: tab area fijo, row format(%7.3f) // area y tipo de ecceso a internet

svy: tab pobre fijo, row  format(%7.3f) // pobreza y conectividad

svy: tab depa fijo, row format(%7.3f)  // departamento y acceso a internet

svy: tab area ve_fijo, row format(%7.3f) // satisfacción fijo velocidad 

svy: tab area con_fijo, row  format(%7.3f)  // satisfacción fijo continuidad

svy: tab area ve_movil, row  format(%7.3f) // satisfacción movil velocidad 

svy: tab area con_movil, row  format(%7.3f)  // satisfacción movil cintinuidad

***************************************** uso internet del jefe del hogar



** comandos preserve y restore mantienen la base inicial sin cambios

*preserve

*collapse (mean) ficha, by(depart)

*restore

** similar al comando collapse
*bysort depart: mean ficha

** revisar las etiquetas de variables
*label list estrato

*************************************************************************nivel personas*********************************************************************************
clear all

set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use OSIPTEL_personas

** solo nos quedamos con los jefes del hogar 

keep ficha q3 q4 q5 q6 q9 u1 u5_4 u6_4 u9 u4_10 area fact_exp depa pobreza   

rename (q4 q5 q6 q9 u1 u5_4 u6_4  u9 u4_10) (sexo edad lengua edu usa_inter uso_fijo uso_movil no_inter cabina)

label define no_inter 1 "Sin servicio en zona" 2 "No sabe usar internet" 3 "No sabe usar computadora" 4 "Caro" 5 "Sin interés" 6 "No necesita" 7 "No útil" 8 "Móvil malogrado"  9 "Cambia número" 10 "Celular del padre" 11 "No tiene tiempo" 12 "Robo móvil" 13 "Mala cobertura" 14 "Sin dinero" 16 "Pérdida de celular" 17 "Sin electricidad" 18 "Problemas visuales" 19 "No tiene móvil" 20 "Sin internet" 21 "Equipo antiguo" 22 "Sin PC" 23 "No sabe contratar" 24 "No sabe leer"

label values no_inter no_inter

replace lengua = 3 if lengua == 3 | lengua == 4 | lengua == 7 | lengua == 10
replace lengua = 6 if lengua == 6 | lengua == 8 | lengua == 9

label  define lengua 1 "castellano" 2 "Quechua" 3 "lengua nativa" 5 "Extranjero" 6 "Otro"

label values lengua lengua 


preserve 

gen trabajo_fijo = .

replace trabajo_fijo = 1 if uso_fijo == 1

gen edu_fijo = .

replace edu_fijo = 1 if uso_fijo == 2

gen trabajo_mo = .

replace trabajo_mo = 1 if uso_movil == 1

gen edu_mo = .

replace edu_mo = 1 if uso_movil == 2

collapse (sum) trabajo_fijo edu_fijo trabajo_mo edu_mo , by(ficha_st) 

save usos_hogar.dta, replace 

restore

replace usa_inter = 0 if usa_inter == 2

preserve 

collapse (sum) usa_inter , by(ficha_st) 
save usa.dta, replace 

restore


** solo nos quedamos con el jefe del hogar 
keep if q3 == 1 

drop q3

save 2019_jefe.dta, replace


***************************************** unir base *****************************************

clear all 

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

*use esco

use 2019_hogar

merge 1:1 ficha using usos_hogar
drop _merge

merge 1:1 ficha_st using usa
drop _merge

rename usa_inter hogar 

merge 1:1 ficha_st using 2019_jefe
drop _merge



gen Porcentaje = (trabajo_fijo/hogar)
gen p_fijo_edu = (edu_fijo/hogar)
gen p_mo_trabajo = (trabajo_mo/hogar)
gen p_mo_edu = (edu_mo/hogar)
gen hogar_inter = (hogar/n_pers)

save base_2019.dta, replace

**********************************************************************************************
clear all 

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use base_2019

svyset id_viv [pweight = fact_exp], strata(conglo) 


svy: tab sexo usa_inter,row format(%7.3f) // genero del jefe del hogar y uso de internet  

svy: tab lengua usa_inter, row format(%7.3f) // lengua y acceso a internet  

svy: tab area cabina, row format(%7.3f)  // 

svy: tab no_inter, format(%7.3f)  // 

preserve 

keep if sexo == 2

svy: tab uso_fijo, format(%7.3f) 

restore

preserve 

keep if sexo == 2
svy: tab uso_movil, format(%7.3f) 

restore 

*svy: tab escolar, format(%7.3f)

***********************************************************************************************

label var Porcentaje "Trabajo Fijo"
label var p_fijo_edu "Educación Fijo"
label var p_mo_trabajo "Trabajo Móvil"
label var p_mo_edu "Educación Móvil"


replace Porcentaje =. if  Porcentaje == 0

histogram Porcentaje, bin(20) percent fcolor(yellow) legend(label (1 "Trabajo Fijo"))  saving(hist1, replace)

kdensity Porcentaje, nograph generate(x fx)


**************************************************************

replace p_fijo_edu =. if   p_fijo_edu == 0

histogram p_fijo_edu, bin(20) percent fcolor(green) legend(label (2 "Educación Fijo"))  saving(hist2, replace)

kdensity p_fijo_edu, nograph generate(x1 fx0) 

****************************************************************

replace p_mo_trabajo =. if p_mo_trabajo == 0

histogram p_mo_trabajo, bin(20) percent fcolor(blue) legend(label (3 "Trabajo Móvil"))  saving(hist3, replace)

kdensity p_mo_trabajo, nograph generate(x2 fx1) 

**************************************************************

replace p_mo_edu =. if p_mo_edu == 0

histogram p_mo_edu, bin(20) percent fcolor(red) legend(label (4 "Educación Móvil"))  saving(hist4, replace)

kdensity p_mo_edu, nograph generate(x3 fx2)

*line cum p_mo_edu
*histogram p_mo_edu, normal

*label var fx "Trabajo (fijo)"
*label var fx0 "Educación (fijo)"
*label var fx1 "Trabajo (móvil)"
*label var fx2 "Educación (móvil)"

*line fx0 fx1 fx2 fx x, sort ytitle(Density 2019)

*histogram Porcentaje, bin(35) percent fcolor(yellow) legend(label (1 "Trabajo Fijo")) addplot(histogram p_fijo_edu, bin(35) percent fcolor(blue) ///
*legend(label (2 "Educación Fijo"))) addplot(histogram p_mo_trabajo, bin(35) percent fcolor(red) ///
*legend(label (2 "Trabajo Móvil"))) addplot(histogram p_mo_edu, bin(35) percent fcolor(green) ///
*legend(label (2 "Educación Móvil"))) saving(hist1, replace)

graph combine hist1.gph hist2.gph hist3.gph hist4.gph, xcommon


histogram Hogares, bin(20) percent fcolor(yellow) legend(label (1 "Hogares 2012")) addplot(histogram Hogares2019, bin(35) percent fcolor(blue) legend(label (2 "Hogares 2019"))) saving(hist1, replace)
*****************************************************************

label var ingreso_pc_mensual "Ingreso mensual"

label var gasto_pc_mensual "Gasto mensual"

****************************************************************
replace hogar_inter = . if hogar_inter == 0

rename hogar_inter Hogares

kdensity Hogares, title(" ")

histogram Hogares, percent 

preserve 

keep ficha_st Hogares 

save mi_inter.dta, replace

restore 

*******************************************************************

preserve

graph hbox ingreso_pc_mensual gasto_pc_mensual, over(fijo) nooutside

restore

******************************************************************

clear all 

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\Archivos DTA"

use mi_inter

destring ficha_st, gen(ficha)

drop ficha_st

save mi_inter, replace 

******************************************************************
use mi_inter

rename Hogares Hogares2019

merge m:1 ficha using mi_inter2012
*drop _merge
replace Hogares = . if Hogares == 0

replace Hogares2019 = . if Hogares2019 == 0

kdensity Hogares, nograph generate(x1 fx1) 

kdensity Hogares2019, nograph generate(x2 fx2) 

label var fx1 "Hogares 2012"
label var fx2 "Hogares 2019"

histogram Hogares, percent 
histogram Hogares2019, percent 
line fx1 fx2 x1, sort ytitle(Density)

*****************************************************************

histogram Hogares, bin(20) percent fcolor(yellow) legend(label (1 "Hogares 2012")) addplot(histogram Hogares2019, bin(35) percent fcolor(blue) legend(label (2 "Hogares 2019"))) saving(hist1, replace)













