import os

import mooseutils
import numpy as np
import pandas as pd

# magnitude of the velocity perpendicular to the field in m/s
v_mag = 1
# chage of the particles in C
q = 1
# mass of the particle in kg
m = 1
# magnitude of the magnetic field in T
B_mag = 1


def analytic_omega_c(q: float, B: float, m: float):
    return np.abs(q) * B / m


def analytic_r_L(v_perp: float, m: float, q: float, B: float):
    return v_perp / analytic_omega_c(q, B, m)


def analytic_x(v_perp: float, m: float, q: float, B: float, t: np.ndarray):
    w_c = analytic_omega_c(q, B, m)
    r = analytic_r_L(v_perp, m, q, B)
    return r * np.sin(w_c * t)


def analytic_v_x(v_perp: float, m: float, q: float, B: float, t: np.ndarray):
    w_c = analytic_omega_c(q, B, m)
    r = analytic_r_L(v_perp, m, q, B)
    return r * w_c * np.cos(w_c * t)


def analytic_y(v_perp: float, m: float, q: float, B: float, t: np.ndarray):
    w_c = analytic_omega_c(q, B, m)
    r = analytic_r_L(v_perp, m, q, B)
    return r * np.cos(w_c * t)


def analytic_v_y(v_perp: float, m: float, q: float, B: float, t: np.ndarray):
    w_c = analytic_omega_c(q, B, m)
    r = analytic_r_L(v_perp, m, q, B)
    return -r * w_c * np.sin(w_c * t)


def error_analysis(files: list[str], dt: np.ndarray):
    l_2_orders = np.zeros_like(files)
    l_2_errors = np.zeros((len(dt), 4))
    l_inf_orders = np.zeros_like(files)
    l_inf_errors = np.zeros((len(dt), 4))

    for i, f in enumerate(files):
        data = pd.read_csv(f)

        simulation_results = [
            data["x"].to_numpy(),
            data["y"].to_numpy(),
            data["v_x"].to_numpy(),
            data["v_y"].to_numpy(),
        ]

        t_pos = data["t_pos"].to_numpy()
        t_vel = data["t_vel"].to_numpy()

        analytic_solutions = [
            analytic_x(v_mag, m, q, B_mag, t_pos),
            analytic_y(v_mag, m, q, B_mag, t_pos),
            analytic_v_x(v_mag, m, q, B_mag, t_vel),
            analytic_v_y(v_mag, m, q, B_mag, t_vel),
        ]

        for j, (simulation, solution) in enumerate(
            zip(simulation_results, analytic_solutions)
        ):
            l_2_errors[i, j] = np.linalg.norm(simulation - solution) / np.linalg.norm(
                solution
            )
            l_inf_errors[i, j] = np.linalg.norm(
                simulation - solution, ord=np.inf
            ) / np.linalg.norm(solution, ord=np.inf)

    for i in range(4):
        l_2_orders[i], _ = np.polyfit(np.log(dt), np.log(l_2_errors[:, i]), deg=1)
        l_inf_orders[i], _ = np.polyfit(np.log(dt), np.log(l_inf_errors[:, i]), deg=1)

    return l_2_errors, l_2_orders, l_inf_errors, l_inf_orders


def test_case(input_file : str):
    method = os.environ.get("METHOD", "opt")
    mpi = 1
    executeable = "../../../../../salamander-" + method
    if "test" not in os.getcwd():
        executeable = "../../../../../salamander-" + method

    dts = np.array([10 ** (-i) for i in range(4)])
    output_files = [f"{input_file.split(".i")[0]:s}_{dt:0.4E}_particle_data.csv" for dt in dts]

    args = [
        "-i",
        input_file,
        "--allow-test-objects",
        "Outputs/exodus=false",
        "",
        "",
        "",
    ]

    for dt in dts:
        num_steps = int(10 / dt)
        args[-3] = f"Outputs/file_base={input_file.split(".i")[0]:s}_{dt:0.4E}"
        args[-2] = f"Executioner/num_steps={num_steps:d}"
        args[-1] = f"Executioner/dt={dt:0.2e}"
        mooseutils.run_executable(executeable, *args, mpi=mpi)

    l_2_errors, l_2_orders, l_inf_errors, l_inf_orders = error_analysis(output_files, dts)
    error_data = {"dt" : dts}
    order_data = {}
    components = ["x", "y", "v_x", "v_y"]

    for i ,component in enumerate( components ):
        error_data[f"{component:s}_l_2_error"] = l_2_errors[:, i]
        error_data[f"{component:s}_l_inf_error"] = l_inf_errors[:, i]
        order_data[f"{component:s}_l_2_order"] = [ l_2_orders[i] ]
        order_data[f"{component:s}_l_inf_order"] = [ l_inf_orders[i] ]

    error_df = pd.DataFrame(error_data)
    error_df.to_csv(f"{input_file.split(".i")[0]:s}_errors.csv",index=False, index_label=False, float_format="%.4E")

    order_df = pd.DataFrame(order_data)
    order_df.to_csv(f"{input_file.split(".i")[0]:s}_orders.csv",index=False, index_label=False, float_format="%.4E")
