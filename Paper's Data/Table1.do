*This produces summary statistics, including some numbers cited in the text on the frequency of village fund loans in the sample (in the output file otherresultsintext.log), 
*the summary statistics in Table 1 (in the output file Table1results.log), and the thresholds used to trim the 1 percent outliers in the program AnnualDataAnalysis_no_outliers.log 
*(in the output file summarystats_for1percentthresholds.log)


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
*create business and ag investment variable 
egen fbinv=rsum(finv pinv binv bafdn sinv safdn)


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

keep case_id year frmpro buspro wageinc riceinc cropinc liveinc educ invHHl vfstl invHH changwat amphoe tambon village dnetinc dlgassd farm netinc bsnew tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway ageh madult fadult kids maleh tinv fbinv  finv tbinv hinv frtexp netinc lac newst vfst infst baacst cbst const edust agst hhast busst frtst age2h educh  gassd gassd2 lgassd rst defcr twage

g double villageyear=int(case_id/1000)

sort case_id year
by case_id: g invHHim=invHH if year==6
by case_id: egen invHHi=mean(invHHim)
g vHHi=1/invHHi
*drop if vHHi>250 | vHHi<50
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
drop if vHHi>250 | vHHi<50
log using summarystats_for1percentthresholds.log, replace
summ newst if newst~=0, detail
summ tc if tc~=0, detail
summ dlgassd if dlgassd~=0, detail
summ dnetinc if dnetinc~=0, detail
summ baacst if baacst~=0, detail
summ cbst if cbst~=0, detail
summ agst if agst~=0, detail
summ busst if busst~=0, detail
summ frtst if frtst~=0, detail
summ const if const~=0, detail
summ rst if rst~=0, detail
summ infst if infst~=0, detail
summ educ if educ~=0, detail
summ grain if grain~=0, detail 
summ milk if milk~=0, detail
summ meat if meat~=0, detail
summ alch1 if alch1~=0, detail
summ alch2 if alch2~=0, detail
summ fuel if fuel~=0, detail
summ tobac if tobac~=0, detail
summ cerem if cerem~=0, detail
summ houserep if houserep~=0, detail
summ vehicrep if vehicrep~=0, detail
summ clothes if clothes~=0, detail
summ mealaway if mealaway~=0, detail
summ buspro if buspro~=0, detail
summ wageinc if wageinc~=0, detail
summ riceinc if riceinc~=0, detail
summ cropinc if cropinc~=0, detail
summ liveinc if liveinc~=0, detail 
summ twage if twage~=0, detail
summ bsnew if bsnew~=0, detail
summ tbinv if tbinv~=0, detail
summ finv if finv~=0, detail 
summ frtexp if frtexp~=0, detail 
log close

use temp, clear
g vfstp=vfst>0
log using otherresultsintext.log, replace
summ vfstp if year==6, detail
summ vfst if vfst>0 & year==6, detail
summ vfstp if year==7, detail
summ vfst if vfst>0 & year==7, detail
summ vfstp if year==6|year==7, detail
summ vfst if (year==6|year==7), detail
summ vfst if vfst>0 & (year==6|year==7), detail
g vfstpn=vfstp if year==6|year==7
g vfstn=vfst if year==6|year==7

log close


log using Table1results.log, replace
summ newst vfstn vfstpn baacst cbst infst agst busst frtst const rst defcrp tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway netinc buspro wageinc riceinc cropinc liveinc gassd bsnew tbinv finv frtexp twage   madult  fadult  kids  maleh farm  ageh  age2h  educh invHHi
collapse (mean) newst vfstn vfstpn baacst cbst infst agst busst frtst const rst defcrp tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway netinc buspro wageinc riceinc cropinc liveinc gassd bsnew tbinv finv frtexp twage  madult  fadult  kids  maleh farm  ageh  age2h  educh invHHi, by (caseid)
**household-specific averages**
summ newst vfstn vfstpn baacst cbst infst agst busst frtst const rst defcrp tc educ grain milk meat alch1 alch2 fuel tobac cerem houserep vehicrep clothes mealaway netinc buspro wageinc riceinc cropinc liveinc gassd bsnew tbinv finv frtexp twage   maleh ageh educh madult  fadult  kids farm   invHHi
log close




