# frozen-string-literal: true

require 'colorize'
require 'pry-byebug'
require_relative './board'
require_relative './player'

# The Game class takes care of initializing other classes and whose turn it is next
class Game
  attr_accessor :player_one, :player_two, :current_player
  attr_writer :game_won, :game_drawn

  def initialize(first_player = nil, second_player = nil, current_player = nil)
    @player_one = first_player
    @player_two = second_player
    @current_player = current_player
    @game_won = false
    @game_drawn = false
  end

  def game_won?
    @game_won
  end

  def game_drawn?
    @game_drawn
  end

  def new_game_message
    puts '----------------------------------------------------'
    puts '----------------------------------------------------'
    puts '----------------------NEW GAME----------------------'
    puts '----------------------------------------------------'
    puts '----------------------------------------------------'
  end

  def play_game
    new_game_message
    sleep(2)
    create_players unless player_one
    board = create_board
    ask_second_disc
    turn_loop(board)
    show_board(board)
    announce_result
    give_new_game_options
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
    puts 'Player One, please enter your name:'
    gets.strip
  end

  def ask_second_name
    puts 'Player Two, please enter your name:'
    gets.strip
  end

  def ask_second_disc
    if disc_input == 'Y'
      # second_player has chosen yellow, so set disc colours for both players
      player_one.set_red
      player_two.set_yellow
    else
      player_one.set_yellow
      player_two.set_red
    end
  end

  def disc_input
    puts "As Player Two, #{player_two.name}, you get to choose colours."
    sleep(2)
    puts 'Type "R" for red discs, or "Y" for yellow.'
    valid_input(%w[R Y])
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
    error = "Invalid input. Please enter #{this_array.join(', ')}#{end_of_error}"
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
    column_chosen = valid_input(%w[1 2 3 4 5 6 7])
    result = board.try_adding_tile(column_chosen, disc)
    @game_won = true if result == 'game_won'
    @game_drawn = true if result == 'game_drawn'
    return unless result == 'full'

    puts 'That column is full. Please choose another.'
    player_places_disc(board, disc)
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
    return unless game_drawn?

    draw_message = "The game ends in a draw, with no Connect Four. Well played, #{player_one.name} and #{player_two.name}!"
    puts draw_message
  end

  def give_new_game_options
    ask_if_general_new_game unless ask_if_same_players
  end

  def ask_if_same_players
    puts "Press Y if you both wish to play another game but with #{player_two.name} going first. Type anything else to continue."
    choice = gets.strip.upcase
    return unless choice == 'Y'

    new_game = Game.new(player_two, player_one, player_two)
    new_game.play_game
    return true
  end

  def ask_if_general_new_game
    puts 'Press Y to start a general new game, anything else to quit.'
    choice = gets.strip.upcase
    if choice == 'Y'
      new_game = Game.new
      new_game.play_game
    else
      puts 'Thanks for playing Connect Four! Goodbye.'
    end
  end
end
