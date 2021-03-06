clear all
cd "$MSAINEQ/Data"
do "$MSAINEQ/Code/read_ACS.do"
recode inctot (9999999=.)
recode ftotinc (9999999=.)
recode incwage (999999=.)
recode incbus (999999=.)
recode incbus00 (999999=.)
recode incfarm (999999=.)
recode incinvst (999999=.)
recode incretir (999999=.)
recode incss (99999 =.)
recode incwelfr (99999 =.)
recode incsupp (99999 =.)
recode incother (99999 =.)

replace incbus = 0 if incbus<0
replace incbus00 = 0 if incbus00<0
replace incfarm=0 if incfarm<0
replace incinvst = 0 if incinvst<0
replace incother = 0 if incother<0
replace incearn = 0 if incearn<0

egen inctot_corr = rowtotal(incwage incbus incbus00 incfarm incinvst  incretir  incss  incwelfr incsupp incother)

sort serial year
egen hhincome_corr = total(inctot_corr), by(serial year)
egen hhsize = max(pernum), by(serial year)

save ACS_raw_microdata.dta, replace


*initial cleaning for MSA-level analysis, ACS
use ACS_raw_microdata.dta, clear
drop datanum
drop if year<2005
do "$MSAINEQ/Code/ACS_Census_topcode_flags.do"
keep MSA_FIPS serial year hhsize hhincome_corr hhincome_topcode topcoded hhwt
collapse (mean) hhwt=hhwt hhsize=hhsize hhincome_corr=hhincome_corr hhincome_topcode=hhincome_topcode (max) topcoded=topcoded, by(serial year)
gen cellmean_equivinc = hhincome_corr/sqrt(hhsize)
gen sqrt_equivinc = hhincome_topcode/sqrt(hhsize)
gen topcoded_equivinc = topcoded * sqrt_equivinc
gen bottom_equivinc = (1-topcoded) * sqrt_equivinc
save ACS_MSA_micro.dta, replace
use ACS_raw_microdata.dta, clear

*Initial Cleaning for MSA-level analysis, Census (We split the 1970-1980 census data from the later data to make analysis a little easier computationally.)
drop datanum
drop if year>=2005 & year<2010
drop if year==2011
do "$MSAINEQ/Code/ACS_Census_topcode_flags.do"
keep MSA_FIPS serial year hhsize hhincome_corr hhincome_topcode topcoded hhwt
collapse (mean) hhwt=hhwt hhsize=hhsize hhincome_corr=hhincome_corr hhincome_topcode=hhincome_topcode (max) topcoded=topcoded, by(serial year)
gen cellmean_equivinc = hhincome_corr/sqrt(hhsize)
gen sqrt_equivinc = hhincome_topcode/sqrt(hhsize)
gen topcoded_equivinc = topcoded * sqrt_equivinc
gen bottom_equivinc = (1-topcoded) * sqrt_equivinc
save Census_MSA_micro.dta, replace

