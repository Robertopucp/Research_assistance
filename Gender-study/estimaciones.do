** Brecha de Género y nivel educativo **

set more off

clear all

global base "C:\Users\Roberto Carlos\Desktop\Ciclo 2021 - 2\Brecha_salarial_por _género\Enaho 2011-2019\output"


use "$base\enaho2011-2019"

* Cambio en el nombre de las variables 

rename (p208a p301a p301b p301c p300a p209 p207 p558a i513t i518 p511a p512b p513a1 p505 p506 p201p) /// 
(edad educ nivel_edu1 nivel_edu2 lengua civil sexo informal horas_1 horas_2 contrato empresa tenure labor sector panel) //

****************************************************************************************************************************************************************
********************************** Summirize las variables  *********************************************************************************************************
****************************************************************************************************************************************************************

summarize edad educ nivel_edu1 nivel_edu2 lengua civil sexo i524e1 i538e1 i530a i541a informal horas_1 horas_2 contrato empresa tenure labor sector panel ocu500

	* Año
gen aniorec = real(year)

***********************************************************
***************** area urbano o rural **********************
************************************************************

replace estrato = 1 if dominio ==8 // ajuste en la definición de estrato para algunas zonas de Lima Metropolitana por ejemplo Pachacamac

recode estrato (1/5=1 "Urbana") (6/8=0 "Rural"), gen(area)

*****************************************************************************************************
******************** Creando dominios para aplciar deflactores espaciales ****************************
******************************************************************************************************

	* Departamento

gen dpto = real(substr(ubigeo,1,2))
lab var dpto "Departamentos"
recode dpto (7 = 15) // Callao como parte de Lima Metropolitana 

	* Etiquetas
label define dpto 1"Amazonas" 2"Ancash" 3"Apurimac" 4"Arequipa" 5"Ayacucho" 6"Cajamarca" 8"Cusco" 9"Huancavelica" 10"Huanuco" 11"Ica" 12"Junin" 13"La Libertad" 14"Lambayeque" 15"Lima" 16"Loreto" 17"Madre de Dios" 18"Moquegua" 19"Pasco" 20"Piura" 21"Puno" 22"San Martin" 23"Tacna" 24"Tumbes" 25"Ucayali"

lab val dpto dpto

tab dpto, gen(dep_)

gen dominioA = 1 if dominio==1 & area == 1
replace dominioA=2 if dominio==1 & area==0
replace dominioA=3 if dominio==2 & area==1
replace dominioA=4 if dominio==2 & area==0
replace dominioA=5 if dominio==3 & area==1
replace dominioA=6 if dominio==3 & area==0
replace dominioA=7 if dominio==4 & area==1
replace dominioA=8 if dominio==4 & area==0
replace dominioA=9 if dominio==5 & area==1
replace dominioA=10 if dominio==5 & area==0
replace dominioA=11 if dominio==6 & area==1
replace dominioA=12 if dominio==6 & area==0
replace dominioA=13 if dominio==7 & area==1
replace dominioA=14 if dominio==7 & area==0
replace dominioA=15 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==1
replace dominioA=16 if dominio==7 & (dpto==16 | dpto==17 | dpto==25) & area==0
replace dominioA=17 if dominio==8 & area==1
replace dominioA=17 if dominio==8 & area==0

label define dominioA 1 "Costa norte urbana" 2 "Costa norte rural" 3 "Costa centro urbana" 4 "Costa centro rural" 5 "Costa sur urbana" 6 "Costa sur rural"	7 "Sierra norte urbana"	8 "Sierra norte rural"	9 "Sierra centro urbana" 10 "Sierra centro rural"	11 "Sierra sur urbana" 12 "Sierra sur rural" 13 "Selva alta urbana"	14 "Selva alta rural" 15 "Selva baja urbana" 16 "Selva baja rural" 17"Lima Metropolitana"
lab val dominioA dominioA 


merge m:1 dominioA using "$base\despacial_ldnew.dta"
drop _m


*******************************************************************************
***************** creando la variable de cantidad de menores en el hogar ******
*******************************************************************************

// Menores entre 0 a 6 años y enntre 6 y 18 años
preserve 

gen menores_6=(edad < 7)

gen menores_17=(edad > 6 & edad < 18)

sort aniorec conglome vivienda hogar

collapse (sum) menores_6 menores_17, by(aniorec conglome vivienda hogar)
save "$base\menores_6.dta", replace

restore

merge m:1 aniorec conglome vivienda hogar using "$base\menores_6.dta", nogen

******************************************************************************
************* Clasificación del hogar ****************************************
******************************************************************************

preserve

recode p203 (1=1) (2=2) (3=3) (4/7=4) (8=5) (9=6) (10=7), gen(paren)

forvalues j = 1/7 {
	
	gen alfap`j'=1 if paren == `j'
}

keep if (p204==1 & p203!=8 & p203!=9)

sort aniorec conglome vivienda hogar

collapse (max) alfa1=alfap1 alfa2=alfap2 alfa3=alfap3 alfa4=alfap4 alfa5=alfap5 alfa6=alfap6 alfa7=alfap7, by(aniorec conglome vivienda hogar)

recode alfa1 alfa2 alfa3 alfa4 alfa5 alfa6 alfa7 (1=1) (.=0)

gen tipo_hogar = 1 if (alfa1==1 & alfa2==1 & alfa3==0 & alfa4==0 & alfa7==0)
replace tipo_hogar = 2 if (alfa1==1 & alfa2==1 & alfa3==1 & alfa4==0 & alfa7==0)
replace tipo_hogar = 3 if (alfa1==1 & alfa2==0 & alfa3==1 & alfa4==0 & alfa7==0)
replace tipo_hogar = 4 if (alfa1==1 & alfa2==1 & alfa3==0 & alfa4==1 & alfa7==0)
replace tipo_hogar = 5 if (alfa1==1 & alfa2==1 & alfa3==1 & alfa4==1 & alfa7==0)
replace tipo_hogar = 6 if (alfa1==1 & alfa2==0 & alfa3==1 & alfa4==1 & alfa7==0)
replace tipo_hogar = 7 if (alfa1==1 & alfa2==0 & alfa3==0 & alfa4==1 & alfa7==0)
replace tipo_hogar = 8 if (alfa1==1 & alfa2==1 & alfa3==0 & alfa4==0 & alfa7==1)
replace tipo_hogar = 9 if (alfa1==1 & alfa2==1 & alfa3==1 & alfa4==0 & alfa7==1)
replace tipo_hogar = 10 if (alfa1==1 & alfa2==0 & alfa3==1 & alfa4==0 & alfa7==1)
replace tipo_hogar = 11 if (alfa1==1 & alfa2==1 & alfa3==0 & alfa4==1 & alfa7==1)
replace tipo_hogar = 12 if (alfa1==1 & alfa2==1 & alfa3==1 & alfa4==1 & alfa7==1)
replace tipo_hogar = 13 if (alfa1==1 & alfa2==0 & alfa3==1 & alfa4==1 & alfa7==1)
replace tipo_hogar = 14 if (alfa1==1 & alfa2==0 & alfa3==0 & alfa4==1 & alfa7==1)
replace tipo_hogar = 15 if (alfa1==1 & alfa2==0 & alfa3==0 & alfa4==0 & alfa7==0)
replace tipo_hogar = 16 if (alfa1==1 & alfa2==0 & alfa3==0 & alfa4==0 & alfa7==1)

label define tipo_hogar 1 "Nuclear sin hijos" 2 "Nuclear con hijos" 3 "Nuclear monoparental" 4 "Extenso sin hijos" 5 "Extenso con hijos" 6 "Extenso monoparental" /*
*/ 7 "Extenso sin nucleo" 8 "Compuesto nuclear sin hijos" 9 "Compuesto nuclear con hijos" 10 "Compuesto nuclear monoparental" 11 "Compuesto extenso sin hijos" /*
*/ 12 "Compuesto extenso con hijos" 13 "Compuesto extenso monoparental" 14 "Compuesto sin nucleo" 15 "Unipersonal" 16 "No familiar"

label values tipo_hogar tipo_hogar

save "$base\tipo_hogar.dta", replace

restore

merge m:1 aniorec conglome vivienda hogar using "$base\tipo_hogar.dta", nogen

*****************************************************************************
**************************Creamos variable de hogares Monoparentales ********
*****************************************************************************

gen monoparental = inlist(tipo_hogar,3,6,10,13) 

**************************************************************************************
***** Trabajadores independientes, dependientes y obreros*****************************
**************************************************************************************

drop if  inlist(p507,1,5,6,7)

***********************************************************
********** Ingresos a a precios constantes del 2019 *******
***********************************************************

*************************************************************
**************** Merge por Deflactores **********************
*************************************************************

merge m:1 aniorec dpto using "$base\deflactores_base2019_new.dta"
drop if _m == 2
drop _m

*************************************************************
// ingresos anuales******************************************
*************************************************************

egen ingreso = rowtotal(i524e1 i538e1)
gen ingreso_r = ingreso/(i00*ld)  // deflactando a precios constantes de Lima Metropolitana 2019

// suma de horas trabajadas en ocupación principal y secundario

egen horas = rowtotal(horas_1 horas_2)


// salario por horas 

gen salario = ingreso_r/(horas*48)

replace salario = . if salario == 0

// salario por hora en logaritmo

gen l_salario = ln(salario)

** Otros ingresos no laborale 

egen n_labor = rowtotal(d544t d556t1 d556t2 d557t d558t)

gen ing_n_labor = n_labor/(i00*ld)  // deflactando a precios constantes de Lima Metropolitana 2019

gen l_n_labor = ln(n_labor)

**** Cálculo de los años de escolaridad

recode educ (1/4=0) (5/6 = 6) (7/10 = 11) (11 = 16) (12 =.), gen(acumulado)

egen estud = rowtotal(nivel_edu1 nivel_edu2)

gen educa = estud + acumulado

**** Dummies por nivel educativo
keep if educ > 5 &  educ != 12

recode educ (6 = 1 "Secundaria completa") (7 = 2 "No universitaria incompleta") (8 = 3 "No universitaria completa") (9 = 4 "Universitaria incompleta") (10 = 5 "Universitaria completa") (11 = 6 "Post-grado universitaria"), gen(d_edu)

**** Número de hijos por hogar 


**** Familia 

***** variables y ajustes adicionales

recode sexo (2=1) (1=0)

label define sexo 1 "mujer" 0 "hombre"
label values sexo sexo 

******************************************************************
******** variable experiencia ************************************
******************************************************************


gen exper = edad - educa - 6

replace exper = . if exper < 0

gen exper_2 = exper^2

** Usando la pregunta años de labor en la ocupación principal como proxy de experiencia

gen tenure_2 = tenure^2

*** Se considera edades de la población de edades entre 18 y 29

keep if edad > 17 & edad < 36

gen edad_2 = edad^2

***************************************************
************* Estado civil ************************
***************************************************

replace civil=inlist(civil,1,2)

label define civil 1 "casado o conviviente"
label values civil civil 

***************************************************
***** jefe de hogar********************************
**************************************************


clonevar jefe = p203

drop if jefe == 11 | jefe == 0

replace jefe = jefe == 1

label define jefe 0 "familiar" 1 "jefe"
label values jefe jefe

****************************************************
**** lengua ****************************************
****************************************************

replace lengua = 1 if inlist(lengua,1,2,3)
replace lengua = lengua == 1

label define lengua 1 "indioma nativo"
label value lengua lengua 

**** Dummy para Lima 

** agregando valores

gen ubigeo_2 = substr(ubigeo,1,2) + "0000" 

*gen lima_metropolitana=dominio==8

** Ajustamos la base a solo Lima Metropolitana

*keep if dominio == 8

*********************************************************************************************************
** Trabajador no nuenta con una cuenta en el sistema de pensiones. Variabe aproximada de trabajo informal.
*********************************************************************************************************

recode informal (5=1)

label define informal 1 "El trabajador no está afiliado al sistema de pensiones"
label values informal informal
******************************************************************************
*********** Dummies por tipo de empresa *************************************
******************************************************************************
recode empresa (min/9=1) (10/20 = 2) (21/100 = 3) (100/max = 4)

* etiquetas respectivas a la variable empresa

label define empresa 1 "microempresa" 2 "pequeña empresa" 3 "mediana empresa" 4 "gran empresa"
label values empresa empresa

****************************************************************************
*********************************************************************************
********** Dummies por sector económnico donde labora la persona ****************
*********************************************************************************

recode sector (min/399 = 1) (500/999 = 2) (1000/4000 = 3) (4000/4399 = 4) (4500/4799 = 5) (5500/5699 =5) (4900/5399 =6) ///
(5800/6399 = 6) (6400/6899 = 7) (6900/max = 8) //


label define sector 1 "agricultura, selvicultura y pesca" 2 "minería" 3 "Manufactura y servicios públcios" 4 "Construcción" 5 "Comercio, hoteles y restaurantes" 6 "Transporte, comunicaciones y alamacenamiento" 7 "Finanzas, seguro y bienes raíces" 8 "Servicios persnales, sociales y comunales"
label values sector sector

*************************************************************************
********** Dummies por tipo de empleo ***********************************
*************************************************************************

recode labor (0/23 = 3) (200/300 = 2) (100/200 = 3) (300/400 = 4) (400/500 = 5) ( 500/600 = 6) (600/700 = 7) (700/800 = 8) (800/900 = 9) (900/max = 1)

label define labor 1 "Ocupaciones elementales" 3 "Profesionales y fuerzas armadas" 4 "Técnicos y similares" 5 "Asistentes administrativos" /// 
6 "Trabajadores de ventas y en servicios" 7 "Trabajo en actividades agrícolas, selvicultura y pesca" 8 "Trabajo en artesanía y afines" /// 
9 "Operadores de planta y maquinaria" 2 "Administradores"
label values labor labor 

keep if merge2 == 3 & merge3==3

drop merge2 merge3

save "$base\base_final.dta", replace

******************************************* Estimaciones ************************************************* 

use "$base\base_final.dta", clear 

svyset [pweight = facpob07], psu(conglome) strata(estrato) 

gen factornd07 = round(facpob07,1)


********************   Descomposición Oaxaca - Blinder ******************************
*recode sexo (0=1) (1=0)
*label drop sexo
*label define sexo 1 "Hombre" 0 "Mujer"
*label values sexo sexo 

*ssc install oaxaca

tabulate labor, generate(Labor_)
tabulate sector, generate(Sector_)
tabulate empresa, generate(Empresa_)
tabulate d_edu, generate(ed_)


*************************************************************************************************************************
*heckman l_salario i.d_edu exper exper_2 informal, select(civil educa edad jefe lengua), if sexo == 0
*himod, ds


*heckman l_salario i.d_edu exper exper_2 informal, select(civil educa edad jefe lengua), if sexo == 1
*lomod, ds

*decomp

*************************************************************************************************************************
*************************************************** Ecuacion de Mincer y ajustado por sesgo de selección ****************
*************************************************************************************************************************

reg l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2011" [pweight=facpob07], robust cluster(conglome)

heckman l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area,  select(edad menores_6 menores_17 sexo monoparental) twostep, if year == "2012" 

************************************************************************************************************************************
************************************************ Descomposición de Oaxaca Blinder **************************************************
************************************************************************************************************************************

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2011", by(sexo) svy

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2013", by(sexo) model2(heckman, twostep select(edad menores_6 menores_17 civil monoparental)) 

***********************************************************************************************************************
***********************************************************************************************************************
**** Juntamos las regresiones *****************************************************************************************
***********************************************************************************************************************

reg l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2011" [pweight=facpob07], robust cluster(conglome)

outreg2 using "$base\estimaciones_Mincer.xls", excel replace ctitle(year - 2011)

heckman l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area,  select(edad menores_6 menores_17 sexo monoparental) twostep, if year == "2011"

outreg2 using "$base\estimaciones_Heckman.xls", excel replace ctitle(year - 2011)

***** Descomposición de Oaxaca Blinder

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2011", by(sexo) relax svy

outreg2 using "$base\estimaciones_oaxaca.xls", excel replace ctitle(year - 2011)

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "2011", by(sexo) model2(heckman, twostep select(edad menores_6 menores_17 civil monoparental)) relax 

outreg2 using "$base\estimaciones_oaxaca_Heckman.xls", excel replace ctitle(year - 2011)

* Agregando por años

forvalues j = 2012/2019 {

***** Ecuación de Mincer ************

reg l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "`j'" [pweight=facpob07], robust cluster(conglome)

outreg2 using "$base\estimaciones_Mincer.xls", excel append ctitle(year - `j')

***** Corregido por sesgo de selección ************

heckman l_salario i.d_edu exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area,  select(edad menores_6 menores_17 sexo monoparental) twostep, if year == "`j'"


outreg2 using "$base\estimaciones_Heckman.xls", excel append ctitle(year - `j')

***** Descomposición de Oaxaca Blinder *******

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24 area if year == "`j'", by(sexo) relax svy

outreg2 using "$base\estimaciones_oaxaca.xls", excel append ctitle(year - `j')

***** Descomposición de Oaxaca Blinder ajustado por error de selección *****

oaxaca l_salario ed_2-ed_6 exper exper_2 Labor_2-Labor_9 Empresa_2-Empresa_4 informal dep_2-dep_24  area if year == "`j'", by(sexo) model2(heckman, twostep select(edad menores_6 menores_17 civil monoparental)) relax 

outreg2 using "$base\estimaciones_oaxaca_Heckman.xls", excel append ctitle(year - `j')

}

















**************************************************************************************************************************

*reg l_salario ed_2-ed_6 exper exper_2 if sexo == 0 & year == "2019"
*himod, ds

*reg l_salario ed_2-ed_6 exper exper_2 if sexo == 1 & year == "2019"
*lomod, ds

*decomp







