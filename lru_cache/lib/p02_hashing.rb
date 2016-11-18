class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    return 0.hash if self.empty?
    hashes = nil
    self.each_with_index do |el, ind|
      if hashes.nil?
        hashes = el.hash + ind.hash
      else
        hashes = hashes ^ (el.hash + ind.hash)
      end
    end
    hashes
  end
end

class String
  ALPHABET = ('a'..'z').to_a.shuffle + ('A'..'Z').to_a.shuffle
  def hash
    indices = []
    self.each_char do |char|
      indices << ALPHABET.index(char)
    end
    indices.hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    keys = self.keys.map(&:to_s)
    values = self.values.map(&:to_s)
    zipped = zip(keys, values)
    zipped.sort.hash
  end

  def zip(left, right)
    zipped = []
    left.each_index do |idx|
      zipped << left[idx] + right[idx]
    end
    zipped
  end
end
