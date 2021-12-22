' PARTICIPACIONES 

'Mercado mayorista

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=PARSIN1!$D$4:$M$112 colhead=1 na="#N/A" @freq m 2011m1

' Mercado minorista

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=PARSIN2!$D$2:$AO$110 colhead=1 na="#N/A" @freq m 2011m1

'CRÉDITO PRINCIPAL

'mayorista y minorista

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=creditos_sf!$D$3:$Ay$100 colhead=1 na="#N/A" @freq m 2011m12


'CRÉDITO OTROS

'mayorista y minorista

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=creditos_sf!$D$104:$Ay$201 colhead=1 na="#N/A" @freq m 2011m12

'COSTOS TOTALES

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=costos_sf!$D$2:$Ay$99 colhead=1 na="#N/A" @freq m 2011m12

' Costo capital

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=Capital_2!$D$3:$D$100 colhead=1 na="#N/A" @freq m 2011m12

'Costo laboral

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=costo_laboral!$e$2:$az$99 colhead=1 na="#N/A" @freq m 2011m12

'Morosidad

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=Morosidad_control!$D$4:$ay$101 colhead=1 na="#N/A" @freq m 2011m12

'Costo de fondeo

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=Costo_fondeo!$D$3:$ay$100 colhead=1 na="#N/A" @freq m 2011m12

'Provisiones

import "C:\Users\Roberto Carlos\Desktop\SBS\Indicador_Bone\base_datos\Costos_Totales_Final.xlsx" range=Costo_provisiones!$D$3:$ay$100 colhead=1 na="#N/A" @freq m 2011m12



