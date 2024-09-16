*This runs the regressions for Tables 3-8 and 11-12 for the baseline IV regressions, but adding it the GIS coefficient.  It calls the data file AnnualData_ShortSample.dta, and outputs
*to the log file Section_IIF_results.log. The coefficients on vfst (or vfstl) are summarized the discussion in the text of Section II.F, and the coefficients themselves are given in the unpublished
*appendix Tables A2.1-A2-5.


clear all
set more off
set mem 200m
set matsize 200
capture log close

use AnnualData_ShortSample.dta, clear
sort case_id


****create important variables

*create total investment variable
egen tinv=rsum(hinv finv pinv binv bafdn sinv safdn lvcn lvnn lvdep)
*create total wages paid
g twage=frmwage+shrwage+buswage
drop frmwage shrwage buswage
*create farmer variable
g farm= (och>-5 & och<=15)
*create total business investment variable 
egen tbinv=rsum(pinv binv bafdn sinv safdn)



* create age squared
g age2h=ageh^2

* create lands squared
g gassd2=gassd^2

* create log assets
g lgassd=log(gassd)


* create dlog assets 
by case_id: g dlgassd1=log(gassd[_n+1]/gassd[_n])


*create dnetinc (new spec; 041606)
by case_id: g dnetinc=log(netinc[_n+1]/netinc[_n])

*create log of number of households in village
g invHH=1/vHH
by case_id: replace invHH=invHH[_n+1] if year==1

*create log of number of households in village
by case_id: g invHHl=1/vHH[_n-1]
by case_id: g vfstl=vfst[_n-1]

g bsnew=bnew+snew

keep case_id year frmpro buspro wageinc riceinc cropinc liveinc educ invHHl vfstl invHH changwat amphoe tambon village dnetinc dlgassd farm netinc bsnew tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway ageh madult fadult kids maleh finv tbinv hinv frtexp netinc lac newst vfst infst baacst cbst const edust agst hhast busst frtst age2h educh  gassd gassd2 lgassd rst defcr twage GIS

g double villageyear=int(case_id/1000)

replace vfst=vfst/10000
replace vfstl=vfstl/10000
replace GIS=GIS*100

sort case_id year
by case_id: g invHHim=invHH if year==6
by case_id: egen invHHi=mean(invHHim)
g vHHi=1/invHHi
drop if vHHi>250 | vHHi<50
*use for levels, get money for sixth year
g invHHpvf=invHHi*(year>5) 
g invHHtvf1=invHHi*(year==6)  
g invHHtvf2=invHHi*(year==7) 


g vfstf=vfst*(maleh==0)  
g invHHtvf1f=invHHtvf1*(maleh==0)
g invHHtvf2f=invHHtvf2*(maleh==0)

g vfstlf=vfstl*(maleh==0)



g double caseid=case_id
drop case_id

g tbinvp=tbinv>0
g finvp=finv>0
g defcrp=defcr>0
keep if year<8




g GISb=GIS*(year<6)
g GISp6=GIS*(year==6)
g GISp7=GIS*(year==7)


log using Section_IIF_results.log.log, replace


xi: xtivreg2 newst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ) , fe i(caseid) first robust cluster(villageyear)  
xi: xtivreg2 tc    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 dlgassd   i.year GISb  madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst   = invHHtvf1   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 dnetinc   i.year GISb  madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst   = invHHtvf1   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  

xi: xtivreg2 newst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 baacst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 cbst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 agst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 busst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 frtst   i.year GISb lac madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year lac madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 const   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 rst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 defcrp   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 infst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 rst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfstl   = invHHtvf2      i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 defcrp   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl   = invHHtvf2   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 infst   i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl   = invHHtvf2  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  

xi: xtivreg2 educ    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)   
xi: xtivreg2 grain    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 milk    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 meat    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 alch1    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 alch2    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 fuel    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 tobac    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 cerem    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 houserep    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 vehicrep    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 clothes    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 mealaway    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  

xi: xtivreg2 buspro    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 wageinc  i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 riceinc    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 cropinc    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 liveinc    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 bsnew    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 tbinv    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh       (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 tbinvp    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh       (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 finv    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 finvp    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 twage    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 frtexp   i.year GISb lac  madult  fadult  kids  maleh farm  ageh  age2h  educh    (vfst  = invHHtvf1 invHHtvf2    lac  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  


xi: xtivreg2 buspro    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl vfstlf  = invHHtvf2 invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 wageinc  i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfstl vfstlf  = invHHtvf2 invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 educ    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 meat    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 alch1    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 alch2    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 houserep    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 vehicrep    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
xi: xtivreg2 clothes    i.year GISb madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  






log close

