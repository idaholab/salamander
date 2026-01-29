import sys
import unittest

# enabling the file to call the required common functions
sys.path.append("../")
from stepper_analysis import test_case


class LeapFrogTimeVarryingElectricTest(unittest.TestCase):
    """
    This test case tests the Leap Frog stepper using a time varying electric field that
    is spatially uniform.
    The exact form of the electric field is calculated by propagating the solution for
    the particles path that is provided by the cyclotron motion case through Newtons
    equations of motion with the assumption that only an electric field is present.
    This allows us to use the same analytic solution for particle motion as the cycltron
    test while also testing a different part of the stepper.
    During the test 4 different time steps are used and the error in the particle
    path is compared to the known solution at each point in time.
    Using all of the errors over the variety of time steps the order or accuracy
    for the particle stepper is calculated.
    In this case the stepper should demonstrate second order accuracy in time.
    """

    def test(self):
        test_case("circular_e_field.i")
