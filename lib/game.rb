# frozen-string-literal: true
# The Game class takes care of initializing other classes and whose turn it is next
class Game
  
  attr_accessor :player_one, :player_two, :current_player

  def initialize
    @player_one = nil
    @player_two = nil
    @current_player = player_one
  end

  def play_game
    puts "Welcome to Connect Four!"
    sleep(2)
    create_players
    create_board
    ask_second_disc
  end

  def create_players
    @player_one = Player.new(ask_first_name)
    @player_two = Player.new(ask_second_name)
  end

  def create_board
    board = Board.new
  end

  def ask_first_name
    puts "Player One, please enter your name:"
    gets.strip
  end

  def ask_second_name
    puts "Player Two, please enter your name:"
    gets.strip
  end

  def ask_second_disc
    if disc_input == 'Y'
      player_one.set_red
      player_two.set_yellow
    else 
      player_one.set_yellow
      player_two.set_red
    end
  end

  def disc_input
    puts "Player Two, you get to choose colours."
    sleep(2)
    puts "Type 'R' for red discs, or 'Y' for yellow."
    valid_input(['R', 'Y'])
  end

  def valid_input(array)
    value = gets.strip.upcase
    return value if array.include?(value)

    puts error_message(array)
    valid_input(array)
  end

  def error_message(array)
    this_array = array.clone
    # prevents the array 'array' from being modified below
    end_of_error = " or #{this_array.pop}."
    error = "Invalid input. Please enter " + this_array.join(', ') + end_of_error
  end
  
  def toggle_player
    @current_player = @current_player == @player_one ? player_two : player_one
  end

  def one_turn
    show_board(board)
    tell_player_to_choose(@current_player)
    player_places_disc(board, @current_player.disc)
    toggle_player
  end

  def player_places_disc(board, disc)
    column_error = 'That column is full. Please choose another.'
    column_chosen = valid_input(['1', '2', '3', '4', '5', '6', '7'])
    result = board.try_adding_tile(column_chosen, disc)
    if result == 'full'
      puts column_error
      player_places_disc(board, disc)
    end
  end



end

class Player
  
  attr_accessor :name, :disc
  
  def initialize(name)
    @name = name
    @disc = nil
  end

  def set_red
    @disc = 'Red'
  end

  def set_yellow
    @disc = 'Yellow'
  end
end

class Board
  def initialize
    @cells_array = Array.new(7) { Array.new(6, 'empty') }
  
  end

  def try_adding_tile(column, disc)
   'full'
  end

end

