clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\area.xlsx", sheet("Hoja1") firstrow case(lower)

rename ubigeo ubigeo1

tostring ubigeo1, gen(ubigeo)

replace ubigeo = "0"+substr(ubigeo,1,5) if ubigeo1 < 100000 

sort ubigeo1

drop nombdist ubigeo1 

rename area area_km

save "$folder1\area.dta", replace 

*********************************************************************
clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\escolar.xls", sheet("hoja1") firstrow case(lower)

generate esc = real(escolar)

codebook esc

replace esc = 0 if esc == .

drop distrito escolar 

save "$folder1\escolar.dta", replace 

*************************************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\foncomun.xls", sheet("hoja1") firstrow case(lower)

drop distrito

save "$folder1\canon.dta", replace 

************************************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\idh.xlsx", sheet("hoja1") firstrow case(lower)

drop in 1875/1940

drop distrito e f g 

save "$folder1\idh.dta", replace 


**********************************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\impuestos_mineros.xlsx", sheet("hoja1") firstrow case(lower)

drop distrito d e f 

save "$folder1\impuestos.dta", replace 


**********************************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\matricula.xls", sheet("hoja1") firstrow case(lower)

generate matri = real(matricula)

drop matricula 

replace matri = 0.9 if matri == .

save "$folder1\matricula.dta", replace 

*******************************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\mineras.xlsx", sheet("hoja1") firstrow case(lower)

drop in 1875/1876

drop d e distrito

save "$folder1\mineras.dta", replace 

*******************************************************************
clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\mortalidad.xls", sheet("hoja1") firstrow case(lower)

generate mort = real(mortalidad)

generate desnu = real(des_inf)

drop distrito mortalidad des_inf 

save "$folder1\mortalidad.dta", replace 

**********************************************************

clear all
set more off

global folder1 = "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Agricultura_TESIS\Base_extendida"

import excel "$folder1\pobreza.xls", sheet("hoja1") firstrow case(lower)

drop distrito

save "$folder1\pobreza.dta", replace 

*********************