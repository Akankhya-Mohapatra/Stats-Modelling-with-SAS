
data temp;
set final.Q3;
weekcat=week;
run;


/*3a.     Visualize the effect of time of the amount of protein in the milk. Comment on the results.*/
proc sgplot data=final.Q3;
series x=week y=protein /group=cow LineAttrs= (pattern=1);
run;


/*3a1. visualize the effect of time of the amount of protein in the milk of the cow it an ID smaller than 10.*/ 
proc sgplot data=final.Q3 (where=(cow<10));
series x=week y=protein /group=cow LineAttrs= (pattern=1);
run;

/*code used for the following questions*/
/*3b. Provide the fitter ordinary linear regression model to assess the effects of the diet and week on the variable protein. */
/*3c. Interpret the effect of time in week over the amount of protein contained in the milk. */

proc glm data=temp;
class cow diet (ref="2") weekcat;
model protein=diet week/ss3 solution clparm;
run;



/*3d.  Predict the protein content for cow with a diet type 1 with protein content = 4 for week 1 (add cow id = 80 and 81) using the model in question 4.2.*/
/* predictions for the response variable Y */
/* addition of two new employees not present in the original sample
to illustrate how to obtain predictions for new observations */
data newdata;
input diet cow week protein;
cards;
1 80 1 4 
1 81 1 4	
;
run;
data temp;
set final.Q3 newdata;
weekcat=week;
run;
proc mixed data=temp;
class cow;
model protein = diet week /solution cl outp=prediction outpm=mean;
random intercept week / subject=cow type=vc ;
run


/* keeping predictions only for all observations including the 2 inputs above in "mean" */
data mean; set mean;
keep pred;
run;


*3e. Determine if the significance tests of parameters will be valid?*/
proc glm data=temp;
class cow diet (ref="2") weekcat;
model protein=diet week/ss3 solution clparm;
run;




/* Code used for the following questions
3f. Assuming the error terms are no longer independent, given that the observations are taken from the same cows over the weeks, provide a fitted model including a compound symmetry covariance structure.*/
/*3g. Perform a test to evaluate if the covariance is significative among the same individuals. If the covariance is significative, interpret the covariance parameter estimate.
3h. Test whether the reduced model without a correlation structure is an adequate simplification of this model including a correlation structure. . 
3i. Interpret the effect of time (in week) over the mean amount of protein in week. How does this interpretation differs from the interpretation in 3c.
*/
proc mixed data=temp method=reml covtest;
class cow diet(ref="2") weekcat;
model protein= diet week/solution cl;
repeated weekcat/subject=cow type=cs r=1 rcorr=1;
run;

/*Code used for the following questions
3j. Using a model with a correlation structure without specifying any restriction, identify the best correlation structure among the following:
a.	Compound symmetry
b.	AR
c.	ARH(1)
*/
proc mixed data=temp method=reml covtest;
class cow diet (ref="2") weekcat;
model protein= diet week/solution cl;
repeated weekcat / subject=cow type=un r=1 rcorr=1;
run;

/*3k. Choose the best correlation structure between the following models. 
*/

/*compound symmetry*/
proc mixed data=temp method=reml covtest;
class cow diet (ref="2") weekcat;
model protein= diet week/solution cl;
repeated weekcat/subject=cow type=cs r=1 rcorr=1;
run;



/*AR structure*/
proc mixed data=temp method=reml covtest;
class cow diet (ref="2") weekcat;
model protein= diet week/solution cl;
repeated weekcat / subject=cow type=ar(1) r=1 rcorr=1;
run;

/*arh(1)*/
proc mixed data=temp method=reml covtest;
class cow diet (ref="2") weekcat;
model protein= diet week/solution cl;
repeated weekcat / subject=cow type=arh(1) r=1 rcorr=1;
run;



/* 3l. Fit the above model with a random effect and show the covariance parameter estimates. Test the significance of the parameter diet. Is this analysis valid? Comment.*/
proc mixed data=final.Q3;
class cow diet ;
model protein = Diet week /solution cl;
random intercept / subject=cow v=1 vcorr=1;
run;
/*3m.   .   Fit the same regression model in question 3i, fit an Auto regressive model (ARH(1)) similar to 4.3 this time adding the correlation structure on the error terms. Are the correlations different for the model this time? */
data temp;
set final.Q3;
weekcat=week;
diet1 = (diet="1");
diet3=(diet="3");
run;
proc mixed data=temp;
class cow weekcat;
model protein = diet1 diet3 week/solution cl;
random intercept/ subject=cow v=1 vcorr=1;
repeated weekcat/ subject=cow type=ar(1) r=1 rcorr=1;
run;




