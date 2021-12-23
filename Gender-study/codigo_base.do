**********************************************************
* Módulo 100: características de la vivienda
**********************************************************
* 2011

use "${temp}enaho01-2011-100.dta", clear

rename aÑo year
keep if result==1 | result==2 //nos quedamos con las encuestas completas e incompletas

sort conglome vivienda hogar
keep year mes conglome vivienda hogar ubigeo dominio estrato result p101 ///
p102 p103 p103a p104 p110 p111 p1121 p112a p1138 p113a p1141 p1142 p1143 p1144
rename p111 p111a

save "${temp}mod100_2011.dta", replace

* 2012
use "${temp}enaho01_2012_100.dta", clear

rename aÑo year
keep if result==1 | result==2 //nos quedamos con las encuestas completas e incompletas

sort conglome vivienda hogar
keep year mes conglome vivienda hogar ubigeo dominio estrato result p101 ///
p102 p103 p103a p104 p110 p111a p1121 p112a p1138 p113a p1141 p1142 p1143 p1144

save "${temp}mod100_2012.dta", replace

* 2013
use "${temp}enaho01_2013_100.dta", clear

rename aÑo year
keep if result==1 | result==2 //nos quedamos con las encuestas completas e incompletas

sort conglome vivienda hogar
keep year mes conglome vivienda hogar ubigeo dominio estrato result p101 ///
p102 p103 p103a p104 p110 p111a p1121 p112a p1138 p113a p1141 p1142 p1143 p1144

save "${temp}mod100_2013.dta", replace

* 2014
use "${temp}440-Modulo01/enaho01-2014-100.dta", clear

rename aÑo year
keep if result==1 | result==2 //nos quedamos con las encuestas completas e incompletas

sort conglome vivienda hogar
keep year mes conglome vivienda hogar ubigeo dominio estrato result p101 ///
p102 p103 p103a p104 p110 p111a p1121 p112a p1138 p113a p1141 p1142 p1143 p1144

save "${temp}mod100_2014.dta", replace

* 2015
use "${temp}498-Modulo01/enaho01-2015-100.dta", clear

rename aÑo year
keep if result==1 | result==2 //nos quedamos con las encuestas completas e incompletas

sort conglome vivienda hogar
keep year mes conglome vivienda hogar ubigeo dominio estrato result p101 ///
p102 p103 p103a p104 p110 p111a p1121 p112a p1138 p113a p1141 p1142 p1143 p1144

save "${temp}mod100_2015.dta", replace


**********************************************************
* Módulo 200: Características de los miembros del hogar
**********************************************************
* 2011
use "${temp}291-Modulo02/enaho01_2011_200.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p203 ///
p204 p207 p208a p208a1 p208a2 facpob07

save "${temp}mod200_2011.dta", replace

* 2012
use "${temp}enaho01-2012-200.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p203 ///
p204 p207 p208a p208a1 p208a2 facpob07

save "${temp}mod200_2012.dta", replace

* 2013
use "${temp}enaho01_2013_200.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p203 ///
p204 p207 p208a p208a1 p208a2 facpob07

save "${temp}mod200_2013.dta", replace

* 2014
use "${temp}440-Modulo02/enaho01-2014-200.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p203 ///
p204 p207 p208a p208a1 p208a2 facpob07

save "${temp}mod200_2014.dta", replace

* 2015
use "${temp}enaho01-2015-200.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p203 ///
p204 p207 p208a p208a1 p208a2 facpob07

save "${temp}mod200_2015.dta", replace


**********************************************************
* Módulo 300: Educación
**********************************************************
* 2011
use "${temp}291-Modulo03/enaho01a-2011-300.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p301a

save "${temp}mod300_2011.dta", replace

* 2012
use "${temp}enaho01a-2012-300.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p301a

save "${temp}mod300_2012.dta", replace

* 2013
use "${temp}404-Modulo03/Enaho01a-2013-300.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p301a

save "${temp}mod300_2013.dta", replace

* 2014
use "${temp}440-Modulo03/enaho01a-20114-300.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p301a

save "${temp}mod300_2014.dta", replace

* 2015
use "${temp}enaho01a-2015-300.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p301a

save "${temp}mod300_2015.dta", replace


**********************************************************
* Módulo 500: Empleo e ingreso
**********************************************************
* 2011
use "${temp}291-Modulo05/Enaho01A-2011-500.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso 
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p501 ///
p502 p503 p506 p507 p521 p545 p5564a p5566a p5567a i524a1 i538a1 ocu500 i513t ///
i518 p53712 p301a d524a1 d538a1 p524a1 p524a2 d524a1 i524a1

save "${temp}mod500_2011.dta", replace

* 2012
use "${temp}enaho01a-2012-500.dta", clear

rename año year
sort conglome vivienda hogar codperso 
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p501 ///
p502 p503 p506 p507 p521 p545 p5564a p5566a p5567a i524a1 i538a1 ocu500 i513t ///
i518 p53712 p301a d524a1 d538a1 p524a1 p524a2 d524a1 i524a1

save "${temp}mod500_2012.dta", replace

* 2013
use "${temp}404-Modulo05/enaho01a-2013-500.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso 
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p501 ///
p502 p503 p506 p507 p521 p545 p5564a p5566a p5567a i524a1 i538a1 ocu500 i513t ///
i518 p53712 p301a d524a1 d538a1 p524a1 p524a2 d524a1 i524a1

save "${temp}mod500_2013.dta", replace

* 2014
use "${temp}440-Modulo05/enaho01a-2014-500.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso 
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p501 ///
p502 p503 p506 p507 p521 p545 p5564a p5566a p5567a i524a1 i538a1 ocu500 i513t ///
i518 p53712 p301a d524a1 d538a1 p524a1 p524a2 d524a1 i524a1

save "${temp}mod500_2014.dta", replace

* 2015
use "${temp}enaho01a-2015-500.dta", clear

rename aÑo year
sort conglome vivienda hogar codperso 
keep year mes conglome vivienda hogar codperso ubigeo dominio estrato p501 ///
p502 p503 p506 p507 p521 p545 p5564a p5566a p5567a i524a1 i538a1 ocu500 i513t ///
i518 p53712 p301a d524a1 d538a1 p524a1 p524a2 d524a1 i524a1

save "${temp}mod500_2015.dta", replace







* Do file para descomprimir los módulos de la Enaho 

cd "${temp}"
local files: dir "${input}" files "*.zip"

foreach file in `files' {
display "`file'"
unzipfile "${input}`file'", replace
}




















clear all
set more off
set mem 1G


********************************************************************************  
* Seleccionar la ruta de escritorio
********************************************************************************
global mydir 	"C:\Users\César\Desktop\Enaho 2011-2015\"


********************************************************************************
* Macros auxiliares
********************************************************************************
global input 	"${mydir}/build/input/"
global code		"${mydir}/build/code/"
global temp 	"${mydir}/build/temp/"
global output 	"${mydir}/build/output/"

global idhogar conglome vivienda hogar
global idper ${idhogar} codperso


********************************************************************************
* Ejecutar tareas
********************************************************************************
do "${code}unzip.do"
do "${code}variables.do"
do "${code}dataset.do"
do "${code}cleantemp.do"




























* Do file para dar un solo formato a las enaho's

local files: dir "${temp}" files "*.dta"

foreach file in `files' {
display "`file'"
use "${temp}`file'", clear
capture rename aÑo year
capture rename año year
save, replace
}


















* Do file para mergear los módulos de la Enaho
********************************************************************************

* 2011
use "${temp}mod100_2011.dta", clear
sort conglome vivienda hogar
merge 1:m conglome vivienda hogar using "${temp}mod200_2011.dta", gen(merge1)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod300_2011.dta", gen(merge2)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod500_2011.dta", gen(merge3)


sort conglome vivienda hogar codperso
save "${temp}enaho2011.dta", replace 




* 2012
use "${temp}mod100_2012.dta", clear
sort conglome vivienda hogar
merge 1:m conglome vivienda hogar using "${temp}mod200_2012.dta", gen(merge1)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod300_2012.dta", gen(merge2)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod500_2012.dta", gen(merge3)


sort conglome vivienda hogar codperso
save "${temp}enaho2012.dta", replace 



* 2013
use "${temp}mod100_2013.dta", clear
sort conglome vivienda hogar
merge 1:m conglome vivienda hogar using "${temp}mod200_2013.dta", gen(merge1)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod300_2013.dta", gen(merge2)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod500_2013.dta", gen(merge3)


sort conglome vivienda hogar codperso
save "${temp}enaho2013.dta", replace 



* 2014
use "${temp}mod100_2014.dta", clear
sort conglome vivienda hogar
merge 1:m conglome vivienda hogar using "${temp}mod200_2014.dta", gen(merge1)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod300_2014.dta", gen(merge2)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod500_2014.dta", gen(merge3)


sort conglome vivienda hogar codperso
save "${temp}enaho2014.dta", replace



* 2015
use "${temp}mod100_2015.dta", clear
sort conglome vivienda hogar
merge 1:m conglome vivienda hogar using "${temp}mod200_2015.dta", gen(merge1)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod300_2015.dta", gen(merge2)
sort conglome vivienda hogar codperso
merge 1:1 conglome vivienda hogar codperso using "${temp}mod500_2015.dta", gen(merge3)


sort conglome vivienda hogar codperso
save "${temp}enaho2015.dta", replace  



**********************************************************
* Juntamos las Enaho
**********************************************************
use "${temp}enaho2011.dta", clear
append using "${temp}enaho2012.dta"
append using "${temp}enaho2013.dta"
append using "${temp}enaho2014.dta"
append using "${temp}enaho2015.dta"
save "${output}enaho2011-2015.dta", replace











































