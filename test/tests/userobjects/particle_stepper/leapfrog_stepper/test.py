#!/usr/bin/env python
import sys
import unittest

sys.path.append("../")
from analysis import test_case


class LeapFrogCyclotronElectricTest(unittest.TestCase):
    def test(self):
        test_case("circular_e_field.i")
