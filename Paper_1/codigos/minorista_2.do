 
 // ESTIMACIÓN DEL INDICADOR DE BOONE (MERCADO MINORISTA)CONSIDERANDO UN SOLO CRÉDITO AGREGADO Y DUMMY EN PARTICIPACIÓN EN OTROS CRÉDITOS
 
clear all
set more off   

// Importamos la base de datos final de mercado minorista (base_minorista)

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(a4:w3884) firstrow clear

global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"

xtset entidad id

destring costo_total, generate (costos)
 drop costo_total
 rename costos costo_total
  destring credito_1, generate (credito1)
    destring credito_2, generate (credito2)
	drop credito_1 credito_2
	destring lab, generate (lab1)
	drop lab
	destring fon, generate (fon1)
	drop fon

	destring prov, generate (prov1)
	drop prov
	
	destring moro, generate (moro1)
	drop moro
	
    destring creditos, generate (credi)
	drop creditos
	rename credi creditos
	
	destring dum_1, generate (dum)
	drop dum_1 
	rename dum dum_1
	
	gen dum = 0
replace dum = 1 if dum_1 > banco & cluster == 3  // Participacion en otros créditos para entidades bancarias
replace dum = 1 if dum_1 > micro & cluster != 3  // Participación en otros crpeditos para entidades microfinancieras
	
	rename part1 part_1
	
* Variables en tasas de crecimiento para corregir la raiz unitaria

gen credito = (creditos-L12.creditos)*100
gen fon = (fon1-L12.fon1)*100
gen prov = (prov1-L12.prov1)*100
gen moro = (moro1-L12.moro1)*100
gen capital1 = (capital-L12.capital)*100
drop capital
rename capital1 capital


** Solo nos quedamos a partir de Diciembre 2012
keep if id>12
gen id_1=id-12
drop id
rename id_1 id
gen id_2 = ln(id)

*** Creamos las variables de la función translogaritmica

gen credito3 = 0.5*credito*credito
gen precio1 = 0.5*lab1*lab1
gen precio2 = lab1*fon
gen precio3 = lab1*prov
gen precio4 = lab1*capital
gen precio5 = 0.5*fon*fon
gen precio6 = fon*prov
gen precio7 = fon*capital
gen precio8 = 0.5*prov*prov
gen precio9 = prov*capital
gen precio10 = 0.5*capital*capital

gen var1 = credito*lab1
gen var2 = credito*fon
gen var3 = credito*prov
gen var4 = credito*capital

// cuadrado de variables de control 

gen z1 = moro*moro
gen z3 = id_2*id_2

* Agrupamos las exogenas 

global exogenas "credito lab1 fon prov capital credito3 precio1 precio2 precio3 precio4 precio5 precio6 precio7 precio8 precio9 precio10 var1 var2 var3 var4 id_2 moro z1 z3"

* Test de Hausman

* Efectos aleatorios
qui xtreg costo_total $exogenas, re 

estimates store fixed

* Efectos fijos
qui xtreg costo_total $exogenas, fe  
*TEST DE HAUSMAN 

hausman fixed


** Test de Test de Breusch y Pagan para decidir entre homogeneidad en inobsservablos (pool MCO) o heterogeneidad (Efectos aleatorios)
xtreg costo_total $exogenas
xtreg costo_total $exogenas, re
xttest0

* Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young
constraint 1 lab1+fon+prov+capital=1
constraint 2 precio1+2*precio2+2*precio3+2*precio4+precio5+2*precio6+2*precio7+precio8+2*precio9+precio10=0
constraint 3 var1+var2+var3+var4+var5+var6+var7+var8=0

* Estimación Pool MCO (no considera dummies por entidad en su estimación)
xi: cnsreg costo_total $exogenas, c(1-3) robust
//outreg2 using "$folder\excel1.xls", e(all) excel replace 
mat list e(b)

** obtenemos los coeficientes
** En este caso se ha reducido los parámetros requeridos para estimar los costos marginales

gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta3 = e(b)[1,6]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,17]  // ceficiente costo laboral
gen beta5 = e(b)[1,18]   // coeficiente costo de fondos
gen beta6 = e(b)[1,19]    // coeficiente provisiones
gen beta7 = e(b)[1,20]    // coeficiente capital   


* Costo marginal del mercado minorista

gen cmg=costo_total*(credito)^(-1)*(beta1+beta3*credito+beta4*lab1+beta5*fon+beta6*prov+beta7*capital)

*Estadisticas descriptivas del costo marginal

sum cmg
sum cmg if cmg>0

* Costo marginal en logaritmos

gen cmg1=ln(cmg)

// creamos dummies por año
gen year1=0
replace year1 = 1 if anual==12
gen year2=0
replace year2 = 1 if anual==13
gen year3=0
replace year3 = 1 if anual==14
gen year4=0
replace year4 = 1 if anual==15
gen year5=0
replace year5 = 1 if anual==16
gen year6=0
replace year6 = 1 if anual==17
gen year7=0
replace year7 = 1 if anual==18
gen year8=0
replace year8 = 1 if anual==19


foreach i of num 1/8 {
gen cmar_`i' = year`i'*cmg1
}


// Indicador de Bonne 

* Test de Hausman 

* Efectos aleatorios
qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re 

estimates store fixed1
* Efectos fijos

qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe 

*TEST DE HAUSMAN 
hausman fixed1

// Se ha rechazado efectos fijos y recurrimos a testear entre efectos aleatorios y MCO

* Test de Test de Breusch y Pagan para decidir entre homogeneidad en inobsservablos (pool MCO) o heterogeneidad (Efectos aleatorios)
xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8

xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re

xttest0

//GANADOR EFECTOS ALEATORIOS

* Efectos aleatorios corregido por heterocedasticidad y autocorrelacion 

 xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re cluster(entidad)
testparm year2 year3 year4 year5 year6 year7 year8
//outreg2 using "$folder\nuevo5.xls", e(all) excel replace

// xtset  entidad id
//xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe cluster(entidad)

//xtscc part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe 
//outreg2 using "$folder\nuevo.xls", e(all) excel replace 
//testparm year2 year3 year4 year5 year6 year7 year8