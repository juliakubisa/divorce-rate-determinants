# Importing libraries 
library(car)
library(corrplot)
library(readxl)
library(rcompanion) 
library(normtest) 
library(psych) 
library(PerformanceAnalytics)
library(dplyr)
library(ggplot2)
library(sandwich)
library(lmtest)
library(stargazer)
library(sandwich)


# Reading data  
dane <- read_excel("rozwody_dane.xlsx")
summary(dane)
str(dane)

dane$edu_m1  = ifelse(dane$edu_m==1,1,0)
dane$edu_m3  = ifelse(dane$edu_m==3,1,0)
dane$edu_m4  = ifelse(dane$edu_m==4,1,0)

dane$edu_w1  = ifelse(dane$edu_w==1,1,0)
dane$edu_w3  = ifelse(dane$edu_w==3,1,0)
dane$edu_w4  = ifelse(dane$edu_w==4,1,0)


# Graphic analysis of the dependent variable  
par(mfrow = c(1,2))

plotNormalHistogram(dane$duration, main = "Histogram", linecol = "black", col="lightblue", ylab = "Liczba obserwacji", xlab = "Lata")
boxplot(dane$duration, main = "Wykres pudełkowy", col="lightblue", xlab="Lata", horizontal=TRUE)


# Normality tests 
shapiro.test(dane$duration) 
jb.norm.test(dane$duration) 
options(scipen=999) 

# Basic statistics of the dependent variable 
summary(dane$duration)
stargazer(as.data.frame(dane[c("duration")]), 
          type="html", out="duration.html", title="Podstawowe statystyki zmiennej objaśnianej")

# Graphic analysis of independent variables 
par(mfrow = c(1,3))

plotNormalHistogram(dane$inc_m, main = "inc_m", linecol = "black", col="lightblue", ylab = "", xlab="dochód", xlim=c(0,50000), breaks=800)
plotNormalHistogram(dane$inc_w, main = "inc_w", linecol = "black", col="lightblue", ylab="", xlab="dochód", xlim=c(0,50000), breaks=400)
plotNormalHistogram(dane$children, main = "children ", linecol = "black", col="lightblue", ylab="", xlab="liczba")

# In-depth statistics of independent variables 
stargazer(as.data.frame(dane[c("inc_m","inc_w","edu_m","edu_w","children")]), 
          type="html", out="statystyki.html", title="Podstawowe statystyki zmiennych objaśnianych")


# Corellaction of variables  
correlation.matrix <- cor(dane[,c("duration","inc_m","inc_w", "children", "edu_w","edu_m")])
stargazer(correlation.matrix, title="Macierz Korelacji", type="html", out="correlation.html")


#MODEL 

# Base model   
model0<-lm(duration~inc_m+inc_w+children+edu_m1+edu_m3+edu_m4+edu_w1+edu_w3+edu_w4,data=dane)
summary(model0)
resettest(model0, power=2, type="fitted")


# Model 1 
model1<-lm(duration~log(inc_m)+log(inc_w)+children+edu_m1+edu_m3+edu_m4+edu_w1+edu_w3+edu_w4,data=dane)
resettest(model1, power=2, type="fitted")

stargazer(model1, type="html",out="model1.html")
summary(model1)


# Model 2
model2<-lm(duration~log(inc_m)+log(inc_w)+children+edu_m1+edu_m3+edu_w1+edu_w3+edu_w4,data=dane)
resettest(model2, power=2, type="fitted")

stargazer(model2, type="html",out="model2.html")
summary(model2)

# Model 3 
model3<-lm(duration~log(inc_m)+log(inc_w)+children+edu_m1+edu_w1+edu_w3+edu_w4,data=dane)
resettest(model3, power=2, type="fitted")

stargazer(model3, type="html",out="model3.html")
summary(model3)


# Model 4 
model4<-lm(duration~log(inc_m)+log(inc_w)+children+edu_m1+edu_w1+edu_w3+edu_w4+children_2,data=dane)
summary(model4)
resettest(model4, power=2, type="fitted")
anova(model3, model4)

stargazer(model4, type="html",out="model4.html")
  

# Outliers 

# leverage statistics  
dzwignie<-hatvalues(model4)
which.max(dzwignie) # most unusual value   

plot(model4,1) # residuals vs fitted graph 
plot(model4,5) # residuals vs leverage graph 

leveragePlots(model4)

# Standarizing the residuals 
rstandard(model4)[abs(rstandard(model4)) > 2]

# Cook's distance  
cutoff <- 4/((nrow(dane)))
plot(model4, which=4, cook.levels=cutoff)  #wykres odległośći cooka 

# Collinearity 
wspol <- vif(model3)
stargazer(wspol, type="html",out="vif.html", title="Statystyka VIF")


# Diagnostics  
# Homoscedacity of residuals 
plot(model4,3) # scale-location graph 

# Breusch-Pagan test  
bptest(model4)

# Heteroskedascity Consisent Estimator 
odporna = coeftest(model4, vcov.=vcovHC(model4,type="HC0")) 
stargazer(odporna, type="html",out="odporna.html") # The best model 
show(odporna)
summary(model4)


# Jacque Bera test 
jb.norm.test(dane)

# Summary of all the models 
stargazer(model1,model2, model3, model4, odporna, type="text", out="model_final.html")



