class Player
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def prompt
    puts "Please enter an operation and position: (r 3,4)"
    print '>'
  end

  def get_move
    prompt
    process_input(get_input)
  end

  def get_input
    gets.chomp!
  end

  def process_input(string)
    move = string.split(' ')
    oper = move.shift
    pos = move[0].split(',').map { |char| Integer(char) }
    [oper, pos]
  end
end
