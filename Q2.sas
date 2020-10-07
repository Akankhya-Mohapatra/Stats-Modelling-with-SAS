/*Source of the dataset: https://www.kaggle.com/c/titanic/data*/

/*Question 2 - titanic - logistic regression - binary variable of interest*/

/*code used for the following questions*/
/*2b. Interpret the individual effect of 
-	being in the first class (PClass=1) on the mean probability of surviving.
-	being a female on the mean probability of surviving
-	age on the mean probability of surviving*/
/*2c. Provide the fit model of the probability of surviving to the Titanic crash*/

proc logistic data=final.q2 (where=(SibSp=0 AND Parch=0));
class sex (ref="male") embarked (ref="C") pclass(ref="3");
model survived(ref="0") = pclass sex age fare Embarked / clparm=pl clodds=pl expb;
lsmeans sex/pdiff=all cl;
run;
/*code used for the following questions*/
/*2d: Test if there is a significant difference in the logit-transformed probability of surviving between male and female.*/
/*2e. If it is significant, then, evaluate the mean probability of surviving of a female. What can you conclude based on this result. */
proc glimmix data=final.q2 (where=(SibSp=0 AND Parch=0));
class sex (ref="male") embarked (ref="C") pclass(ref="3");
model survived(ref="0") = pclass sex age fare Embarked / dist=binary link=logit solution;
lsmeans sex/pdiff=all cl;
run;

/*2f. Estimate the probability of survival of a passenger with the following characteristics:*/
/*2g. Using a visual representation of the odds ratios with a 95% profile-Likelihood confidence limits, conclude on the significance of PClass1 and PClass2. Justify your answer referring to the graph. */

proc logistic data=final.q2 (where=(SibSp=0 AND Parch=0));
class sex (ref="male") embarked (ref="C") pclass(ref="3");
model survived(ref="0") = pclass sex age fare Embarked / clparm=pl clodds=pl expb;
lsmeans sex/pdiff=all cl;
run;







