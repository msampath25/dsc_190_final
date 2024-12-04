library(data.table)
library(irlba)
  
  args <- commandArgs(trailingOnly = TRUE)
  exp_f = args[1]
  out_f = args[2]
  
  exp = fread(exp_f)
  samples <- exp[[1]]
  exp = data.frame(exp)[,2:length(colnames(exp))]
  rownames(exp) = samples
  
  print(paste(exp_f,dim(exp)[1]))
  exp = as.data.frame(scale(exp))
  irlba_result<- irlba(as.matrix(exp), nv = 10)
  expcs = irlba_result$u
  eigenvalues <- irlba_result$d^2
  
#   rownames(expcs) = lapply(rownames(exp), function(x)(paste(x,' ',x)))
  expcs = cbind(rownames(exp), rownames(exp), expcs)

  write.table(expcs,file = paste(out_f,'.eigenvec',sep=''),sep=' ',quote = F, col.names = F, row.names = F)
  write.table(eigenvalues,file = paste(out_f,'.eigenval',sep=''),quote = F, col.names = F, row.names = F)