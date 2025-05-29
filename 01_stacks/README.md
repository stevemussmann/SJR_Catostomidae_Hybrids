# Raw data processing with Stacks, Bowtie2, and fastp

## 1. process_radtags

Illumina fastq files were initially demultiplexed using the process_radtags module of Stacks v2.64. See `process_radtags.slurm`. All barcode files are in the `barcodes/` subdirectory.

## 2. fastp

fastp was used to trim reads to remove the first 8 bases of each read (including the restriction cut site region) and trim all reads to a standard length. Poly-g sequences and Illumina adapter sequences were also removed. See `fastp.slurm`

## 3. bowtie2

Reads were aligned to the Razorback Sucker reference genome. See `bowtie2.ddrad.slurm`

## 4. gstacks

Aligned reads were processed in gstacks module of Stacks v2.64. See `stacks.slurm`. The file `dx2003_map.txt` was used as input for gstacks.

## 5. populations

The populations module of Stacks v2.64 was used to do initial filtering (see `populations.slurm`) and dx2003_map.txt contained the list of samples processed.

populations was also used to recover a set group of loci for the Bayesian Genomic Cline analysis (list contained in `bgc_whitelist.txt`). See `populations.bgc.slurm`.
