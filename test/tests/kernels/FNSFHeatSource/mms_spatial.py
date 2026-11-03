import os
import mms

# Changes working directory to script directory (for consistent MooseDocs usage)
script_folder = os.path.dirname(__file__)
os.chdir(script_folder)

def run():
    if "/salamander/doc/" in script_folder.lower():  # if in documentation folder
        mms_input = "../../../../../test/tests/kernels/FNSFHeatSource/mms.i"
    else:  # if in test folder
        mms_input = "mms.i"
    df1 = mms.run_spatial(mms_input, 4, console=False, mpi=8)
    df2 = mms.run_spatial(mms_input, 4, 'Mesh/second_order=true', 'Variables/temp/order=SECOND',
                          console=False, mpi=8)

    fig = mms.ConvergencePlot(xlabel='Element Size ($h$)', ylabel='$L_2$ Error')
    fig.plot(df1, label='1st Order', marker='o', markersize=8)
    fig.plot(df2, label='2nd Order', marker='o', markersize=8)
    fig.save('mms_spatial.png')
    return fig


if __name__ == '__main__':
    run()
