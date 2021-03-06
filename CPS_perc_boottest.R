library(GB2)
library(ineq)
library(reldist)
library(plyr)
library(ggplot2)
library(reshape)
library(parallel)
library(doMC)

registerDoMC()
options(cores=detectCores())

setwd("/home8/jlv/MSA_Ineq")
source("functions.r")
load("CPS_broadinc_hh.rda")

perc_replicates<-function(data, year1, year2, ord, reps){
  replicates<-foreach (i = 1:reps, .combine=c)%dopar%{
  Lorenz_KB(sample(data[which(data$year==year2),]$value, replace=T), rep(1, length(data[which(data$year==year1),]$value)), ord, type="mean")-
    Lorenz_KB(sample(data[which(data$year==year2),]$value, replace=T), rep(1, length(data[which(data$year==year1),]$value)), ord, type="mean")
  }
  return(replicates)
}
perc_boot_virt<-function(data, year1, year2, ord, reps=500){
  bootreps<-ddply(data, .variables=c("variable"), function(x) data.frame("replicates"=perc_replicates(data, year1, year2, ord, reps), 
                                                                        "L_hat"=rep(Lorenz_KB(sample(data[which(data$year==year2),]$value, replace=T), 
                                                                        				rep(1, length(data[which(data$year==year1),]$value)), ord, type="mean")-
    																				Lorenz_KB(sample(data[which(data$year==year2),]$value, replace=T), 
    																					rep(1, length(data[which(data$year==year1),]$value)), ord, type="mean"), 																						reps)),.parallel=F)
  bootreps$p_val<-(bootreps$replicates-bootreps$L_hat^2)-(bootreps$L_hat^2)
  p_val<-mean(apply(data.frame(bootreps$p_val),1, function(x) if (x>=0){1}else{0}))
  U_B<-as.numeric(quantile(bootreps$replicates, probs=0.975))
  L_B<-as.numeric(quantile(bootreps$replicates, probs=0.025))
  Point<-mean(bootreps$L_hat)
  return(c("ord"=ord, "Point"=Point, "U_B"=U_B, "L_B"=L_B, "p_val"=p_val))
}

CPS.work.hh<-subset(CPS.work.hh, CPS.work.hh$year>1991 & CPS.work.hh$year<2013)

years_unique<-unique(CPS.work.hh$year)                           
ptm1<-proc.time()
Natl_fit_prebroad<-foreach (i=years_unique, .combine=c)%dopar%{
  temp.year<-subset(CPS.work.hh, CPS.work.hh$year==i)
  bottom_cutoff<-quantile(temp.year$equivinc_pretax_broad, probs=0.3)
  temp.year<-subset(temp.year, temp.year$equivinc_pretax_broad>bottom_cutoff)
  ml.gb2(temp.year$equivinc_pretax_broad)
}
Natl_fit_postbroad<-foreach (i=years_unique, .combine=c)%dopar%{
  temp.year<-subset(CPS.work.hh, CPS.work.hh$year==i)
  bottom_cutoff<-quantile(temp.year$equivinc_posttax_broad, probs=0.3)
  temp.year<-subset(temp.year, temp.year$equivinc_posttax_broad>bottom_cutoff)
  ml.gb2(temp.year$equivinc_posttax_broad)
}
Natl_fit_preequity<-foreach (i=years_unique, .combine=c)%dopar%{
  temp.year<-subset(CPS.work.hh, CPS.work.hh$year==i)
  bottom_cutoff<-quantile(temp.year$equivinc_pretax_equity, probs=0.3)
  temp.year<-subset(temp.year, temp.year$equivinc_pretax_equity>bottom_cutoff)
  ml.gb2(temp.year$equivinc_pretax_equity)
}
Natl_fit_postequity<-foreach (i=years_unique, .combine=c)%dopar%{
  temp.year<-subset(CPS.work.hh, CPS.work.hh$year==i)
  bottom_cutoff<-quantile(temp.year$equivinc_posttax_equity, probs=0.3)
  temp.year<-subset(temp.year, temp.year$equivinc_posttax_equity>bottom_cutoff)
  ml.gb2(temp.year$equivinc_posttax_equity)
}
Natl_fit_baseline<-foreach (i=years_unique, .combine=c)%dopar%{
  temp.year<-subset(CPS.work.hh, CPS.work.hh$year==i)
  bottom_cutoff<-quantile(temp.year$equivinc_pretax_broad, probs=0.3)
  temp.year<-subset(temp.year, temp.year$equivinc_pretax_broad>bottom_cutoff)
  ml.gb2(temp.year$equivinc_pretax_broad)
}

Gini_try_postbroad<-data.frame()
Gini_try_preequity<-data.frame()
Gini_try_postequity<-data.frame()
Gini_try_prebroad<-data.frame()
Gini_try_baseline<-data.frame()
counter=0
for (i in years_unique){
counter=counter+1
tempyear<-subset(CPS.work.hh, CPS.work.hh$year==i)
virtual_inc_postbroad<-matrix(0, length(tempyear$topcoded_equivinc_postequity), 100)
virtual_inc_preequity<-matrix(0, length(tempyear$topcoded_equivinc_postequity), 100)
virtual_inc_postequity<-matrix(0, length(tempyear$topcoded_equivinc_postequity), 100)
virtual_inc_prebroad<-matrix(0, length(tempyear$topcoded_equivinc_postequity), 100)
virtual_inc_baseline<-matrix(0, length(tempyear$topcoded_equivinc_postequity), 100)
for (j in 1:100){
  temp.data.replace<-vapply(tempyear$topcoded_equivinc_prebroad, FUN=topcode_sub, Natl_fit_prebroad[counter], FUN.VALUE=0.0)
  virtual_inc_prebroad[,j]<-temp.data.replace+tempyear$bottom_equivinc_prebroad
  temp.data.replace<-vapply(tempyear$topcoded_equivinc_postbroad, FUN=topcode_sub, Natl_fit_postbroad[counter], FUN.VALUE=0.0)
  virtual_inc_postbroad[,j]<-temp.data.replace+tempyear$bottom_equivinc_postbroad
  temp.data.replace<-vapply(tempyear$topcoded_equivinc_preequity, FUN=topcode_sub, Natl_fit_preequity[counter], FUN.VALUE=0.0)
  virtual_inc_preequity[,j]<-temp.data.replace+tempyear$bottom_equivinc_preequity
  temp.data.replace<-vapply(tempyear$topcoded_equivinc_postequity, FUN=topcode_sub, Natl_fit_postequity[counter], FUN.VALUE=0.0)
  virtual_inc_postequity[,j]<-temp.data.replace+tempyear$bottom_equivinc_postequity
  temp.data.replace<-vapply(tempyear$topcoded_equivinc, FUN=topcode_sub, Natl_fit_baseline[counter], FUN.VALUE=0.0)
  virtual_inc_baseline[,j]<-temp.data.replace+tempyear$bottom_equivinc
}
virtual_inc_prebroad<-data.frame(virtual_inc_prebroad)
virtual_inc_postbroad<-data.frame(virtual_inc_postbroad)
virtual_inc_preequity<-data.frame(virtual_inc_preequity)
virtual_inc_postequity<-data.frame(virtual_inc_postequity)
virtual_inc_baseline<-data.frame(virtual_inc_baseline)
virtual_inc_prebroad$State<-tempyear$State
virtual_inc_preequity$State<-tempyear$State
virtual_inc_postbroad$State<-tempyear$State
virtual_inc_postequity$State<-tempyear$State
virtual_inc_baseline$State<-tempyear$State
virtual_inc_prebroad$year<-rep(i, length(tempyear$topcoded_equivinc))
virtual_inc_preequity$year<-rep(i, length(tempyear$topcoded_equivinc))
virtual_inc_postbroad$year<-rep(i, length(tempyear$topcoded_equivinc))
virtual_inc_postequity$year<-rep(i, length(tempyear$topcoded_equivinc))
virtual_inc_baseline$year<-rep(i, length(tempyear$topcoded_equivinc))
Gini_try_preequity<-rbind(Gini_try_preequity, virtual_inc_preequity)
Gini_try_postbroad<-rbind(Gini_try_postbroad, virtual_inc_postbroad)
Gini_try_postequity<-rbind(Gini_try_postequity, virtual_inc_postequity)
Gini_try_prebroad<-rbind(Gini_try_prebroad, virtual_inc_prebroad)
Gini_try_baseline<-rbind(Gini_try_baseline, virtual_inc_baseline)
}
proc.time()-ptm1
save(Gini_try_prebroad, file="State_GB2_virtinc_prebroad.rda")
save(Gini_try_preequity, file="State_GB2_virtinc_preequity.rda")
save(Gini_try_postbroad, file="State_GB2_virtinc_postbroad.rda")
save(Gini_try_postequity, file="State_GB2_virtinc_postequity.rda")
save(Gini_try_baseline, file="State_GB2_virtinc_baseline.rda")

Gini_try_preequity<-melt(Gini_try_preequity, id.vars=c("State", "year"))
Gini_try_postbroad<-melt(Gini_try_postbroad, id.vars=c("State", "year"))
Gini_try_postequity<-melt(Gini_try_postequity, id.vars=c("State", "year"))
Gini_try_prebroad<-melt(Gini_try_prebroad, id.vars=c("State", "year"))
Gini_try_baseline<-melt(Gini_try_baseline, id.vars=c("State", "year"))

LC_change_preequity<-data.frame()
LC_change_postbroad<-data.frame()
LC_change_postequity<-data.frame()
LC_change_prebroad<-data.frame()
LC_change_baseline<-data.frame()


Gini_try_postbroad_small<-Gini_try_postbroad[which(Gini_try_postbroad$year==2000 | Gini_try_postbroad==2012),]

ord=0.5
ptm<-proc.time()
LC_try<-ddply(Gini_try_postbroad_small, .variables=c("State"), function(x) c(perc_boot_virt(x, 2000, 2012, ord)), .parallel=T)
proc.time()-ptm


for (i in c(0.01, seq(0.05,0.95, 0.05), 0.99){
	
}

