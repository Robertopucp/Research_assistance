****** ESTADISTICAS DESCRIPTIVAS ******
cd 		"C:\Users\Mariale\Documents\PUCP\Tesis\Avances Álvaro\Tesis Mariale"
set more off
use base_reducida, clear

**** Declarando a la base como encuesta
*svyset n_de_conglomerado [pweight= facexp], strata (estrato) : indica conglomerado, ponderacion y estrato
svyset n_de_conglomerado [w= facexp], strata (estrato)
	

*** TABLAS ***

* ¿Necesitó un credito del SF?
svy: tab necesita_cred 
* Ahora se asume que si SOLICITÓ, NECESITÓ (ya no se reconstruye)
*svy: tab solicito_cred: Los % son muy diferentes a los de NS
 
* ¿Solicitó crédito a una IF?
svy: tab solicito_formal if necesita_cred==1
*svy: tab solicito_formal if solicito_cred==1
 
* ¿Le otorgan crédito?
svy: tab cred_aprob if solicito_formal==1


*** Gráficos
* - Tipo de Demanda si solicitó crédito
graph pie [pweight = facexp] if solicito_cred==1, over(tipo_demanda) plabel(_all percent) legend(on order(1 "Formal" 2 "No Formal" 3 "Ambos" ) cols(3))
svy: tab tipo_demanda if solicito_cred==1

* - Tipo de Demanda por edad, género 
gen rango_edad=0
replace rango_edad=1 if edad<=30
replace rango_edad=2 if edad>30 & edad<=40
replace rango_edad=3 if edad>40 & edad<=50
replace rango_edad=4 if edad>50 & edad<=65
replace rango_edad=5 if edad>65
label define rango_edad 1 "18 a 30 años" 2 "31 a 40 años" 3 "41 a 50 años" 4 "51 a 65 años" 5 "65 a más", replace
label values rango_edad rango_edad

* Rango de edad
svy: tab rango_edad tipo_demanda if solicito_cred==1 
* Género
svy: tab mujer tipo_demanda if solicito_cred==1 
* Estrato
svy: tab estrato tipo_demanda if solicito_cred==1 
* Rango de ingresos
label define rango_ingresos 0 "No tiene" 1 "Menos de S/400" 2 "De S/400 a S/750" 3 "De S/750 a S/1500" 4 "Más de S/1500", replace
label values ingresos rango_ingresos
svy: tab ingresos tipo_demanda if solicito_cred==1 
* Nivel educativo
label define nivel_educ 1 "Primaria o menos" 2 "Secundaria" 3 "Superior", replace
label values educ nivel_educ
svy: tab educ tipo_demanda if solicito_cred==1 

** Razones por las que no solicitaron crédito
svy: tab motivo_no_solicito if motivo_no_solicito!=1  
svy: tab motivo_no_solicito if motivo_no_solicito!=1 & rural==1 
svy: tab motivo_no_solicito if motivo_no_solicito!=1 & rural==0

*** Motivos más importantes para solicitar un préstamo
svy: tab impte_tramite
svy: tab impte_cuota
svy: tab impte_plazo 
svy: tab impte_pagos 
svy: tab impte_cantidad 
svy: tab impte_costo 
svy: tab impte_docu 
svy: tab impte_regalo 
svy: tab impte_otro

svy: tab impte_tramite if rural==1
svy: tab impte_cuota if rural==1
svy: tab impte_plazo if rural==1
svy: tab impte_pagos if rural==1
svy: tab impte_cantidad if rural==1
svy: tab impte_costo if rural==1
svy: tab impte_docu if rural==1
svy: tab impte_regalo if rural==1
svy: tab impte_otro if rural==1

svy: tab impte_tramite if rural!=1
svy: tab impte_cuota if rural!=1
svy: tab impte_plazo if rural!=1
svy: tab impte_pagos if rural!=1
svy: tab impte_cantidad if rural!=1
svy: tab impte_costo if rural!=1
svy: tab impte_docu if rural!=1
svy: tab impte_regalo if rural!=1
svy: tab impte_otro if rural!=1

** Educación Financiera
svy: tab plan_efec tipo_demanda if solicito_cred==1
svy: tab calc_int tipo_demanda if solicito_cred==1


***** ESTADÍSTICAS DESCRIPTIVAS

*** SUMMARIZE
sum 	$i $j $k $l $m $n $o $p $q
** los que necesitaron
bysort necesita_cred: sum $k lengua estado_civil edad edad_2 educ mujer empleo empleo_dep ingresos exp_adv exp_eadv $m $n $o $p $q
** los que solicitaron
bysort solicito_cred: sum $k lengua estado_civil edad edad_2 educ mujer empleo empleo_dep ingresos exp_adv exp_eadv $m $n $o $p $q if necesita_cred==1

sum necesita_cred solicito_formal solicito_informal presencia_sf ltm_of cred_prod cred_vehi cred_viv edad edad_2 jefe_hogar mujer estado_civil educ lengua empleo_dep ingresos exp_eadv activos_usa ahorro_mat recibio_ing_sf plan_efec calc_int internet celular pared  

***** ESTADÍSTICAS DESCRIPTIVAS

*** SUMMARIZE
sum 	$i $j $k $l $m $n $o $p $q
** los que necesitaron
bysort necesita_cred: sum $k lengua estado_civil edad edad_2 educ mujer empleo empleo_dep ingresos exp_adv exp_eadv $m $n $o $p $q
** los que solicitaron
bysort solicito_cred: sum $k lengua estado_civil edad edad_2 educ mujer empleo empleo_dep ingresos exp_adv exp_eadv $m $n $o $p $q if necesita_cred==1

*** Correlación
pwcorr presencia_sf tiempo_ofi_2 jefe_hogar lengua estado_civil edad edad_2 educ mujer empleo_dep ingresos exp_eadv activos_usa ahorro_mat recibe_remes recibio_ing_sf plan_efec calc_int techo internet rural cred_colateral


















