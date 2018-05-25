import unittest
from snv_caller.caller_strategies import SubReference
from cStringIO import StringIO

class TestSubReference(unittest.TestCase):

  def setUp(self):
    reference_file = StringIO('> chr15:21-30\nACGTTGACgT')
    self.sub_reference = SubReference(reference_file)

  def test_it_utilises_the_position_coordinates_to_find_the_min_pos_zero_based(self):
    self.assertEqual(self.sub_reference.min_pos,20)

  def test_it_utilises_the_position_coordinates_to_find_the_max_pos_zero_based(self):
    self.assertEqual(self.sub_reference.max_pos,29)

  def test_it_utilises_the_reference_label_to_supply_the_reference_name(self):
    self.assertEqual(self.sub_reference.reference_name,'chr15')

  def test_slicing_uses_the_shifted_coordinates_to_correspond_with_the_reference_extended_slices(self):
    self.assertEqual(self.sub_reference[23:],'TTGACGT')

  def test_slicing_uses_the_shifted_coordinates_to_correspond_with_the_reference_basic_slice(self):
      self.assertEqual(self.sub_reference[22],'G')

  def test_slicing_uses_the_shifted_coordinates_to_correspond_with_the_reference_neg_slice(self):
      self.assertEqual(self.sub_reference[-1:],'T')

  def test_slicing_for_positions_outside_of_the_shifted_range_throws_an_index_error(self):
    with self.assertRaises(IndexError):
      self.sub_reference[0]

  def test_it_uppercases_the_returned_bases(self):
    self.assertEqual(self.sub_reference[28],'G')
