library(RIdeogram)

rbskaryotype <- read.table("rbs.karyotype", sep="\t", header=TRUE)
outliercoords <- read.table("coords.txt", sep="\t", header=TRUE)
alphacoords <- read.table("alpha.txt", sep="\t", header=TRUE)
betacoords <- read.table("beta.txt", sep="\t", header=TRUE)

#ideogram(karyotype = rbskaryotype, label=outliercoords, label_type="marker")
#convertSVG("chromosome.svg", device = "png", dpi=600)

ideogram(karyotype = rbskaryotype, overlaid=alphacoords, output="alpha.svg", label=outliercoords, label_type="marker")
convertSVG("alpha.svg", file="alpha", device = "png", dpi=600)
convertSVG("alpha.svg", file="alpha", device = "pdf", dpi=600)

ideogram(karyotype = rbskaryotype, overlaid=betacoords, output="beta.svg", label=outliercoords, label_type="marker")
convertSVG("beta.svg", file="beta", device = "png", dpi=600)
convertSVG("beta.svg", file="beta", device = "pdf", dpi=600)
