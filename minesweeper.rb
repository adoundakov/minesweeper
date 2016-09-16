require_relative 'board'
require_relative 'player'

class Minesweeper

  def initialize(player)
    @board = Board.new
    @player = player
  end

  def run
    until over? || boom?
      @board.render
      take_turn
    end
    @board.render_full
    puts "Game Over!"
    puts "BOOM!" if boom?
    puts "You Win!" if over?
  end

  def take_turn
    handle_move(@player.get_move)
  end

  def over?
    @board.over?
  end

  def boom?
    @board.boom
  end

  def handle_move(move)
    oper = move[0]
    pos = move[1]

    case oper
    when 'r'
      @board.reveal(pos)
    when 'f'
      @board.flag(pos)
    else
      puts "Invalid Move"
      take_turn
    end

  end

end

if __FILE__ == $0
  p1 = Player.new('p1')
  game = Minesweeper.new(p1)
  game.run
end
