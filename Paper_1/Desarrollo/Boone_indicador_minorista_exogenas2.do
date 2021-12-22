clear all
set more off   

// Importamos la base de datos final de la pestaña Base_mayor ( mercado mayorista )

import excel "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(c4:AA3884) firstrow clear
drop creditos dum_1 banco micro

global folder = "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Resultados"


xtset entidad id
*Adecuamos las variables 

 destring credito_1, generate(credito1)
 drop credito_1
 
 destring credito_2, generate(credito2)
 drop credito_2
  
 destring costo_total, generate(costo_total_1)
 drop costo_total
 rename costo_total_1 costo_total
  
  	destring lab, generate (lab1)
	drop lab
	destring fon, generate (fon1)
	drop fon
	destring prov, generate (prov1)
	drop prov
	destring moro, generate (moro1)
	drop moro

rename part1 part_1
*gen part_1=(part1-L12.part1)*100
  * Variables en tasas de crecimiento para corregir la raiz unitaria
 
gen credito_1 = (credito1-L12.credito1)*100
gen credito_2 = (credito2-L12.credito2)*100
gen fon = (fon1-L12.fon1)*100
gen prov = (prov1-L12.prov1)*100
gen moro = (moro1-L12.moro1)*100
gen capital1 = (capital-L12.capital)*100
gen capital2 = (capital_2-L12.capital_2)*100
drop capital
rename capital_2 capital_m
rename (capital1 capital2) (capital capital_2)

** Solo nos quedamos a partir de Diciembre 2012 (por la correción de RU)
keep if id>13
gen id_1=id-12
drop id
rename id_1 id_2
*gen id_2 = ln(id) /*por qué? tendencia?*/
 //// Creamos las variables adecuadas para estimar la función de costos translogaritmica
xtset entidad id_2

gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c2c2 = 0.5*fon*fon
gen c5c5 = 0.5*capital_2*capital_2
gen c4c4 = 0.5*prov*prov

gen c1c2 = lab1*fon
gen c1c5 = lab1*capital_2
gen c1c4 = lab1*prov
gen c2c5 = fon*capital_2
gen c2c4 = fon*prov
gen c4c5 = prov*capital_2

*** nueva variable capital
gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c5 = credito_1*capital_2
gen y1c4 = credito_1*prov

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c5 = credito_2*capital_2
gen y2c4 = credito_2*prov

* Tendencia
gen z2z2 = 0.5*id_2*id_2
gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c5 = id_2*capital_2
gen z2c4 = id_2*prov
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1z2=id_2*moro

* morosidad
gen z1z1 = 0.5*moro*moro
gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c5 = moro*capital_2
gen z1c4 = moro*prov
gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2

** Agrupamos las exogenas 
*Exógenas 1
global exogenas_1 "lab1 fon capital prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c3c3 c4c4 c1c2 c1c3 c1c4 c2c3 c2c4 c3c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 id_2 z2z2 z2c1 z2c2 z2c3 z2c4 z2y1 z2y2"
*Exógenas 2
global exogenas_2 "lab1 fon capital_2 prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c5c5 c4c4 c1c2 c1c5 c1c4 c2c5 c2c4 c4c5 y1c1 y1c2 y1c5 y1c4 y2c1 y2c2 y2c5 y2c4 id_2 z2z2 z2c1 z2c2 z2c5 z2c4 z2y1 z2y2 moro z1z1 z1c1 z1c2 z1c5 z1c4 z1y1 z1y2 z1z2"

* EVALUACIÓN: Para grupo "exógenas_2"
** Test de Hausman
*** Efectos aleatorios
qui xtreg costo_total $exogenas_2, re 
estimates store fixed_2
** Efectos fijos
qui xtreg costo_total $exogenas_2, fe 
*Test de Hausman
hausman fixed_2 /*Efectos fijos*/

*Test de Breush Pagan ( efectos aleatorios vs pool MCO)
xtreg costo_total $exogenas_2
xtreg costo_total $exogenas_2, re
xttest0
// Resultado: Estimador Pool MCO

* Homogeneidad Total 
******** Estimación de la función de costos translogaritmica


* Exógenas_2: Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young

constraint 4 lab1+fon+prov+capital_2=1
constraint 5 c1c1+c2c2+c5c5+c4c4+2*c1c2+2*c1c4+2*c1c5+2*c2c5+2*c2c4+2*c4c5=0
constraint 6 y1c1+y1c2+y1c4+y1c5=0
constraint 7 y2c1+y2c2+y2c4+y2c5=0
constraint 8 z2c1+z2c2+z2c4+z2c5=0
constraint 9 z1c1+z1c2+z1c4+z1c5=0

** La estimación Pool MCO


xi: cnsreg costo_total $exogenas_2, c(4-9) robust  // robustas a problemas de heterocedasticidaad 
*ssc install outreg2
*outreg2 using "$folder\Final_preliminar\CostoTotal_minorista.xls", e(all) excel replace 

mat lis e(b)

** Especificación de la matriz 
matrix b=e(b)

** obtenemos los coeficientes

gen beta1 = b[1,1]  // coeficiente laboral
gen beta2 = b[1,2]  // coeficiente fondeo
gen beta3 = b[1,3]  // coeficiente capital_2
gen beta4 = b[1,4]  // ceficiente provisiones
gen beta5 = b[1,5]  // coeficiente y1
gen beta6 = b[1,6]  // coeficiente y2
gen beta7 = b[1,28]    // coeficiente z2 (tendencia)
gen beta8 = b[1,36]    // coeficiente z1 (morosidad)

gen beta11 = b[1,10]    // coeficiente laboral_2
gen beta22 = b[1,11]    // coeficiente fondeo_2
gen beta33 = b[1,12]    // coeficiente capital_2
gen beta44 = b[1,13]    // coeficiente provisiones_2
gen beta55 = b[1,7]    // coeficiente y1_2
gen beta66 = b[1,8]    // coeficiente y2_2 
gen beta77 = b[1,29]    // coeficiente z2_2 

gen beta12 = b[1,14]  // coeficiente lab_fondeo
gen beta13 = b[1,15]   // coeficiente lab_capital
gen beta14 = b[1,16]  // coeficiente lab_provisiones
gen beta23 = b[1,17]    // coeficiente fondeo_capital
gen beta24 = b[1,18]    // coeficiente fondeo_prov
gen beta34 = b[1,18]    // coeficiente cap_prov
gen beta17 = b[1,30]    // coeficiente lab_tend
gen beta27 = b[1,31]    // coeficiente fondeo_tend
gen beta37 = b[1,32]    // coeficiente capital_tend
gen beta47 = b[1,33]    // coeficiente provisiones_tend

gen beta15 = b[1,20]   // coeficiente lab_y1
gen beta25 = b[1,21]    // coeficiente fondeo_y1
gen beta35 = b[1,22]    // coeficiente capital_y1
gen beta45 = b[1,23]    // coeficiente provisiones_y1
gen beta75 = b[1,34]    // coeficiente tend_y1
gen beta16 = b[1,24]    // coeficiente lab_y2
gen beta26 = b[1,25]    // coeficiente fondeo_y2
gen beta36 = b[1,26]    // coeficiente capital_y2
gen beta46 = b[1,27]    // coeficiente provisiones_y2
gen beta56 = b[1,9]    // coeficiente y1_y2   
gen beta76 = b[1,35]    // coeficiente tend_y2

gen beta81 = b[1,37]    // coeficiente moro_2
gen beta82 = b[1,38]    // coeficiente moro_lab1
gen beta83 = b[1,39]    // coeficiente moro_fon
gen beta84 = b[1,40]    // coeficiente moro_capital_2
gen beta85 = b[1,41]    // coeficiente moro_prov
gen beta86 = b[1,42]    // coeficiente moro_y1
gen beta87 = b[1,43]    // coeficiente moro_y2
gen beta88 = b[1,44]    // coeficiente moro_id_2

** Se construye los costos marginales (mercado mayorista)

** Se construye los costos marginales (mercado mayorista)

gen cmg_1=costos_niveles*(credito_nivel_1)^(-1)*(beta5+beta55*credito_1+beta15*lab1+beta25*fon+beta35*capital_2+beta45*prov+beta56*credito_2+beta75*id_2+beta86*moro)

*Costo marginal (otros créditos) 

gen cmg_2=costos_niveles*(credito_nivel_2)^(-1)*(beta6+beta66*credito_2+beta16*lab1+beta26*fon+beta36*capital_2+beta46*prov+beta56*credito_1+beta76*id_2+beta87*moro)


** Estadisticas descriptivas de los costos marginales
** Estadisticas descriptivas de los costos marginales
sum cmg_1
sum cmg_1 if cmg_1>0
sum cmg_2
sum cmg_2 if cmg_2>0

** Generamos el logaritmo de los costos marginales 
gen ln_cmg1=ln(cmg_1)

// creamos dummies por año
gen year1=0
replace year1 = 1 if anual==13
gen year2=0
replace year2 = 1 if anual==14
gen year3=0
replace year3 = 1 if anual==15
gen year4=0
replace year4 = 1 if anual==16
gen year5=0
replace year5 = 1 if anual==17
gen year6=0
replace year6 = 1 if anual==18
gen year7=0
replace year7 = 1 if anual==19


foreach i of num 1/7 {
gen ln_cmg_`i' = year`i'*ln_cmg1
}

// Indicador de Boone 

**Test de Hausman

** Efectos aleatorios
qui xtreg part_1 ln_cmg_* year*, re 

estimates store fixed2

** Efectos fijos 
qui xtreg part_1 ln_cmg_* year*, fe  

hausman fixed2

**Test de efestos aleatorios
xtreg part_1 ln_cmg_* year*
xtreg part_1 ln_cmg_* year*, re
xttest0
* Resultado: Se estima por efectos aleatorios  

xtreg part_1 ln_cmg_* year2 year3 year4 year5 year6 year7, re cluster(entidad)
outreg2 using "$folder\Final_preliminar\boone_minorista.xls", e(all) excel replace
testparm year2 year3 year4 year5 year6 year7 // SIgnificativa de inlusión de dummies por tiempo al 7%

********************************************************************CLUSTER 1*********************************************************************************

clear all
set more off   

// Importamos la base de datos final de la pestaña Base_mayor ( mercado mayorista )

import excel "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(c4:AA3884) firstrow clear
drop creditos dum_1 banco micro

global folder = "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Resultados"

keep if cluster == 1
 
xtset entidad id

*Adecuamos las variables 

 destring credito_1, generate(credito1)
 drop credito_1
 
 destring credito_2, generate(credito2)
 drop credito_2
  
 destring costo_total, generate(costo_total_1)
 drop costo_total
 rename costo_total_1 costo_total
  
  	destring lab, generate (lab1)
	drop lab
	destring fon, generate (fon1)
	drop fon
	destring prov, generate (prov1)
	drop prov
	destring moro, generate (moro1)
	drop moro

rename part1 part_1
 
  * Variables en tasas de crecimiento para corregir la raiz unitaria
 
gen credito_1 = (credito1-L12.credito1)*100
gen credito_2 = (credito2-L12.credito2)*100
gen fon = (fon1-L12.fon1)*100
gen prov = (prov1-L12.prov1)*100
gen moro = (moro1-L12.moro1)*100
gen capital1 = (capital-L12.capital)*100
gen capital2 = (capital_2-L12.capital_2)*100
drop capital 
rename capital_2 capital_m
rename (capital1 capital2) (capital capital_2)

** Solo nos quedamos a partir de Diciembre 2012 (por la correción de RU)
keep if id>13
gen id_1=id-12
drop id
rename id_1 id_2
*gen id_2 = ln(id) /*por qué? tendencia?*/
 
//// Creamos las variables adecuadas para estimar la función de costos translogaritmica
xtset entidad id_2

gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c2c2 = 0.5*fon*fon
gen c5c5 = 0.5*capital_2*capital_2
gen c4c4 = 0.5*prov*prov

gen c1c2 = lab1*fon
gen c1c5 = lab1*capital_2
gen c1c4 = lab1*prov
gen c2c5 = fon*capital_2
gen c2c4 = fon*prov
gen c4c5 = prov*capital_2

*** nueva variable capital
gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c5 = credito_1*capital_2
gen y1c4 = credito_1*prov

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c5 = credito_2*capital_2
gen y2c4 = credito_2*prov

* Tendencia
gen z2z2 = 0.5*id_2*id_2
gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c5 = id_2*capital_2
gen z2c4 = id_2*prov
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1z2=id_2*moro

* morosidad
gen z1z1 = 0.5*moro*moro
gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c5 = moro*capital_2
gen z1c4 = moro*prov
gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2

** Agrupamos las exogenas 
*Exógenas 1
global exogenas_1 "lab1 fon capital prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c3c3 c4c4 c1c2 c1c3 c1c4 c2c3 c2c4 c3c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 id_2 z2z2 z2c1 z2c2 z2c3 z2c4 z2y1 z2y2"
*Exógenas 2
global exogenas_2 "lab1 fon capital_2 prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c5c5 c4c4 c1c2 c1c5 c1c4 c2c5 c2c4 c4c5 y1c1 y1c2 y1c5 y1c4 y2c1 y2c2 y2c5 y2c4 id_2 z2z2 z2c1 z2c2 z2c5 z2c4 z2y1 z2y2 moro z1z1 z1c1 z1c2 z1c5 z1c4 z1y1 z1y2 z1z2"

* EVALUACIÓN: Para grupo "exógenas_2"
** Test de Hausman
*** Efectos aleatorios
qui xtreg costo_total $exogenas_2, re 
estimates store fixed_2
** Efectos fijos
qui xtreg costo_total $exogenas_2, fe 
*Test de Hausman
hausman fixed_2 /*Efectos fijos*/

*Resultado: estimador por efectos fijos 

******** Estimación de la función de costos translogaritmica

* Exógenas_2: Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young

constraint 4 lab1+fon+prov+capital_2=1
constraint 5 c1c1+c2c2+c5c5+c4c4+2*c1c2+2*c1c4+2*c1c5+2*c2c5+2*c2c4+2*c4c5=0
constraint 6 y1c1+y1c2+y1c4+y1c5=0
constraint 7 y2c1+y2c2+y2c4+y2c5=0
constraint 8 z2c1+z2c2+z2c4+z2c5=0
constraint 9 z1c1+z1c2+z1c4+z1c5=0

** La estimación por efectos fijos 

xi: cnsreg costo_total $exogenas_2 i.entidad, c(4-9) robust  // robustas a problemas de heterocedasticidaad 
*ssc install outreg2
*outreg2 using "$folder\Final_preliminar\CostoTotal_minoristas_cluster1.xls", e(all) excel replace 

mat lis e(b)

** Especificación de la matriz 
matrix b=e(b)

** obtenemos los coeficientes

gen beta1 = b[1,1]  // coeficiente laboral
gen beta2 = b[1,2]  // coeficiente fondeo
gen beta3 = b[1,3]  // coeficiente capital_2
gen beta4 = b[1,4]  // ceficiente provisiones
gen beta5 = b[1,5]  // coeficiente y1
gen beta6 = b[1,6]  // coeficiente y2
gen beta7 = b[1,28]    // coeficiente z2 (tendencia)
gen beta8 = b[1,36]    // coeficiente z1 (morosidad)

gen beta11 = b[1,10]    // coeficiente laboral_2
gen beta22 = b[1,11]    // coeficiente fondeo_2
gen beta33 = b[1,12]    // coeficiente capital_2
gen beta44 = b[1,13]    // coeficiente provisiones_2
gen beta55 = b[1,7]    // coeficiente y1_2
gen beta66 = b[1,8]    // coeficiente y2_2 
gen beta77 = b[1,29]    // coeficiente z2_2 

gen beta12 = b[1,14]  // coeficiente lab_fondeo
gen beta13 = b[1,15]   // coeficiente lab_capital
gen beta14 = b[1,16]  // coeficiente lab_provisiones
gen beta23 = b[1,17]    // coeficiente fondeo_capital
gen beta24 = b[1,18]    // coeficiente fondeo_prov
gen beta34 = b[1,18]    // coeficiente cap_prov
gen beta17 = b[1,30]    // coeficiente lab_tend
gen beta27 = b[1,31]    // coeficiente fondeo_tend
gen beta37 = b[1,32]    // coeficiente capital_tend
gen beta47 = b[1,33]    // coeficiente provisiones_tend

gen beta15 = b[1,20]   // coeficiente lab_y1
gen beta25 = b[1,21]    // coeficiente fondeo_y1
gen beta35 = b[1,22]    // coeficiente capital_y1
gen beta45 = b[1,23]    // coeficiente provisiones_y1
gen beta75 = b[1,34]    // coeficiente tend_y1
gen beta16 = b[1,24]    // coeficiente lab_y2
gen beta26 = b[1,25]    // coeficiente fondeo_y2
gen beta36 = b[1,26]    // coeficiente capital_y2
gen beta46 = b[1,27]    // coeficiente provisiones_y2
gen beta56 = b[1,9]    // coeficiente y1_y2   
gen beta76 = b[1,35]    // coeficiente tend_y2

gen beta81 = b[1,37]    // coeficiente moro_2
gen beta82 = b[1,38]    // coeficiente moro_lab1
gen beta83 = b[1,39]    // coeficiente moro_fon
gen beta84 = b[1,40]    // coeficiente moro_capital_2
gen beta85 = b[1,41]    // coeficiente moro_prov
gen beta86 = b[1,42]    // coeficiente moro_y1
gen beta87 = b[1,43]    // coeficiente moro_y2
gen beta88 = b[1,44]    // coeficiente moro_id_2

** Se construye los costos marginales (mercado mayorista)

gen cmg_1=costos_niveles*(credito_nivel_1)^(-1)*(beta5+beta55*credito_1+beta15*lab1+beta25*fon+beta35*capital_2+beta45*prov+beta56*credito_2+beta75*id_2+beta86*moro)

*Costo marginal (otros créditos) 

gen cmg_2=costos_niveles*(credito_nivel_2)^(-1)*(beta6+beta66*credito_2+beta16*lab1+beta26*fon+beta36*capital_2+beta46*prov+beta56*credito_1+beta76*id_2+beta87*moro)

** Estadisticas descriptivas de los costos marginales

** Estadisticas descriptivas de los costos marginales
sum cmg_1
sum cmg_1 if cmg_1>0
sum cmg_2
sum cmg_2 if cmg_2>0

** Generamos el logaritmo de los costos marginales 
gen ln_cmg1=ln(cmg_1)

// creamos dummies por año
gen year1=0
replace year1 = 1 if anual==13
gen year2=0
replace year2 = 1 if anual==14
gen year3=0
replace year3 = 1 if anual==15
gen year4=0
replace year4 = 1 if anual==16
gen year5=0
replace year5 = 1 if anual==17
gen year6=0
replace year6 = 1 if anual==18
gen year7=0
replace year7 = 1 if anual==19

foreach i of num 1/7 {
gen ln_cmg_`i' = year`i'*ln_cmg1
}

// Indicador de Bonne 

**Test de Hausman

** Efectos aleatorios
qui xtreg part_1 ln_cmg_* year*, re 

estimates store fixed2

** Efectos fijos 
qui xtreg part_1 ln_cmg_* year*, fe  

*TEST DE HAUSMAN 

hausman fixed2

**Test de efestos aleatorios
xtreg part_1 ln_cmg_* year*
xtreg part_1 ln_cmg_* year*, re
xttest0

* No se rechaza el estimador por efectos aleatorios

*xtreg part_1 ln_cmg_* year2 year3 year4 year5 year6 year7, re cluster(entidad)
*testparm year2 year3 year4 year5 year6 year7 // No significativa la inclusión conjunta de dummies por tiempo
*outreg2 using "$folder\boone_minorista_1.xls", e(all) excel replace 

xtreg part_1 ln_cmg_* year2 year3 year4 year5 year6 year7 , re cluster(entidad)
// estimación mediante Efectos fijos con la correción de Driscoll-Kraay en los errores estándar
** No se incluye la dummy del primer año para evitar la trampa de las dummies 
*xtscc part_1 ln_cmg_* year2 year3 year4 year5 year6 year7, fe 
outreg2 using "$folder\Final_preliminar\boone_minorista_cluster1.xls", e(all) excel replace 
testparm year2 year3 year4 year5 year6 year7 

********************************************************************************CLUSTER 2*****************************************************************

clear all
set more off   

import excel "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(c4:AA3884) firstrow clear
drop creditos dum_1 banco micro

global folder = "K:\Esteco\ASF\Informes\Informes de Analisis ASF\Competencia\Indicador Boone\Indicador_Bone_04_06\Resultados"

keep if cluster == 2
 
xtset entidad id

*Adecuamos las variables 

 destring credito_1, generate(credito1)
 drop credito_1
 
 destring credito_2, generate(credito2)
 drop credito_2
  
 destring costo_total, generate(costo_total_1)
 drop costo_total
 rename costo_total_1 costo_total
   
 	destring lab, generate (lab1)
	drop lab
	destring fon, generate (fon1)
	drop fon
	destring prov, generate (prov1)
	drop prov
	destring moro, generate (moro1)
	drop moro

rename part1 part_1
 
* Variables en tasas de crecimiento para corregir la raiz unitaria
 
gen credito_1 = (credito1-L12.credito1)*100
gen credito_2 = (credito2-L12.credito2)*100
gen fon = (fon1-L12.fon1)*100
gen prov = (prov1-L12.prov1)*100
gen moro = (moro1-L12.moro1)*100
gen capital1 = (capital-L12.capital)*100
gen capital2 = (capital_2-L12.capital_2)*100
drop capital capital_2
rename (capital1 capital2) (capital capital_2)

** Solo nos quedamos a partir de Diciembre 2012 (por la correción de RU)
keep if id>13
gen id_1=id-12
drop id
rename id_1 id_2
*gen id_2 = ln(id) /*por qué? tendencia?*/
 
//// Creamos las variables adecuadas para estimar la función de costos translogaritmica
xtset entidad id_2

gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c2c2 = 0.5*fon*fon
gen c5c5 = 0.5*capital_2*capital_2
gen c4c4 = 0.5*prov*prov

gen c1c2 = lab1*fon
gen c1c5 = lab1*capital_2
gen c1c4 = lab1*prov
gen c2c5 = fon*capital_2
gen c2c4 = fon*prov
gen c4c5 = prov*capital_2

*** nueva variable capital
gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c5 = credito_1*capital_2
gen y1c4 = credito_1*prov

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c5 = credito_2*capital_2
gen y2c4 = credito_2*prov

* Tendencia
gen z2z2 = 0.5*id_2*id_2
gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c5 = id_2*capital_2
gen z2c4 = id_2*prov
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1z2=id_2*moro

* morosidad
gen z1z1 = 0.5*moro*moro
gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c5 = moro*capital_2
gen z1c4 = moro*prov
gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2

** Agrupamos las exogenas 
*Exógenas 1
global exogenas_1 "lab1 fon capital prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c3c3 c4c4 c1c2 c1c3 c1c4 c2c3 c2c4 c3c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 id_2 z2z2 z2c1 z2c2 z2c3 z2c4 z2y1 z2y2"
*Exógenas 2
global exogenas_2 "lab1 fon capital_2 prov credito_1 credito_2 y1y1 y2y2 y1y2 c1c1 c2c2 c5c5 c4c4 c1c2 c1c5 c1c4 c2c5 c2c4 c4c5 y1c1 y1c2 y1c5 y1c4 y2c1 y2c2 y2c5 y2c4 id_2 z2z2 z2c1 z2c2 z2c5 z2c4 z2y1 z2y2 moro z1z1 z1c1 z1c2 z1c5 z1c4 z1y1 z1y2 z1z2"

* EVALUACIÓN: Para grupo "exógenas_2"
** Test de Hausman
*** Efectos aleatorios
qui xtreg costo_total $exogenas_2, re 
estimates store fixed_2
** Efectos fijos
qui xtreg costo_total $exogenas_2, fe 
*Test de Hausman
hausman fixed_2 /*Efectos fijos*/

******** Estimación de la función de costos translogaritmica

* Exógenas_2: Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young

constraint 5 lab1+fon+prov+capital_2=1
constraint 6 c1c1+c2c2+c5c5+c4c4+2*c1c2+2*c1c4+2*c1c5+2*c2c5+2*c2c4+2*c4c5=0
constraint 7 y1c1+y1c2+y1c4+y1c5=0
constraint 8 y2c1+y2c2+y2c4+y2c5=0
constraint 9 z2c1+z2c2+z2c4+z2c5=0
constraint 10 z1c1+z1c2+z1c4+z1c5=0

** La estimación por efectos fijos 

xi: cnsreg costo_total $exogenas_2 i.entidad, c(5-10) robust  // robustas a problemas de heterocedasticidaad 
*ssc install outreg2
*outreg2 using "$folder\Final_preliminar\CostoTotal_minorista_cluster2.xls", e(all) excel replace 

mat lis e(b)

** Especificación de la matriz 
matrix b=e(b)

** obtenemos los coeficientes

gen beta1 = b[1,1]  // coeficiente laboral
gen beta2 = b[1,2]  // coeficiente fondeo
gen beta3 = b[1,3]  // coeficiente capitalb
gen beta4 = b[1,4]  // ceficiente provisiones
gen beta5 = b[1,5]  // coeficiente y1
gen beta6 = b[1,6]  // coeficiente y2
gen beta7 = b[1,28]    // coeficiente z2 (tendencia)
gen beta8 = b[1,36]    // coeficiente z1 (morosidad)

gen beta11 = b[1,10]    // coeficiente laboral_2
gen beta22 = b[1,11]    // coeficiente fondeo_2
gen beta33 = b[1,12]    // coeficiente capital_2
gen beta44 = b[1,13]    // coeficiente provisiones_2
gen beta55 = b[1,7]    // coeficiente y1_2
gen beta66 = b[1,8]    // coeficiente y2_2 
gen beta77 = b[1,29]    // coeficiente z2_2 

gen beta12 = b[1,14]  // coeficiente lab_fondeo
gen beta13 = b[1,15]   // coeficiente lab_capital
gen beta14 = b[1,16]  // coeficiente lab_capital
gen beta23 = b[1,17]    // coeficiente fondeo_capital
gen beta24 = b[1,18]    // coeficiente fondeo_prov
gen beta34 = b[1,18]    // coeficiente cap_prov
gen beta17 = b[1,30]    // coeficiente lab_y2
gen beta27 = b[1,31]    // coeficiente fondeo_y2
gen beta37 = b[1,32]    // coeficiente capital_y2
gen beta47 = b[1,33]    // coeficiente provisiones_y2

gen beta15 = b[1,20]   // coeficiente lab_y1
gen beta25 = b[1,21]    // coeficiente fondeo_y1
gen beta35 = b[1,22]    // coeficiente capital_y1
gen beta45 = b[1,23]    // coeficiente provisiones_y1
gen beta75 = b[1,34]    // coeficiente tend_y1
gen beta16 = b[1,24]    // coeficiente lab_y2
gen beta26 = b[1,25]    // coeficiente fondeo_y2
gen beta36 = b[1,26]    // coeficiente capital_y2
gen beta46 = b[1,27]    // coeficiente provisiones_y2
gen beta56 = b[1,9]    // coeficiente y1_y2   
gen beta76 = b[1,35]    // coeficiente tend_y2

gen beta81 = b[1,37]    // coeficiente moro_2
gen beta82 = b[1,38]    // coeficiente moro_lab1
gen beta83 = b[1,39]    // coeficiente moro_fon
gen beta84 = b[1,40]    // coeficiente moro_capital_2
gen beta85 = b[1,41]    // coeficiente moro_prov
gen beta86 = b[1,42]    // coeficiente moro_y1
gen beta87 = b[1,43]    // coeficiente moro_y2

** Se construye los costos marginales (mercado mayorista)
gen cmg_1=costos_niveles*(credito_nivel_1)^(-1)*(beta5+beta55*credito_1+beta15*lab1+beta25*fon+beta35*capital_2+beta45*prov+beta56*credito_2+beta75*id_2+beta86*moro)

*Costo marginal (otros créditos) 

gen cmg_2=costos_niveles*(credito_nivel_2)^(-1)*(beta6+beta66*credito_2+beta16*lab1+beta26*fon+beta36*capital_2+beta46*prov+beta56*credito_1+beta76*id_2+beta87*moro)

** Estadisticas descriptivas de los costos marginales
sum cmg_1
sum cmg_1 if cmg_1>0
sum cmg_2
sum cmg_2 if cmg_2>0

** Generamos el logaritmo de los costos marginales 
gen ln_cmg1=ln(cmg_1)

// creamos dummies por año
gen year1=0
replace year1 = 1 if anual==13
gen year2=0
replace year2 = 1 if anual==14
gen year3=0
replace year3 = 1 if anual==15
gen year4=0
replace year4 = 1 if anual==16
gen year5=0
replace year5 = 1 if anual==17
gen year6=0
replace year6 = 1 if anual==18
gen year7=0
replace year7 = 1 if anual==19

foreach i of num 1/7 {
gen ln_cmg_`i' = year`i'*ln_cmg1
}

// Indicador de Bonne 

**Test de Hausman

** Efectos aleatorios
qui xtreg part_1 ln_cmg_* year*, re 

estimates store fixed2

** Efectos fijos 
qui xtreg part_1 ln_cmg_* year*, fe  

*TEST DE HAUSMAN 

hausman fixed2

* Estimación por efectos fijos al 0,97%

// estimación mediante Efectos fijos con la correción de Driscoll-Kraay en los errores estándar
** No se incluye la dummy del primer año para evitar la trampa de las dummies 
xtscc part_1 ln_cmg_* year2 year3 year4 year5 year6 year7, fe 
outreg2 using "$folder\Final_preliminar\boone_minorista_cluster2.xls", e(all) excel replace 
testparm year2 year3 year4 year5 year6 year7 // SIgnificativa la inclusión de dummies por tiempo al 5%


