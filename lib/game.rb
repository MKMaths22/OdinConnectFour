# frozen-string-literal: true
# The Game class takes care of initializing other classes and whose turn it is next
class Game
  
  attr_accessor :player_one, :player_two, :current_player

  def initialize
    # @this_game = play_game
    @player_one = nil
    @player_two = nil
    @current_player = player_one
  end

  def play_game
    puts "Welcome to Connect Four!"
    sleep(2)
    create_players
    ask_second_disc
  end

  def create_players
    @player_one = Player.new(ask_first_name)
    @player_two = Player.new(ask_second_name)
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

  end
  
  def one_turn
    @current_player = @current_player == @player_one ? player_two : player_one
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

