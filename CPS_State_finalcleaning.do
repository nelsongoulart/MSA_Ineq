cd "$MSAINEQ/Data/"

*initial cleaning for MSA-level analysis, CPS
replace hhincome=hhincome_cutoff1 if hhincome>3000000 & year<1980
*Individual states are only identified post-1977 in the Public use CPS
drop if year<1977 
*drop if metarea>9996
sort serial year
egen hhsize = max(pernum), by(serial year)
keep year serial hhsize hwtsupp hhincome hhincome_cutoff1 hhincome_cutoff2 statefip topcoded
collapse (mean) hwtsupp=hwtsupp hhsize=hhsize hhincome_cutoff1=hhincome_cutoff1 hhincome_cutoff2=hhincome_cutoff1 hhincome=hhincome (max) statefip=statefip topcoded=topcoded, by(serial year)
gen sqrt_equivinc = hhincome_cutoff2/sqrt(hhsize)
gen cellmean_equivinc = hhincome/sqrt(hhsize)
gen topcoded_equivinc = topcoded * sqrt_equivinc
gen bottom_equivinc = (1-topcoded) * sqrt_equivinc
save CPS_topcode_State.dta, replace

