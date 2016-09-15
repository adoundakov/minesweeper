class Player
  def initialize(name)
    @name = name
  end

  def prompt
    puts "Please enter an operation and position: (r 3,4)"
    print '>'
  end

  def get_move
    prompt
    p process_input(get_input)
  end

  def get_input
    gets.chomp!
  end

  def valid_play?(string)

  end

  def process_input(string)
    move = string.split(' ')
    oper = move.shift
    pos = move[0].split(',').map { |char| Integer(char) }
    [oper, pos]
  end
end
