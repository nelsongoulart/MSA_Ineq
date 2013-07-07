set more off
cd "$MSAINEQ/Data"
*do "$MSAINEQ/Code/read_CPS.do"
do "$MSAINEQ/Code/cps_00034.do"

*Recode missing (NIU) values
recode inctot (99999999=.)
recode ftotval (99999999=.)
recode incwage (9999999=.)
recode incbus (9999999=.)
recode incfarm (9999999=.)
recode incretir (999999=.)
recode incss (99999 =.)
recode incwelfr (99999 =.)
recode incssi (99999=.)
recode incint (99999=.)
recode incvet (99999=.)
recode incsurv (999999=.)
recode incdisab (999999=.)
recode incdivid (999999=.)
recode incrent (99999=.)
recode inceduc (99999=.)
recode incchild (99999 = .)
recode incalim (99999=.)
recode incasist (99999=.)
recode incother (99999 =.)
recode incint (99999=.)
recode incunemp (99999=.)
recode incwkcom (99999=.)
recode incvet (99999=.)
recode incsurv (999999=.)
recode incgov (99999=.)
recode incidr (99999=.)
recode incdrt (99999=.)
recode incaloth (99999=.)


*Replace hard-coded IPUMS top code flag with the actual top code for the relevant year (Larrimore et al (2008) for the top codes)
replace incdrt = 99999 if incdrt>=99997 & incdrt~=.
replace incint = 50000 if incint==99997 & year<=1981 &incint~=.
replace incint = 75000 if incint==99997 & year>=1982 & year<=1984 &incint~=.
replace incint = 99999 if incint==99997 & year>=1985 & year<=1998 &incint~=.
replace incint = 35000 if incint==99997 & year>1998 & year<=2002 &incint~=.
replace incint = 25000 if incint==99997 & year>2002 & year<=2010 &incint~=.
replace incint = 24000 if incint==99997 & year==2011 &incint~=.
replace incint = 22000 if incint==99997 & year==2012 &incint~=.
replace incunemp = 99999 if incunemp==99997 & incunemp~=.
replace incwkcom = 99999 if incwkcom==99997 & incwkcom~=.
replace incvet = 29999 if incvet==99997 & year<=1993 & incvet~=.
replace incvet = 99999 if incvet==99997 & year>1993 & incvet~=.
replace incrent = 99999 if incrent==99997 & year<=1998 & incrent~=. 
replace incrent = 25000 if incrent==99997 & year>1998 & year<=2002 & incrent~=.
replace incrent = 40000 if incrent==99997 & year>2002 & year<=2010 & incrent~=.
replace incrent = 50000 if incrent ==99997 & year==2011 & incrent~=.
replace incrent = 60000 if incrent==99997 & year==2012 & incrent~=.
replace inceduc = 99999 if inceduc==99997 & year<=1998 &inceduc~=. 
replace inceduc = 20000 if inceduc==99997 & year >1998 & year<=2010 &inceduc~=.
replace inceduc = 30000 if inceduc==99997 & year==2011 &inceduc~=.
replace inceduc = 25000 if inceduc==99997 & year == 2012 &inceduc~=.
replace incchild = 99999 if incchild==99997 & year<=1998 &incchild~=.
replace incchild = 15000 if incchild==99997 & year>1998 & year<2010 &incchild~=.
replace incchild = 21000 if incchild==99997 & year==2011 &incchild~=.
replace incchild = 18300 if incchild==99997 & year==2012 &incchild~=.
replace incalim = 99999 if incalim==99997 & year<=1998 &incalim~=.
replace incalim = 50000 if incalim==99997 & year==1999 &incalim~=.
replace incalim = 40000 if incalim==99997 & year>=2000 & year<=2002 &incalim~=.
replace incalim = 45000 if incalim==99997 & year>2002 & year<=2010 &incalim~=.
replace incalim = 66000 if incalim==99997 & year==2011 &incalim~=.
replace incalim = 96000 if incalim==99997 & year==2012 &incalim~=.
replace incasist = 99999 if incasist==99997 & year<=1998 & incasist ~=.
replace incasist = 30000 if incasist==99997 & year>1998 & year<=2011 & incasist ~=.
replace incasist = 36000 if incasist==99997 & year==2012 & incasist ~=.
replace incother = 99999 if incother==99997 & year<=1998 & incother~=.
replace incother = 25000 if incother==99997 & year>1998 & year<=2011 & incother~=.
replace incother = 31200 if incother==99997 & year==2012 & incother~=.
replace incdivid=99999 if incdivid==99997

*Truncate negative income amounts to zero
*replace incbus = 0 if incbus<0 & incbus~=.
*replace incfarm=0 if incfarm<0 & incfarm~=.
*replace incother = 0 if incother<0 & incother~=.
*replace inceduc= 0 if inceduc<0 & inceduc~=.
*replace incrent = 0 if incrent<0 & incrent~=.
*replace incdrt=0 if incdrt<=0 & incdrt~=.
*replace incidr=0 if incidr<=0 & incidr~=.

save CPS_raw_microdata.dta, replace

