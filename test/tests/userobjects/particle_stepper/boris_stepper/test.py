#!/usr/bin/env python
import sys
import unittest

sys.path.append("../")
from stepper_analysis import test_case


class BorisCyclotronMagneticTest(unittest.TestCase):
    def test(self):
        test_case("cyclotron_motion.i")


class BorisCyclotronElectricTest(unittest.TestCase):
    def test(self):
        test_case("circular_e_field.i")


BorisCyclotronElectricTest().test()
