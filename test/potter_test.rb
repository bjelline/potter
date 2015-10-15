require 'minitest/autorun'
require './potter'

class PotterTest < MiniTest::Test

  def test_bookogram
    b = Bookogram.new([1,1,1])
    assert_kind_of Bookogram, b
    assert_equal b.counts, [1,1,1,0,0]
  end

  def test_zero
    assert_equal 0, potter( Bookogram.new([0,0,0,0,0]) )
  end

  def test_level_1
    assert_equal potter( Bookogram.new([1,0,0,0,0]), 1), 8 * 1
    assert_equal potter( Bookogram.new([1,1,0,0,0]), 1), 8 * 2
    assert_equal potter( Bookogram.new([2,0,0,0,0]), 1), 8 * 2
    assert_equal potter( Bookogram.new([2,1,0,0,0]), 1), 8 * 3
  end

  def test_level_2
    assert_equal potter( Bookogram.new([3        ]), 2), 8 * 3
    #assert_equal potter( Bookogram.new([2,1      ]), 2), 8 * 2 * 0.95 + 8
    #assert_equal potter( Bookogram.new([1,1,1    ]), 2), 8 * 2 * 0.95 + 8
  end

end
