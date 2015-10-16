require 'minitest/autorun'
require './potter'

class PotterTest < MiniTest::Test

  def setup
    # short hand for the discounted deals: TWO = price of two different books with discount applied
    @one   = PRICE
    @two   = PRICE * 2 * DISCOUNTS[ 2-1 ] 
    @three = PRICE * 3 * DISCOUNTS[ 3-1 ] 
    @four  = PRICE * 4 * DISCOUNTS[ 4-1 ] 
    @five  = PRICE * 5 * DISCOUNTS[ 5-1 ] 
  end

  def test_potter_public_interface
    assert_equal 2 * @one,     potter([ 'Sorcerers Stone', 'Sorcerers Stone' ])
    assert_equal @two +  @one, potter([ 'Sorcerers Stone', 'Sorcerers Stone', 'Darthly Hallows' ]) 
    assert_equal @five + @one, potter([ 'Stone', 'Chamber', 'Prisoner', 'Goblet', 'Order', 'Prisoner' ])
    assert_equal 2 * @four,    potter([ 'Stone', 'Stone', 'Chamber', 'Chamber', 'Prisoner', 'Prisoner', 'Goblet', 'Order' ])
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


  # ----------- tests for the internale "potter" function from here ---------------

  def test_zero
    assert_equal [0, [[0,0,0,0,0]]], potter2( Bookogram.new([0,0,0,0,0]))
  end

  def test_no_discount_any_level
    (1..5).each do |level|
      assert_equal [ 6 * @one, [[6,0,0,0,0]] ], potter2( Bookogram.new([6]), level)
      assert_equal [ 5 * @one, [[5,0,0,0,0]] ], potter2( Bookogram.new([5]), level)
      assert_equal [ 4 * @one, [[4,0,0,0,0]] ], potter2( Bookogram.new([4]), level)
      assert_equal [ 3 * @one, [[3,0,0,0,0]] ], potter2( Bookogram.new([3]), level)
    end
  end

  def test_level_1
    assert_equal [     @one, [[1,0,0,0,0]] ], potter2( Bookogram.new([1,0,0,0,0]), 1)
    assert_equal [ 2 * @one, [[1,1,0,0,0]] ], potter2( Bookogram.new([1,1,0,0,0]), 1)
    assert_equal [ 2 * @one, [[2,0,0,0,0]] ], potter2( Bookogram.new([2,0,0,0,0]), 1)
    assert_equal [ 3 * @one, [[2,1,0,0,0]] ], potter2( Bookogram.new([2,1,0,0,0]), 1)
  end

  def test_discount_2
    (2..5).each do |level|
      assert_equal [ @two + 5 * @one, [[1,1], [5,0,0,0,0]] ],  potter2( Bookogram.new([6,1      ]), level)
      assert_equal [ @two + 4 * @one, [[1,1], [4,0,0,0,0]] ],  potter2( Bookogram.new([5,1      ]), level)
      assert_equal [ @two + 3 * @one, [[1,1], [3,0,0,0,0]] ],  potter2( Bookogram.new([4,1      ]), level)
      assert_equal [ @two + 2 * @one, [[1,1], [2,0,0,0,0]] ],  potter2( Bookogram.new([3,1      ]), level)
      assert_equal [ @two + 1 * @one, [[1,1], [1,0,0,0,0]] ],  potter2( Bookogram.new([2,1      ]), level)
    end
    assert_equal [     @two + @one, [ [1,1],[1,0,0,0,0] ] ],  potter2( Bookogram.new([1,1,1    ]), 2)
  end

  def test_discount_3
    (3..5).each do |level|
      assert_equal [ @three            + 5 * @one, [ [1,1,1], [5,0,0,0,0]        ] ], potter2( Bookogram.new([6,1,1      ]), level)
      assert_equal [ @three + 3 * @two + 2 * @one, [ [1,1,1], [3,3], [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1      ]), level)
    end
  end

  def test_discount_4
    (4..5).each do |level|
      assert_equal [ @four              + 5 * @one, [ [1,1,1,1], [5,0,0,0,0]          ] ], potter2( Bookogram.new([6,1,1,1      ]), level)
      assert_equal [ @four + 3 * @three + 2 * @one, [ [1,1,1,1], [3,3,3], [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,4,1      ]), level)
      assert_equal [ @four + 3 * @two   + 2 * @one, [ [1,1,1,1], [3,3],   [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1,1      ]), level)
    end
  end

  def test_discount_5
    assert_equal [ @five            + @one,     [ [1,1,1,1,1], [1,0,0,0,0]          ] ], potter2( Bookogram.new([2,1,1,1,1]), 5)
    assert_equal [ @five            + 5 * @one, [ [1,1,1,1,1], [5,0,0,0,0]          ] ], potter2( Bookogram.new([6,1,1,1,1]), 5)
    assert_equal [ @five + 3 * @two + 2 * @one, [ [1,1,1,1,1], [3,3],   [2,0,0,0,0] ] ], potter2( Bookogram.new([6,4,1,1,1]), 5)
  end

  def test_horcurx 
    # switch on debugging in this case, it's really intresting!!!
    assert_equal [                2 * @four               , [ [1,1,1,1], [1,1,1,1], [0,0,0,0,0] ] ], potter2( Bookogram.new([2,2,2,1,1]), 5, false)
  end

  def test_other_horcruxes
    # found a cheaper price through testing, originally had [ [1,1,1,1,1], [3,3,3], [2,0,0,0,0]       ]
    assert_equal [ 2 * @four + 2 * @three + 2 * @one,       [ [1,1,1,1],[1,1,1,1],[2,2,2],[2,0,0,0,0]]], potter2( Bookogram.new([6,4,4,1,1]), 5)
    assert_equal [ 2 * @four + 2 * @two   + 2 * @one,       [ [1,1,1,1],[1,1,1,1],[2,2],  [2,0,0,0,0]]], potter2( Bookogram.new([6,4,2,1,1]), 5)
  end

  def test_simple
    assert_equal [ 2 * @two,        [ [1,1],[1,1],[0,0,0,0,0] ] ],  potter2( Bookogram.new([1,1,1,1    ]), 2)
  end


end
