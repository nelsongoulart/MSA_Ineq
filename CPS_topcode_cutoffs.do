*Replacing Cellmean values with cutoffs & reconstructing "topcoded" total income amounts, step 2: imposing topcode cutoffs, and reconstructing truncating incomes

*Creating Topcoded Flag

*Flagging all Topcoded observations (note: multiple income sources can be topcoded for a single observation)
*Total Income (post 1988)
replace inctot=99999 if inctot>=99999 & year<=1995 & inctot~=.
replace inctot=150000 if inctot>=150000 & year>=1996 & year<=2002 & inctot~=.
replace inctot=200000 if inctot>=200000 & year>=2003 & year<=2010 & inctot~=.
replace inctot=250000 if inctot>=250000 & year>=2011 & inctot~=.

*Wages
replace incwage=50000 if incwage>=50000 & year<=1981 & incwage~=.
replace incwage=75000 if incwage>=75000 & year>=1982 & year<=1984 & incwage~=.
replace incwage=99999 if incwage>=99999 & year>=1985 & year<=1995 & incwage~=.
replace incwage=25000 if incwage>=25000 & year>=1996 & year<=2002 & incwage~=.
replace incwage=35000 if incwage>=35000 & year>=2003 & year<=2010 & incwage~=.
replace incwage=47000 if incwage>=47000 & year==2011 & incwage~=.
replace incwage=50000 if incwage>=50000 & year==2012 & incwage~=.

*Business/Self Employment Income
replace incbus=50000 if incbus>=50000 & year<=1981 &incbus~=.
replace incbus=75000 if incbus>=75000 & year>=1982 & year<=1984 &incbus~=.
replace incbus=99999 if incbus>=99999 & year>=1985 & year<=1995 &incbus~=.
replace incbus=40000 if incbus>=40000 & year>=1996 & year<=2002 &incbus~=.
replace incbus=50000 if incbus>=50000 & year>=2003 & year<=2010 &incbus~=.
replace incbus=60000 if incbus>=60000 & year==2011 &incbus~=.
replace incbus=60000 if incbus>=60000 & year==2012 &incbus~=.

*Farm Income
replace incfarm=50000 if incfarm>=50000 & year<=1981 &incfarm~=.
replace incfarm=75000 if incfarm>=75000 & year>=1982 & year<=1984 &incfarm~=.
replace incfarm=99999 if incfarm>=99999 & year>=1985 & year<=1995 &incfarm~=.
replace incfarm=25000 if incfarm>=25000 & year>=1996 & year<=2002 &incfarm~=.
replace incfarm=25000 if incfarm>=25000 & year>=2003 & year<=2010 &incfarm~=.
replace incfarm=30000 if incfarm>=30000 & year==2011 &incfarm~=.
replace incfarm=40000 if incfarm>=40000 & year==2012 &incfarm~=.

*SS Income
replace incss=9999 if incss>=9999 & year<=1981 &incss~=.
replace incss=19999 if incss>=19999 & year>=1982 & year<=1987 &incss~=.
replace incss=29999 if incss>=29999 & year>=1988 & year<=1993 &incss~=.
replace incss=49999 if incss>=49999 & year>=1994 &incss~=.

*SSI income
replace incssi=5999 if incssi>=5999 & year<=1984 &incssi~=.
replace incssi=9999 if incssi>=9999 & year>=1985 & year<=1995 &incssi~=.
replace incssi=25000 if incssi>=25000 & year>=1996 &incssi~=.

*Interest Income (Interest income had topcodes hardcoded in IPUMS, so we just need to insert a flag)
replace incint=50000 if incint>=50000 & year<=1981 &incint~=.
replace incint=75000 if incint>=75000 & year>=1982 & year<=1984 &incint~=.
replace incint=99999 if incint>=99999 & year>=1985 & year<=1998 &incint~=.
replace incint=35000 if incint>=35000 & year>=1999 & year<=2002 &incint~=.
replace incint=25000 if incint>=25000 & year>=2003 & year<=2010 &incint~=.
replace incint=24000 if incint>=24000 & year==2011 &incint~=.
replace incint=22000 if incint>=22000 & year==2012 &incint~=.

*Public Assistance Income
replace incwelfr=19999 if incwelfr>=19999 & year<=1993 & incwelfr~=.
replace incwelfr=24999 if incwelfr>=24999 & year>=1994 & incwelfr~=.

*Dividend and Rental Income (Combined 1968-1987)
replace incidr=50000 if incidr>=50000 & year<=1981 & incidr~=.
replace incdrt=50000 if incdrt>=50000 & year<=1981 & incdrt~=.
replace incdrt=75000 if incdrt>=75000 & year>=1982 & year<=1984 & incdrt~=.
replace incdrt=99999 if incdrt>=99999 & year>=1985 & incdrt~=.
replace incdivid=99999 if incdivid>=99999 & year<=1998 & incdivid~=.
replace incdivid=15000 if incdivid>=15000 & year>=1999 & year<=2010 & incdivid~=.
replace incdivid=20000 if incdivid>=20000 & year>=2011 & incdivid~=.
replace incrent=99999 if incrent>=99999 & year<=1998 & incrent~=.
replace incrent=25000 if incrent>=25000 & year>=1999 & year<=2002 & incrent~=.
replace incrent=40000 if incrent>=40000 & year>=2003 & year<=2010 & incrent~=.
replace incrent=50000 if incrent>=50000 & year==2011 & incrent~=.
replace incrent=60000 if incrent>=60000 & year==2012 & incrent~=.

*Gov't Assistnance/Vet/Wk comp (combined pre 1988) - Post 1988, already hardcoded & corrected in CPS_read_in_clean.do
replace incgov=29999 if incgov>=29999 &incgov~=.
replace incwkcom=99999 if incwkcom>=99999 & incwkcom~=.
replace incvet=99999 if incvet>=99999 & incvet~=.

*Retirement Income
replace incretir=50000 if incretir>=50000 & year<=1981 &incretir~=.
replace incretir=75000 if incretir>=75000 & year>=1982 & year<=1984 &incretir~=.
replace incretir=99999 if incretir>=99999 & year>=1985 & year<=1998 &incretir~=.
replace incretir=45000 if incretir>=45000 & year>=1999 & year<=2010 &incretir~=.
replace incretir=64000 if incretir>=64000 & year==2011 &incretir~=.
replace incretir=67000 if incretir>=67000 & year==2012 &incretir~=.

*Other Income
replace incaloth=50000 if incaloth>=50000 & year<=1981 &incaloth~=.
replace incaloth=75000 if incaloth>=75000 & year>=1982 & year<=1984 &incaloth~=.
replace incaloth=99999 if incaloth>=99999 & year>=1985 & year<=1987 &incaloth~=.
replace incother=99999 if incother>=99999 & year>=1985 & year<=1998 &incother~=.
replace incother=25000 if incother>=25000 & year>=1999 & year<=2010 &incother~=.
replace incother=30000 if incother>=30000 & year==2011 &incother~=.
replace incother=31200 if incother>=31200 & year==2012 &incother~=.

*Alimony
replace incalim=99999 if incalim>=99999 & year<=1998 & incalim~=.
replace incalim=50000 if incalim>=50000 & year==1999 & incalim~=.
replace incalim=40000 if incalim>=40000 & year>=2000 & year<=2002 & incalim~=.
replace incalim=45000 if incalim>=45000 & year>=2003 & year<=2010 & incalim~=.
replace incalim=66000 if incalim>=66000 & year==2011 & incalim~=.
replace incalim=96000 if incalim>=96000 & year==2012 & incalim~=.

*Child Support
replace incchild=99999 if incchild>=99999 & year<=1998 & incchild~=.
replace incchild=15000 if incchild>=15000 & year>=1999 & year<=2010 & incchild~=.
replace incchild=21000 if incchild>=21000 & year==2011 & incchild~=.
replace incchild=18300 if incchild>=18300 & year==2012 & incchild~=.

*Unemployment
replace incunemp=99999 if incunemp>=99999 &incunemp~=.

*Survivor Benefits
replace incsurv=99999 if incsurv>=99999 & year<=1998 & incsurv~=.
replace incsurv=50000 if incsurv>=50000 & year>=1999 & year<=2010 & incsurv~=.
replace incsurv=57600 if incsurv>=57600 & year==2011 & incsurv~=.
replace incsurv=75000 if incsurv>=75000 & year==2012 & incsurv~=.

*Disability Benefits
replace incdisab=99999 if incdisab>=99999 & year<=1998 & incdisab~=.
replace incdisab=35000 if incdisab>=35000 & year>=1999 & year<=2010 & incdisab~=.
replace incdisab=48000 if incdisab>=48000 & year==2011 & incdisab~=.
replace incdisab=44000 if incdisab>=44000 & year==2012 & incdisab~=.

*Educational Assistance
replace inceduc=99999 if inceduc>=99999 & year<=1998 & inceduc~=.
replace inceduc=20000 if inceduc>=20000 & year>=1999 & year<=2010 & inceduc~=.
replace inceduc=30000 if inceduc>=30000 & year==2011 & inceduc~=.
replace inceduc=25000 if inceduc>=25000 & year==2012 & inceduc~=.

*Other Assistance
replace incasist=99999 if incasist>=99999 & year<=1998 & incasist~=.
replace incasist=30000 if incasist>=30000 & year>=1999 & year<=2010 & incasist~=.
replace incasist=30000 if incasist>=30000 & year==2011 & incasist~=.
replace incasist=36000 if incasist>=36000 & year==2012 & incasist~=.

save "CPS_topcodes.dta", replace


*Assumption 1: Treat business losses as income but truncate negative household incomes to zero
egen incearned1 = rowtotal(incwage incbus incfarm incretir incint incother incdivid incalim incchild incidr incdrt incaloth incasist incrent)
egen inctransfer1 = rowtotal(incss incwelfr incgov incssi incunemp incwkcom incvet incsurv incdisab inceduc)
egen inc_cutoff1 = rowtotal(incearned1 inctransfer1)
sort year serial
egen hhincome_cutoff1 = total(inc_cutoff1), by(year serial)
replace hhincome_cutoff1=0 if hhincome_cutoff1<0

*Assumption 2: Treat business losses like consumption (e.g. truncate business income to zero for losses, but still count other income sources towards hhincome)
replace incbus = 0 if incbus<0 & incbus~=.
replace incfarm=0 if incfarm<0 & incfarm~=.
replace incother = 0 if incother<0 & incother~=.
replace inceduc= 0 if inceduc<0 & inceduc~=.
replace incrent = 0 if incrent<0 & incrent~=.
replace incdrt=0 if incdrt<=0 & incdrt~=.
replace incidr=0 if incidr<=0 & incidr~=.
egen incearned2 = rowtotal(incwage incbus incfarm incretir incint incother incdivid incalim incchild incidr incdrt incaloth incasist incrent)
egen inctransfer2 = rowtotal(incss incwelfr incgov incssi incunemp incwkcom incvet incsurv incdisab inceduc)
egen inc_cutoff2 = rowtotal(incearned2 inctransfer2)
sort year serial
egen hhincome_cutoff2 = total(inc_cutoff2), by(year serial)
replace hhincome=0.01 if hhincome<=0 & hhincome~=.
save "CPS_topcodes.dta", replace
