require_relative 'tile'
require 'byebug'

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
    puts "  #{(0...size).to_a.join(" ")}"
    @board.each_with_index do |row, i|
      print "#{i} "
      values = []
      row.each do |tile|
        # case tile
        if tile.flag
          values << 'F'
        elsif tile.revealed?
          values << tile.value
        else
          values << '*'
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
        case tile
        when tile.flag
          values << 'f'
        when tile.is_bomb?
          values << 'B'
        else
          values << (tile.value == 0 ? ' ' : tile.value)
        end
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
    row, col = pos
    (-1..1).each do |row_offset|
      (-1..1).each do |col_offset|
        n_row = row + row_offset
        n_col = col + col_offset
        next if out_of_range?(n_row) || out_of_range?(n_col)
        n_pos = [n_row, n_col]
        tile = self[n_pos]
  # ÷      byebug
        next if tile.is_bomb?
        tile.value += 1
      end
    end
  end

  def flag(pos)
    self[pos].toggle_flag
  end

  def reveal(pos)
    tile = self[pos]
    boom if tile.is_bomb?
    tile.reveal
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
