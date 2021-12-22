clear all
cd "C:\Users\Samsung\Documents\Sesion 02\Reto 3"
use JTRAIN1
**PREGUNTA 1
reg  lscrap grant grant_1 d88 d89 
estimates store pooled
xtreg lscrap grant grant_1 d88 d89,fe
estimates store fe
xtreg lscrap grant grant_1 d88 d89,re
estimates store re
xttest0
hausman fe re
**PREGUNTA 2
*Pruebas de efectos fijos
xtreg lscrap grant grant_1 d88 d89,fe
xtserial lscrap  grant grant_1 d88 d89
xtreg lscrap grant grant_1 d88 d89,fe
xtcsd, pesaran show
*Prueba de efectos aleatorios
 xtreg lscrap grant grant_1 d88 d89,re
 xttest1
*Corrije problema de autocorrelación y correlación serial
 xtgls lscrap grant grant_1 d88 d89,p(h) c(ar1)
 estimates store xtglsre
 xtpcse lscrap grant grant_1 d88 d89,  het c(ar1)
 estimates store xtpcsere
 
**PREGUNTA 3
sort fcode year
reg d.lscrap d.(grant grant_1) d88 d89, noconstant
estimates store pd

**ANEXO
estimates table pooled fe re xtglsre xtpcsere pd,stats(aic bic r2) star(.05 .01 .001) style(oneline)

