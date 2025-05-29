library("ClineHelpR")

prefix="dx2003"
plotDIR="./plots"

# make sure lnl files are changed to LnL (case sensitive) before running command
bgc.genes <- combine_bgc_output(results.dir = "./", prefix = prefix)

# Plot the likelihood and parameter traces
# showPLOTS=TRUE prints the plots to the screen
plot_traces(df.list = bgc.genes, prefix = prefix, plotDIR = plotDIR, showPLOTS=TRUE)

gene.outliers <-
  get_bgc_outliers(
    df.list = bgc.genes, # object returned from combine_bgc_output()
    admix.pop = "Admix", # Admixed population
    popmap = "dx2003_bgc_map.txt", # popmap file path
    loci.file = "dx2003_loci.txt", # optional; loci file path; gets generated in vcf2bgc.py; optional (but required for ideograms)
    qn = 0.975)
write.table(gene.outliers[[1]], file="dx2003_rerun.txt", sep="\t", quote=FALSE)

ab.range <-
  data.frame(
    "full.alpha" = c(
      "min" = min(gene.outliers[[1]]$alpha),
      "max" = max(gene.outliers[[1]]$alpha)
    ),
    "full.beta" = c(
      "min" = min(gene.outliers[[1]]$beta),
      "max" = max(gene.outliers[[1]]$beta)
    ),
    "genes.alpha" = c(
      "min" = min(gene.outliers[[1]]$alpha),
      "max" = max(gene.outliers[[1]]$alpha)
    ),
    "genes.beta" = c(min(gene.outliers[[1]]$beta), max(gene.outliers[[1]]$beta))
  )

phiPlot(
  outlier.list = gene.outliers,
  popname = paste0("FMS", " RBS"),
  line.size = 0.35,
  saveToFile = paste0(prefix, "_genes"),
  plotDIR = plotDIR,
  showPLOTS = TRUE,
  both.outlier.tests = FALSE,
  neutral.color = "gray60",
  alpha.color = "#33a02c",
  beta.color = "#ff7f00",
  both.color = "#6a3d9a",
  hist.y.origin = 1.2,
  hist.height = 1.8,
  margins = c(160.0, 5.5, 5.5, 5.5),
  hist.binwidth = 0.05
)


alphaBetaPlot(
  gene.outliers,
  both.outlier.tests = FALSE,
  alpha.color = "#33a02c",
  beta.color = "#ff7f00",
  neutral.color = "gray60",
  saveToFile = prefix,
  plotDIR = "./plots",
  showPLOTS = TRUE,
  padding = 0.5,
)
