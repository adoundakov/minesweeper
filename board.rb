require 'colorize'
require_relative 'tile'

class Board
  attr_reader :size, :boom

  def initialize(size = 9, bomb_count = 10)
    @size = size
    @board = Array.new(size) { Array.new(size) }
    @bomb_count = bomb_count
    @boom = false
    populate_board
    place_bombs(bomb_count)
  end

  def render
    puts "  #{(0...size).to_a.join(" ")}".colorize(:white)
    @board.each_with_index do |row, i|
      print "#{i} ".colorize(:white)
      values = []
      row.each do |tile|
        if tile.flag
          values << 'F'.colorize(:red)
        elsif tile.revealed?
          values << tile.value
        elsif tile.is_0? && tile.revealed?
          values << ' '
        else
          values << '*'.colorize(:blue)
        end
      end
      puts values.join(' ')
    end
  end

  def render_full
    puts "  #{(0...size).to_a.join(" ")}"
    @board.each_with_index do |row, i|
      print "#{i} "
      values = []
      row.each do |tile|
        values << (tile.is_0? ? ' ' : tile.value)
      end
      puts values.join(' ')
    end
  end

  def populate_board
    @size.times do |row|
      @size.times do |col|
        self[[row,col]] = Tile.new([row, col])
      end
    end
  end

  def place_bombs(bomb_count)
    until bomb_count == 0
      rand_row, rand_col = rand(size), rand(size)
      rand_pos = [rand_row, rand_col]
      tile = self[rand_pos]
      if tile.value != :B
        tile.value = :B
        update_neighbors(rand_pos)
        bomb_count -= 1
      end
    end
  end

  def update_neighbors(pos)
    neighbors(pos).each do |neighbor|
      next if neighbor.is_bomb?
      neighbor.value += 1
    end
  end

  def reveal_neighbors(pos)
    neighbors = neighbors(pos).sort { |a, b| b.value <=> a.value }
    neighbors.reject! { |tile| tile.revealed? }
    neighbors.each do |tile|
      if !tile.is_0?
        tile.reveal unless tile.is_bomb? || tile.flag
      elsif tile.is_0?
        tile.reveal
        reveal_neighbors(tile.pos)
      end
    end
  end

  def flag(pos)
    self[pos].toggle_flag
  end

  def reveal(pos)
    tile = self[pos]
    if tile.flag
      puts "Cannot reveal a flagged tile"
      puts "Please unflag the tile first"
    else
      boom! if tile.is_bomb?
      reveal_neighbors(pos) if tile.is_0?
      tile.reveal
    end
  end

  def neighbors(pos)
    neighbors = []
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        n_row , n_col = (pos[0] + row_offset), (pos[1] + col_offset)
        next if out_of_range?(n_row) || out_of_range?(n_col)
        tile = self[[n_row, n_col]]
        neighbors << tile
      end
    end
    neighbors
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

  def out_of_range?(num)
    num >= size || num < 0
  end

  def over?
    @board.each do |row|
      row.each do |tile|
        if tile.revealed? == false
          return false unless tile.is_bomb?
        end
      end
    end
    true
  end

  def boom!
    @boom = true
  end

end
