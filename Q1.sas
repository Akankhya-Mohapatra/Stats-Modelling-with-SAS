/*Source of the dataset :
https://www.kaggle.com/christophercorrea/dc-residential-properties*/


/*adding logprice variable*/
data final.Q1;
set final.Q1 (where=(( ASSESSMENT_NBHD="Kalorama") OR ( ASSESSMENT_NBHD="Brookland" ) OR ( ASSESSMENT_NBHD="Wakefield" ) OR ( ASSESSMENT_NBHD="Berkley" )));
logPrice= log(price);
run;

/*code used for the following questions*/
/*Question 1a. Provide the fitted full model of the logprice.*/
/*Question 1b. Provide the fitted model of the price*/
proc glm data=final.Q1 (where=(( ASSESSMENT_NBHD="Kalorama") OR ( ASSESSMENT_NBHD="Brookland" ) OR ( ASSESSMENT_NBHD="Wakefield" ) OR ( ASSESSMENT_NBHD="Berkley" )));
class ASSESSMENT_NBHD (ref="Kalorama") CNDTN (ref="Average");
model logprice =  	ROOMS	 CNDTN ASSESSMENT_NBHD BEDRM	AYB	EYB	STORIES	KITCHENS	FIREPLACES		LANDAREA	SQUARE BATHRM/ss3 solution clparm;
run;
/*Question 1c. Provide a plot of the JSR residuals against the predicted values. What can you conclude based on the plot? Explain.*/

proc glm data=final.Q1 (where=(( ASSESSMENT_NBHD="Kalorama") OR ( ASSESSMENT_NBHD="Brookland" ) OR ( ASSESSMENT_NBHD="Wakefield" ) OR ( ASSESSMENT_NBHD="Berkley" )));
class ASSESSMENT_NBHD (ref="Kalorama") CNDTN (ref="Average");
model logprice =  	ROOMS	 CNDTN ASSESSMENT_NBHD BEDRM	AYB	EYB	STORIES	KITCHENS	FIREPLACES		LANDAREA	SQUARE BATHRM/ss3 solution;
output out=residuals predicted=pred rstudent=dsresid;
run;

proc loess data=residuals plots(only)=(fit);
model dsresid = pred  /clm;
run;

/*code used for the following questions*/
/*Question 1d. Interpret R^2 in the context of the dataset*/
/*Question 1e. Complete a global test on the LOGPRICE. Write down the hypothesis of the test and interpret the results of the global test.*/
/*Question 1f. Identify the parameters of variables that have a significant linear effect on the mean logprice. Interpret your results. */
/*Question 1g.	Based on the fit model, interpret the coefficient of the following variables on the mean price of a house. */
/*Question 1h. Based on a t-test, conclude on the significance of the parameters of the following variables. */
proc glm data=final.Q1 (where=(( ASSESSMENT_NBHD="Kalorama") OR ( ASSESSMENT_NBHD="Brookland" ) OR ( ASSESSMENT_NBHD="Wakefield" ) OR ( ASSESSMENT_NBHD="Berkley" )));
class ASSESSMENT_NBHD (ref="Kalorama") CNDTN (ref="Average");
model logprice =  	ROOMS	 CNDTN ASSESSMENT_NBHD BEDRM	AYB	EYB	STORIES	KITCHENS	FIREPLACES		LANDAREA	SQUARE BATHRM/ss3 solution clparm;
run;

/*1i. Changing the reference ASSESSMENT_NBHD to Berkley, interpret the significance of the t-test of the parameters of the following variables:  
-	ASSESSMENT_NBHD Brookland
-	ASSESSMENT_NBHD Wakefield
Compare your results with the results obtained in question 1g.*/

proc glm data=final.Q1 (where=(( ASSESSMENT_NBHD="Kalorama") OR ( ASSESSMENT_NBHD="Brookland" ) OR ( ASSESSMENT_NBHD="Wakefield" ) OR ( ASSESSMENT_NBHD="Berkley" )));
class ASSESSMENT_NBHD (ref="Berkley") CNDTN (ref="Average");
model logprice =  	ROOMS	 CNDTN ASSESSMENT_NBHD BEDRM	AYB	EYB	STORIES	KITCHENS	FIREPLACES		LANDAREA	SQUARE BATHRM/ss3 solution clparm;
run;



