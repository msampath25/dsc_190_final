import os
import pandas as pd
import sys

e_f = sys.argv[1]
out = sys.argv[2]
os.makedirs(out, exist_ok = True)
e = pd.read_csv(e_f,index_col  = 0)
cols = e.columns
e['id'] = e.index
outdir = os.path.join(out)
os.makedirs(outdir, exist_ok = True)
for col in cols:
    gene = col.split('.')[0]
    e[['id','id']+[col]].to_csv(os.path.join(outdir,gene+'.phen'), index = False, header = False, sep = ' ')