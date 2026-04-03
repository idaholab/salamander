import os

import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
import pandas as pd

# Changes working directory to script directory (for consistent MooseDocs usage)
script_folder = os.path.dirname(__file__)
os.chdir(script_folder)

# Sets the directory where data is fetched from to create the convergence study plots
data_folder = None
if "/salamander/doc/" in script_folder.lower():  # if in documentation folder
    data_folder = "../../../../../test/tests/userobjects/particle_stepper/"
else:  # if in test folder
    data_folder = "./"

linestyles = ['-', '--', '-.', ':']
markerstyles = ['o', 'v', 's', 'D']
plt.rcParams["figure.frameon"] = False
plt.rcParams["legend.frameon"] = False

plt.rcParams["xtick.direction"] = "in"
plt.rcParams["ytick.direction"] = "in"

def plot_motion_error(error_data_path : str, order_data_path : str, save_location : str):
    """ Reads the simulation data needed to recreate the convergence studies used to verify the implementation of the particle steppers.

    Args:
        error_data_path (str): The path to the csv file containing the relative errors for particle path and velocity at each time step size.
        order_data_path (str): The path to the csv file containing the order of accuracy computed when examining the data in the error_data_path file.
        save_location (str): The prefix for where the resulting plots will be saved


    Returns:
        None
    """

    # Reading the data from the provided files
    error_data = pd.read_csv(error_data_path)
    order_data = pd.read_csv(order_data_path)
    # The strings representing the name of each component
    names = ['x', 'y', 'v_x', 'v_y']

    _, ax = plt.subplots(figsize=(6,6))
    for i, name in enumerate(names):
      ax.loglog(1 / error_data["dt"], error_data[name + "_l_2_error"], linestyles[i] + markerstyles[i],  label=f"${name:s}$ Order$\\,$: {order_data[name + "_l_2_order"][0]:0.3f}")
    ax.minorticks_on()
    ax.xaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    ax.yaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    plt.xlabel("$\\omega_c / \\Delta t$ (rad)")
    plt.ylabel("Relative $l_2$ Error")
    plt.legend()
    plt.savefig(f"{save_location:s}_l2.png", format='png', bbox_inches='tight', dpi=300)

    _, ax = plt.subplots(figsize=(6,6))
    for i, name in enumerate(names):
      ax.loglog(1 / error_data["dt"], error_data[name + "_l_inf_error"], linestyles[i] + markerstyles[i],  label=f"${name:s}$ Order$\\,$: {order_data[name + "_l_2_order"][0]:0.3f}")
    ax.minorticks_on()
    ax.xaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    ax.yaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    plt.xlabel("$\\omega_c / \\Delta t$ (rad)")
    plt.ylabel("Relative $l_\\infty$ Error")
    plt.legend()
    plt.savefig(f"{save_location:s}_linf.png", format='png', bbox_inches='tight', dpi=300)
