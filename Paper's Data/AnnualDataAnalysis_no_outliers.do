*This runs the regressions for Tables 3-8 and 11-12 for the IV regressions that drop the 1 percent outlying tails (Row 4 in these tables).  It calls the data file AnnualData_ShortSample.dta, and outputs
*to the log file AnnualDataAnalysis_no_outliers.log. The coefficients on vfst (or vfstl) are presented in the tables.  The cutoffs are from the file summarystats_for1percentthresholds.log, produced by Table1.do


clear all
set more off
set mem 200m
set matsize 200
capture log close

use AnnualData_ShortSample, clear
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

save temp, replace 

log using AnnualDataAnalysis_no_outliers.log, replace




* Table 3, Row 4
drop if newst>315000
xi: xtivreg2 newst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ) , fe i(caseid) first robust cluster(villageyear)  
use temp, clear
drop if tc <4430 | tc>433000
xi: xtivreg2 tc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if dlgassd <-2.565758 | dlgassd>2.494314
xi: xtivreg2 dlgassd   i.year  madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst   = invHHtvf1   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if dnetinc <-2.605709 | dnetinc>2.848096
xi: xtivreg2 dnetinc   i.year  madult  fadult  kids  maleh farm  ageh  age2h  educh   (vfst   = invHHtvf1   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh  ), fe i(caseid) robust cluster(villageyear)  


*Table 4, Row 4
use temp, clear
drop if newst>315000
xi: xtivreg2 newst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if baacst>240000
xi: xtivreg2 baacst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if cbst>300000
xi: xtivreg2 cbst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if agst>170000
xi: xtivreg2 agst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if busst>750000
xi: xtivreg2 busst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if frtst>300000
xi: xtivreg2 frtst   i.year lac madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year lac madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if const>170000
xi: xtivreg2 const   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ) , fe i(caseid) robust cluster(villageyear)  

* Table 5, Row 4
use temp, clear
drop if rst<-.062482 | rst>.6458962
xi: xtivreg2 rst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if infst>370000
xi: xtivreg2 infst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if rst<-.062482 | rst>.6458962
xi: xtivreg2 rst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfstl   = invHHtvf2      i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if infst>370000
xi: xtivreg2 infst   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl   = invHHtvf2  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ) , fe i(caseid) robust cluster(villageyear)  

*Table 6, Row 4
use temp, clear
drop if educ>55000
xi: xtivreg2 educ    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)   
use temp, clear
drop if grain<1200 | grain>33600
xi: xtivreg2 grain    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if milk>24000
xi: xtivreg2 milk    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if meat>21600
xi: xtivreg2 meat    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if alch1>31200
xi: xtivreg2 alch1    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if alch2>25200
xi: xtivreg2 alch2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  

use temp, clear
drop if fuel>57600
xi: xtivreg2 fuel    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if tobac>16200
xi: xtivreg2 tobac    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if cerem>49992
xi: xtivreg2 cerem    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if houserep>300000
xi: xtivreg2 houserep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if vehicrep>40000
xi: xtivreg2 vehicrep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if clothes>10000
xi: xtivreg2 clothes    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if mealaway>23580
xi: xtivreg2 mealaway    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  


*Table 7, Row 4
use temp, clear
drop if buspro<-74800 | buspro>1298000
xi: xtivreg2 buspro    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if wageinc>328030
xi: xtivreg2 wageinc  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if riceinc>225600
xi: xtivreg2 riceinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if cropinc>500000
xi: xtivreg2 cropinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if liveinc>640000
xi: xtivreg2 liveinc    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl  = invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  

*Table 8, Row 4
use temp, clear
drop if bsnew>3
xi: xtivreg2 bsnew    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if tbinv>660000
xi: xtivreg2 tbinv    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh       (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if finv>400000
xi: xtivreg2 finv    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if twage>158500
xi: xtivreg2 twage    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst  = invHHtvf1 invHHtvf2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if frtexp>95000
xi: xtivreg2 frtexp   i.year lac  madult  fadult  kids  maleh farm  ageh  age2h  educh    (vfst  = invHHtvf1 invHHtvf2    lac  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  


*Table 11, Row 4
use temp, clear
drop if buspro<-74800 | buspro>1298000
xi: xtivreg2 buspro    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfstl vfstlf  = invHHtvf2 invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if wageinc>328030
xi: xtivreg2 wageinc  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfstl vfstlf  = invHHtvf2 invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh    ), fe i(caseid) robust cluster(villageyear)  

*Table 12, Row 4
use temp, clear
drop if educ>55000
xi: xtivreg2 educ    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if meat>21600
xi: xtivreg2 meat    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if alch1>31200
xi: xtivreg2 alch1    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if alch2>25200
xi: xtivreg2 alch2    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if houserep>300000
xi: xtivreg2 houserep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if vehicrep>40000
xi: xtivreg2 vehicrep    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh      (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f   i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  
use temp, clear
drop if clothes>10000
xi: xtivreg2 clothes    i.year madult  fadult  kids  maleh farm  ageh  age2h  educh     (vfst vfstf = invHHtvf1 invHHtvf2 invHHtvf1f invHHtvf2f  i.year madult  fadult  kids  maleh farm  ageh  age2h  educh   ), fe i(caseid) robust cluster(villageyear)  


log close

