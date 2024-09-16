*This produces the GIS results referenced in the text of Section III.E by redoing the estimations in Table 14 using the GIS variable as a control.  It uses the data file 
*AnnualData_LongSample.dta as an input, and outputs the results to the file Section_IIIE_GISresults.log. The year-specific village size and GIS coefficients are are given 
*in Table A.4 of the unpublished appendix.

clear all
set more off
set mem 200m
set matsize 200
capture log close


use AnnualData_LongSample, clear


****create important variables

*create farmer variable
g farm= (och>-5 & och<=15)

* create age squared
g age2h=ageh^2

* create lands squared
g gassd2=gassd^2

* create log assets
g lgassd=log(gassd)


*create log of number of households in village
g invHH=1/vHH
sort case_id year
by case_id: replace invHH=invHH[_n+1] if year==1

keep case_id year educ invHH changwat amphoe tambon village  farm netinc  tc  ageh madult fadult kids maleh netinc newst vfst  age2h educh lgassd defcr dfvfst vfst
g double villageyear=int(case_id/1000)
sort case_id year
by case_id: g invHHim=invHH if year==6
by case_id: egen invHHi=mean(invHHim)
g vHHi=1/invHHi
drop if vHHi>250 | vHHi<50  

*scale by multiply things by a million to put in per baht terms, and then divide by 10,000 to put in treatment effect terms
g invHHtvfm1=invHHi*(year==6)*100  
g invHHtvfm2=invHHi*(year==7)*100
g invHHtvfm3=invHHi*(year==8)*100
g invHHtvfm4=invHHi*(year==9)*100
g invHHtvfm5=invHHi*(year==10)*100
g invHHtvfm6=invHHi*(year==11)*100





g double caseid=case_id
drop case_id

g defcrp=defcr>0
g vfst1=vfst*(year==6)
g vfst2=vfst*(year==7)
g vfst3=vfst*(year==8)
g vfst4=vfst*(year==9)
g vfst5=vfst*(year==10)
g vfst6=vfst*(year==11)



g GISb=GIS*(year<6)
g GISp6=GIS*(year==6)
g GISp7=GIS*(year==7)
g GISp8=GIS*(year==8)
g GISp9=GIS*(year==9)
g GISp10=GIS*(year==10)
g GISp11=GIS*(year==11)



log using Section_IIIE_GISresults.log, replace



* Table 14 with GIS (Table A.4 in unpublished Appendix)

xi: xtivreg2 vfst   i.year GISp6 GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h  educh invHHtvfm1 invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6, fe i(caseid) first robust cluster(villageyear)  
test GISp6 GISp7 GISp8 GISp9 GISp10 GISp11
xi: xtivreg2 newst   i.year GISp6 GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h  educh invHHtvfm1 invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6, fe i(caseid) first robust cluster(villageyear)  
test GISp6 GISp7 GISp8 GISp9 GISp10 GISp11
xi: xtivreg2 defcrp    i.year GISp6 GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h  educh invHHtvfm1 invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6 , fe i(caseid) robust cluster(villageyear)  
test GISp6 GISp7 GISp8 GISp9 GISp10 GISp11
xi: xtivreg2 tc    i.year GISp6 GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h  educh invHHtvfm1 invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6 , fe i(caseid) robust cluster(villageyear)  
test GISp6 GISp7 GISp8 GISp9 GISp10 GISp11
xi: xtivreg2 lgassd   i.year GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6, fe i(caseid) robust cluster(villageyear)  
test GISp7 GISp8 GISp9 GISp10 GISp11
xi: xtivreg2 netinc   i.year GISp7 GISp8 GISp9 GISp10 GISp11 madult  fadult  kids  maleh farm  ageh  age2h  educh   invHHtvfm2  invHHtvfm3 invHHtvfm4 invHHtvfm5 invHHtvfm6, fe i(caseid) robust cluster(villageyear)  
test GISp7 GISp8 GISp9 GISp10 GISp11

log close

