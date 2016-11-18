require_relative 'p05_hash_map'
require_relative 'p04_linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      update_link!(@map[key])
      @map[key].val
    else
      eject! if count >= @max
      calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private

  def calc!(key)
    # suggested helper method; insert an (un-cached) key
    val = @prc.call(key)
    link = @store.insert(key,val)
    @map[key] = link
    val
  end

  def update_link!(link)
    # suggested helper method; move a link to the end of the list
    @store.remove(link.key)
    new_link = @store.insert(link.key, link.val)
    @map[link.key] = new_link
  end

  def eject!
    oldest_key = @store.first.key
    @map.delete(oldest_key)
    @store.remove(oldest_key)
  end
end
