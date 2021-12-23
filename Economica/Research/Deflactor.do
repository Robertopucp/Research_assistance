clear all
set more off

cd "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019"

import excel "C:\Users\Roberto Carlos\Desktop\Ciclo-2020-2\Economica\Boletin\base-datos\2019\deflactor.xlsx", sheet("2019") cellrange(B3:E28) firstrow clear

drop Departamento

rename ubigeo ubi
tostring ubi, gen(ubigeo)

drop ubi

save deflactor, replace 