#!/usr/bin/env python
import os

import mooseutils

input_file = (
    "test/tests/userobjects/particle_stepper/leapfrog_stepper/circular_e_field.i"
)
mpi = 1
executeable = "./salamander-opt"
supress_output = False


args = ["-i", input_file, "--allow-test-objects", "", "", ""]

time_steps = [1, 1e-1, 1e-2, 1e-3]


for dt in time_steps:
    num_steps = int(10 / dt)
    output_dir = f"dt={dt:0.2e}"
    os.makedirs(output_dir, exist_ok=True)

    file_base = f"{output_dir:s}/particle"

    args[-1] = f"Outputs/file_base='{file_base}'"
    args[-2] = f"Executioner/dt={dt:0.2e}"
    args[-3] = f"Executioner/num_steps={num_steps:d}"
    print(args)
    mooseutils.run_executable(
        executeable, *args, mpi=mpi, suppress_output=supress_output
    )
