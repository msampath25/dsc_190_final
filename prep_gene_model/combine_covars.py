import pandas as pd
import argparse

#########################################################################################################
# INPUTS:

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--cat", default = '', help="Categorical covariates file (To be one-hot-encoded) ")
parser.add_argument("-q", "--quant", default = '', help="Quantitative covariates file (To be used as normalized)")
parser.add_argument("-g", "--gtpc", default = '', help = "genotype PC (plink .eigenvec format)")
parser.add_argument( "--top-gtpc", default = 10, type = int, help = "Max no of genotype PCs")
parser.add_argument("-x", "--gepc", default = '', help = 'gene expression PC (plink .eigenvec format)')
parser.add_argument( "--top-gepc", default = 10, type = int, help = "Max no of gene exp PCs")
parser.add_argument("-o", "--out", required = True, help = 'output space-separated file (plink .phen/.covars/.eigenvecs format)')

params = parser.parse_args()


open(params.out,'w').write('trying write, if error here, give valid [-o (--out)] arg')
#########################################################################################################

## METADATA
# Example:
# g=/home/i3gupta/lustre/lupus/imputed/LupusHRC.plink/lupusHRC_hm3_consensus_sumstats_info_0.3_maf_0.05_N50_w5_rsq0.8.pruned.notna.gtpc.eigenvec
# x=/home/i3gupta/lustre/lupus/pbcounts_mean_log/B_cell.eigenvecs
# python /home/i3gupta/scripts/combine_covars.py -c ~/lustre/lupus/obs_metadata.csv --c-cols 'Processing_Cohort,sex' -q ~/lustre/lupus/obs_metadata.csv --q-cols age --c-fid donor_id --c-iid donor_id -g $g -x $x
if params.cat:
    cat = pd.read_csv(params.cat, sep = ' ', header = None)
    cat.columns = ['fid','iid'] + ['cat_' + str(col) for col in cat.columns[2:]]
else:
    cat = None
if params.quant:
    quant = pd.read_csv(params.quant, sep = ' ', header = None)
    quant.columns = ['fid','iid'] + ['quant_' + str(col) for col in quant.columns[2:]]
else:
    quant = None
if params.gtpc:
    gtpc = pd.read_csv(params.gtpc, sep = ' ', header = None).iloc[:,:2+params.top_gtpc]
    gtpc.columns = ['fid','iid'] + ['gtpc_' + str(col) for col in gtpc.columns[2:]]
else:
    gtpc = None
if params.gepc:
    gepc = pd.read_csv(params.gepc, sep = ' ', header = None).iloc[:,:2+params.top_gepc]
    gepc.columns = ['fid','iid'] + ['gepc_' + str(col) for col in gepc.columns[2:]]
else:
    gepc = None


#########################################################################################################
# Categorical covariates

if cat is not None:
    ohe_cols = []
    for cat_col in cat.columns[2:]:
        ohe = pd.get_dummies(cat[cat_col]).astype(int)
        for category in ohe.columns[:-1]:
            ohe_col = cat_col + "_" + str(category)
            cat[ohe_col] = ohe[category]
            ohe_cols.append(ohe_col)

    cat = cat[['fid','iid'] + ohe_cols]

metadata = None
for df2 in (cat, quant, gtpc, gepc):
    if df2 is not None:
        print(df2.head())
        if metadata is None:
            metadata = df2.copy()
        else:
            metadata = pd.merge(metadata,df2, on=['fid','iid'], how='inner')

metadata = metadata.drop_duplicates()
# Normalize all columns


# metadata[metadata.columns[2:]]=(metadata[metadata.columns[2:]]-metadata[metadata.columns[2:]].mean())/metadata[metadata.columns[2:]].std()
metadata.to_csv(params.out, sep = ' ', index = False, header = False)










