require 'colorize'

class Tile
  attr_accessor :value#, :flag

  def initialize(pos, value = 0)
    @pos = pos
    @value = value
    @flag = false
  end

  def toggle_flag
    @flag = @flag == true ? false : true
  end

  def is_bomb?
    @value == :B
  end

end
