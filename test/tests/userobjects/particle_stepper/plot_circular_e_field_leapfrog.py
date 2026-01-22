import os

from plot_stepper_errors import plot_motion_error

# Changes working directory to script directory (for consistent MooseDocs usage)
script_folder = os.path.dirname(__file__)
os.chdir(script_folder)

# Sets the directory where data is fetched from to create the convergence study plots
data_folder = None
if "/salamander/doc/" in script_folder.lower():  # if in documentation folder
    data_folder = "../../../../../test/tests/userobjects/particle_stepper/"
else:  # if in test folder
    data_folder = "./"

plot_motion_error(
    data_folder + "leapfrog_stepper/gold/circular_e_field_errors.csv",
    data_folder + "leapfrog_stepper/gold/circular_e_field_orders.csv",
    "leapfrog_circular_e_field",
)
