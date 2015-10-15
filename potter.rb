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


def potter(books, level=5)
  min_hist = books.min
  books_present = books.present

  if level == 1 or books.length <= 1
    price = books.length * 8
    return price
  end

  n = books.biggest_set_of( level )

  prices = Array.new(n, 0)
  (0..n).each do |i|
    books_left_over = books.remove_first( level, i ) 
    prices[i] = (level*i*8*0.95) + potter( books_left_over, level-1 )
  end
  best_price = prices.min()
  i = prices.rindex( best_price )
  return best_price
end


