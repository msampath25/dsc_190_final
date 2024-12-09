gene_names = as.list(readLines("~/cis_done_genes.txt"))
models_dir = "~/lustre/DSC291/data/out/models"
models = c("baseline", "cis_epi_000", "cis_epi_001", "cis_epi_010", 
              "cis_epi_011", "cis_epi_100", "cis_epi_101", 
              "cis_epi_110", "cis_epi_111")

rsqs_enet_out <- "~/lustre/DSC291/data/out/gene_models_analaysis/r2_cis_enet.csv"
rsqs_lasso_out <- "~/lustre/DSC291/data/out/gene_models_analaysis/r2_cis_lasso.csv"
hsqs_out <- "~/lustre/DSC291/data/out/gene_models_analaysis/h2_cis.csv"
best_rsqs_enet_out <- "~/lustre/DSC291/data/out/gene_models_analaysis/r2_cis_enet_best_epi.csv"
best_hsqs_out <- "~/lustre/DSC291/data/out/gene_models_analaysis/h2_cis_best_epi.csv"


rsqs_lasso <- list()
rsqs_enet <- list()
hsqs <- list()
for (g in gene_names) {
    rsqs_g_lasso = rep(NA, 9)
    rsqs_g_enet = rep(NA, 9)
    hsqs_g = rep(NA, 9)
    for (i in seq_along(models)){
        model = models[i]
        file_path <- file.path(models_dir,model, paste0(g, ".wgt.RDat"))

        if (file.exists(file_path) && file.info(file_path)$size > 0) {
            # Load the RDat file
            x = load(file_path)
            rsqs_g_enet[i] = cv.performance["rsq", "enet"]
            rsqs_g_lasso[i] = cv.performance["rsq", "lasso"]
            hsqs_g[i] = hsq[1]
        }
    }
    rsqs_lasso[[g]] <- rsqs_g_lasso
    rsqs_enet[[g]] <- rsqs_g_enet
    hsqs[[g]] <- hsqs_g

}

rsqs_lasso_df <- do.call(rbind, rsqs_lasso)
rownames(rsqs_lasso_df) <- names(rsqs_lasso)
colnames(rsqs_lasso_df) <- models

rsqs_enet_df <- do.call(rbind, rsqs_enet)
rownames(rsqs_enet_df) <- names(rsqs_enet)
colnames(rsqs_enet_df) <- models
best_rsqs_enet = t(data.frame(apply(rsqs_enet_df[,2:9],1,function(x)(c(max(x,na.rm = T), models[1+which.max(x)])))))

hsqs_df <- do.call(rbind, hsqs)
rownames(hsqs_df) <- names(hsqs)
colnames(hsqs_df) <- models
best_hsqs = t(data.frame(apply(hsqs_df[,2:9],1,function(x)(c(max(x,na.rm = T), models[1+which.max(x)])))))


write.csv(rsqs_enet_df, file = rsqs_enet_out, row.names = TRUE, quote = F)
write.csv(rsqs_lasso_df, file = rsqs_lasso_out, row.names = TRUE, quote = F)
write.csv(hsqs_df, file = hsqs_out, row.names = TRUE, quote = F)
write.csv(best_rsqs_enet, file = best_rsqs_enet_out, quote = F)
write.csv(best_hsqs, file = best_hsqs_out, quote = F)
cat("Results successfully saved to: ", rsqs_enet_out, " ; ", rsqs_lasso_out, " ; ", hsqs_out, " ; ", best_rsqs_enet_out, " ; ", best_hsqs_out, "\n")