*This runs the regression in Table 2 using the baseline IV regressions.  It calls the data file AnnualData_ShortSample.dta, and outputs
*to the log file AnnualDataAnalysis_baseline.log


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


log using Table2results.log, replace


* Table 2
xi: xtivreg2 newst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh invHHi  (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh ) , fe i(caseid) first robust cluster(villageyear)  


log close