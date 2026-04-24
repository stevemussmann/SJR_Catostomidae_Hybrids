library("ggplot2")

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

data <- read.table("mtdna.txt", header=TRUE)

cbPalette6 <- c("#0072B2", "#999999", "#F0E442", "#D55E00", "#CC79A7", "#000000")

mtdnaPlot <- ggplot(data=data, mapping=aes(x=anc, y=cnt, fill=dna)) + 
  geom_bar(position="fill", stat="identity") + 
  facet_grid(~ gen, scales = "free", space = "free") +
  scale_fill_manual(values=cbPalette6, labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)},name="mtDNA") + 
  scale_x_discrete(labels=function(x){ x=gsub("\\d{1}\\-", "", x, fixed=FALSE); gsub("_", " ", x, fixed=TRUE)}) +
  theme(text=element_text(size=14),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle=-30, hjust = 0),
        axis.text = element_text(size=12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold", hjust = 0.5),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14, face = "bold")
        ) +
  xlab("Ancestry Category") + ylab("Proportion") + ggtitle("mtDNA Haplotypes per Ancestry Category")

mtdnaPlot

ggsave("mtdna_haplotypes.png", dpi = 600)
save_plot("mtdna_haplotypes.svg", plot = mtdnaPlot, base_height = 6.92, base_width = 10)
