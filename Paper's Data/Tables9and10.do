*This program yields the results in Tables 9 and 10, which are the log wage regressions estimates using the monthly panel data.  It uses the data in MonthlyDataforTables9and10.dta, and it outputs
*to Tables9and10results.log. The entries in Tables 9 and 10 are the coefficients on lag12_loan_9 in the regressions below.



clear all

set more off

set mem 130000


use monthlydataforTables9and10, clear


sort caseid month
replace loan_9=loan_9/10000
replace lag12_loan_9=lag12_loan_9/10000
save temp, replace

log using Tables9and10results.logreplace

********FIRST CORROBORATE INCOME GROWTH***********************
**************************************************************
use temp, clear
xi: xtreg dnetinc i.month gassd gassdsq loan_9 if lwage~=., fe i(caseid) robust  
xi: xtivreg2 dnetinc i.month gassd gassdsq (loan_9 = gassd gassdsq chi*) if lwage~=., fe i(caseid) robust  
*1 percent
xi: xtivreg2 dnetinc i.month gassd gassdsq (loan_9= gassd gassdsq chi*) if (dnetinc<4.529738  & dnetinc>-4.427192  ) & lwage~=., fe i(caseid) robust  


**************************************************************
**************************************************************
********Table 7 Estimates*************************************

use temp, clear
*TOTAL WAGES OVERALL
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>.9665835   & lwage<5.325377 ), fe i(caseid) robust  
log close


use temp, clear
keep if ((occup>=7&occup<=21)|occup==61)

log using Tables9and10results.logappend
*agricultural worker (7 – 21, 61)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>1.097612 & lwage<5.542189 ), fe i(caseid) robust  

log close

use temp, clear
keep if (occup==35)

log using Tables9and10results.logappend
*factory worker (35)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>2.171946 & lwage<4.562945 ), fe i(caseid) robust  

log close

use temp, clear
keep if (occup==31|occup==33|occup==57)

log using Tables9and10results.logappend
*merchant (31, 33, 57)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>1.693473 & lwage<4.435549), fe i(caseid) robust  

log close

use temp, clear
keep if (occup>=37&occup<=53)


log using Tables9and10results.logappend
*professional (37-53)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>.7662981 & lwage<5.264677), fe i(caseid) robust  

log close

use temp, clear
keep if (occup==63)

log using Tables9and10results.logappend
*non-agricultural general worker (63)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust   
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>1.458013 & lwage<5.03851), fe i(caseid) robust  

log close

use temp, clear
keep if (occup==23)

log using Tables9and10results.logappend
*Construction work in village  (23)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>1.65074 & lwage<4.707952), fe i(caseid) robust  

log close

use temp, clear
keep if (occup==27 | occup==29)


log using Tables9and10results.logappend
*Construction work not in village (25 - 29)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>1.81007 & lwage<4.255234), fe i(caseid) robust  

log close


use temp, clear
keep if (occup==65)

log using Tables9and10results.logappend
*other (65)
xi: xtreg lwage i.month gassd gassdsq lag12_loan_9, fe i(caseid) robust  
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*), fe i(caseid) robust  
*1 percent
xi: xtivreg2 lwage i.month gassd gassdsq (lag12_loan_9 = gassd gassdsq chi*) if (lwage>.6962672 & lwage<5.517448), fe i(caseid) robust  

log close