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
    create_players
  end

  def create_players
    @player_one = Player.new(ask_first_name)
    @player_two = Player.new(ask_second_name)
  end

  def ask_first_name
  
  end

  def ask_second_name
  
  end

  def one_turn
    @current_player = @current_player == @player_one ? player_two : player_one
  end



end

class Player
  def initialize(name)
    @name = name
  end
end

