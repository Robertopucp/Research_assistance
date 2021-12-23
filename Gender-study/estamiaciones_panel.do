clear all 
set more off

global base "C:\Users\Roberto Carlos\Desktop\Ciclo 2021 - 2\Brecha_salarial_por _género\Enaho 2011-2019\output"


use "$base\base_final"

destring year, replace 

sort year

tostring panel, gen(codigo) format("%17.0f")

****** etiqueta id-unico

gen unico = codperso + codigo 
***********************************************************************************

preserve
keep if year == 2015
// revisar la presencia de datos duplicados 
sort unico
quietly by unico: gen dup = cond(_N==1,1,_n)
drop if dup > 1

keep unico
save "$base\panel.dta", replace
restore 

*******************************************************************************************

forvalues i = 2015/2019 {
preserve
keep if year == `i'
sort unico
quietly by unico: gen dup = cond(_N==1,1,_n)
drop if dup > 1
drop dup
save "$base\base`i'.dta", replace
restore 
}


forvalues i = 2015/2019 {

use "$base\base`i'.dta", clear
keep if year == `i'
merge 1:1 unico using "$base/panel.dta", gen(merge4)
keep if merge4 == 3
drop merge4
save "$base\panel`i'.dta", replace
}

****************************************************

// Append base de datos
use "$base\panel2015.dta", clear

forvalues y = 2016/2019 {

	append using "$base\panel`y'.dta"
}

preserve
sort unico year
quietly by unico: gen dup = cond(_N==1,1,_n)
keep if year == 2019
keep if dup == 5
drop dup
save "$base\filtro.dta", replace
restore

merge m:1 unico using "$base\filtro.dta", gen(merge4)


keep if merge4 == 3
drop merge4

sort unico year

quietly by unico: egen valido = total(sexo)
keep if valido == 0 | valido == 5


** corrigiendo casos codigos panel asignados a diferentes personas 

sort unico year

** Declarando a STATA que la base de datos es tipo Panel

gen id = .
local k = 1

forvalues i = 1/249 {
    
	forvalues j = 1/5 {
	    
	replace id = `i' in `k' 
	
	local k = `k' + 1
	}

}

save "$base\base_panel_final", replace


**************************************************
**************************************************


use "$base\base_panel_final", clear

**************************************************
*sort unico year

xtset id year

* Creamos una dummy temporal y declaramos a STATA que usamo datos de un encuesta

tabulate year, generate(D_)

svyset [pweight = facpob07], psu(conglome) strata(estrato) 

* Estimación Panel por efectos fijos 
tabulate d_edu, generate(ed_)
tabulate labor, generate(Labor_)
tabulate sector, generate(Sector_)
tabulate empresa, generate(Empresa_)

*gen educ_2015 = educa*D_1
*gen educ_2016 = educa*D_2
*gen educ_2017 = educa*D_3
*gen educ_2018 = educa*D_4
*gen educ_2019 = educa*D_5

*****************************************************************************************************************************************************************************
***************************************** Using Fixed Effects and matrix de varianza y covarianza robusto ante la autocorrelación intragrupo ********************************
*****************************************************************************************************************************************************************************
xtscc l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal, fe  
outreg2 using "$base\estimaciones_panel.xls", excel replace ctitle(Modelo 1)

*****************************************************************************************************************************************************************************
***************************************** Using Fixed Effects  *************************************************************************************************************
*****************************************************************************************************************************************************************************
xtreg l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal, fe  
outreg2 using "$base\estimaciones_panel.xls", excel append ctitle(Modelo 2)
*testparm D_*
*****************************************************************************************************************************************************************************
***************************************** Using Random Effects *************************************************************************************************************
*****************************************************************************************************************************************************************************
xtreg l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal D_*, re  
outreg2 using "$base\estimaciones_panel.xls", excel append ctitle(Modelo 3)
*testparm D_*

xtscc l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal D_*, re
testparm D_*
outreg2 using "$base\estimaciones_panel.xls", excel append ctitle(Modelo 4)
*****************************************************************************************************************************************************************************
**********************************************************************Test de Hausman****************************************************************************************
*****************************************************************************************************************************************************************************

** Efectos aleatorios
qui xtreg l_salario educa exper exper_2, re

estimates store fixed

** Efectos fijos 
qui xtreg l_salario educa exper exper_2, fe  

*TEST DE HAUSMAN 

hausman fixed

*** Estimación modelo Oaxaca Blinder 

*net install xtoaxaca, from(https://gitlab.com/jhart/xtoaxaca/-/raw/master) replace

**********************************************************************************


keep if l_salario != .
keep if exper != .
keep if Empresa_2 != .

*qui: eststo est1: xtreg l_salario i.year##i.sexo##c.(exper exper_2 informal) i.year##i.sexo##i.(d_edu labor empresa), fe

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est1) detail change(interventionist)





*estimates table, star(.1 .05 .01)

*parmest, list(,) stars(0.05 0.01 0.1)

********************************************************************************
********************************************************************************

*preserve 

*collapse (count) valido, by(id) 
*rename valido valido2

*save "$base\id_base", replace

*restore

*merge m:1 id using "$base\id_base"

*keep if valido2 == 5

**************************
**************************
*bysort id: gen ct = _n
**************************
**************************

*gen id2 = .
*local k = 1

*forvalues i = 1/245 {
    
	*forvalues j = 1/5 {
	    
	*replace id2 = `i' in `k' 
	
	*local k = `k' + 1
	*}

*}

*xtset, clear 

*gen newid = id2

*xtset newid year

****************************************************************************************************************************************************************************
****************************************************************************************************************************************************************************
***************************************** Using Fixed Effects and matrix de varianza y covarianza robusto ante la autocorrelación intragrupo ********************************
*****************************************************************************************************************************************************************************

qui: eststo est2: xtscc l_salario i.year##i.sexo##c.(exper exper_2) i.year##i.sexo##i.(d_edu labor empresa informal), re

xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est2) change(interventionist) bootstrap(50) detail resultsdata(output, replace) 

******************************************************************************************************************************************

*qui: eststo est3: xtscc l_salario i.year##i.sexo i.year##i.sexo##c.(exper exper_2) i.year##i.sexo##i.(d_edu labor empresa informal), re

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est3) change(interventionist) bootstrap(2) detail resultsdata(output, replace) 


*****************************************************************************************************************************************************************************
***************************************** Using Fixed Effects ********************************
*****************************************************************************************************************************************************************************

*qui: eststo est2: xtreg l_salario i.year##i.sexo##c.(exper exper_2 informal) i.year##i.sexo##i.(d_edu labor empresa), fe

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est2) change(interventionist) bootstrap(50) detail resultsdata(output, replace) 



*qui: eststo est3: xtreg l_salario i.year##i.sexo i.year##i.sexo##c.(exper exper_2 informal) i.year##i.sexo##i.(d_edu labor empresa), fe

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est3) change(interventionist) bootstrap(50) detail resultsdata(output, replace) 


*****************************************************************************************************************************************************************************
***************************************** Using Random Effects **************************************************************************************************************
*****************************************************************************************************************************************************************************

*qui: eststo est4: xtreg l_salario i.year##i.sexo##c.(exper exper_2 informal) i.year##i.sexo##i.(d_edu labor empresa)

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est4) change(interventionist) bootstrap(50) detail resultsdata(output, replace) 



*qui: eststo est5: xtreg l_salario i.year##i.sexo i.year##i.sexo##c.(exper exper_2 informal) i.year##i.sexo##i.(d_edu labor empresa)

*xtoaxaca d_edu exper exper_2 labor empresa informal, groupvar(sexo) groupcat(0 1) timevar(year) times(2015 2016 2017 2018 2019) timeref(2015) model(est5) change(interventionist) bootstrap(50) detail resultsdata(output, replace) 


**********************************************************************************************************************************************







































