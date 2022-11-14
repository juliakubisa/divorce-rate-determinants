# What determines the divorce rate in Mexico?

:books: This is a first attempt to apply OLS model to determine the divorce rate in a country of choice 

#### DATASET

The dataset was obtained from Mexico government official site and discribes overall 4900 divorces that were filed in Xalpa city. Becuase of many missing values, only 
1479 were used in this analysis. Following variables were used: 
- Dependent variable: duration, which measures the marriage in years (y) 
- Independent variables: men's income (x_1), women's income (x_2), years of eduaction of men (x_3), years of education of women (x_4), number of children (x_5), number of children squared (x_6)

#### ANALYZING THE DATA

To analyse the data, the basic descriptive statistics were calculated. Interpreting the histogram plot led to an assumption that the dependent variable (lenght of marriage) is right-skewed. 
Shapiro-Wilk and Jacque-Bere tests confirmed, that the data doesn't have a normal distribution (p-value < -0.05). 
Therefore, the same procedure was repeated for independent variables. Each one of them was right-skewed. 

Then, the corellation between values was measured using corellation matrix. Variable y (duration) had the highest positive correlation with x5 (children). The only variables
with negative corellation to duration were edu_m and edu_w. Also education for both genders was negatively corellated with the number of children. 

#### REGRESSION
The logarithmic transformation of variables inc_w and inc_w was applied, to eliminate the problem of non-linearity. Then, the least significant variables were eliminated from the model 
one by one. In the final model (model no. 4) the highest levels of education for men were left out, while the rest of variables proved significant.

