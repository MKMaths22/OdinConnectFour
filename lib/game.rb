# frozen-string-literal: true
require 'colorize'

# The Game class takes care of initializing other classes and whose turn it is next
class Game
  
  attr_accessor :player_one, :player_two, :current_player
  attr_writer :game_won, :game_drawn

  def initialize
    @player_one = nil
    @player_two = nil
    @current_player = nil
    @game_won = false
    @game_drawn = false
  end

  def game_won?
    @game_won
  end

  def game_drawn?
    @game_drawn
  end

  def play_game
    puts "Welcome to Connect Four!"
    sleep(2)
    create_players
    board = create_board
    ask_second_disc
    turn_loop(board)
    show_board(board)
    announce_result
  end

  def create_players
    @player_one = Player.new(ask_first_name)
    @current_player = @player_one
    @player_two = Player.new(ask_second_name)
  end

  def create_board
    Board.new
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

  def show_board(board)
    board.display_board
  end
  
  def turn_loop(board)
    one_turn(board) until game_won? || game_drawn?
  end
  
  def one_turn(board)
    show_board(board)
    tell_player_to_choose(@current_player)
    player_places_disc(board, @current_player.disc)
    toggle_player unless game_won?
    # ensures that announce_result method knows that the current_player won the game
  end

  def give_colour_name(string)
    string == 'R' ? 'Red' : 'Yellow'
  end
  
  def tell_player_to_choose(player)
    puts "#{player.name}, please choose an available column numbered from 1 to 7 for a #{give_colour_name(player.disc)} disc."
  end

  def player_places_disc(board, disc)
    column_chosen = valid_input(['1', '2', '3', '4', '5', '6', '7'])
    result = board.try_adding_tile(column_chosen, disc)
    @game_won = true if result == 'game_won'
    @game_drawn = true if result == 'game_drawn'
    if result == 'full'
      puts 'That column is full. Please choose another.'
      player_places_disc(board, disc)
    end
  end

  def announce_result
    if game_won?
      winning_player = current_player
      losing_player = player_one == current_player ? player_two : player_one
      win_message = "That's Connect Four! #{winning_player.name} wins, well done!"
      lose_message = "Commiserations, #{losing_player.name}. Better luck next time!"
      puts win_message
      puts lose_message
    end
    if game_drawn?
      draw_message = "The game ends in a draw, with no Connect Four. Well played, #{player_one.name} and #{player_two.name}!"
      puts draw_message
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
    @disc = 'R'
  end

  def set_yellow
    @disc = 'Y'
  end
end

class Board
  
  attr_accessor :cells_array
  
  def initialize
    @cells_array = Array.new(7) { Array.new(6, nil) }
  end

  def try_adding_tile(column, disc)
    # The column is inputted as a STRING numbered from 1 to 7, which will have to be reinterpreted 
    actual_column = column.to_i - 1
    return 'full' unless cells_array[actual_column][5] == nil

    cell_to_use = cells_array[actual_column].index(nil)
    cells_array[actual_column][cell_to_use] = disc
    return 'game_won' if check_if_game_won?(cells_array, actual_column, cell_to_use)

    return 'game_drawn' if check_if_game_drawn?(cells_array, actual_column, cell_to_use)

  end

  def top_half(char)
    seven_spaces = '       '
    return seven_spaces.colorize(:background => :white) unless char
    char == 'R' ? seven_spaces.colorize(:background => :red) : seven_spaces.colorize(:background => :light_yellow)
  end

  def low_half(char)
    seven_scores = '_______'
    return seven_scores.colorize(:color => :black, :background => :white) unless char
    char == 'R' ? seven_scores.colorize(:color => :black, :background => :red) : seven_scores.colorize(:color => :black, :background => :light_yellow)
  end
  
  def display_board
    v = "|".colorize(:color => :black, :background => :white)
    numbers = "    1       2       3       4       5       6       7"
    string = ''
      [5, 4, 3, 2, 1, 0].each do |i|
        [0, 1, 2, 3, 4, 5, 6].each do |j|
          string += (v + top_half(cells_array.dig(j, i)))
        end
        string += (v + "\n")
        [0, 1, 2, 3, 4, 5, 6].each do |j|
          string += (v + low_half(cells_array.dig(j, i)))
        end
        string += (v + "\n")
      end
    puts string + numbers
  end

  def check_if_game_won?(array, column, row)
    disc = array[column][row]
    return true if array.dig(column, row - 1) == disc && array.dig(column, row - 2) == disc && array.dig(column, row - 3) == disc
    
    for i in [0, 1, 2, 3] do
      four_in_a_row = true
      for j in [i, i + 1, i + 2, i + 3] do
        four_in_a_row = false unless array.dig(j, row) == disc
      end
      return true if four_in_a_row
    end
    
    diff = column - row
    for i in [0, 1, 2, 3] do
      four_in_a_north_east_diagonal = true
      for j in [i, i + 1, i + 2, i + 3] do
        four_in_a_north_east_diagonal = false unless array.dig(j, j - diff) == disc
      end
      return true if four_in_a_north_east_diagonal
    end

    sum = column + row
    for i in [0, 1, 2, 3] do
      four_in_a_north_west_diagonal = true
      for j in [i, i + 1, i + 2, i + 3] do
        four_in_a_north_west_diagonal = false unless array.dig(j, sum - j) == disc
      end
      return true if four_in_a_north_west_diagonal
    end
    
    return false
  end 

  def check_if_game_drawn?(array, column, row)
    return false unless row == 5

    return true unless [array.dig(0, 5), array.dig(1, 5), array.dig(2, 5), array.dig(3, 5), array.dig(4, 5), array.dig(5, 5), array.dig(6, 5)].include?(nil)

    false
  end

end

