
library(rmeta)
library(forestplot)
library(readxl)
#data(cochrane)

#View(cochrane)

wc_data <- read_excel("FPlot_analysis.xlsx", sheet = 3)

View(wc_data)
names(wc_data)
attach(wc_data)


steroid <- meta.MH(withintotal, crosstotal, WithinProject, CrossProject,
                   names=Study, data=wc_data)

#steroid1 <- meta.MH(n.trt, n.ctrl, ev.trt, ev.ctrl,
 #                  names=name, data=cochrane)


tabletext3<-cbind(c("Study",steroid$names,NA,"Summary"),
                 c("Within",WithinProject,NA, NA),
                 c("Cross", CrossProject,NA, NA),
                 c("OR",format(exp(steroid$logOR),digits=2),NA,format(exp(steroid$logMH),digits=2)))

m<- c(NA,steroid$logOR,NA,steroid$logMH)
l<- m-c(NA,steroid$selogOR,NA,steroid$selogMH)*2
u<- m+c(NA,steroid$selogOR,NA,steroid$selogMH)*2
forestplot(tabletext3,m,l,u,
           is.summary=c(TRUE,rep(FALSE,6),TRUE),
           clip=c(log(0.1),log(2.5)),
           xlog=TRUE,
           new_page = TRUE,
           digitsize=0.9,
           boxsize = 1,
           graphwidth = unit(3, "inches"),
           col=meta.colors(box="royalblue",
                           line="darkblue", summary="royalblue"))
