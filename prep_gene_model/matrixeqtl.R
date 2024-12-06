library(MatrixEQTL);
library(plink2R)
library(data.table)

##################################################################
# Arguments:

if (!requireNamespace("optparse", quietly = TRUE)) {
  install.packages("optparse")
}
library(optparse)

# Define command-line arguments
option_list <- list(
  make_option(c("--bfile"), type = "character", help = "Path to the PLINK binary file prefix (without extensions)"),
  make_option(c("--gene"), type = "character", help = "Gene name or file path"),
  make_option(c("--covar"), type = "character", help = "Path to the covariates file"),
  make_option(c("--pval"), type = "double", default = 1e-2, help = "P-value threshold for MatrixEQTL (default: 1e-2)"),
  make_option(c("--out"), type = "character", help = "Output file prefix")
)

# Parse command-line arguments
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check if required arguments are provided
if (is.null(opt$bfile) || is.null(opt$gene) || is.null(opt$out)) {
  print_help(opt_parser)
  stop("[FAILED] Arguments (--bfile, --gene, --out) are required.")
}

# Example workflow using the parsed arguments
# Replace the following lines with your specific logic
cat("Reading PLINK dataset from:", opt$bfile, "\n")
cat("Processing gene information from:", opt$gene, "\n")
cat("Using covariates from:", opt$covar, "\n")
cat("Using p-value threshold from:", opt$pval, "\n")
cat("Saving results to:", opt$out, "\n")

##################################################################

gt = read_plink(opt$bfile)
snps = gt$bed
if (is.null(snps)){
  snps = gt$X
}
gt_samples = gt$fam$V1

if (!is.null(opt$covar)){
  cvrt = fread(opt$covar)
  if (all(cvrt$V1 != gt_samples) && all(cvrt$V2 != gt_samples)){
    stop("[FAILED] Covariate file samples don't match genotype samples")
  }
  else{
    cat("[PASSED] Covariate file samples match genotype samples\n")
  }
  cvrt = cvrt[,3:ncol(cvrt)]
}

ge = fread(opt$gene, header = T)
ge_samples = ge$V1
ge = ge[,2:ncol(ge)]

common_samples = intersect(ge_samples,gt_samples)
ge2common_samples = c(match(common_samples,ge_samples))
ge = ge[,..ge2common_samples]

gt2common_samples = match(common_samples,gt_samples)
snps = snps[gt2common_samples,]

snp_slice <- SlicedData$new()
snp_slice$CreateFromMatrix(t(snps))

ge_slice = SlicedData$new();
ge_slice$CreateFromMatrix(t(ge))

cvrt_slice = SlicedData$new()
if (!is.null(opt$covar)){
  cvrt = cvrt[gt2common_samples,]
  cvrt_slice$CreateFromMatrix(t(cvrt))
}

cat("[PASSED] Slices made, now running eqtls \n")

eqtl_results <- Matrix_eQTL_main(
  snps = snp_slice,
  gene = ge_slice,
  cvrt = cvrt_slice,
  output_file_name = opt$out,
  pvOutputThreshold = opt$pval, 
  useModel = modelLINEAR,
  errorCovariance = numeric(),
  verbose = TRUE
)