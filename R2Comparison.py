# %%
import pandas as pd
import matplotlib.pyplot as plt

def process_and_combine_plot(file_paths, model_type, title_suffix):
    plt.figure(figsize=(10, 7))

    for file_path in file_paths:

        file_name = file_path.split('/')[-1].replace('.csv', '')

        data = pd.read_csv(file_path)

        baseline_column = 'baseline' if 'cis' in model_type else 'trans_baseline'

        data_cleaned = data.dropna(subset=[baseline_column])

        data_cleaned = data_cleaned.fillna(0)

        baseline = data_cleaned[baseline_column]
        bins = ['cis_epi_000', 'cis_epi_001', 'cis_epi_010', 'cis_epi_011',
                'cis_epi_100', 'cis_epi_101', 'cis_epi_110', 'cis_epi_111'] \
            if 'cis' in model_type else \
            ['trans_epi_000', 'trans_epi_001', 'trans_epi_010', 'trans_epi_011',
             'trans_epi_100', 'trans_epi_101', 'trans_epi_110', 'trans_epi_111']
        best_r2 = data_cleaned[bins].max(axis=1)

        plt.scatter(baseline, best_r2, alpha=0.5, label=f'{file_name} Data')

    plt.plot([0, 1], [0, 1], color='red', linestyle='--', label='x=y Line')
    plt.title(f'Comparison of Baseline vs Best R² ({model_type.capitalize()} {title_suffix})')
    plt.xlabel('Baseline R²')
    plt.ylabel('Best R²')
    plt.legend()
    plt.grid()
    plt.show()


r2_cis_file_paths = [
    '/Users/marcosanchez/DSC 190 project/r2_cis_enet.csv',
    '/Users/marcosanchez/DSC 190 project/r2_cis_lasso.csv'
]

r2_trans_file_paths = [
    '/Users/marcosanchez/DSC 190 project/r2_trans_enet.csv',
    '/Users/marcosanchez/DSC 190 project/r2_trans_lasso.csv'
]

h2_cis_file_path = [
    '/Users/marcosanchez/DSC 190 project/h2_cis.csv'
]

h2_trans_file_path = [
    '/Users/marcosanchez/DSC 190 project/h2_trans.csv'
]

process_and_combine_plot(r2_cis_file_paths, 'cis', 'R² Models')
process_and_combine_plot(r2_trans_file_paths, 'trans', 'R² Models')
process_and_combine_plot(h2_cis_file_path, 'cis', 'h² Models')
process_and_combine_plot(h2_trans_file_path, 'trans', 'h² Models')
