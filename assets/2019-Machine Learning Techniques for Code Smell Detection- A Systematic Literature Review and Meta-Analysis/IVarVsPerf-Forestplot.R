library(forestplot)
# Cochrane data from the 'rmeta'-package


# Import the data

library(readxl)

data <- read_excel("FPlot_analysis.xlsx", sheet=4)

attach(data)

names(data)


#m <- c(91.28667, 97.43667, 81.88, 73.16667, 90.59, 76.8, 68.525, 67.565)/100
#l <- c(82.81283, 96.5292, 70.59533, 33.72151, 83.85226, 63.68325, 53.0256, 62.20456)/100
#u <- c(99.7605, 98.34413, 93.16467, 112.6118, 97.32774, 89.91675, 84.0244, 72.92544)/100

#print(mean(m))
#print(mean(l))
#print(mean(u))


IVarVSPerf_MLU <- 
  structure(list(
    mean  = c(NA, 0.9128667, 0.9743667, 0.8188000, 0.7316667, 0.9059000, 0.7680000, 0.6852500, 0.6756500, 0.8090625), 
    lower = c(NA, 0.8281283, 0.9652920, 0.7059533, 0.3372151, 0.8385226, 0.6368325, 0.5302560, 0.6220456, 0.6830307),
    upper = c(NA, 0.9976050, 0.9834413, 0.9316467, 1.1261180, 0.9732774, 0.8991675, 0.8402440, 0.7292544, 0.9350943)),
    .Names = c("mean", "lower", "upper"), 
    row.names = c(NA, -10L), 
    class = "data.frame")

print(IVarVSPerf_MLU)

tabletext1<-cbind(
  c("Study", "S[01]", "S[13]", 
    "S[06]", "S[09]", "S[04]", "S[05]", 
    "S[07]", "S[15]", "Total (95% CI)"),
  c("F-measure", ".9129", ".9744", 
    ".8188", ".7317", ".9059", ".7680", 
    ".6952", ".6757", NA)
  )

forestplot(tabletext1, 
           IVarVSPerf_MLU$mean,
           IVarVSPerf_MLU$lower,
           IVarVSPerf_MLU$upper,
           new_page = TRUE,
           is.summary=c(TRUE,rep(FALSE,8), TRUE),
           clip=c(.1,2.5), 
           xlog=TRUE,
           #boxsize = .1,
           txt_gp = fpTxtGp(label = list(gpar(fontface = 1, cex=1.2),
                                         gpar(fontface = 1)),
                            ticks = gpar(fontfamily = "", cex=1),
                            xlab  = gpar(fontfamily = "", cex = 1)),
           xlab="F-measure values of the classifiers using different Variables Set",
           col=fpColors(box="royalblue",line="darkblue", summary="royalblue"))



# =============== ANOVA TEST ==================

boxplot(Fmeasure~Metrics)

# Ho = Mean f-measures is same for all the Classifiers

ANOVA1 <- aov(Fmeasure~Metrics)
ANOVA1

summary(ANOVA1)

attributes(ANOVA1)

# Pair wise comparison

TukeyHSD(ANOVA1)

# Visualize the pair wise comparison

plot(TukeyHSD(ANOVA1), las=1)

# Results of the test

# aov(formula = Fmeasure ~ Metrics)

#Terms:
#  Metrics Residuals
# Sum of Squares  4179.164  4717.012
# Deg. of Freedom        6        32

# Summary of Resutls
#              Df  Sum Sq  Mean Sq  F value  Pr(>F)   
# Metrics      6   4179    696.5    4.725    0.0015 **
# Residuals   32   4717    147.4                  
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1


# ==============================================

# =============== Kruskal Wallis TEST ==================

# For kruskal test convert the textual names to factor

metricsfactor <- as.factor(Metrics)

print(metricsfactor)

kruskal <- kruskal.test(Fmeasure~metricsfactor)

kruskal

attributes(kruskal)

summary(kruskal)


# Kruskal-Wallis rank sum test

# data:  Fmeasure by metricsfactor
# Kruskal-Wallis chi-squared = 21.038, df = 6, p-value = 0.001806



#======================================================


