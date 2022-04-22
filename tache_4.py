import os
import sys
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

if len(sys.argv) != 2:
    print("Missing CSV file argument")
    exit(1)
if not os.path.isfile(sys.argv[1]):
    print("Cannot find CSV file %s", sys.argv[1])
    exit(1)

def plot(title, ax, x_data, y_data, x_label, y_label):
    ax.plot(x_data, y_data)

    ax.set(xlabel=x_label, ylabel=y_label,title=title)
    ax.grid()

# reverse csv rows to get chronological order of commits
data = pd.read_csv(sys.argv[1]).iloc[::-1]
del data["id_version"]

fig, (ax_1, ax_2, ax_3) = plt.subplots(3, 1, sharex=True)

plot("Évolution du nombre de classes, par rapports aux commits",
    ax_1, range(data.shape[0]), data["NC"], "commit", "NC")
plot("Évolution de la moyenne de la métrique WMC, par rapports aux commits",
    ax_2, range(data.shape[0]), data["mWMC"], "commit", "mWMC")
plot("Évolution de la moyenne de la métrique classe_BC, par rapports aux commits",
ax_3, range(data.shape[0]), data["mcBC"], "commit", "mcBC")

plt.show()