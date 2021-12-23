** INDICADOR DE BOONE MERCADO MAYORISTA

* INDICADOR DE BOONE DONDE NO SE CONSIDERA LA INTERACCIÓN ENTRE LAS VARIABLES DE CONTROL (SOLO TENDENCIA PARA MAYORISTA) CON LOS OTROS COSTOS Y TIPO DE CRÉDITO

 
clear all
set more off   

// Importamos la base de datos final de la pestaña Base_mayor ( mercado mayorista )

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_mayorista") cellrange(c2:q972) firstrow clear

global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"

xtset entidad id

*Adecuamos las varibales 

 destring credito_1, generate(credito1)
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

gen credito_1 = (credito1-L12.credito1)*100
gen credito_2 = (credito2-L12.credito2)*100
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


//// Creamos las variables adecuadas para estimar la función de costos translogaritmica

gen credito3 = credito_1*credito_2
gen credito4 = 0.5*credito_1*credito_1
gen credito5 = 0.5*credito_2*credito_2 
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

gen var1 = credito_1*lab1
gen var2 = credito_1*fon
gen var3 = credito_1*prov
gen var4 = credito_1*capital

gen var5 = credito_2*lab1
gen var6 = credito_2*fon
gen var7 = credito_2*prov
gen var8 = credito_2*capital

// Cuadrado de la tendencia

gen z3 = id_2*id_2


** Agrupamos las exogenas que no considera la interacción entre las variables de control con los costos y los créditos

global exogenas "credito_1 credito_2 lab1 fon prov capital credito3 credito4 credito5 precio1 precio2 precio3 precio4 precio5 precio6 precio7 precio8 precio9 precio10 var1 var2 var3 var4 var5 var6 var7 var8 id_2 z3"

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

* Dado que no se considera la interacción entre las variables de control y los crédito solo se consiedra 3 restricciones
 
constraint 1 lab1+fon+prov+capital=1
constraint 2 precio1+2*precio2+2*precio3+2*precio4+precio5+2*precio6+2*precio7+precio8+2*precio9+precio10=0
constraint 3 var1+var2+var3+var4+var5+var6+var7+var8=0

** La estimación de efectos fijos mediante un MCO panel incluyendo dummies por entidad y las restricciones
xi: cnsreg costo_total $exogenas i.entidad, c(1-3) robust  // robustas a problemas de heterocedasticidaad 
//outreg2 using "$folder\cuadro1.xls", e(all) excel replace 

mat list e(b)

** obtenemos los coeficientes

gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta2 = e(b)[1,7]  // coeficeinte credito2
gen beta3 = e(b)[1,8]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,20]  // ceficiente costo laboral
gen beta5 = e(b)[1,21]   // coeficiente costo de fondos
gen beta6 = e(b)[1,22]    // coeficiente provisiones
gen beta7 = e(b)[1,23]    // coeficiente capital   


gen beta11 = e(b)[1,2]  // coeficiente credito2
gen beta12 = e(b)[1,7]  // coeficeinte credito1
gen beta13 = e(b)[1,9]   // coeficiente credito2_(2)
gen beta14 = e(b)[1,24]  // ceficiente costo laboral
gen beta15 = e(b)[1,25]   // coeficiente costo de fondos
gen beta16 = e(b)[1,26]    // coeficiente provisiones
gen beta17 = e(b)[1,27]    // coeficiente capital   


*gen beta10 = beta8 + beta9

** Se construye los costos marginales (mercado mayorista)

gen cmg=costo_total*(credito_1)^(-1)*(beta1+beta2*credito_2+beta3*credito_1+beta4*lab1+beta5*fon+beta6*prov+beta7*capital)

*Costo marginal (otros créditos) 

gen cmg_o=costo_total*(credito_2)^(-1)*(beta11+beta12*credito_1+beta13*credito_2+beta14*lab1+beta15*fon+beta16*prov+beta17*capital)

** Estadisticas descriptivas de los costos marginales
sum cmg
sum cmg if cmg>0
sum cmg_o
sum cmg_o if cmg_o>0

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


//xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe cluster(entidad)

//testparm year2 year3 year4 year5 year6 year7 year8

//outreg2 using "$folder\mayor2.xls", e(all) excel replace

// estimación mediante Efectos fijos con la correción de Driscoll-Kraay en los errores estándar
** No se incluye la dummy del primer año para evitar la trampa de las dummies 
xtscc part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe 
//outreg2 using "$folder\nuevo3.xls", e(all) excel replace 
testparm year2 year3 year4 year5 year6 year7 year8
