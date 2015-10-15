require 'minitest/autorun'
require './potter'

class PotterTest < MiniTest::Test

  def test_bookogram
    b = Bookogram.new([1,2,3])
    assert_kind_of Bookogram, b
    assert_equal [3,2,1,0,0], b.counts
  end

  def test_bookogram_biggest_pair
    assert_equal 4, Bookogram.new([4,4,1]).biggest_set_of(2)
    assert_equal 2, Bookogram.new([4,2,1]).biggest_set_of(2)
    assert_equal 0, Bookogram.new([4    ]).biggest_set_of(2)
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

  def test_level_2_no_discount
    assert_equal potter( Bookogram.new([6        ]), 2), 8 * 6
    assert_equal potter( Bookogram.new([5        ]), 2), 8 * 5
    assert_equal potter( Bookogram.new([4        ]), 2), 8 * 4
    assert_equal potter( Bookogram.new([3        ]), 2), 8 * 3
  end

  
  def test_zero
    assert_equal 0, potter( Bookogram.new([0,0,0,0,0]) )
  end

  def test_level_1
    assert_equal 8 * 1, potter( Bookogram.new([1,0,0,0,0]), 1)
    assert_equal 8 * 2, potter( Bookogram.new([1,1,0,0,0]), 1)
    assert_equal 8 * 2, potter( Bookogram.new([2,0,0,0,0]), 1)
    assert_equal 8 * 3, potter( Bookogram.new([2,1,0,0,0]), 1)
  end

  def test_level_2_no_discount
    assert_equal 8 * 6, potter( Bookogram.new([6        ]), 2)
    assert_equal 8 * 5, potter( Bookogram.new([5        ]), 2)
    assert_equal 8 * 4, potter( Bookogram.new([4        ]), 2)
    assert_equal 8 * 3, potter( Bookogram.new([3        ]), 2)
  end

  def test_level_2_discount_2
    assert_equal 8 * 2 * 0.95 + 8, potter( Bookogram.new([2,1      ]), 2)
    assert_equal 8 * 2 * 0.95 + 8, potter( Bookogram.new([1,1,1    ]), 2)
  end

  def test_level_3_no_discount
    assert_equal 8 * 6, potter( Bookogram.new([6        ]), 3)
    assert_equal 8 * 5, potter( Bookogram.new([5        ]), 3)
    assert_equal 8 * 4, potter( Bookogram.new([4        ]), 3)
    assert_equal 8 * 3, potter( Bookogram.new([3        ]), 3)
    assert_equal 8 * 3, potter( Bookogram.new([2,1      ]), 3)
  end

end
