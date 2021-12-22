****** ESTADISTICAS DESCRIPTIVAS ******
clear all
set more off
cd 		"C:\Users\Roberto Carlos\Desktop\SBS\Modelo crédito formal_informal"
set more off
use base_reducida, clear

// Defino un folder 
global folder1 = "C:\Users\Roberto Carlos\Desktop\SBS\Modelo crédito formal_informal\Resultados"
**** Declarando a la base como encuesta
svyset n_de_conglomerado [w= facexp], strata (estrato)/*indica conglomerado, ponderacion y estrato*/

/*/ ID
global i sbs_id facexp departamento provincia distrito codubigeo estrato 
// DEPENDIENTES
global j 	demando_credito demando_formal demando_informal tipo_demanda ///
			prest_aprob necesita_cred solicito_credito cred_aprob 

// OFERTA DE CREDITOS
global k 	tiempo_ofi_2 tiempo_atm_2 tiempo_cc_2 ltm_of ltm_punto presencia_sf
// CARACTERISTICAS SOCIODEMOGRAFICAS
global l 	jefe_hogar lengua i.estado_civil edad edad_2 i.educ mujer empleo ///
			empleo_dep i.ingresos exp_adv exp_eadv 
// MANEJO FINANCIERO
global m 	activos activos_usa ahorro_mat ahorro_din recibe_remes recibio_ing_sf
// EDUCACION FINANCIERA
global n 	plan_efec calc_int rent_risk 
*conoce_ofi conoce_atm conoce_cc conoce_sf_internet conoce_sf_celu  //averig_cond_cta --> se quito x poca data
// CRITERIOS DE DECISION Y PERCEPCION DEL SF
global o 	cost_cred_impte cuot_mont_impte tramit_impte ganamas_ctasf flexib_ctasf mascosto_ctasf 
// CARACTERISTICAS DE LA VIVIENDA
global p 	pared piso techo agua sshh luz internet telef celular
// DESTINO DE CREDITO
global q 	cred_consumo cred_prod cred_viv cred_vehi cred_otros
*/


*** HECKPROBIT: Acceso a crédito formal
****** Modelo 1
ssc install outreg2
ssc install collin

**********************************************************************************************************

////Nuevas Regresiones


// MODELO HECKPROBIT

* Modelo 1
heckprobit solicito_formal presencia_sf tiempo_ofi_2 jefe_hogar lengua estado_civil edad edad_2 i.educ mujer rural empleo_dep i.ingresos activos_usa internet tiene_prod_fin impte_costo cred_consumo cred_colateral plan_efec calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua  estado_civil edad edad_2 i.educ mujer rural empleo_dep i.ingresos exp_eadv activos_usa internet techo ahorro recibe_remes plan_efec) vce (cluster n_de_conglomerado) 
estat ic 

* Modelo 2
heckprobit solicito_formal presencia_sf tiempo_ofi_2 jefe_hogar lengua estado_civil edad edad_2 i.educ mujer rural empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua  estado_civil edad edad_2 i.educ mujer rural empleo_dep i.ingresos exp_eadv activos_usa internet techo ahorro plan_efec) vce (cluster n_de_conglomerado) 
estat ic 

** MODELO 3 ** (En la ecuación de selección la variable es empleo dependiente)
**** Formal FINAL
heckprobit solicito_formal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado) 
estat ic
outreg2 using "$folder1\Heck_formal.xls", nocons e(all) excel replace
**** No Formal
heckprobit solicito_informal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado) 
estat ic
outreg2 using "$folder1\Heck_informal.xls", nocons e(all) excel replace

*** No Formal FINAL (sin prod financieros)
heckprobit solicito_informal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado) 
outreg2 using "$folder1\Heck_informal2.xls", nocons e(all) excel replace

*CONSULTAR: No ejecutan

// EFECTOS MARGINALES Y PROBABILIDADES

heckprobit solicito_formal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo impte_tramite cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado) 
*margins, dydx(ingresos) atmeans post
margins, dydx(*) atmeans post  // probabilidad conjunta solicitud = 1 y necesita = 1
outreg2 using "$folder1\heck_margins_formal.xlsx", excel replace ctitle(Efectos Marginales)

** Formal
heckprobit solicito_formal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo impte_tramite cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado)
* Efectos marginales sobre la probabilidad de necesitar crédito para ello se especifica la probabilidad de la ecuación de selección (psel)
margins, predict(psel) dydx(*) atmeans post 
outreg2 using "$folder1\margin_necesitar_credito.xls", excel replace ctitle(Efectos Marginales de la probabilidad de necesitar crédito)
*Efectos marginales sobre la probabilidad de solicitar crédito formal 
*Volver a correr el modelo  
margins, dydx(*) atmeans post   //(efectos marginales evaluado en la media de las variables) 
outreg2 using "$folder1\margin_solicita_formal.xls", excel replace ctitle(Efectos Marginales de la probabilidad de solicitar crédito formal)
//Calculo de probabilidades
//Volver a correr el modelo 
margins, atmeans // 33% de probabilidad de solicitar crédito formal p(solicita formal = 1)
margins, at(mujer=1) atmeans // No muestra cambios significativos
margins, at(cred_consumo=1) atmeans // alcanza un 50% en constraste del 33% del caso inicial 
margins, at(cred_colateral=1) atmeans // la probabilidad aumenta ahsta 74 %
margins, at(empleo_dep=1) atmeans // Se reduce la probabilidad de acceder al crédito formal 
margins, at(tiene_prod_fin=1) atmeans // Se incrementa hasta 44 %

// Probabilidades de solicitar crédito formal para diferentes niveles de ingreso y educación 
margins ingresos, atmeans 
margins educ, atmeans

// Probabilidad de necesitar crédito para diferentes niveles de estrato social, ingresos y educación 
margins, predict(psel) // Probabilidad de necesitar crédito 64%
margins ingresos, predict(psel) atmeans  
margins educ, predict(psel) atmeans
*margins estrato, predict(psel) atmeans  

// Probabilidades adicionales
margins, predict(pcond)   // probabilidad condicional P( solicita=1, necesita=1)/P(nesecita =1 ) 19%
margins, predict(p11)   // probabilidad solicita = 1 y necesita = 1  13%
margins, predict(p01)   // probabilidad solicita = 0 y necesita = 1  50%
margins, predict(p10)    // probabilidad solicita = 1 y necesita = 0   22%
*outreg2 using "$folder1\heck_formal_prob.xls", excel replace ctitle(Probabilidades estimadas)

** No Formal
heckprobit solicito_informal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo impte_tramite cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado) 
*Efectos marginales sobre la probabilidad de solicitar crédito informal 
margins, dydx(*) atmeans post   //(efectos marginales evaluado en la media de las variables) 
outreg2 using "$folder1\margin_solicita_informal.xls", excel replace ctitle(Efectos Marginales de la probabilidad de solicitar crédito informal)

//Calculo de probabilidades
// Volver a correr el modelo 
margins, atmeans //  41% de probabilidad de solicitar crédito informal p(solicita informal = 1)
margins, at(mujer=1) atmeans // 39% de probabilidad 
margins, at(cred_consumo=1) atmeans // alcanza un 82% en constraste del 41% del caso inicial 
margins, at(cred_colateral=1) atmeans // la probabilidad aumenta hasta 63 %
margins, at(empleo_dep=1) atmeans // 33% de probabilidad 
margins, at(tiene_prod_fin=1) atmeans // Se reduce a 39%

//Calculo de probabilidades adicionales 
//margins, predict(psel)    // probabilidad de seleccion y2 = 1  64%
margins, predict(pcond)   // probabilidad condicional          20%
margins, predict(p11)   // probabilidad solicita = 1 y necesita = 1      14%
margins, predict(p01)   // probabilidad solicita = 0 y necesita = 1      49%
margins, predict(p10)    // probabilidad solicita = 1 y necesita = 0     26%
*outreg2 using "$folder1\heck_informal_prob.xls", excel replace ctitle(Probabilidades estimadas)


****************************************************************************************************+
//********************************* BIPROBIT : Solo para quienes necesitan

** Con presencia y estratos
biprobit solicito_formal solicito_informal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
estat ic
* Sin estratos y presencia
biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
** FINAL: Sin presencia_sf y Con estratos
biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
estat ic
outreg2 using "$folder1\Biprobit1.xls", nocons e(all) excel replace 


// Efectos marginales en 3 escenarios

biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
margins, dydx (*) atmeans post
outreg2 using "$folder1\biprobit1_margins.xls", nocons e(all) excel replace

biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
margins, predict(p10) dydx (*) atmeans post
outreg2 using "$folder1\biprobit1_margins_p10.xls", nocons e(all) excel replace

biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
margins, predict(p01) dydx (*) atmeans post
outreg2 using "$folder1\biprobit1_margins_p01.xls", nocons e(all) excel replace

// estimacion de probabilidades

biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
margins, predict(pcond1)  // Probabilidad conjunta de credito formal e informal dado que el credito es informal 
margins, predict(pcond2)   // Probabilidad conjunta de credito formal e informal dado que el credito es formal 
margins, predict(p11) // probabilidad conjunta de credito formal e infiormal 
margins, predict(p01) // probablidad connuta de no credito formal y credito informal
margins, predict(p10) // probabilidad conjunta de credito formal y no infromal  
margins, predict(pmarg1) // probailidad de solo credito formal 24%
margins, predict(pmarg2) // probabilidad de solo credito informal 30%

margins, predict(pmarg1) at(cred_consumo=1) // probabilidad de credito formal para el credito de consumo 35%
margins, predict(pmarg2) at(cred_consumo=1) // probabilidad de credito informal para consumo 73%

margins, predict(pmarg1) at(cred_colateral=1) // probabilidad de credito formal para credito colateral 65%
margins, predict(pmarg2) at(cred_colateral=1)  // probabilidad credito informal para credito colateral 47%

margins, predict(p10) at(cred_consumo=1) // probabilidad conjunta de crédito formal y no informal dado credito consumo
margins, predict(p01) at(cred_consumo=1) // probabilidad conjunta de no crédito formal pero si informal dado credito consumo
margins, predict(p10) at(cred_colateral=1) // probabilidad conjunta de crédito formal y no informal dado credito colateral
margins, predict(p01) at(cred_colateral=1) // probabilidad conjunta de no crédito formal pero si informal dado credito colateral

margins, predict(p10) at(cost_cred_impte =1) // probablidad conjunta de credito formal y no infornal dado costos de impedimento
margins, predict(p01) at(cost_cred_impte =1) // probablidad conjunta de  no credito formal pero si infornal dado costos de impedimento

margins, predict(p10) at(tramit_impte=1)  // probablidad conjunta de  credito formal y no infornal dado impedimento por trámites
margins, predict(p01) at(tramit_impte=1)  // probablidad conjunta de  no credito formal pero si infornal dado impedimento por trámites
// Evaluacion de colienaliedad de los regresores
*findit collin
*collin presencia_sf tiempo_ofi_2 jefe_hogar lengua estado_civil edad edad_2 educ mujer rural empleo_dep activos_usa recibio_ing_sf cred_consumo cred_colateral plan_efec calc_int ingresos exp_eadv internet techo ahorro recibe_remes if !missing(necesita_cred)

*collin presencia_sf tiempo_ofi_2 jefe_hogar lengua estado_civil edad edad_2 educ mujer rural internet empleo_dep ingresos exp_eadv activos_usa ahorro recibio_ing_sf   plan_efe calc_int cred_colateral cred_consumo if !missing(solicito_informal)

// estadisticas descriptivas
*sum tiempo_ofi_2 cred_colateral cred_consumo rural mujer techo recibe_remes ahorro ahorro_din

**********************************************************************************************************
**************************** CAPACIDAD PREDICTIVA ****************************************+

//Capacidad predictiva Modelo 1 

gen capa1 = 1 

sum necesita_cred 
 
 misstable sum, all
 
heckprobit solicito_formal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo impte_tramite cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado)
 
 ** CAPACIDAD PREDICTIVA DE NECESITAR CREDITO 
 * P(Y2=1)
 
 // "Necesita" variable que almacena la probabilidad de necesitar crédito

 predict necesita, psel
 
 // creamos la variable pred 3 donde colocoamos como 1 a las observaciones con probabilidad de necesitar crédito mayor a 0.5 (necesita credito)
 //Predicción y2=1
 gen pred3 = 0
 replace pred3 = 1 if necesita >= 0.5
 //  // creamos la variable pred 4 donde colocoamos como 1 a las observaciones con probabilidad de necesitar crédito menor a 0.5 (no necesita credito)
  //Predicción y2=0
 gen pred4 = 0
 replace pred4 = 1 if necesita < 0.5
 
 *NECESITA CREDITO
 // creamos la variable "a" que asigna el valor de 1 a observaciones donde se predice correctamente la necesidad de credito
gen a = 0
replace a = 1 if pred3 == 1 & necesita_cred == 1
tab a
// la baribale "b" identifica observaciones donde la predicción de probablidad de necesitar crédito es incorrecto
gen b = 0
replace b = 1 if pred3 == 1 & necesita_cred == 0
tab b

*NO NECESITA CREDITO
// la baribale "c" identifica observaciones donde la predicción de probabilidad de no necesitar crédito es incorrecto
gen c = 0
replace c = 1 if pred4 == 1 & necesita_cred == 1
tab c
// la baribale "d" identifica observaciones donde la predicción de probabilidad de no necesitar crédito es correcto
gen d = 0
replace d = 1 if pred4 == 1 & necesita_cred == 0
tab d
***********************************************************************************************************************************************************
* CAPACIDAD PREDICITIVA DE SOLICITAR CREDITO y NECESITAR CREDITO (PROBABILIDAD CONJUNTA DE EXITO)
* P(Y1=1,Y2=1)

* Creamos la variable formal que contiene las probablidad conjunta de solicitar y necesitar crédito en cada observación
 predict formal, p11

 // creamos la variable pred 5 donde colocoamos como 1 a las observaciones con probabilidad de solicitar credito formal mayor a 0.5 (SOLICITA CREDITO FORMAL Y NECESITA CREDITO)
 gen pred5 = 0
 replace pred5 = 1 if formal >= 0.5
 //  // creamos la variable pred 6 donde colocamos como 1 a las observaciones con probabilidad de solicitar credito formal menor a 0.5 (NO SOLICITA CREDITO FORMAL DADO QUE NECESITA)
 
  //Predicción y2=0
 gen pred6 = 0
 replace pred6 = 1 if formal < 0.5
 
 // creamos la variable "e" que asigna el valor de 1 a observaciones donde la probabilidad predice correctamente solicitar credito formal y que necesite crédito
gen e = 0
replace e = 1 if pred5 == 1 & solicito_formal == 1 & necesita_cred == 1
tab e
// la baribale "b" identifica observaciones donde la predicción de probablidad de solicitar credito es incorrecto
gen f = 0
replace f = 1 if (pred5 == 1 & solicito_formal == 0 & necesita_cred == 1) | (pred5 == 1 & solicito_formal == 0 & necesita_cred == 0) | (pred5 == 1 & solicito_formal == 1 & necesita_cred == 0) 
tab f

// la baribale "c" identifica observaciones donde la predicción de probabilidad de no solicitar credito formal es incorrecto
gen g = 0
replace g = 1 if pred6 == 1 & solicito_formal == 1 & necesita_cred == 1 
tab g
// la baribale "d" identifica observaciones donde la predicción de probabilidad de no solicitar credito formal es correcto
gen h = 0
replace h = 1 if (pred6 == 1 & solicito_formal == 0 & necesita_cred == 1) | (pred6 == 1 & solicito_formal == 1 & necesita_cred == 0) | (pred6 == 1 & solicito_formal == 0 & necesita_cred == 0) 
tab h

***********************************************************************************************************************************************************
* CAPACIDAD PREDICITIVA DE SOLICITAR CREDITO INFORMAL Y QUE NECESITE CREDITO (PROBABILIDAD CONJUNTA DE EXITO)
* P(Y1=1,Y2=1)
heckprobit solicito_informal presencia_sf tiempo_ofi_2 estado_civil lengua edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin impte_costo impte_tramite cred_consumo cred_colateral calc_int [pweight=facexp], select(necesita_cred= jefe_hogar lengua estado_civil edad edad_2 i.educ mujer empleo i.ingresos i.estrato exp_eadv activos_usa ahorro plan_efec) vce (cluster n_de_conglomerado)
* Creamos la variable formal que contiene las probablidad de solicitar credito informal y que necesita crédito para cada observación
 predict informal, p11

 // creamos la variable pred 7 donde colocoamos como 1 a las observaciones con probabilidad de solicitar credito informal mayor a 0.5 
 gen pred7 = 0
 replace pred7 = 1 if informal >= 0.5
 //  // creamos la variable pred 8 donde colocamos como 1 a las observaciones con probabilidad de solicitar credito informal menor a 0.5
  //Predicción y2=0
 gen pred8 = 0
 replace pred8 = 1 if informal < 0.5
 
 // creamos la variable "j" que asigna el valor de 1 a observaciones donde la probabilidad predice correctamente solicitar credito informal y que necesite crédito
gen j = 0
replace j = 1 if pred7 == 1 & solicito_informal == 1 & necesita_cred == 1
tab j
// la baribale "k" identifica observaciones donde la predicción de probablidad de solicitar credito informal es incorrecto
gen k = 0
replace k = 1 if (pred7 == 1 & solicito_informal == 0 & necesita_cred == 1) | (pred7 == 1 & solicito_informal == 0 & necesita_cred == 0) | (pred7 == 1 & solicito_informal == 1 & necesita_cred == 0) 
tab k

// la baribale "m" identifica observaciones donde la predicción de probabilidad de no solicitar credito informal es incorrecto
gen m = 0
replace m = 1 if pred8 == 1 & solicito_informal == 1 & necesita_cred == 1  
tab m
// la baribale "n" identifica observaciones donde la predicción de probabilidad de no solicitar credito formal es correcto
gen n = 0
replace n = 1 if (pred8 == 1 & solicito_informal == 0 & necesita_cred == 1) | (pred8 == 1 & solicito_informal == 1 & necesita_cred == 0) | (pred8 == 1 & solicito_informal == 0 & necesita_cred == 0)
tab n

************************************************************************************************************************************************************************
// CAPACIDAD PREDICTIVA MODELO BIPROBIT
biprobit solicito_formal solicito_informal tiempo_ofi_2 estado_civil edad edad_2 i.educ mujer empleo_dep i.ingresos activos_usa tiene_prod_fin ahorro cost_cred_impte tramit_impte cred_consumo cred_colateral calc_int i.estrato if necesita_cred==1 [pweight=facexp], vce (cluster n_de_conglomerado) 
 
 // PROBAILIDAD MARGINAL DE SOLICITAR CREDITO FORMAL p(y1 = 1)
 predict p1, pmarg1
 // pred 9 asigna 1 a las observaciones con probabilidad de solicitar credito formal mayor a 0.5 (solicita credito formal)
gen pred9 = 0
replace pred9 = 1 if p1 >= 0.5
 // pred 10 asigna 1 a las observaciones con probabilidad de solicitar credito formal menor a 0.5  (no solicita credito formal)
gen pred10 = 0
replace pred10 = 1 if p1 < 0.5 
tab pred10
// "p" variable que predice correctamente la probabilidad de solicitar credito formal
gen p = 0
replace p = 1 if pred9 == 1 & solicito_formal == 1
// "q" variable que predice incorrectamente la probabilidad de solicitar credito formal
gen q = 0
replace q = 1 if pred9 == 1 & solicito_formal == 0

tab p 
tab q

// "r" variable que predice de manera incorrecta la probabildiad de no solicitar credito formal
gen r = 0
replace r = 1 if pred10 == 1 & solicito_formal == 1
// "s" variable que predice de manera correcta la probabildiad de no solicitar credito formal
gen s = 0
replace s = 1 if pred10 == 1 & solicito_formal == 0

tab r
tab s


// PROBABILIDAD MARGINAL DE SOLICITAR INFORMAL   p(y2 = 1)
 predict p2, pmarg2
 // pred 11 asigna 1 a probablidades de solicitar credito informal mayor a 0.5 (solicita credito informal)
gen pred11 = 0
replace pred11 = 1 if p2 >= 0.5 
 tab pred11
  // pred 11 asigna 1 a probablidades de solicitar credito informal menor a 0.5 (no solicita credito informal)
gen pred12 = 0
replace pred12 = 1 if p2 < 0.5 
tab pred12
// "t" variable que predice de manera correcta la probabildiad de solicitar credito informal
gen t = 0
replace t = 1 if pred11 == 1 & solicito_informal == 1
// "w" variable que predice de manera incorrecta la probabildiad de solicitar credito informal
gen w = 0
replace w = 1 if pred11 == 1 & solicito_informal == 0

tab t
tab w

// "x" variable que predice de manera incorrecta la probabildiad de no solicitar credito informal
gen x = 0
replace x = 1 if pred12 == 1 & solicito_informal == 1
// "t" variable que predice de manera correcta la probabildiad de no solicitar credito informal
gen z = 0
replace z = 1 if pred12 == 1 & solicito_informal == 0

tab x
tab z
