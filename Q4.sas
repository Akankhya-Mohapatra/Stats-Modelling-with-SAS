
/*4a.  Draw a survival curve for data and briefly describe the curve.*/

ods rtf;
ods graphics on;
proc lifetest data=final.Q4 method=km plots=(s(cl)) ;
time Days_survival*Status(0);
run;
ods graphics off;
ods rtf close;


/* 4b.  Calculate the survival probability of heroin addicts after one year’s follow up. Calculate the median and mean survival time.*/

ods rtf;
ods graphics on;
PROC LIFETEST DATA=final.Q4 PLOTS=SURVIVAL TIMELIM=899;
time Days_survival*Status(0);
RUN;
ods graphics off;
ods rtf close;

/* 4c. Draw the survival curve for heroin addicts, separating those who have received heavy methadone dose those who have received light methadone dose separately. Do heroin addicts who has heavy methadone dose survive longer than those who have light methadone dose? (using formal test to assess this hypothesis) */

ods rtf;
ods graphics on;
proc sgplot data=final.Q4;
histogram dose;
run;
ods graphics off;
ods rtf close;

/* find the optimal cutoff point dose=70 */
ods rtf;
%findcut (data=final.Q4, time=Days_survival, event=Status, cutvar=dose);
ods rtf close;


/* add new column dose_cat in dataset */

data final.Q4;
set final.Q4;
if dose>=70 then dose_cat="heavy";
else dose_cat="light";
run;

/* Comparing survival curves between heavy dose and light dose */
ods rtf;
ods graphics on;
proc lifetest data=final.Q4 method=km plots=(s) ;
time Days_survival*Status(0);
strata dose_cat;
run;
ods graphics off;
ods rtf close;


/* 4d. Draw two separate survival curves for heroin addicts who have a prison record and those who did not have prison record separately.  Do heroin addicts who never has prison record survive longer than those who did? (using formal test to assess this hypothesis)*/

ods rtf;
ods graphics on;
proc lifetest data=final.Q4 method=km plots=(s) ;
time Days_survival*Status(0);
strata prison;
run;
ods graphics off;
ods rtf close;


/* 4e. Draw the survival curve for heroin addicts in clinic 1 and in clinic 2 separately.  Is there any difference in survival time of heroin addicts between these two clinics? (using formal test to assess this hypothesis) */

ods rtf;
ods graphics on;
proc lifetest data=final.Q4 method=km plots=(s) ;
time Days_survival*Status(0);
strata clinic;
run;
ods graphics off;
ods rtf close;


/* 4f.  Using formal hypothesis test, assess the effect of each variable “methadone dose” and “clinic” on hazard rate for heroin addicts. Use formal hypothesis test to assess the model fitting. */

ods rtf;
proc phreg data=final.Q4;
model Days_survival*Status(0)= dose clinic / ties=exact; 
run;
ods rtf close;


/* 4g.  Is the effect of methadone dose on survival time dependent on the choice of clinic? (use formal hypothesis test to assess)*/

ods rtf;
proc phreg data=final.Q4;
model Days_survival*Status(0)= dose clinic dose*clinic / ties=exact; 
run;
ods rtf close;


/* 4h. Make formal hypothesis test to compare the model survival ~ clinic + dose + prison with model survival ~ clinic + dose*/

ods rtf;
proc phreg data=final.Q4;
model Days_survival*Status(0)= dose clinic / ties=exact; 
run;
proc phreg data=final.Q4;
model Days_survival*Status(0)= dose clinic prison / ties=exact; 
run;
data pval;
pval=1-CDF('CHISQ',3.773,1);
run;
proc print data=pval;
run;
ods rtf close;
