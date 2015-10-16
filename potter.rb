#
# Brigitte Jellineks solution to the "Harry Potter" Kata
#

# number of books in the potter series
NO_POTTERS = 7

# price for one potter book
PRICE     = 8                           

#
# discount factor for i-1 distinct books,
# e.g. for 3 different books a,b,c 
# you will get a discount of DISCOUNT[2] == 0.95
#
DISCOUNTS = [1, 0.95, 0.90, 0.80, 0.75]

def potter(list_of_books)
  counts = list_of_books.group_by{ |v| v }.values.map{ |list_of_v| list_of_v.length }
  
  bookogram = Bookogram.new( counts )

  results = potter2( bookogram, DISCOUNTS.length )

  return results[0]   # first is price, second is structure
end

# ------------- recursive function -------------
#
# books is a Bookogram
# level limits the level of discounts applied, e.g. level=4 means discount for 5 books is not used
# set debug flag to true to see trace of the recursion
#
# this function returns TWO values:
#   - the price that was computed
#   - and array that describes the structure, how books were split up to apply the discounts
# only the price is used by the external function, the seond value is only here
# to enable debugging / tracing 

def potter2(books, level=5, debug=false)

  # end of recursion
  if level == 1 or books.length <= 1
    price = books.length * PRICE
    return [price, [books.counts]]
  end

  n = books.biggest_set_of( level )

  # we have to compare different alternatibes
  # will collet the prices + structures into these arrays:
  prices    = Array.new(n, 0)
  structure = Array.new(n, [])

  # when removing no books, descend one level
  prices[0], structure[0] = potter2( books, level - 1, debug )

  # when removing 1 to n books, no need to descend by level
  (1..n).each do |i|
    books_left_over = books.remove_i_layers_of_n_tupels( i, level ) 
    price_r, structure_r = potter2( books_left_over, level, debug )
    # total price = price for the removed books at current disount, plus price computed through recursion
    prices[i]    = level * i * PRICE * DISCOUNTS[level-1] + price_r
    # total structure = i times the tupel of current level, plus structure computed through recursion
    structure[i] = [ Array.new( level, i ) ]               + structure_r
  end

  if debug and n > 0 
    puts 
    puts "-- there are #{n+1} alternatives i found through recursion for the #{books.length} books on level #{level}:"
    (0..n).each do | i |
      puts "%5.2f for %s" % [ prices[i], structure[i] ]
    end
    puts "--"
  end

  best_price = prices.min()
  i = prices.rindex( best_price )
  return best_price, structure[i]
end



require 'forwardable'

class Bookogram
# 7 counts for the seven books
# Without loss of generality (WOLOG) sorted descending

  attr_reader :counts

  extend Forwardable
  def_delegators :@counts, :to_s, :min

  def initialize(a)
    @counts = a
    (0..NO_POTTERS-1).each do |i|
      if @counts[i].nil?
        @counts[i] = 0
      end
    end
    @counts = @counts.sort.reverse
  end

  def biggest_set_of(n)
    # the book-counts are sorted by size, e.g:
    # 4,3,2,2,0,0,0
    # 2,0,0,0,0,0,0
    # so the biggest set of - say - three books
    # is found by just looking at the third element in the array
    # 4,3,_2_,2,0,0,0
    # 2,0,_0_,0,0,0,0
    
    return @counts[n-1]
  end

  def remove_i_layers_of_n_tupels( i, n )
    c = @counts.clone
    (0..n-1).each { |k| c[k] -= i }
    return Bookogram.new(c)
  end

  def length
    @counts.reduce(:+)
  end
end


