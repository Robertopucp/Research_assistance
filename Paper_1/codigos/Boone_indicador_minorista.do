** MERCADO MINORISTA **


clear all
set more off

// importamos la pestaña base_minorista
import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(e4:w3884) firstrow clear


 destring costo_total, generate(costos)
 drop costo_total
 rename costos costo_total
  destring credito_1, generate(credito1)
    destring credito_2, generate(credito2)
	drop credito_1 credito_2
	destring lab, generate (lab1)
	drop lab
	rename lab1 lab
	destring fon, generate (fon1)
	drop fon
	rename fon1 fon
	destring prov, generate (prov1)
	drop prov
	rename prov1 prov
	destring moro, generate (moro1)
	drop moro
	rename moro1 moro

	
	** Prueba de raiz unitaria costos totales **
	
	  //Declaramos la base de datos como un panel 
  xtset  entidad id
  
    // En este caso no se usa el test Levin–Lin–Chuv (LLC), ya que exige un panel estrictamente balanceado
	
  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
    xtunitroot ips costo_total, trend lags(bic 6)
	  xtunitroot ips costo_total, trend lags(aic 6)
	    xtunitroot ips costo_total, trend lags(hqic 6)
		xtunitroot fisher costo_total, dfuller lags(6) trend 
		xtunitroot fisher costo_total, dfuller lags(12) trend 
		xtunitroot fisher costo_total, pperron lags(6) trend 
		xtunitroot fisher costo_total, pperron lags(12) trend 
	
		** Prueba de raiz unitaria credito minorista **
	  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
		    xtunitroot ips credito1, trend lags(bic 6)
	  xtunitroot ips credito1, trend lags(aic 6)
	    xtunitroot ips credito1, trend lags(hqic 6)
	    	xtunitroot fisher credito1, dfuller lags(6) trend 
			xtunitroot fisher credito1, dfuller lags(12) trend 
			xtunitroot fisher credito1, pperron lags(6) trend 
			xtunitroot fisher credito1, pperron lags(12) trend 
		
		** Prueba de raiz unitaria credito minorista (otros)**
	
	  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
		    xtunitroot ips credito2, trend lags(bic 6)
	  xtunitroot ips credito2, trend lags(aic 6)
	    xtunitroot ips credito2, trend lags(hqic 6)
		
			xtunitroot fisher credito2, dfuller lags(6) trend 
			xtunitroot fisher credito2, dfuller lags(12) trend 
			xtunitroot fisher credito2, pperron lags(6) trend 
			xtunitroot fisher credito2, pperron lags(12) trend 
			
//Raiz untaria en costo laboral
  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
  
	    xtunitroot ips lab, trend lags(bic)
	  xtunitroot ips lab, trend lags(aic)
	    xtunitroot ips lab, trend lags(hqic)
	
				xtunitroot fisher lab, dfuller lags(6) trend 
			xtunitroot fisher lab, dfuller lags(12) trend 
			xtunitroot fisher lab, pperron lags(6) trend 
			xtunitroot fisher lab, pperron lags(12) trend 
			
//	Raiz untaria en costo de fondeo

  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
		    xtunitroot ips fon, trend lags(bic)
	  xtunitroot ips fon, trend lags(aic)
	    xtunitroot ips fon, trend lags(hqic)
       
	   		xtunitroot fisher fon, dfuller lags(6) trend 
			xtunitroot fisher fon, dfuller lags(12) trend 
			xtunitroot fisher fon, pperron lags(6) trend 
			xtunitroot fisher fon, pperron lags(12) trend 		

//	Raiz untaria en provisiones

  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
			
	    xtunitroot ips prov, trend lags(bic)
	  xtunitroot ips prov, trend lags(aic)
	    xtunitroot ips prov, trend lags(hqic)

			xtunitroot fisher prov, dfuller lags(6) trend 
			xtunitroot fisher prov, dfuller lags(12) trend 
			xtunitroot fisher prov, pperron lags(6) trend 
			xtunitroot fisher prov, pperron lags(12) trend 			

//	Raiz untaria en morosidad

  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data
			
	  xtunitroot ips moro, trend lags(bic)
	  xtunitroot ips moro, trend lags(aic)
	    xtunitroot ips moro, trend lags(hqic)
   
   
			xtunitroot fisher moro, dfuller lags(6) trend 
			xtunitroot fisher moro, dfuller lags(12) trend 
			xtunitroot fisher moro, pperron lags(6) trend 
			xtunitroot fisher moro, pperron lags(12) trend 
			
//	Raiz untaria en participación	

  	// panel no balanceado Im–Pesaran–Shin, Test de Fisher-perron y Dicky Fuller
	** Se usa rezagos superiores a 6 debido a la frecuencia mensual de la data		
						
	    xtunitroot ips part1, trend lags(bic)
	  xtunitroot ips part1, trend lags(aic)
	    xtunitroot ips part1, trend lags(hqic)
		
			xtunitroot fisher part1, dfuller lags(6) trend 
			xtunitroot fisher part1, dfuller lags(12) trend 
			xtunitroot fisher part1, pperron lags(6) trend 
			xtunitroot fisher part1, pperron lags(12) trend 			
   
   
   *****************************************************************************************************************************************************************************		
   
clear all
set more off   

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(e4:w3884) firstrow clear

global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"

xtset entidad id

 destring costo_total, generate(costos)
 drop costo_total
 rename costos costo_total
  destring credito_1, generate(credito1)
    destring credito_2, generate(credito2)
	drop credito_1 credito_2
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
drop capital
rename capital1 capital

** Solo nos quedamos a partir de Diciembre 2012
keep if id>12

gen id_1=id-12
drop id
rename id_1 id
gen id_2 = ln(id)

*** Creamos las variables de la función translogaritmica

xtset entidad id
gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c1c2 = lab1*fon
gen c1c3 = lab1*prov
gen c1c4 = lab1*capital
gen c2c2 = 0.5*fon*fon
gen c2c3 = fon*prov
gen c2c4 = fon*capital
gen c3c3 = 0.5*prov*prov
gen c3c4 = prov*capital
gen c4c4 = 0.5*capital*capital

gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c3 = credito_1*prov
gen y1c4 = credito_1*capital

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c3 = credito_2*prov
gen y2c4 = credito_2*capital

gen z1z1 = 0.5*moro*moro
gen z1z2 = moro*id_2
gen z2z2 = 0.5*id_2*id_2

gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c3 = moro*prov
gen z1c4 = moro*capital

gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c3 = id_2*prov
gen z2c4 = id_2*capital

** Agrupamos las exogenas 

global exogenas "credito_1 credito_2 lab1 fon prov capital y1y1 y1y2 y2y2 c1c1 c1c2 c1c3 c1c4 c2c2 c2c3 c2c4 c3c3 c3c4 c4c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 moro id_2 z1z1 z2z2 z1z2 z1y1 z1y2 z2y1 z2y2 z1c1 z1c2 z1c3 z1c4 z2c1 z2c2 z2c3 z2c4"

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
constraint 2 c1c1+c2c2+c3c3+c4c4+2*c1c2+2*c1c3+2*c1c4+2*c2c3+2*c2c4+2*c3c4=0
constraint 3 y1c1+y1c2+y1c3+y1c4+y2c1+y2c2+y2c3+y2c4=0
constraint 4  z1c1+z1c2+z1c3+z1c4+z2c1+z2c2+z2c3+z2c4=0


//xi: cnsreg costo_total $exogenas i.entidad, c(1-4) robust

* Estimación Pool MCO (no considera dummies por entidad en su estimación)
xi: cnsreg costo_total $exogenas, c(1-4) robust
outreg2 using "$folder\cuad1.xls", e(all) excel replace 
mat list e(b)

** obtenemos los coeficientes
gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta2 = e(b)[1,8]  // coeficeinte credito2
gen beta3 = e(b)[1,7]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,20]  // ceficiente costo laboral
gen beta5 = e(b)[1,21]   // coeficiente costo de fondos
gen beta6 = e(b)[1,22]    // coeficiente provisiones
gen beta7 = e(b)[1,23]    // coeficiente capital   
gen beta8 = e(b)[1,33]    // coeficeinte morosidad
gen beta9 = e(b)[1,35]    // coeficeitne tendencia 


gen beta11 = e(b)[1,2]  // coeficiente credito2
gen beta12 = e(b)[1,8]  // coeficeinte credito1
gen beta13 = e(b)[1,9]   // coeficiente credito2_(2)
gen beta14 = e(b)[1,24]  // ceficiente costo laboral
gen beta15 = e(b)[1,25]   // coeficiente costo de fondos
gen beta16 = e(b)[1,26]    // coeficiente provisiones
gen beta17 = e(b)[1,27]    // coeficiente capital   
gen beta18 = e(b)[1,34]    // coeficeinte morosidad
gen beta19 = e(b)[1,36]    // coeficeitne tendencia 


* Costo marginal del mercado minorista

gen cmg=costo_total*(credito_1)^(-1)*(beta1+beta2*credito_2+beta3*credito_1+beta4*lab1+beta5*fon+beta6*prov+beta7*capital+beta8*moro+beta9*id_2)

*Costo marginal (otros créditos) 

gen cmg_o=costo_total*(credito_2)^(-1)*(beta11+beta12*credito_1+beta13*credito_2+beta14*lab1+beta15*fon+beta16*prov+beta17*capital+beta18*moro+beta19*id_2)

*Estadisticas descriptivas del costo marginal

sum cmg
sum cmg if cmg>0
sum cmg_o
sum cmg_o if cmg_o>0

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
outreg2 using "$folder\cuad2.xls", e(all) excel replace 


*****************************************************************************************************************************************************************************+


clear all
set more off   

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(e4:w3884) firstrow clear
global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"


// Solo evaluamos al cluster 1 
keep if cluster==1 


xtset entidad id

 destring costo_total, generate(costos)
 drop costo_total
 rename costos costo_total
  destring credito_1, generate(credito1)
    destring credito_2, generate(credito2)
	drop credito_1 credito_2
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
drop capital
rename capital1 capital

** Solo nos quedamos a partir de Diciembre 2012
keep if id>12

gen id_1=id-12
drop id
rename id_1 id
gen id_2 = ln(id)

*** Creamos las variables de la función translogaritmica

xtset entidad id
gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c1c2 = lab1*fon
gen c1c3 = lab1*prov
gen c1c4 = lab1*capital
gen c2c2 = 0.5*fon*fon
gen c2c3 = fon*prov
gen c2c4 = fon*capital
gen c3c3 = 0.5*prov*prov
gen c3c4 = prov*capital
gen c4c4 = 0.5*capital*capital

gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c3 = credito_1*prov
gen y1c4 = credito_1*capital

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c3 = credito_2*prov
gen y2c4 = credito_2*capital

gen z1z1 = 0.5*moro*moro
gen z1z2 = moro*id_2
gen z2z2 = 0.5*id_2*id_2

gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c3 = moro*prov
gen z1c4 = moro*capital

gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c3 = id_2*prov
gen z2c4 = id_2*capital

** Agrupamos las exogenas 

global exogenas "credito_1 credito_2 lab1 fon prov capital y1y1 y1y2 y2y2 c1c1 c1c2 c1c3 c1c4 c2c2 c2c3 c2c4 c3c3 c3c4 c4c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 moro id_2 z1z1 z2z2 z1z2 z1y1 z1y2 z2y1 z2y2 z1c1 z1c2 z1c3 z1c4 z2c1 z2c2 z2c3 z2c4"

* Test de Hausman 
* Efectos aleatorios
qui xtreg costo_total $exogenas, re //constraint(1) constraint(2) constraint(3) constraint(4) 

estimates store fixed
* Efectos fijos 

qui xtreg costo_total $exogenas, fe  //constraint(1) constraint(2) constraint(3) constraint(4) 
*TEST DE HAUSMAN 

hausman fixed

* Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young
constraint 1 lab1+fon+prov+capital=1
constraint 2 c1c1+c2c2+c3c3+c4c4+2*c1c2+2*c1c3+2*c1c4+2*c2c3+2*c2c4+2*c3c4=0
constraint 3 y1c1+y1c2+y1c3+y1c4+y2c1+y2c2+y2c3+y2c4=0
constraint 4  z1c1+z1c2+z1c3+z1c4+z2c1+z2c2+z2c3+z2c4=0

** La estimación de efectos fijos mediante un MCO panel incluyendo dummies por entidad y las restricciones
xi: cnsreg costo_total $exogenas i.entidad, c(1-4) robust
outreg2 using "$folder\cuad31.xls", e(all) excel replace 
mat list e(b)

** obtenemos los coeficientes
gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta2 = e(b)[1,8]  // coeficeinte credito2
gen beta3 = e(b)[1,7]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,20]  // ceficiente costo laboral
gen beta5 = e(b)[1,21]   // coeficiente costo de fondos
gen beta6 = e(b)[1,22]    // coeficiente provisiones
gen beta7 = e(b)[1,23]    // coeficiente capital   
gen beta8 = e(b)[1,33]    // coeficeinte morosidad
gen beta9 = e(b)[1,35]    // coeficeitne tendencia 


gen beta11 = e(b)[1,2]  // coeficiente credito2
gen beta12 = e(b)[1,8]  // coeficeinte credito1
gen beta13 = e(b)[1,9]   // coeficiente credito2_(2)
gen beta14 = e(b)[1,24]  // ceficiente costo laboral
gen beta15 = e(b)[1,25]   // coeficiente costo de fondos
gen beta16 = e(b)[1,26]    // coeficiente provisiones
gen beta17 = e(b)[1,27]    // coeficiente capital   
gen beta18 = e(b)[1,34]    // coeficeinte morosidad
gen beta19 = e(b)[1,36]    // coeficeitne tendencia 


* Costo marginal del mercado minorista

gen cmg=costo_total*(credito_1)^(-1)*(beta1+beta2*credito_2+beta3*credito_1+beta4*lab1+beta5*fon+beta6*prov+beta7*capital+beta8*moro+beta9*id_2)

*Costo marginal (otros créditos) 

gen cmg_o=costo_total*(credito_2)^(-1)*(beta11+beta12*credito_1+beta13*credito_2+beta14*lab1+beta15*fon+beta16*prov+beta17*capital+beta18*moro+beta19*id_2)

*Estadisticas descriptivas Costo Marginal 
sum cmg
sum cmg if cmg>0
sum cmg_o
sum cmg_o if cmg_o>0

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

** Test de Test de Breusch y Pagan para decidir entre homogeneidad en inobsservablos (pool MCO) o heterogeneidad (Efectos aleatorios)
* Pool MCO
xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8
* Efectos aleatorios
xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re 

xttest0

// Efectos aleatorios corregido por heterocedasticidad o autocorrelación

xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re cluster(entidad)
testparm year2 year3 year4 year5 year6 year7 year8
outreg2 using "$folder\cuad41.xls", e(all) excel replace 

******************************************************************************************************************************************************************************


clear all
set more off   

import excel "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\Costos_Totales_Final.xlsx", sheet("base_minorista") cellrange(e4:w3884) firstrow clear
global folder = "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone"

* Nos quedamos con las entidades del cluster 2
keep if cluster==2
 

xtset entidad id

 destring costo_total, generate(costos)
 drop costo_total
 rename costos costo_total
  destring credito_1, generate(credito1)
    destring credito_2, generate(credito2)
	drop credito_1 credito_2
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
drop capital
rename capital1 capital

** Solo nos quedamos a partir de Diciembre 2012
keep if id>12

gen id_1=id-12
drop id
rename id_1 id
gen id_2 = ln(id)

*** Creamos las variables de la función translogaritmica

xtset entidad id
gen y1y2 = credito_1*credito_2
gen y1y1 = 0.5*credito_1*credito_1
gen y2y2 = 0.5*credito_2*credito_2 

gen c1c1 = 0.5*lab1*lab1
gen c1c2 = lab1*fon
gen c1c3 = lab1*prov
gen c1c4 = lab1*capital
gen c2c2 = 0.5*fon*fon
gen c2c3 = fon*prov
gen c2c4 = fon*capital
gen c3c3 = 0.5*prov*prov
gen c3c4 = prov*capital
gen c4c4 = 0.5*capital*capital

gen y1c1 = credito_1*lab1
gen y1c2 = credito_1*fon
gen y1c3 = credito_1*prov
gen y1c4 = credito_1*capital

gen y2c1 = credito_2*lab1
gen y2c2 = credito_2*fon
gen y2c3 = credito_2*prov
gen y2c4 = credito_2*capital

gen z1z1 = 0.5*moro*moro
gen z1z2 = moro*id_2
gen z2z2 = 0.5*id_2*id_2

gen z1y1 = moro*credito_1
gen z1y2 = moro*credito_2
gen z2y1 = id_2*credito_1
gen z2y2 = id_2*credito_2

gen z1c1 = moro*lab1
gen z1c2 = moro*fon
gen z1c3 = moro*prov
gen z1c4 = moro*capital

gen z2c1 = id_2*lab1
gen z2c2 = id_2*fon
gen z2c3 = id_2*prov
gen z2c4 = id_2*capital

** Agrupamos las exogenas 

global exogenas "credito_1 credito_2 lab1 fon prov capital y1y1 y1y2 y2y2 c1c1 c1c2 c1c3 c1c4 c2c2 c2c3 c2c4 c3c3 c3c4 c4c4 y1c1 y1c2 y1c3 y1c4 y2c1 y2c2 y2c3 y2c4 moro id_2 z1z1 z2z2 z1z2 z1y1 z1y2 z2y1 z2y2 z1c1 z1c2 z1c3 z1c4 z2c1 z2c2 z2c3 z2c4"

*Test de Hausamn 
* Efectos aleatorios
qui xtreg costo_total $exogenas, re 

estimates store fixed
* Efectos fijos
qui xtreg costo_total $exogenas, fe   
*TEST DE HAUSMAN 

hausman fixed

* Condiciones de Homogeneidad lineal en el precio de los insumos y el Teorema de Young
constraint 1 lab1+fon+prov+capital=1
constraint 2 c1c1+c2c2+c3c3+c4c4+2*c1c2+2*c1c3+2*c1c4+2*c2c3+2*c2c4+2*c3c4=0
constraint 3 y1c1+y1c2+y1c3+y1c4+y2c1+y2c2+y2c3+y2c4=0
constraint 4  z1c1+z1c2+z1c3+z1c4+z2c1+z2c2+z2c3+z2c4=0

** La estimación de efectos fijos mediante un MCO panel incluyendo dummies por entidad y las restricciones
xi: cnsreg costo_total $exogenas i.entidad, c(1-4) robust
outreg2 using "$folder\cuad5.xls", e(all) excel replace 
mat list e(b)

** obtenemos los coeficientes
gen beta1 = e(b)[1,1]  // coeficiente credito1
gen beta2 = e(b)[1,8]  // coeficeinte credito2
gen beta3 = e(b)[1,7]   // coeficiente credito1_(2)
gen beta4 = e(b)[1,20]  // ceficiente costo laboral
gen beta5 = e(b)[1,21]   // coeficiente costo de fondos
gen beta6 = e(b)[1,22]    // coeficiente provisiones
gen beta7 = e(b)[1,23]    // coeficiente capital   
gen beta8 = e(b)[1,33]    // coeficeinte morosidad
gen beta9 = e(b)[1,35]    // coeficeitne tendencia 


gen beta11 = e(b)[1,2]  // coeficiente credito2
gen beta12 = e(b)[1,8]  // coeficeinte credito1
gen beta13 = e(b)[1,9]   // coeficiente credito2_(2)
gen beta14 = e(b)[1,24]  // ceficiente costo laboral
gen beta15 = e(b)[1,25]   // coeficiente costo de fondos
gen beta16 = e(b)[1,26]    // coeficiente provisiones
gen beta17 = e(b)[1,27]    // coeficiente capital   
gen beta18 = e(b)[1,34]    // coeficeinte morosidad
gen beta19 = e(b)[1,36]    // coeficeitne tendencia 


* Costo marginal del mercado minorista

gen cmg=costo_total*(credito_1)^(-1)*(beta1+beta2*credito_2+beta3*credito_1+beta4*lab1+beta5*fon+beta6*prov+beta7*capital+beta8*moro+beta9*id_2)

*Costo marginal (otros créditos) 

gen cmg_o=costo_total*(credito_2)^(-1)*(beta11+beta12*credito_1+beta13*credito_2+beta14*lab1+beta15*fon+beta16*prov+beta17*capital+beta18*moro+beta19*id_2)

* Estadisticas descriptivas
sum cmg
sum cmg if cmg>0
sum cmg_o
sum cmg_o if cmg_o>0

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

*Test de Hausamn

* Efectos aleatorios
qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, re 

estimates store fixed1
* Efecros fijos
qui xtreg part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe  
*TEST DE HAUSMAN 
hausman fixed1

// estimación mediante Efectos fijos con la correción de Driscoll-Kraay en los errores estándar
** No se incluye la dummy del primer año para evitar la trampa de las dummies 
xtscc part_1 cmar_1 cmar_2 cmar_3 cmar_4 cmar_5 cmar_6 cmar_7 cmar_8 year2 year3 year4 year5 year6 year7 year8, fe 
outreg2 using "$folder\cuad6.xls", e(all) excel replace 
testparm year2 year3 year4 year5 year6 year7 year8

***********************************************************************************************************************************************************************************











