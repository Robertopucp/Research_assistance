// ESTIMACIÓN DEL INDICADOR DE BOONE (MERCADO MAYORISTA) CONSIDERANDO UN SOLO CRÉDITO AGREGADO Y DUMMY EN PARTICIPACIÓN EN OTROS CRÉDITOS

clear all
set more off   

// Importamos la base de datos final de la pestaña base_mayorista ( mercado mayorista )

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_mayorista") cellrange(c2:T972) firstrow clear

global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"

xtset entidad id

*Adecuamos las varibales 
 destring credito, generate (uno)
 drop credito
 
  destring dum_1, generate (dum)
 drop dum_1
 rename dum dum_1


 destring credito_1, generate (credito1)
 drop credito_1
 rename credito_2 credito2
 
 	destring lab, generate (lab1)
	drop lab
	destring fon, generate (fon1)
	drop fon
	destring prov, generate (prov1)
	drop prov
	destring moro, generate (moro1)
	drop moro

 destring part1, generate(part_1)
 drop part1
 
 * Variables en tasas de crecimiento para corregir la raiz unitaria

gen credito = (uno-L12.uno)*100
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

* Dummy que indica la participación en otros créditos mayor a la proporción del sistema 
gen dum = 0
replace dum = 1 if dum_1 > banco

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

* incluimos solo el cuadradod e la tendencia para el mercado mayorista
gen z3 = id_2*id_2

** Agrupamos las exogenas 

global exogenas "credito lab1 fon prov capital credito3 precio1 precio2 precio3 precio4 precio5 precio6 precio7 precio8 precio9 precio10 var1 var2 var3 var4 id_2 z3 dum"

** Test de Hausman

** Efectos aleatorios
qui xtreg costo_total $exogenas, re 

estimates store fixed
** Efectos fijos
qui xtreg costo_total $exogenas, fe 
*TEST DE HAUSMAN 

hausman fixed

******** Estimación de la función de costos translogaritmica

* Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young

constraint 1 lab1+fon+prov+capital=1
constraint 2 precio1+2*precio2+2*precio3+2*precio4+precio5+2*precio6+2*precio7+precio8+2*precio9+precio10=0
constraint 3 var1+var2+var3+var4=0

** La estimación de efectos fijos mediante un MCO panel incluyendo dummies por entidad y las restricciones
xi: cnsreg costo_total $exogenas i.entidad, c(1-3) robust  // robustas a problemas de heterocedasticidaad 
//outreg2 using "$folder\cuadro1.xls", e(all) excel replace 

mat list e(b)

** obtenemos los coeficientes

gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta2 = e(b)[1,6]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,17]  // ceficiente costo laboral
gen beta5 = e(b)[1,18]   // coeficiente costo de fondos
gen beta6 = e(b)[1,19]    // coeficiente provisiones
gen beta7 = e(b)[1,20]    // coeficiente capital   

** Se construye los costos marginales (mercado mayorista)

gen cmg=costo_total*(credito)^(-1)*(beta1+beta2*credito+beta4*lab1+beta5*fon+beta6*prov+beta7*capital)

** Estadisticas descriptivas de los costos marginales
sum cmg
sum cmg if cmg>0

** Generamos el logaritmo de los costos marginales 
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

**Test de Hausman

** Efectos aleatorios
qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re 

estimates store fixed2

** Efectos fijos 
qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe  //constraint(1) constraint(2) constraint(3) constraint(4) 

*TEST DE HAUSMAN 

hausman fixed2


//xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re

//xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe cluster(entidad)

//testparm year2 year3 year4 year5 year6 year7 year8

//outreg2 using "$folder\mayor2.xls", e(all) excel replace


// estimación mediante Efectos fijos con la correción de Driscoll-Kraay en los errores estándar
** No se incluye la dummy del primer año para evitar la trampa de las dummies 
xtscc part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe 
//outreg2 using "$folder\nuevo3.xls", e(all) excel replace 
testparm year2 year3 year4 year5 year6 year7 year8



