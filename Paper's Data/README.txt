This directory contains the replication files for Kaboski and Townsend's "The Impact of Credit on Village Economies". 

The following (version 11) programs reproduce the results of the paper: 
Table1.do - This produces summary statistics, including some numbers cited in the text on the frequency of village fund loans in the sample (in the output file otherresultsintext.log), 
the summary statistics in Table 1 (in the output file Table1results.log), and the thresholds used to trim the 1 percent outliers in the program AnnualDataAnalysis_no_outliers.log 
(in the output file summarystats_for1percentthresholds.log)

Table2.do -- This runs the regression in Table 2 using the baseline IV regressions. It is identical to the first regression in AnnualDataAnalysis_baseline.do.  It calls the data file AnnualData_ShortSample.dta, and outputs
to the log file AnnualDataAnalysis_baseline.log


The following files are used to produce the results in Tables 3-8 and 11-12:

	AnnualDataAnalysis_OLS.do - This runs the regressions for Tables 3-8 and 11-12 for the OLS regressions (Row 1 in these tables).  It calls the data file AnnualData_ShortSample.dta, and 
				    outputs to the log file AnnualDataAnalysis_OLS.log. The coefficients on vfst (or vfstl) are presented in the tables.

	AnnualDataAnalysis_baseline.do - This runs the regressions for Tables 3-8 and 11-12 for the baseline IV regressions(Row 2 in these tables).  It calls the data file AnnualData_ShortSample.dta,
                                         and outputs to the log file AnnualDataAnalysis_baseline.log. The coefficients on vfst (or vfstl) are presented in the tables.

	AnnualDataAnalysis_all_villages.do - This runs the regressions for Tables 3-8 and 11-12 for the IV Regression Using All Villages (Row 3 in these Tables).  It calls the data file 
	                                     AnnualData_ShortSample.dta, and outputs to the log file AnnualDataAnalysis_all_villages.log

	AnnualDataAnalysis_no_outliers.do - This runs the regressions for Tables 3-8 and 11-12 for the IV regressions that drop the 1 percent outlying tails (Row 4 in these tables).  It calls the
                                            data file AnnualData_ShortSample.dta, and outputs to the log file AnnualDataAnalysis_no_outliers.log. The coefficients on vfst (or vfstl) are presented in the tables.  The cutoffs are from the 
                                            file summarystats_for1percentthresholds.log, produced by Table1.do


Tables9and10.do - This program yields the results in Tables 9 and 10, which are the log wage regressions estimates using the monthly panel data.  It uses the data in MonthlyDataforTables9and10.dta, and it outputs
to Tables9and10results.log. The entries in Tables 9 and 10 are the coefficients on lag12_loan_9 in the regressions below.

Tables13and14.do - This produces the results in Tables 13 and 14.  It calls the data file AnnualData_LongSample.dta, and outputs
to the log file Tables13and14results.log. The coefficients on vfst (or vfstl) are presented in Table 14.

Section_II.D_results.do - This runs the regressions with year-specific dummy variables that are described in Section II.D of the paper.  
It uses the data in AnnualData_ShortSample.dta and outputs to the file Section_IIDresults.log. The actual coefficients on these dummies and F-tests are given in the on-line appendix.

Section_II.F_results.do - This runs the regressions for Tables 3-8 and 11-12 for the baseline IV regressions, but adding it the GIS coefficient.  It calls the data file AnnualData_ShortSample.dta, and outputs
to the log file Section_IIF_results.log. The coefficients on vfst (or vfstl) are summarized the discussion in the text of Section II.F, and the coefficients themselves are given in the unpublished
appendix Tables A2.1-A2-5.

Section_III.E_GISresults.do - This produces the GIS results referenced in the text of Section III.E by redoing the estimations in Table 14 using the GIS variable as a control.  It uses the data file 
AnnualData_LongSample.dta as an input, and outputs the results to the file Section_IIIE_GISresults.log. The year-specific village size and GIS coefficients are are given 
in Table A.4 of the unpublished appendix.


Date files: 

MonthlyDataforTables9and10.dta - This is called by Tables9and10.do
AnnualdData_ShortSample.dta - This is called by Table1.do, Table2.do, AnnualDataAnalysis*.do, Section_II.D_results.do, and Section_II.F_results.do
AnnualdData_LongSample.dta - This is called by Tables13and14.do and Section_III.E_GISresults.do