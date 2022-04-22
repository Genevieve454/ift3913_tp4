import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from pandas.plotting import scatter_matrix

if len(sys.argv) != 2:
    print("Missing CSV file argument")
    exit(1)
if not os.path.isfile(sys.argv[1]):
    print("Cannot find CSV file %s", sys.argv[1])
    exit(1)

# reverse csv rows to get chronological order of commits
data = pd.read_csv(sys.argv[1]).iloc[::-1]
del data["id_version"]

# https://stackoverflow.com/a/30215541
axes = scatter_matrix(data, diagonal='kde')
corr = data.corr(method="spearman").to_numpy()
for i, j in zip(*plt.np.tril_indices_from(axes, k=1)):
    if j < i:
        axes[i, j].annotate(
            "%.3f" % corr[i, j], (0.8, 0.8), xycoords='axes fraction', ha='center', va='center')

plt.suptitle(
    "Matrice de corrélation entre différentes mesures,\n pour le projet jfreechart")
plt.show()

rho_nc_mwmc = data[["NC", "mWMC"]].corr(method="spearman")["NC"]["mWMC"]
print("Rho for NC/mWMC : %.3f" % rho_nc_mwmc)
rho_nc_mcbc = data[["NC", "mcBC"]].corr(method="spearman")["NC"]["mcBC"]
print("Rho for NC/mcBC : %.3f" % rho_nc_mcbc)