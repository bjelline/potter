DISCOUNTS = [1, 0.95, 0.90, 0.80, 0.75]

class Bookogram
# 5 counts for the five books
# Without loss of generality (WOLOG) sorted descending

  attr_reader :counts
  def initialize(a)
    @counts = a
    (0..4).each do |i|
      if @counts[i].nil?
        @counts[i] = 0
      end
    end
    @counts = @counts.sort.reverse
  end

  def to_s
    @counts.to_s
  end

  def biggest_set_of(n)
    return @counts[n-1]
  end

  def remove_first( x, y )
    c = @counts.clone
    (0..x-1).each { |i| c[i] -= y }
    return Bookogram.new(c)
  end

  def length
    @counts.reduce(:+)
  end

  def min
    @counts.min
  end

  def present
    @counts.find_all { |count| count > 0 }
  end
end


def potter2(books, level=5)
  if level == 1 or books.length <= 1
    price = books.length * 8
    return [price, [books.counts]]
  end

  n = books.biggest_set_of( level )

  prices    = Array.new(n, 0)
  structure = Array.new(n, [])
  (0..n).each do |i|
    books_left_over = books.remove_first( level, i ) 
    results = potter2( books_left_over, level-1 )
    prices[i] = (level*i*8*DISCOUNTS[level-1]) + results[0]
    structure[i] = results[1]
    if i > 0 
      structure[i].unshift( Array.new( level, i ) )
    end
  end
  best_price = prices.min()
  i = prices.rindex( best_price )
  return best_price, structure[i]
end



def potter(list_of_books)
  count = list_of_books.group_by{ |v| v }.values.map{ |list_of_v| list_of_v.length }.sort

  results = potter2( Bookogram.new( count ), 5 )

  return results[0]   # first is price, second is structure
end


