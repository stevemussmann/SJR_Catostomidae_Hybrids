library(RIdeogram)

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

rbskaryotype <- read.table("rbs.karyotype", sep="\t", header=TRUE)
outliercoords <- read.table("coords_lowerCI.txt", sep="\t", header=TRUE)
alphacoords <- read.table("alpha_lowerCI.txt", sep="\t", header=TRUE)
betacoords <- read.table("beta_lowerCI.txt", sep="\t", header=TRUE)
allcoords <- read.table("coords_lowerCI_all.txt", sep="\t", header=TRUE)

ideogram(karyotype = rbskaryotype, label=outliercoords, label_type="marker", output="chromosome.svg")
convertSVG("chromosome.svg", device = "png", dpi=600)

ideogram(karyotype = rbskaryotype, label=allcoords, label_type="marker", output="allLoci.svg")
convertSVG("allLoci.svg", device = "png", dpi=600)

ideogram(karyotype = rbskaryotype, overlaid=alphacoords, output="alpha.svg", label=outliercoords, label_type="marker")
convertSVG("alpha.svg", file="alpha", device = "png", dpi=600)
#convertSVG("alpha.svg", file="alpha", device = "pdf", dpi=600)

ideogram(karyotype = rbskaryotype, overlaid=betacoords, output="beta.svg", label=outliercoords, label_type="marker")
convertSVG("beta.svg", file="beta", device = "png", dpi=600)
#convertSVG("beta.svg", file="beta", device = "pdf", dpi=600)
