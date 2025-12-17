import sys
import unittest

# enabling the file to call the required common functions
sys.path.append("../")
from stepper_analysis import test_case


class LeapFrogTimeVarryingElectricTest(unittest.TestCase):
    def test(self):
        test_case("circular_e_field.i")
