library("tidyverse")
library("ggplot2")
library("patchwork")
library("cowplot")

# set working directory in Rstudio
setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# function to parse input files
parseFiles <- function(namefile, qfile, Qfile){
  names <- read.csv(namefile, header=FALSE)
  q<-read.csv(qfile, header=TRUE)
  Q<-read.csv(Qfile, header=TRUE)
  
  q_filt <- q %>% filter(str_detect(param, "pop_0"))
  Q_filt <- Q %>% filter(str_detect(param, "_anc_2-1"))
  
  qNamed <- bind_cols(as.data.frame(q_filt), as.data.frame(names))
  QNamed <- bind_cols(as.data.frame(Q_filt), as.data.frame(names))
  
  qNamed <- rename(qNamed, qparam = param, qmean = mean, qmed = median, qci_0.950_LB = ci_0.950_LB, qci_0.950_UB = ci_0.950_UB, name = V1)
  QNamed <- rename(QNamed, Qparam = param, Qmean = mean, Qmed = median, Qci_0.950_LB = ci_0.950_LB, Qci_0.950_UB = ci_0.950_UB, name = V1)
  
  qQ <- left_join(qNamed, QNamed, by = "name")
  
  return(qQ)
  
}

# read the input files
CDFMqQ <- parseFiles("Cdis_x_Clat.pl.names.txt", "Cdis_x_Clat.admixest.txt", "Cdis_x_Clat.Q12.txt") # cdis x clat
CDXTqQ <- parseFiles("Cdis_x_Xtex.pl.names.txt", "Cdis_x_Xtex.admixest.txt", "Cdis_x_Xtex.Q12.txt") # cdis x xtex
FMXTqQ <- parseFiles("Clat_x_Xtex.pl.names.txt", "Clat_x_Xtex.admixest.txt", "Clat_x_Xtex.Q12.txt") # Clat x xtex

CDXTqQ <- CDXTqQ %>% mutate(qmean = 1-qmean) # entropy flipped x-axis values for CDxXT; this keeps CD in lower left and XT in lower right corners of triangle to keep consistency with other plots

# assign entropy classifications
assignHyb <- function(df, sp1, sp2){
  SP1BX <- paste0(sp1, "_Bx")
  SP2BX <- paste0(sp2, "_Bx")
  # for plotting
  df <- df %>%
    mutate(Ancestry = case_when(
        qmean > 0.4 & qmean < 0.6 & Qmean > 0.75 ~ "F1",
        qmean > 0.4 & qmean < 0.6 & Qmean < 0.75 & Qmean > 0.25 ~ "F2",
        #qmean > 0.15 & qmean < 0.35 & Qmean < 0.75 & Qmean > 0.25 ~ SP1BX,
        #qmean > 0.65 & qmean < 0.85 & Qmean < 0.75 & Qmean > 0.25 ~ SP2BX,
        qmean > 0.15 & qmean < 0.35 & Qmean < 0.75 & Qmean > 0.25 ~ "Bx",
        qmean > 0.65 & qmean < 0.85 & Qmean < 0.75 & Qmean > 0.25 ~ "Bx",
        qmean < 0.10 & Qmean < 0.10 ~ sp1,
        qmean > 0.90 & Qmean < 0.10 ~ sp2,
        TRUE ~ "Unclassified"
      )
    )
  # for counting backcrosses
  df <- df %>%
    mutate(entropy = case_when(
      qmean > 0.4 & qmean < 0.6 & Qmean > 0.75 ~ "F1",
      qmean > 0.4 & qmean < 0.6 & Qmean < 0.75 & Qmean > 0.25 ~ "F2",
      qmean > 0.15 & qmean < 0.35 & Qmean < 0.75 & Qmean > 0.25 ~ SP1BX,
      qmean > 0.65 & qmean < 0.85 & Qmean < 0.75 & Qmean > 0.25 ~ SP2BX,
      qmean < 0.10 & Qmean < 0.10 ~ sp1,
      qmean > 0.90 & Qmean < 0.10 ~ sp2,
      TRUE ~ "Unclassified"
    )
    )
  return(df)
}

# assign hybrids from entropy results
CDFMqQ <- assignHyb(CDFMqQ, "BHS", "FMS")
CDXTqQ <- assignHyb(CDXTqQ, "BHS", "RBS")
FMXTqQ <- assignHyb(FMXTqQ, "FMS", "RBS")

# dump entropy results to csv
write_csv(CDFMqQ, "CDFMqQ.csv")
write_csv(CDXTqQ, "CDXTqQ.csv")
write_csv(FMXTqQ, "FMXTqQ.csv")

# left line of triangle - for plotting
line_data1 <- data.frame(
  x_start = -0.01,
  y_start = 0.0,
  x_end = 0.50,
  y_end = 1.01
)

# right line of triangle - for plotting
line_data2 <- data.frame(
  x_start = 1.01,
  y_start = 0.0,
  x_end = 0.50,
  y_end = 1.01
)


cbPalette <- c("BHS" = "#0072B2", "FMS" = "#999999", "RBS" = "#F0E442", "F1" = "#009E73", "Bx" = "#E69F00", "F2" = "#D55E00", "Unclassified" = "#56B4E9")#, "RBS_Bx" = "#CC79A7")

# function for producing the triangle plot. qQ = output of parseFiles function; ll = label lower left corner; lr = label lower right corner; title = plot title
trianglePlot <- function(qQ, ll, lr, title){
  plt <- ggplot(data = qQ, aes(x = qmean, y = Qmean)) + 
    geom_point(aes(color=Ancestry)) +
    scale_color_manual(values=cbPalette) +
    #geom_point(color="blue") +
    geom_segment(data = line_data1, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
                 color = "black", linewidth = 0.5) +
    geom_segment(data = line_data2, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
                 color = "black", linewidth = 0.5) +
    xlim(-0.02, 1.02)+
    ylim(-0.02, 1.02) +
    annotate("text", x=0.1, y=0.02, label = ll, fontface = "bold", size = 4) +
    annotate("text", x=0.9, y=0.02, label = lr, fontface = "bold", size = 4) +
    theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
          panel.background = element_blank(), axis.line = element_line(colour = "black"),
          axis.text = element_text(size=12),
          axis.title = element_text(size = 14),
          plot.title = element_text(size = 16, face = "bold"),
          legend.position = c(1, 1),
          legend.justification = c(1,1),
          legend.text = element_text(size = 12),
          legend.title = element_text(size = 14, face = "bold"),
          legend.background = element_rect(fill = "transparent")
          ) +
    ylab(expression(bold("Q" ["12"]))) +
    xlab(expression(bold("q"))) + ggtitle(title)
  
  
  return(plt)
}

# make data plots
bhsXfms.plot <- trianglePlot(CDFMqQ, "BHS", "FMS", "B.") + theme(axis.text.x = element_blank(), axis.text.y = element_blank()) + xlab("") + ylab("")
bhsXrbs.plot <- trianglePlot(CDXTqQ, "BHS", "RBS", "C.")
fmsXrbs.plot <- trianglePlot(FMXTqQ, "FMS", "RBS", "D.") + theme(axis.text.y = element_blank()) + ylab("")

# make dummy plot
dummy.plot <- ggplot(data = CDFMqQ, aes(x = qmean, y = Qmean)) + 
  geom_segment(data = line_data1, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "black", linewidth = 0.5) +
  geom_segment(data = line_data2, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "black", linewidth = 0.5) +
  xlim(-0.02, 1.02)+
  ylim(-0.02, 1.02) +
  annotate("text", x=0.12, y=0.02, label = "Species A", fontface = "bold", size = 4) +
  annotate("text", x=0.88, y=0.02, label = "Species B", fontface = "bold", size = 4) +
  annotate("text", x=0.5, y=0.08, label = "Historical", fontface = "bold", size = 4) +
  annotate("text", x=0.5, y=0.02, label = "Hybridization", fontface = "bold", size = 4) +
  annotate("text", x=0.5, y=0.94, label = "F1", fontface = "bold", size = 4) +
  annotate("text", x=0.5, y=0.5, label = "F2", fontface = "bold", size = 4) +
  annotate("text", x=0.5, y=0.25, label = "F3", fontface = "bold", size = 4) +
  annotate("text", x=0.2, y=0.5, label = "Species A Bx", fontface = "bold", size = 4, angle = 60) +
  annotate("text", x=0.8, y=0.5, label = "Species B Bx", fontface = "bold", size = 4, angle = -60) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), axis.line = element_line(colour = "black"),
        axis.text = element_text(size=12),
        axis.title = element_text(size = 14),
        plot.title = element_text(size = 16, face = "bold")) +
  ylab(expression(bold("Q" ["12"]))) +
  xlab(expression(bold("q"))) +
  ggtitle("A.")

# blank out x axis for inclusion in multipanel plot
dummy.plot <- dummy.plot + theme(axis.text.x = element_blank()) + xlab("")

# patchwork multipanel plot
((dummy.plot | bhsXfms.plot) / (bhsXrbs.plot | fmsXrbs.plot))
p <- ((dummy.plot | bhsXfms.plot) / (bhsXrbs.plot | fmsXrbs.plot))

# save final plot
ggsave("entropy_4panel.png", dpi = 600, units = "in", width = 10, height = 9.2)
save_plot("entropy_4panel.svg", plot = p, base_height = 9.2, base_width = 10)
