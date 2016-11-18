class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end

class LinkedList

  include Enumerable

  def initialize
    @head = Link.new(:head)
    @tail = Link.new(:tail)
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    (last == @head && first == @tail)
  end

  def get(key)
    each { |link| return link.val if link.key == key }
    return nil
  end

  def include?(key)
    return true if get(key)
    false
  end

  def insert(key, val)
    link = get_link(key)
    if link
      link.val = val
    else
      parent = last
      link = Link.new(key,val)
      parent.next = link
      link.prev = parent
      link.next = @tail
      @tail.prev = link
    end
    link
  end

  def remove(key)
    link = get_link(key)
    if link
      prev_link = link.prev
      next_link = link.next
      prev_link.next = next_link
      next_link.prev = prev_link
    end
  end

  def each(&prc)
    link = self.first
    until link == @tail
      prc.call(link)
      link = link.next
    end
  end

  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end

  private

  def get_link(key)
    each { |link| return link if link.key == key }
    nil
  end
end
