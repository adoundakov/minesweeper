require 'byebug'
class StaticArray
  attr_reader :store
  def initialize(capacity)
    @store = Array.new(capacity)
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  def length
    @store.length
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  attr_reader :count

  include Enumerable

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
  end

  def [](i)
    return nil if i >= @count || i.abs > @count
    i >= 0 ? @store[i] : @store[@count + i]
  end

  def []=(i, val)
    if i >= capacity
      increase = i - capacity + 1
      resize!(increase)
      @count += increase
    elsif i > @count
      @count = i
    end
    @count += 1 if self[i] == nil
    i >= 0 ? (@store[i] = val) : (@store[@count + i] = val)
  end

  def capacity
    @store.length
  end

  def include?(val)
    self.each { |v| return true if v == val}
    false
  end

  def push(val)
    resize!(capacity) if @count == capacity
    @store[@count] = val
    @count += 1
  end

  def unshift(val)
    new_store = StaticArray.new(capacity + 1)
    self.each_with_index { |el, idx| new_store[idx + 1] = el }
    @store = new_store
    self[0] = val
    @count += 1
  end

  def pop
    return nil if @count == 0
    val = last
    self[-1] = nil
    @count -= 1
    val
  end

  def shift
    return nil if @count == 0
    val = first
    new_store = StaticArray.new(capacity)
    new_count = 0
    i = 1
    while i < @count
      el = self[i]
      new_store[i - 1] = el
      new_count += 1
      i += 1
    end
    @store = new_store
    @count = new_count
    val
  end

  def first
    self[0]
  end

  def last
    self[-1]
  end

  def each(&prc)
    i = 0
    while i < @count
      prc.call(@store[i])
      i += 1
    end
    @store
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    return false unless self.length == other.length

    self.each_with_index do |el, ind|
      return false unless el == other[ind]
    end

    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private

  def resize!(increase)
    new_store = StaticArray.new(capacity + increase)
    self.each_with_index { |el, idx| new_store[idx] = el }
    @store = new_store
  end
end
