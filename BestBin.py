# %%
import pandas as pd
import matplotlib.pyplot as plt

def process_and_plot_histograms(file_paths, model_type):

    combined_bins = None

    for file_path in file_paths:

        data = pd.read_csv(file_path)
        data_cleaned = data.fillna(0)

        bins = ['cis_epi_000', 'cis_epi_001', 'cis_epi_010', 'cis_epi_011',
                'cis_epi_100', 'cis_epi_101', 'cis_epi_110', 'cis_epi_111'] \
            if 'cis' in model_type else \
            ['trans_epi_000', 'trans_epi_001', 'trans_epi_010', 'trans_epi_011',
             'trans_epi_100', 'trans_epi_101', 'trans_epi_110', 'trans_epi_111']

        best_bins = data_cleaned[bins].idxmax(axis=1)

        bin_counts = best_bins.value_counts()

        if combined_bins is None:
            combined_bins = bin_counts
        else:
            combined_bins = combined_bins.add(bin_counts, fill_value=0)

    all_bins = bins
    combined_bins = combined_bins.reindex(all_bins, fill_value=0)

    cleaned_labels = [label.replace('cis_', '').replace('trans_', '') for label in combined_bins.index]

    plt.figure(figsize=(10, 5))
    combined_bins.sort_index().plot(kind='bar', alpha=0.7, color='blue' if 'cis' in model_type else 'orange')
    plt.title(f'{model_type.capitalize()}: Number of Times Each Bin Gave the Best Model')
    plt.xlabel('Bin')
    plt.ylabel('Count')
    plt.xticks(range(len(cleaned_labels)), cleaned_labels, rotation=0)
    plt.grid(axis='y')
    plt.show()

cis_file_paths = [
    '/Users/marcosanchez/DSC 190 project/r2_cis_enet.csv',
    '/Users/marcosanchez/DSC 190 project/r2_cis_lasso.csv',
    '/Users/marcosanchez/DSC 190 project/h2_cis.csv'
]

trans_file_paths = [
    '/Users/marcosanchez/DSC 190 project/r2_trans_enet.csv',
    '/Users/marcosanchez/DSC 190 project/r2_trans_lasso.csv',
    '/Users/marcosanchez/DSC 190 project/h2_trans.csv'
]

process_and_plot_histograms(cis_file_paths, 'cis')
process_and_plot_histograms(trans_file_paths, 'trans')
