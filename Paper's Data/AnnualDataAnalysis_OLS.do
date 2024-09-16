*This runs the regressions for Tables 3-8 and 11-12 for the OLS regressions (Row 1 in these tables).  It calls the data file AnnualData_ShortSample.dta, and outputs
*to the log file AnnualDataAnalysis_OLS.log. The coefficients on vfst (or vfstl) are presented in the tables.


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

keep case_id year frmpro buspro wageinc riceinc cropinc liveinc educ invHHl vfstl invHH changwat amphoe tambon village dnetinc dlgassd farm netinc bsnew tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway ageh madult fadult kids maleh finv tbinv hinv frtexp netinc lac newst vfst infst baacst cbst const edust agst hhast busst frtst age2h educh  gassd gassd2 lgassd rst defcr twage

g double villageyear=int(case_id/1000)

replace vfst=vfst/10000
replace vfstl=vfstl/10000


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


log using AnnualDataAnalysis_OLS.log, replace


* Table 3, Row 1
xi: xtreg newst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg tc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg dlgassd   i.year  madult  fadult  kids  maleh farm  ageh  age2h  educh   vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg dnetinc   i.year  madult  fadult  kids  maleh farm  ageh  age2h  educh   vfst, fe i(caseid) robust cluster(villageyear)  


*Table 4, Row 1
xi: xtreg newst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg baacst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg cbst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg agst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg busst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg frtst   i.year lac madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg const   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  

*Table 5, Row 1
xi: xtreg rst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg defcrp   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg infst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst , fe i(caseid) robust cluster(villageyear)  
xi: xtreg rst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfstl , fe i(caseid) robust cluster(villageyear)  
xi: xtreg defcrp   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl , fe i(caseid) robust cluster(villageyear)  
xi: xtreg infst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl , fe i(caseid) robust cluster(villageyear)  

*Table 6, Row 1
xi: xtreg educ    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)   
xi: xtreg grain    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg milk    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg meat    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg alch1    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg alch2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  

xi: xtreg fuel    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg tobac    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg cerem    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg houserep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg vehicrep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg clothes    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg mealaway    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  


*Table 7, Row 1
xi: xtreg buspro    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl, fe i(caseid) robust cluster(villageyear)  
xi: xtreg wageinc  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl, fe i(caseid) robust cluster(villageyear)  
xi: xtreg riceinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl, fe i(caseid) robust cluster(villageyear)  
xi: xtreg cropinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl, fe i(caseid) robust cluster(villageyear)  
xi: xtreg liveinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl, fe i(caseid) robust cluster(villageyear)  

*Table 8, Row 1
xi: xtreg bsnew    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg tbinv    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh       vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg tbinvp    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh       vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg finv    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg finvp    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg twage    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst, fe i(caseid) robust cluster(villageyear)  
xi: xtreg frtexp   i.year lac  madult  fadult  kids  maleh farm  ageh  age2h  educh    vfst, fe i(caseid) robust cluster(villageyear)  


*Table 11, Row 1
xi: xtreg buspro    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfstl vfstlf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg wageinc  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfstl vfstlf, fe i(caseid) robust cluster(villageyear)  

*Table 12, Row 1
xi: xtreg educ    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst vfstf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg meat    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst vfstf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg alch1    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst vfstf , fe i(caseid) robust cluster(villageyear)  
xi: xtreg alch2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst vfstf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg houserep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst vfstf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg vehicrep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      vfst vfstf, fe i(caseid) robust cluster(villageyear)  
xi: xtreg clothes    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     vfst vfstf, fe i(caseid) robust cluster(villageyear)  


log close