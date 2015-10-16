require 'minitest/autorun'
require './potter'

class PotterTest < MiniTest::Test

  def test_main_potter
    assert_equal 8 * 2, potter([ 'Sorcerers Stone', 'Sorcerers Stone' ])
    assert_equal 8 * 2 * 0.95 + 8 * 1, potter([ 'Sorcerers Stone', 'Sorcerers Stone', 'Darthly Hallows' ]) 
    assert_equal 8 * 5 * 0.75 + 8 * 1, potter([ 'Stone', 'Chamber', 'Prisoner', 'Goblet', 'Order', 'Prisoner' ])
    assert_equal 8 * 4 * 0.80 * 2,     potter([ 'Stone', 'Stone', 'Chamber', 'Chamber', 'Prisoner', 'Prisoner', 'Goblet', 'Order' ])
  end

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
    assert_equal [0, [[0,0,0,0,0]]], potter2( Bookogram.new([0,0,0,0,0]) )
  end

  def test_level_1
    assert_equal [ 8 * 1, [[1,0,0,0,0]] ], potter2( Bookogram.new([1,0,0,0,0]), 1)
    assert_equal [ 8 * 2, [[1,1,0,0,0]] ], potter2( Bookogram.new([1,1,0,0,0]), 1)
    assert_equal [ 8 * 2, [[2,0,0,0,0]] ], potter2( Bookogram.new([2,0,0,0,0]), 1)
    assert_equal [ 8 * 3, [[2,1,0,0,0]] ], potter2( Bookogram.new([2,1,0,0,0]), 1)
  end

  def test_level_2_no_discount
    (3..6).each do |i| assert_equal [ 8 * i, [[i,0,0,0,0]] ], potter2( Bookogram.new([i]), 2)
    end
  end

  
  def test_no_discount_any_level
    (1..5).each do |level|
      assert_equal [ 8 * 6, [[6,0,0,0,0]] ], potter2( Bookogram.new([6]), level)
      assert_equal [ 8 * 5, [[5,0,0,0,0]] ], potter2( Bookogram.new([5]), level)
      assert_equal [ 8 * 4, [[4,0,0,0,0]] ], potter2( Bookogram.new([4]), level)
      assert_equal [ 8 * 3, [[3,0,0,0,0]] ], potter2( Bookogram.new([3]), level)
    end
  end

  def test_discount_2
    (2..5).each do |level|
      assert_equal [ 8 * 2 * 0.95 + 8 * 5, [[1,1], [5,0,0,0,0]] ],  potter2( Bookogram.new([6,1      ]), level)
      assert_equal [ 8 * 2 * 0.95 + 8 * 4, [[1,1], [4,0,0,0,0]] ],  potter2( Bookogram.new([5,1      ]), level)
      assert_equal [ 8 * 2 * 0.95 + 8 * 3, [[1,1], [3,0,0,0,0]] ],  potter2( Bookogram.new([4,1      ]), level)
      assert_equal [ 8 * 2 * 0.95 + 8 * 2, [[1,1], [2,0,0,0,0]] ],  potter2( Bookogram.new([3,1      ]), level)
      assert_equal [ 8 * 2 * 0.95 + 8 * 1, [[1,1], [1,0,0,0,0]] ],  potter2( Bookogram.new([2,1      ]), level)
    end
    assert_equal [ 8 * 2 * 0.95 + 8,  [ [1,1],[1,0,0,0,0] ] ],  potter2( Bookogram.new([1,1,1    ]), 2)
    # assert_equal 8 * 2 * 0.95 * 2, potter( Bookogram.new([1,1,1,1  ]), 2)
  end

  def test_discount_3
    (3..5).each do |level|
      assert_equal [ 8 * 3 * 0.90 + 8 * 5,                    [ [1,1,1], [5,0,0,0,0]        ] ], potter2( Bookogram.new([6,1,1      ]), level)
      assert_equal [ 8 * 3 * 0.90 + 8 * 2 * 3 * 0.95 + 8 * 2, [ [1,1,1], [3,3], [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1      ]), level)
    end
  end

  def test_discount_4
    (4..5).each do |level|
      assert_equal [ 8 * 4 * 0.80 + 8 * 5,                    [ [1,1,1,1], [5,0,0,0,0]          ] ], potter2( Bookogram.new([6,1,1,1      ]), level)
      assert_equal [ 8 * 4 * 0.80 + 8 * 2 * 3 * 0.95 + 8 * 2, [ [1,1,1,1], [3,3],   [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1,1      ]), level)
      assert_equal [ 8 * 4 * 0.80 + 8 * 3 * 3 * 0.90 + 8 * 2, [ [1,1,1,1], [3,3,3], [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,4,1      ]), level)
    end
  end

  def test_discount_4
    assert_equal [ 8 * 5 * 0.75 + 8 * 1,                    [ [1,1,1,1,1], [1,0,0,0,0]          ] ], potter2( Bookogram.new([2,1,1,1,1]), 5)
    assert_equal [ 8 * 5 * 0.75 + 8 * 5,                    [ [1,1,1,1,1], [5,0,0,0,0]          ] ], potter2( Bookogram.new([6,1,1,1,1]), 5)
    assert_equal [ 8 * 5 * 0.75 + 8 * 2 * 3 * 0.95 + 8 * 2, [ [1,1,1,1,1], [3,3],   [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1,1,1]), 5)
    assert_equal [ 8 * 5 * 0.75 + 8 * 3 * 3 * 0.90 + 8 * 2, [ [1,1,1,1,1], [3,3,3], [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,4,1,1]), 5)
  end
  def test_discount_horcurx
    assert_equal [                8 * 4 * 2 * 0.80        , [ [1,1,1,1], [1,1,1,1]              ] ], potter2( Bookogram.new([2,2,2,1,1]), 5)
  end
end
