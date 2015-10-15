DISCOUNTS = [1, 0.95, 0.90, 0.80, 0.75]

class Bookogram
  attr_reader :counts
  def initialize(a)
    @counts = a
    (0..4).each do |i|
      if @counts[i].nil?
        @counts[i] = 0
      end
    end
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
    return books.length * 8
  end
  if level == 2
    if books_present.length >= 2 
      first = 
      second = books_present.pop()
      # return 2 * 8 * 0.95 + potter( leftover_books, 
    else
      return books.length * 8
    end
  end
end


