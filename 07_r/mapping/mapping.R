library("tidyverse")
library("ggplot2")

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

data <- read.csv("mappingData.txt", sep='\t', header=TRUE)

include <- c("Cdis","Clat","Xtex")

filtered <- data %>% filter(Hybrid_Classification %in% include)

ggplot(filtered, aes(x=Hybrid_Classification, y=map_pct, fill=reference)) +
  geom_boxplot() + #facet_wrap(~Hybrid_Classification, space = "free_x") +
  xlab("Species") + ylab("% Reads Mapped") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle=-30, hjust = 0),
        axis.text = element_text(size=12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14, face = "bold")
  ) + scale_fill_discrete(name = "Reference Genome")

ggsave("pctMappedByReference.png", dpi = 300)

visID <- data %>% filter(reference == "Xtex")

ggplot(filtered, aes(x=visual_id, y=map_pct)) +
  geom_boxplot() + #facet_wrap(~Hybrid_Classification, space = "free_x") +
  xlab("Species") + ylab("% Reads Mapped") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text.x = element_text(angle=-30, hjust = 0),
        axis.text = element_text(size=12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold"),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 14, face = "bold")
  ) + scale_fill_discrete(name = "Reference Genome") +
  scale_x_discrete(labels = function(x) gsub("_", " ", x))
ggsave("pctMappedByVisID.png", dpi = 600)
