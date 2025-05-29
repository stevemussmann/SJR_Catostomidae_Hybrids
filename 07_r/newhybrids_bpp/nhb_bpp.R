library(ggplot2)
library(patchwork)

cdisxclat<-read.csv("cdis_x_clat_newhybrids_bpp.txt", header=TRUE, sep="\t")
cdisxxtex<-read.csv("cdis_x_xtex_newhybrids_bpp.txt", header=TRUE, sep="\t")
clatxxtex<-read.csv("clat_x_xtex_newhybrids_bpp.txt", header=TRUE, sep="\t")

myTheme <- theme(legend.position="none", panel.grid.major = element_blank(), 
                 axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
                 panel.grid.minor = element_blank(), 
                 panel.background = element_blank(), 
                 axis.line = element_line(colour = "black"), 
                 plot.title = element_text(hjust=0.5, face="bold"),
                 text=element_text(size=14)) 


pCdisxClat <- ggplot(cdisxclat, aes(x=cat, y=bpp)) +
  geom_boxplot() + ylim(c(0.0,1.0)) +
  myTheme + ggtitle("A") + xlab("") + ylab("BPP") +
  scale_x_discrete(labels=function(x){ x=gsub("_X_", " x ", x, fixed=TRUE); gsub("Bx", " Bx", x, fixed=TRUE)})

pCdisxXtex <- ggplot(cdisxxtex, aes(x=cat, y=bpp)) +
  geom_boxplot() + ylim(c(0.0,1.0))+
  myTheme + ggtitle("B") + xlab("") + ylab("") +
  scale_x_discrete(labels=function(x){ x=gsub("_X_", " x ", x, fixed=TRUE); gsub("Bx", " Bx", x, fixed=TRUE)})

pClatxXtex <- ggplot(clatxxtex, aes(x=cat, y=bpp)) +
  geom_boxplot() + ylim(c(0.0,1.0))+
  myTheme + ggtitle("C") + ylab("BPP") + xlab("Hybrid Category") +
  scale_x_discrete(labels=function(x){ x=gsub("_X_", " x ", x, fixed=TRUE); gsub("Bx", " Bx", x, fixed=TRUE)})

(pCdisxClat | pCdisxXtex) / pClatxXtex

ggsave("newhybrids_bpp.png", device="png", dpi=600)
