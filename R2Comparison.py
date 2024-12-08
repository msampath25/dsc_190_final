# %%
import pandas as pd
import matplotlib.pyplot as plt

trans_data = pd.read_csv('/Users/marcosanchez/DSC 190 project/trans_snpcounts_gene_by_bin.csv', sep='\t')
cis_data = pd.read_csv('/Users/marcosanchez/DSC 190 project/cis_snpcounts_gene_by_bin.csv', sep='\t')

# Scatterplot data
trans_baseline = trans_data['Baseline']
trans_best_r2 = trans_data.iloc[:, 2:].max(axis=1)

cis_baseline = cis_data['Baseline']
cis_best_r2 = cis_data.iloc[:, 2:].max(axis=1)

# Calculate mean R² values for trans and cis models
trans_mean_baseline = trans_baseline.mean()
trans_mean_best_r2 = trans_best_r2.mean()

cis_mean_baseline = cis_baseline.mean()
cis_mean_best_r2 = cis_best_r2.mean()

plt.figure(figsize=(7, 7))
plt.scatter(trans_mean_baseline, trans_mean_best_r2, color='blue', label='Trans', s=100)
plt.scatter(cis_mean_baseline, cis_mean_best_r2, color='orange', label='Cis', s=100)
plt.plot([0, max(trans_mean_baseline, cis_mean_baseline)],
         [0, max(trans_mean_best_r2, cis_mean_best_r2)],
         color='red', linestyle='--', label='x=y Line')
plt.title('Comparison of Mean Cross-Validation R²')
plt.xlabel('No Epigenetic Info')
plt.ylabel('Best Epigenetic Bins')
plt.legend()
plt.grid()
plt.show()
