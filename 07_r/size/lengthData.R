library(ggplot2)
library(patchwork)
library(scales)
library(tidyverse)

lengthData <- read.table("clat_xtex_lengthData.txt", header=TRUE, sep="\t")

dlengthData <- data.frame(lengthData)


myColors <- c("FMS" = "#999999", "RBS" = "#F0E442", "1" = "#009E73", "2" = "#E69F00", "3" = "#56B4E9")
custom_colors <- scale_fill_manual(drop=TRUE, name = "Hybrid Generations", values = myColors)

dlengthData$Hybrid_Generation2<-factor(dlengthData$Hybrid_Generation2, levels = c(
  "FMS",
  "RBS",
  "1",
  "2",
  "3"
  )
)
pAll <- ggplot(dlengthData, aes(x=TL, fill=Hybrid_Generation2)) + 
  geom_histogram(position="stack", binwidth=10) + custom_colors +
  theme(axis.text = element_text(size=14), legend.position=c(0.9,0.8), legend.background = element_rect(fill="white", size=0.5, linetype="solid", color="black"), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(vjust = -8, hjust=0.1, size=20))
pAll

# set bins for presenting data
lengths = seq(from = 0, to = 650, by = 30)
labs = lengths[-1]

df <- dlengthData %>% as_tibble() %>% mutate(bin = cut(TL, breaks = lengths,labels=labs)) %>% arrange(TL) 

df <- df %>% mutate_at(vars(bin), factor)
df
df <- as.data.frame(df %>% group_by(bin, Hybrid_Generation2) %>% count() %>% ungroup() %>% group_by(bin) %>%
                      mutate(ttl = sum(n), pct_ttl = n / ttl) %>%
                      ungroup() )

write_csv(df, "table.csv")

df <- read.table("table.csv", header=TRUE, sep=",")

custom_col_line <- scale_color_manual(drop=TRUE, limits = levels(dlengthData$Hybrid_Generation2), name = "Ancestry", values = myColors)
myTheme <- theme(legend.position="none", panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(vjust = -8, hjust=0.1))

pProp <- ggplot(df, aes(x=bin, y=pct_ttl, group=Hybrid_Generation2)) + 
  geom_line(aes(color=Hybrid_Generation2), size=1) +
  geom_point(aes(shape=Hybrid_Generation2, color=Hybrid_Generation2), size=3) +
  scale_color_manual(values=myColors) +
  scale_y_continuous(labels=scales::percent) + 
    theme(axis.text = element_text(size=14), 
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(vjust = -8, hjust=0.1, size=20)) +
  theme(legend.title = element_blank(), text=element_text(size=18),
                          axis.text.x=element_text(angle=30, hjust=1),
                          plot.title = element_text(vjust = -8, hjust=0.01, size=20),
                          axis.title=element_text(size=18)) + xlab("Total Length (mm)") + ylab("Percent")
pProp
ggsave("clat_xtex_lengthData.png", device="png", dpi=600)
ggsave("clat_xtex_lengthData.svg", device="svg", dpi=600)

df1 <- filter(df, n>0)
myTheme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(vjust = -8, hjust=0.1))

pProp <- ggplot(df1, aes(x=bin, y=n, fill=Hybrid_Generation2)) +
  geom_bar(position="fill", stat="identity")+
  scale_fill_manual(values=myColors) +
  scale_x_continuous(n.breaks=12 + myTheme) +
  scale_y_continuous(labels=scales::percent) +
  theme(axis.text = element_text(size=14), #legend.position = "none",
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), axis.line = element_line(colour = "black"), plot.title = element_text(vjust = -8, hjust=0.1, size=20)) +
  theme(text=element_text(size=18),
        plot.title = element_text(vjust = -8, hjust=0.01, size=20),
        axis.title=element_text(size=18)) + xlab("Total Length (mm)") + ylab("Percent")
pProp
ggsave("clat_xtex_lengthData_stacked_proportion.png", device="png", dpi=600)
