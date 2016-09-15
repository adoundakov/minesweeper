require_relative 'tile'
require 'byebug'

class Board
  attr_reader :size, :bomb

  def initialize(size = 9, bomb_count = 10)
    @size = size
    @board = Array.new(size) { Array.new(size) }
    @bomb_count = bomb_count
    populate_board
    place_bombs(bomb_count)
  end

  def render
    puts "  #{(0...size).to_a.join(" ")}"
    @board.each_with_index do |row, i|
      print "#{i} "
      values = []
      row.each do |tile|
        values << (tile.value == 0 ? ' ' : tile.value)
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
        # update_neighbors(rand_pos)
        bomb_count -= 1
      end
    end
  end


  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @board[row][col] = val
  end

end
