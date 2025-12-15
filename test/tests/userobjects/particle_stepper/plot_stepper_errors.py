import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import numpy as np
import pandas as pd

sublabel_x = 0.96
sublabel_y = 0.04

linestyles = ['-', '--', '-.', ':']
markerstyles = ['o', 'v', 's', 'D']
plt.rcParams["figure.frameon"] = False
plt.rcParams["legend.frameon"] = False

plt.rcParams["xtick.direction"] = "in"
plt.rcParams["ytick.direction"] = "in"

def plot_motion_error(error_data_path : str, order_data_path : str, save_location : str):
    error_data = pd.read_csv(error_data_path)
    order_data = pd.read_csv(order_data_path)
    names = ['x', 'y', 'v_x', 'v_y']

    _, ax = plt.subplots(figsize=(6,6))
    for i, name in enumerate(names):
      ax.loglog(error_data["dt"], error_data[name + "_l_2_error"], linestyles[i] + markerstyles[i],  label=f"${name:s}$ Order$\\,$: {order_data[name + "_l_2_order"][0]:0.3f}")

    ax.minorticks_on()
    ax.xaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    ax.yaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))

    plt.xlabel("$\\omega_c / \\Delta t$ (rad)")
    plt.ylabel("Relative $l_2$ Error")

    plt.legend()
    plt.savefig(f"{save_location:s}_l2.png", format='png', bbox_inches='tight', dpi=600)

    _, ax = plt.subplots(figsize=(6,6))
    for i, name in enumerate(names):
      ax.loglog(error_data["dt"], error_data[name + "_l_inf_error"], linestyles[i] + markerstyles[i],  label=f"${name:s}$ Order$\\,$: {order_data[name + "_l_2_order"][0]:0.3f}")
    ax.minorticks_on()
    ax.xaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))
    ax.yaxis.set_minor_locator(ticker.LogLocator(base=10.0, subs=np.arange(2, 10), numticks=100))

    plt.xlabel("$\\omega_c / \\Delta t$ (rad)")
    plt.ylabel("Relative $l_\\infty$ Error")

    plt.legend()
    plt.savefig(f"{save_location:s}_linf.png", format='png', bbox_inches='tight', dpi=600)


plot_motion_error("boris_stepper/gold/circular_e_field_errors.csv", "boris_stepper/gold/circular_e_field_orders.csv","boris_circular_e_field")
plot_motion_error("boris_stepper/gold/cyclotron_motion_errors.csv", "boris_stepper/gold/cyclotron_motion_orders.csv","boris_cyclotron")
plot_motion_error("leapfrog_stepper/gold/circular_e_field_errors.csv", "leapfrog_stepper/gold/circular_e_field_orders.csv","leapfrog_circular_e_field")
