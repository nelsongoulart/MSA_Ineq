set more off
use "/media/john/Shared Linux_Windows Files/MSA Level Inequality/Data/State_covariates.dta", clear
xtset State year
egen mean_pop=mean(Population), by(State)
replace Real_PersIncPC=Real_PersIncPC/1000000
replace UR = UR/100
replace Population = Population/1000000


gen log_gini = log(CPS_gini)
gen log_top1 = log(CPS_top1)
gen log_theil = log(CPS_theil)
gen log_9010 = log(CPS_9010)
gen log_UR = log(UR)
gen log_unionmem = log(union_mem+0.01)
gen log_DPI = log(Real_PersIncPC)
gen log_college = log(college_prop)
gen log_netrate = log(100-State_rate_wages)
gen log_pop = log(Population)

gen log_w_top1 = log(weighted_top1)
gen log_tot_netrate = log(100-Total_rate_wages)
gen log_fed_netrate = log(100-Fed_rate_wages)
gen log_cap_netrate = log(100-Total_rate_capgains)
gen log_capgains_netrate = log(100-State_rate_capgains)
cd "/media/john/Shared Linux_Windows Files/MSA Level Inequality/Results/Tables"
local ineq gini top1 theil 9010
foreach i of local ineq{
	*unweighted
	qui reg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population, vce(robust)
	eststo unCPS_`i'_nofe
	qui estadd local fixed "no" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "None", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population, fe vce(robust)
	eststo unCPS_`i'_fe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "None", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages  Population i.year, fe vce(robust)
	eststo unCPS_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "None", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year i.State#c.year, fe vce(robust)
	eststo unCPS_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
		qui estadd local regweights "None", replace

	*esttab unCPS_`i'_nofe unCPS_`i'_fe unCPS_`i'_yearfe unCPS_`i'_trend using unCPS_state_`i'.tex, style(tex) replace b se keep(union_mem UR Real_PersIncPC college_prop State_rate_wages Population) stats(fixed yearfe trend N, label("FE" "year FE" "trend")) nomtitles note("no regression weights") starlevels(* 0.1 ** 0.05 *** 0.01)
*display "`i', unweighted"
*esttab unCPS_`i'_nofe unCPS_`i'_fe unCPS_`i'_yearfe unCPS_`i'_trend , b se keep(union_mem UR Real_PersIncPC college_prop State_rate_wages Population) stats(fixed yearfe trend N, label("FE" "year FE" "trend")) nomtitles note("no regression weights")
	*weighted by 1/mean(pop)
	qui reg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population [weight=mean_pop], vce(robust)
	eststo CPS_`i'_nofe
	qui estadd local fixed "no" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "Population", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population [weight=mean_pop], fe vce(robust)
	eststo CPS_`i'_fe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "Population", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year [weight=mean_pop], fe vce(robust)
	eststo CPS_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "no" , replace
		qui estadd local regweights "Population", replace
	qui xtreg CPS_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year i.State#c.year [weight=mean_pop], fe vce(robust)
	eststo CPS_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
		qui estadd local regweights "Population", replace

	*esttab unCPS_`i'_fe unCPS_`i'_yearfe unCPS_`i'_trend CPS_`i'_fe CPS_`i'_yearfe CPS_`i'_trend using CPS_state_`i'.tex, style(tex) replace b se keep(union_mem UR Real_PersIncPC college_prop State_rate_wages Population) stats(fixed yearfe trend regweights N, label("FE" "year FE" "trend" "Reg. Weights")) nomtitles 
	display "`i'"
	esttab unCPS_`i'_fe unCPS_`i'_yearfe unCPS_`i'_trend CPS_`i'_fe CPS_`i'_yearfe CPS_`i'_trend, b se keep(union_mem UR Real_PersIncPC college_prop State_rate_wages Population) stats(fixed yearfe trend regweights N, label("FE" "year FE" "trend" "Reg. Weights")) nomtitles 	
}


local log_ineq log_gini log_theil log_9010 log_top1
local indepvars log_UR log_college log_DPI log_unionmem log_pop log_cap_netrate

foreach i of local log_ineq{
	display "`i'"
	qui xtreg `i' `indepvars', fe vce(robust)
	eststo log_`i'_fe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
	qui estadd local regweights "None", replace
	qui xtreg `i' `indepvars' i.year,  fe vce(robust)
	eststo log_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "no" , replace
	qui estadd local regweights "None", replace
	qui xtreg `i' `indepvars' i.year i.State#c.year, fe vce(robust)
	eststo log_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
	qui estadd local regweights "None", replace
	*With pop weights
	qui xtreg `i' `indepvars' [weight=mean_pop], fe vce(robust)
	eststo log_w_`i'_fe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "no" , replace
	qui estadd local trend "no" , replace
	qui estadd local regweights "Mean Pop.", replace
	qui xtreg `i' `indepvars' i.year [weight=mean_pop],  fe vce(robust)
	eststo log_w_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "no" , replace
	qui estadd local regweights "Mean Pop.", replace
	qui xtreg `i' `indepvars' i.year i.State#c.year [weight=mean_pop], fe vce(robust)
	eststo log_w_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
	qui estadd local regweights "Mean Pop.", replace
	esttab log_`i'_fe log_`i'_yearfe log_`i'_trend log_w_`i'_fe log_w_`i'_yearfe log_w_`i'_trend, b se keep(log_UR log_college log_DPI log_unionmem log_pop log_cap_netrate) stats(fixed yearfe trend  regweights N, label("MSA FE" "year FE" "trend" "Reg. Weights")) nomtitles title("Log-log Specification, `i'")
}


local ineq gini top1 theil 9010
foreach i of local ineq{
	*unweighted
	display "`i'"
	qui xtreg weighted_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year, fe vce(robust)
	qui eststo average_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "no" , replace

	qui xtreg weighted_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year i.State#c.year, fe vce(robust)
	qui eststo average_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
	*weighted by 1/mean(pop)

	qui xtreg weighted_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year [weight=mean_pop], fe vce(robust)
	qui eststo average_w_`i'_yearfe
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
        qui estadd local trend "no" , replace

	qui xtreg weighted_`i' union_mem UR Real_PersIncPC college_prop State_rate_wages Population i.year i.State#c.year [weight=mean_pop], fe vce(robust)
	qui eststo average_w_`i'_trend
	qui estadd local fixed "yes" , replace
	qui estadd local yearfe "yes" , replace
	qui estadd local trend "yes" , replace
	esttab average_`i'_yearfe average_`i'_trend  average_w_`i'_yearfe  average_w_`i'_trend, b se keep(union_mem UR Real_PersIncPC college_prop State_rate_wages Population) stats(fixed yearfe trend N, label("FE" "year FE" "trend")) nomtitles note("Weighted by the inverse of population (analytic weights)")
}

