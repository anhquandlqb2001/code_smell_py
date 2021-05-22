library(forestplot)
# Cochrane data from the 'rmeta'-package

# Import the data

data <- read_excel("FPlot_analysis.xlsx", sheet = 2)

attach(data)

names(data)


SVM <- subset(data, MLAlgo == "SVM")
DT <- subset(data, MLAlgo == "Decision Tree")
RF <- subset(data, MLAlgo == "Random Forest")
JRip <- subset(data, MLAlgo == "JRip")
NB <- subset(data, MLAlgo == "Naive Bayes")


studies <- list(SVM, DT, RF, JRip, NB)


for(l in studies){
  fm <- l$Fmeasure
  print(l$MLAlgo)
  # Find the mean and length of the data
  data.mean <- mean(fm)
  data.length <- length(fm)
  #print(data.mean)
  #print(data.length)
  
  # Calculate the standard deviation
  data.stdiv <- sd(fm, na.rm = FALSE)
  #print(data.stdiv)
  
  # Calculate the standard error
  data.error <- data.stdiv/sqrt(data.length)
  #print(data.error)
  
  std.error <- qt(.95, df=data.length-1)*data.error
  #print(std.error)
  
  
  lower <- data.mean - std.error
  upper <- data.mean + std.error
  
  # Display the mean, upper and lower values
  print(data.mean)
  print(lower)
  print(upper)
}

m <- c(62.11667, 83.31704, 93.194, 96.57556,56.50815)/100
l<- c(51.25987, 76.16331, 89.42874, 94.24841, 47.01901)/100
u <- c(72.97347, 90.47077, 96.95926, 98.9027, 65.99729)/100
m
l
u
mean(m)
mean(l)
mean(u)



MLVsPerf_MLU <- 
  structure(list(
    mean  = c(NA, 0.6211667, 0.8331704, 0.9319400, 0.9657556, 0.5650815, 0.7834228), 
    lower = c(NA, 0.5125987, 0.7616331, 0.8942874, 0.9424841, 0.4701901, 0.7162387),
    upper = c(NA, 0.7297347, 0.9047077, 0.9695926, 0.9890270, 0.6599729, 0.850607)),
    .Names = c("mean", "lower", "upper"), 
    row.names = c(NA, -7L), 
    class = "data.frame")

print(MLVsPerf_MLU$mean)

tabletext2<-cbind(
  c("Study", "Support Vector Machine (S[1],S[6],S[9],S[13])", "Decision Tree (S[1],S[5],S[9],S[13])", 
    "Random Forest (S[1],S[5],S[9],S[13])", "JRip (S[1],S[5],S[13])", "Naive Bayes (S[1],S[13])", "Total (95% CI)")
  #c("F-measure", ".9129", ".9744", 
  # ".8188", ".7317", ".9059", ".7680", 
  #".6952", ".6757", NA, NA)
)

forestplot(tabletext2, 
           MLVsPerf_MLU$mean,
           MLVsPerf_MLU$lower,
           MLVsPerf_MLU$upper,
           new_page = TRUE,
           is.summary=c(TRUE,rep(FALSE,5), TRUE),
           clip=c(.1,2.5), 
           #graphwidth = unit(5, "inches"),
           #boxsize = 0.2,
           xlog=TRUE,
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1, cex=1.2),
                                         gpar(fontface = 1)),
                            ticks = gpar(fontfamily = "", cex=1),
                            xlab  = gpar(fontfamily = "", cex = 1)),
           xlab="F-measure values of machine learning algorithms",
           col=fpColors(box="royalblue",line="darkblue", summary="royalblue"))




# =============== ANOVA TEST ==================

boxplot(Fmeasure~MLAlgo)

# Ho = Mean f-measures is same for all the Classifiers

ANOVA1 <- aov(Fmeasure~MLAlgo)
ANOVA1

summary(ANOVA1)

attributes(ANOVA1)

# Pair wise comparison

TukeyHSD(ANOVA1)

# Visualize the pair wise comparison

plot(TukeyHSD(ANOVA1), las=1)


# Resutls

# aov(formula = Fmeasure ~ MLAlgo)

# Terms:
#  MLAlgo Residuals
#Sum of Squares  24104.86  57300.69
#Deg. of Freedom        4        97

# Residual standard error: 24.30491
# Estimated effects may be unbalanced

#              Df Sum Sq  Mean Sq  F value   Pr(>F)    
# MLAlgo       4  24105    6026    10.2      6.17e-07 ***
# Residuals   97  57301     591                     
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1



# ==============================================

# =============== Kruskal Wallis TEST ==================

# For kruskal test convert the textual names to factor

MLfactor <- as.factor(MLAlgo)

print(MLfactor)

kruskal <- kruskal.test(Fmeasure~MLfactor)

kruskal

attributes(kruskal)

summary(kruskal)

# Resutls

# Kruskal-Wallis rank sum test

# data:  Fmeasure by MLfactor
# Kruskal-Wallis chi-squared = 36.581, df = 4, p-value = 2.197e-07


#======================================================


