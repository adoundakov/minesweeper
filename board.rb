require 'colorize'
require_relative 'tile'
require 'byebug'

class Board
  attr_reader :size, :boom

  def initialize(size = 9, bomb_count = 10)
    @size = size
    @board = Array.new(size) do |row|
                Array.new(size) {|col| Tile.new([row, col])}
              end
    @bomb_count = bomb_count
    @boom = false
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
        elsif tile.is_0? && tile.revealed?
          values << ' '
        elsif tile.revealed?
          values << add_color(tile.value)
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

  def add_color(value)
    colors = {
      1 => '1'.colorize(:blue),
      2 => '2'.colorize(:green),
      3 => '3'.colorize(:light_magenta),
      4 => '4'.colorize(:light_green),
      5 => '5'.colorize(:yellow),
      6 => '6'.colorize(:magenta),
      7 => '7'.colorize(:light_yellow),
      8 => '8'.colorize(:white),
      9 => '9'.colorize(:cyan)
    }

    colors[value]
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
