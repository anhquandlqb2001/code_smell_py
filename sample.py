import PythonMeta as PMA
import matplotlib.pyplot as plt


def showstudies(studies, dtype):
    # show dichotomous data
    text = "%-10s %-20s %-20s \n" % ("Study ID",
                                     "Experiment Group", "Control Group")
    text += "%-10s %-10s %-10s %-10s %-10s \n" % (" ", "e1", "n1", "e2", "n2")
    for i in range(len(studies)):
        text += "%-10s %-10s %-10s %-10s %-10s \n" % (
            studies[i][4],  # study ID
            str(studies[i][0]),  # event num of group1
            str(studies[i][1]),  # total num of group1
            str(studies[i][2]),  # event num of group2
            str(studies[i][3])  # total num of group2
        )
    return text


def showresults(rults):
    text = "%-10s %-6s  %-18s %-10s" % ("Study ID",
                                        "n", "ES[95% CI]", "Weight(%)\n")
    for i in range(1, len(rults)):
        text += "%-10s %-6d  %-4.2f[%.2f %.2f]   %6.2f\n" % (   # for each study
            rults[i][0],  # study ID
            rults[i][5],  # total num
            rults[i][1],  # effect size
            rults[i][3],  # lower of CI
            rults[i][4],  # higher of CI
            100*(rults[i][2]/rults[0][2])  # weight
        )
    text += "%-10s %-6d  %-4.2f[%.2f %.2f]   %6d\n" % (         # for total effect
        rults[0][0],  # total effect size name
        rults[0][5],  # total N (all studies)
        rults[0][1],  # total effect size
        rults[0][3],  # total lower CI
        rults[0][4],  # total higher CI
        100
    )
    text += "%d studies included (N=%d)\n" % (len(rults)-1, rults[0][5])
    text += "Heterogeneity: Tau\u00b2=%.3f " % (
        rults[0][12]) if not rults[0][12] == None else "Heterogeneity: "
    text += "Q(Chisquare)=%.2f(p=%s); I\u00b2=%s\n" % (
        rults[0][7],  # Q test value
        rults[0][8],  # p value for Q test
        str(round(rults[0][9], 2))+"%")  # I-square value
    # z-test value and p-value
    text += "Overall effect test: z=%.2f, p=%s\n" % (
        rults[0][10], rults[0][11])

    return text


def main(stys, settings):
    d = PMA.Data()  # Load Data class
    m = PMA.Meta()  # Load Meta class
    f = PMA.Fig()  # Load Fig class

    # You should always tell the datatype first!!!
    # set data type, 'CATE' for binary data or 'CONT' for continuous data
    d.datatype = settings["datatype"]
    studies = d.getdata(stys)  # load data
    # studies = d.getdata(d.readfile("studies.txt"))  #get data from a data file, see examples of data files
    print(showstudies(studies, d.datatype))  # show studies

    m.datatype = d.datatype  # set data type for meta-analysis calculating
    m.models = settings["models"]  # set effect models: 'Fixed' or 'Random'
    # set algorithm, based on datatype and effect size
    m.algorithm = settings["algorithm"]
    # set effect size:RR/OR/RD for binary data; SMD/MD for continuous data
    m.effect = settings["effect"]
    results = m.meta(studies)  # performing the analysis
    print(m.models + " " + m.algorithm + " " + m.effect)
    print(showresults(results))  # show results table
    f.forest(results).show()  # show forest plot
    f.funnel(results).show()  # show funnel plot


if __name__ == '__main__':

    # samp_cate = [
    #     "SVM 0.6211666666666668, 0.7269401488264567, 0.5153931845068768",
    #     "Decision Tree 0.8331703703703703, 0.9029347981632785, 0.7634059425774623",
    #     "Naive Bayes 0.5650814814814816, 0.6581175662078189, 0.47204539675514423",
    #     "Random Forest 0.9319399999999999, 0.9674561018166902, 0.8964238981833096",
    #     "JRip 0.9657555555555557, 0.9865396033475249, 0.9449715077635865",
    #     "<subgroup>name=medium term",
    #     "#<nototal>",
    #     "",
    #     "#This is a sample of continuous data.",
    #     "#Input one study in a line;",
    #     "#Syntax: study name, m1, sd1, n1, m2, sd2, n2",
    #     "#m1, sd1, n1: mean, SD and number of experiment group;",
    #     "#m2, sd2, n2: mean, SD and number of control group."
    # ]

    samp_cate = [
        "Fang 2015.12312,15,40,24,37",
        "Gong 2012,10,40,18,35",
        "Liu 2015,30,50,40,50",
        "Long 2012,19,40,26,40",
        "Wang 2003,7,86,15,86",
        "Chen 2008,20,60,28,60",
        "Guo 2014,31,51,41,51",
        "Li 2015,29,61,31,60",
        "Yang 2006,21,40,31,40",
        "Zhao 2012,27,40,30,40",
    ]
print("--------------------")
print(samp_cate)
print("--------------------")

# sample 1: dichotomous data
settings = {"datatype": "CATE",  # for CATEgorical/count/binary/dichotomous data
            "models": "Fixed",  # models: Fixed or Random
            "algorithm": "MH",  # algorithm: MH, Peto or IV
            "effect": "RR"}  # effect size: RR, OR, RD
main(samp_cate, settings)

plt.show()
