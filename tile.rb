require 'byebug'
require 'colorize'

class Tile
  attr_accessor :value, :flag, :pos

  def initialize(pos, value = 0)
    @pos = pos
    @value = value
    @flag = false
    @revealed = false
  end

  def toggle_flag
    @flag = @flag == true ? false : true
  end

  def is_bomb?
    @value == :B
  end

  def is_0?
    @value == 0
  end

  def reveal
    @revealed = true
  end

  def revealed?
    @revealed
  end

end
