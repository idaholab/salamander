import unittest
from mooseutils import fuzzyAbsoluteEqual
import mms_spatial


class TestMMS(unittest.TestCase):
    def test(self):
        fig = mms_spatial.run()
        expected = {'1st Order': 2.0, '2nd Order': 3.0}
        for key, value in fig.label_to_slope.items():
            print('%s, %f' % (key, value))
            self.assertTrue(fuzzyAbsoluteEqual(value, expected[key], 0.1))


if __name__ == '__main__':
    unittest.main(__name__, verbosity=2)
