library("ggplot2")
library("cowplot")
library("patchwork")
library("dplyr")

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# read data
data <- read.csv("hybridProportions.txt", header=TRUE, sep='\t')
dataAP <- read.csv("ancestryProportions.txt", header=TRUE, sep='\t')

# filter groups by age class
adult <- data %>% filter(Age_Class == "Adult")
age1 <- data %>% filter(Age_Class == "Age_1+")
juvenile <- data %>% filter(Age_Class == "Juvenile")
larvae <- data %>% filter(Age_Class == "Larvae")

cbPalette <- c("#0072B2", "#999999", "#F0E442", "#009E73", "#E69F00", "#D55E00", "#56B4E9", "#CC79A7")

makePlot <- function(df, plotName){
  plt <- ggplot(df, aes(fill=Ancestry_Class, y=Count, x=Visual_ID)) +
    geom_bar(position="fill", stat="identity") +
    scale_fill_manual(values=cbPalette, labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)},name="Ancestry Class") + 
    scale_x_discrete(labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)}) +
    ggtitle(plotName) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text.x = element_text(angle=-30, hjust = 0),
          axis.text = element_text(size=12),
          axis.title = element_text(size = 14),
          plot.title = element_text(size = 16, face = "bold"),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 14, face = "bold")
    ) + ylab("Proportion")
  
  return(plt)
}

adultPlot <- makePlot(adult, "Adult") + theme(legend.position = "none") + theme(axis.text.x = element_blank()) + xlab("")
age1Plot <- makePlot(age1, "Age 1+") + theme(legend.position = "none") + theme(axis.text.x = element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")
juvenilePlot <- makePlot(juvenile, "Juvenile") + theme(legend.position = "none") + xlab("Visual ID")
larvaePlot <- makePlot(larvae, "Larvae")

# get legend
legend <- get_legend(larvaePlot)
larvaePlot <- larvaePlot + theme(legend.position = "none", axis.text.y = element_blank()) + xlab("Visual ID") + ylab("")

# dummy plot to take up space
dummy <- ggplot() + theme_void()

(adultPlot | age1Plot | legend) / (juvenilePlot | larvaePlot | dummy)
p <- (adultPlot | age1Plot | legend) / (juvenilePlot | larvaePlot | dummy)

ggsave("ancestry_proportions.png", dpi = 300)
save_plot("ancestry_proportions.svg", plot = p, base_height = 6.92, base_width = 10)

newLabels <- c(
  '1-BHS'="BHS",
  '2-FMS'="FMS",
  '3-RBS'="RBS",
  '4-FMS_x_RBS'="FMS x RBS",
  '5-Catostomidae'="Catostomidae"
)

apPlot <- ggplot(data=dataAP, mapping=aes(x=Age_Class, y=Count, fill=Ancestry_Class)) + 
  geom_bar(position="fill", stat="identity") + 
  facet_grid(~ Visual_ID, scales = "free", space = "free", labeller=labeller(Visual_ID = newLabels)) +
  scale_fill_manual(values=cbPalette, labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)},name="Ancestry") + 
  scale_x_discrete(labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)}) +
  theme(text=element_text(size=14),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle=-30, hjust = 0),
        axis.text = element_text(size=14),
        axis.title = element_text(size = 16),
        plot.title = element_text(size = 18, face = "bold", hjust = 0.5),
        legend.text = element_text(size = 14),
        legend.title = element_text(size = 16, face = "bold")
  ) +
  xlab("Age Class") + ylab("Proportion") + ggtitle("Ancestry Proportions")

apPlot
ggsave("ancestryProportionsFacetGrid.png", dpi = 600, width = 10, height = 6.92)
save_plot("ancestryProportionsFacetGrid.svg", plot = apPlot, base_height = 6.92, base_width = 10)
