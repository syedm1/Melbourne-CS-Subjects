import unittest
from snv_caller.caller import call_snvs
from snv_caller.caller_strategies import HeterozygoteStrategy
from cStringIO import StringIO
import os 

class TestSnvCallerIntegration(unittest.TestCase):

  def setUp(self):
    self.dir_path = os.path.dirname(os.path.realpath(__file__))
    self.output_file = StringIO()
    call_snvs(os.path.join(self.dir_path,'support_data/reads.bam'),self.output_file,caller_strategy=HeterozygoteStrategy())
    self.output_file.seek(0) #rewind back to zero

  @unittest.skip("removed week5 test data from submission")
  def test_that_it_produces_the_same_output_as_the_week5_example(self):
    with open(os.path.join(self.dir_path,'support_data/expected_snv_output.txt')) as f:
      self.assertEqual(self.output_file.read(), f.read())
