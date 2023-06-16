# frozen-string-literal: true
require '../lib/game'
require 'pry-byebug'

describe Game do
  subject(:game) { described_class.new }
      
  describe "#ask_first_name" do
    it "asks the first player their name" do
      expect(game).to receive(:puts).with('Player One, please enter your name:')
      game.ask_first_name
    end
  end
      
  describe "#create_players" do
    context 'When Peter and Chris play' do
      before do 
        allow(game).to receive(:ask_first_name).and_return('Peter')
        allow(game).to receive(:ask_second_name).and_return('Chris')
      end
      it "sends two messages to the Player class" do
        expect(Player).to receive(:new).with('Peter')
        expect(Player).to receive(:new).with('Chris')
        game.create_players
      end

      it "sets the current player to equal player one" do
        game.create_players
        expect(game.current_player).to equal(game.player_one)
      end
    end
  end

  describe "#toggle_player" do
    context 'player_one has had a turn, so player_two should be next' do
        subject(:game) { described_class.new(player_one, player_two, player_one) }
        let(:player_one) { instance_double(Player) }
        let(:player_two) { instance_double(Player) }
      it 'changes the value of current_player' do
        game.toggle_player
        expect(game.instance_variable_get(:@current_player)).to equal(player_two)
      end
    end
  end

  describe "#ask_second_disc" do
    context 'Second player chooses yellow' do
      subject(:game) { described_class.new(player_one, player_two, player_one) }
      let(:player_one) { instance_double(Player) }
      let(:player_two) { instance_double(Player) }
            
      it 'sends the second player message to set disc to yellow' do
        allow(game).to receive(:disc_input).and_return('Y')
        allow(player_one).to receive(:set_red)
        expect(player_two).to receive(:set_yellow)
        game.ask_second_disc
      end

      it 'sends the first player message to set disc to red' do
        allow(game).to receive(:disc_input).and_return('Y')
        allow(player_two).to receive(:set_yellow)
        expect(player_one).to receive(:set_red)
        game.ask_second_disc
      end
    end
  end

  describe '#valid_input' do
    context 'when using valid_input for choice of disc colour' do
      my_array = ['R', 'Y']
      specific_error = "Invalid input. Please enter 'R' or 'Y'"
      context 'wrong input once then valid second time' do
        first_input = 'A'
        second_input = ' Y'
        it 'displays the error once' do
          allow(game).to receive(:error_message).with(my_array).and_return(specific_error)
          allow(game).to receive(:gets).and_return(first_input, second_input)
          expect(game).to receive(:puts).with(specific_error).once
          game.valid_input(my_array)
        end
      end
      context 'valid input first time, lowercase' do
        valid_input = 'r'
        it 'does not display the error' do
          allow(game).to receive(:gets).and_return(valid_input)
          allow(game).to receive(:error_message).with(my_array).and_return(specific_error)
          expect(game).to_not receive(:puts).with(specific_error)
          game.valid_input(my_array)
        end
      end
    end
  end

  describe '#give_colour_name' do
    context 'when input is "R"' do
      it 'outputs "Red"' do
        expect(game.give_colour_name("R")).to eq("Red")
      end
    end

    context 'when input is "Y"' do
      it 'outputs "Yellow"' do
        expect(game.give_colour_name("Y")).to eq("Yellow")
      end
    end
  end
      
  describe '#tell_player_to_choose' do
    context 'it is Peter with the Yellow discs' do
      let(:peter) { instance_double(Player) }
      before do
        allow(peter).to receive(:disc).and_return('Y')
        allow(peter).to receive(:name).and_return('Peter')
      end
      it 'tells Peter to choose a column for a Yellow disc' do
        peter_yellow_message = "Peter, please choose an available column numbered from 1 to 7 for a Yellow disc."
        expect(game).to receive(:puts).with(peter_yellow_message)
        game.tell_player_to_choose(peter)
      end
    end
    context 'it is Chris with the Red discs' do
      let(:chris) { instance_double(Player) }
      before do
        allow(chris).to receive(:disc).and_return('R')
        allow(chris).to receive(:name).and_return('Chris')
      end
      it 'tells Chris to choose a column for a Red disc' do
        chris_red_message = "Chris, please choose an available column numbered from 1 to 7 for a Red disc."
        expect(game).to receive(:puts).with(chris_red_message)
        game.tell_player_to_choose(chris)
      end
    end
  end
      
  describe '#turn_loop' do
    context 'game ends after just 7 turns' do
      let(:board) { instance_double(Board) }
      it 'executes one_turn exactly 6 times' do
        allow(game).to receive(:game_won?).exactly(8).times.and_return(false, false, false, false, false, false, false, true)
        allow(game).to receive(:game_drawn?).exactly(8).times.and_return(false, false, false, false, false, false, false, false)
        expect(game).to receive(:one_turn).exactly(7).times
        game.turn_loop(board)
      end
    end

    context 'game drawn after 42 turns' do
      let(:board) { instance_double(Board) }
      it 'executes one_turn exactly 42 times' do
        allow(game).to receive(:game_won?).exactly(43).times.and_return(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false)
        allow(game).to receive(:game_drawn?).exactly(43).times.and_return(false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, true)
        expect(game).to receive(:one_turn).exactly(42).times
        game.turn_loop(board)
      end
    end
  end

  describe '#announce_result' do
    context 'Peter has won the game versus Chris' do
      subject(:game) { described_class.new(peter, chris, peter) }
      let(:chris) { instance_double(Player) }
      let(:peter) { instance_double(Player) }
       before do
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
        allow(game).to receive(:game_won?).and_return(true)
        allow(game).to receive(:game_drawn?).and_return(false)
      end
      it 'congratulates Peter and commisserates Chris' do
        win_message = "That's Connect Four! Peter wins, well done!"
        lose_message = "Commiserations, Chris. Better luck next time!"
        expect(game).to receive(:puts).with(win_message)
        expect(game).to receive(:puts).with(lose_message)
        game.announce_result
      end
    end

    context 'the game is a draw between Peter and Chris' do
      subject(:game) { described_class.new(peter, chris, chris) }
      let(:chris) { instance_double(Player) }
      let(:peter) { instance_double(Player) }
      before do
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
        allow(game).to receive(:game_drawn?).and_return(true)
        allow(game).to receive(:game_won?).and_return(false)
      end
      it 'announces a draw, mentioning both players' do
        draw_message = "The game ends in a draw, with no Connect Four. Well played, Peter and Chris!"
        expect(game).to receive(:puts).with(draw_message)
        game.announce_result
      end
    end
  end
      
  describe '#player_places_disc' do
    context 'valid column entered first time' do
      valid_input = '5'
      let(:board) { instance_double(Board) }
      it 'sends message to the board' do
        allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(valid_input)
        expect(board).to receive(:try_adding_tile).with('5', 'Y')
        game.player_places_disc(board, 'Y')
      end
    end

    context 'full column entered first time, then possible column' do
      full_column = '4'
      possible_column = '5'
      column_error = 'That column is full. Please choose another.'
      let(:board) { instance_double(Board) }
      it 'sends two messages to the board' do
        allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(full_column, possible_column)
        allow(board).to receive(:try_adding_tile).with('4', 'Y').and_return('full')
        allow(game).to receive(:puts).with(column_error)
        expect(board).to receive(:try_adding_tile).with('5', 'Y')
        game.player_places_disc(board, 'Y')
      end
    end  
      
    context 'possible column entered, which wins the game' do
      possible_column = '5'
      let(:board) { instance_double(Board) }
      before do
        allow(game).to receive(:game_won).and_return(false)
      end
      it 'changes the value of game_won' do
        allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(possible_column)
        allow(board).to receive(:try_adding_tile).with('5', 'Y').and_return('game_won')
        game.player_places_disc(board, 'Y')
        expect(game).to be_game_won
      end
    end

    context 'possible column entered, which draws the game' do
      possible_column = '5'
      let(:board) { instance_double(Board) }
      before do
        allow(game).to receive(:game_drawn).and_return(false)
      end
      it 'changes the value of game_drawn' do
        allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(possible_column)
        allow(board).to receive(:try_adding_tile).with('5', 'Y').and_return('game_drawn')
        game.player_places_disc(board, 'Y')
        expect(game).to be_game_drawn
      end
    end
  end

  describe '#create_board' do
    it 'sends message to the Board class' do
      expect(Board).to receive(:new)
      game.create_board
    end
  end

  describe '#show_board' do
    context 'board has been created' do
      let(:board) { instance_double(Board) }
      it 'sends a message to the board' do
        expect(board).to receive(:display_board)
        game.show_board(board)
      end
    end
  end
  
  describe '#ask_if_same_players' do
    context 'Peter just played Chris in that order' do
      subject(:game) { described_class.new(peter, chris, peter) }
      let(:peter) { instance_double(Player) }
      let(:chris) { instance_double(Player) }
      option_message = 'Press Y if you both wish to play another game but with Chris going first. Type anything else to continue.'
      before do
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
      end
      it 'offers the option to play again with order reversed' do
        expect(game).to receive(:puts).with(option_message)
        game.ask_if_same_players
      end
      context 'the players agree to play again' do
        let(:new_game) { described_class.new(chris, peter, chris) }
        before do
          allow(game).to receive(:gets).and_return('y')
        end
        it 'sends a message to the Game class' do
          allow(game).to receive(:puts).with(option_message)
          allow(new_game).to receive(:play_game)
          expect(described_class).to receive(:new).with(chris, peter, chris).and_return(new_game)
          game.ask_if_same_players
        end
        it 'plays the new game' do
          allow(game).to receive(:puts).with(option_message)
          allow(Game).to receive(:new).with(chris, peter, chris).and_return(new_game)
          expect(new_game).to receive(:play_game)
          game.ask_if_same_players
        end
        it 'returns true' do
          allow(game).to receive(:puts).with(option_message)
          allow(Game).to receive(:new).with(chris, peter, chris).and_return(new_game)
          allow(new_game).to receive(:play_game)
          expect(game.ask_if_same_players).to be true
        end
      end
      context 'the players do not agree to play again' do
        before do
          allow(game).to receive(:gets).and_return('')
        end
        it 'does not send a message to the Game class' do
          expect(Game).to_not receive(:new).with(chris, peter, chris)
          game.ask_if_same_players
        end
      end
    end
  end

  describe '#ask_if_general_new_game' do
    context 'Peter and Chris just played' do
      subject(:game) { described_class.new(peter, chris, peter) }
      let(:peter) { instance_double(Player) }
      let(:chris) { instance_double(Player) }
      option_message = 'Press Y to start a general new game, anything else to quit.'
      quit_message = "Thanks for playing Connect Four! Goodbye."
      before do 
        allow(peter).to receive(:name).and_return('Peter')
        allow(chris).to receive(:name).and_return('Chris')
      end
      it 'asks if a general new game is wanted' do
        allow(game).to receive(:puts).with(quit_message)
        expect(game).to receive(:puts).with(option_message)
        game.ask_if_general_new_game
      end
      
      context 'a general new game is requested' do
        let(:general_new_game) { described_class.new }
        before do
          allow(game).to receive(:gets).and_return('y')
        end
        it 'sends a message to the Game class' do
          allow(game).to receive(:puts).with(option_message)
          allow(general_new_game).to receive(:play_game)
          expect(described_class).to receive(:new).and_return(general_new_game)
          game.ask_if_general_new_game
        end
        it 'plays the new game' do
          allow(game). to receive(:puts).with(option_message)
          allow(Game).to receive(:new).and_return(general_new_game)
          expect(general_new_game).to receive(:play_game)
          game.ask_if_general_new_game
        end
      end
      context 'the game is quit' do
        before do
          allow(game).to receive(:gets).and_return('')
        end
        it 'does not send a message to the Game class' do
          allow(game).to receive(:puts).with(option_message)
          allow(game).to receive(:puts).with(quit_message)
          expect(Game).to_not receive(:new)
          game.ask_if_general_new_game
        end
      end
    end
  end
end

describe Board do
  subject(:board) { described_class.new(first_cells_array) }

  describe '#try_adding_tile' do
    context 'the column has space' do
      let(:first_cells_array) { [['R', 'R', 'Y', 'R', nil, nil],['Y', 'Y', 'R', 'Y', nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      let(:result_array) { [['R', 'R', 'Y', 'R', 'R', nil], ['Y', 'Y', 'R', 'Y', nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
        it 'adds a red tile to the first column' do
          allow(board).to receive(:check_if_game_won?).with(result_array, 0, 4).and_return(false)
          allow(board).to receive(:check_if_game_drawn?).with(result_array, 0, 4).and_return(false)
          board.try_adding_tile('1', 'R')
          expect(board.cells_array).to eq(result_array)
        end
    end

    context 'the column is full' do
      let(:first_cells_array) { [['R', 'R', 'Y', 'R', nil, nil],['Y', 'Y', 'R', 'Y', 'Y', 'R'], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      it "returns 'full' " do
          expect(board.try_adding_tile('2', 'Y')).to eq('full')
      end

      it 'does not change the cells_array' do
          board.try_adding_tile('2', 'Y')
          expect(board.cells_array).to eq(first_cells_array)
      end
    end

    context 'this ends the game in a win' do
      let(:first_cells_array) { [['R', 'R', 'R', nil, nil, nil], ['Y', 'Y', 'R', 'Y', 'Y', nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      let(:next_cells_array) { [['R', 'R', 'R', 'R', nil, nil], ['Y', 'Y', 'R', 'Y', 'Y', nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      it 'declares the game to be won' do
        allow(board).to receive(:check_if_game_won?).with(next_cells_array, 0, 3).and_return(true)
        expect(board.try_adding_tile('1', 'R')).to eq('game_won')
      end
    end

    context 'ends the game in a win with the board full' do
      let(:first_cells_array) { [['R', 'Y', 'R', 'Y', 'R', 'Y'], ['Y', 'R', 'Y', 'R', 'Y', 'R'], ['R', 'Y', 'R', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'Y', 'R', nil], ['R', 'Y', 'R', 'Y', 'R', 'Y'], ['Y', 'R', 'Y', 'R', 'Y', 'R'], ['R', 'Y', 'R', 'Y', 'R', 'Y'] ]}
      let(:next_cells_array) { [['R', 'Y', 'R', 'Y', 'R', 'Y'], ['Y', 'R', 'Y', 'R', 'Y', 'R'], ['R', 'Y', 'R', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'Y', 'R', 'R'], ['R', 'Y', 'R', 'Y', 'R', 'Y'], ['Y', 'R', 'Y', 'R', 'Y', 'R'], ['R', 'Y', 'R', 'Y', 'R', 'Y'] ]}
      it 'declares the game to be won' do
        allow(board).to receive(:check_if_game_won?).with(next_cells_array, 3, 5).and_return(true)
        allow(board).to receive(:check_if_game_drawn?).with(next_cells_array, 3, 5).and_return(true)
        expect(board.try_adding_tile('4', 'R')).to eq('game_won')
      end
    end

    context 'this ends the game in a draw' do
      let(:first_cells_array) { [['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', nil]] }
      let(:next_cells_array) { [['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y']] }
      it 'declares the game to be a draw' do
        allow(board).to receive(:check_if_game_drawn?).with(next_cells_array, 6, 5).and_return(true)
        expect(board.try_adding_tile('7', 'Y')).to eq('game_drawn')
      end
    end
  end

  describe '#is_vertical_connect_four?' do
    let(:first_cells_array) { [['R', 'R', 'R', 'R', nil, nil], ['Y', 'Y', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
    it 'returns true' do
      expect(board.is_vertical_connect_four?(first_cells_array, 0, 3, 'R')).to eq(true)
    end
  end

  describe '#is_horizontal_connect_four?' do
    let(:first_cells_array) { [['R', 'Y', 'Y', 'R', nil, nil], ['Y', 'Y', 'Y', nil, nil, nil], ['R', 'R', 'Y', 'Y', nil, nil], ['Y', 'R', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6)] }
    it 'returns true' do
      expect(board.is_horizontal_connect_four?(first_cells_array, 1, 2, 'Y')).to eq(true)
    end
  end

  describe '#is_north_east_connect_four?' do
    let(:first_cells_array) { [['Y', 'Y', 'R', nil, nil, nil], ['Y', 'R', nil, nil, nil, nil], ['R', 'R', 'R', nil, nil, nil], ['Y', 'Y', 'Y', 'R', nil, nil], ['Y', 'R', 'Y', 'R', 'R', nil], ['R', 'Y', 'Y', 'R', 'Y', nil], ['R', 'Y', 'R', 'Y', 'R', nil]] }
    it 'returns true' do
      expect(board.is_north_east_connect_four?(first_cells_array, 3, 3, 'R')).to eq(true)
    end
  end

  describe '#is_north_west_connect_four?' do
    let(:first_cells_array) { [['R', 'Y', 'R', 'Y', 'R', nil], ['R', 'Y', 'Y', 'R', 'Y', nil], ['Y', 'R', 'Y', 'R', 'R', nil], ['Y', 'Y', 'Y', 'R', nil, nil], ['R', 'R', 'R', nil, nil, nil], ['Y', 'R', nil, nil, nil, nil], ['Y', 'Y', 'Y', nil, nil, nil]] }
    it 'returns true' do
      expect(board.is_north_west_connect_four?(first_cells_array, 3, 3, 'R')).to eq(true)
    end
  end

  describe '#check_if_game_won?' do
    let(:first_cells_array) { [['R', 'R', 'R', nil, nil, nil], ['Y', 'Y', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
    it 'returns false' do
      expect(board.check_if_game_won?(first_cells_array, 0, 2)).to eq(false)
    end
  end

  describe '#check_if_game_drawn?' do
    context 'the board is not full' do
      let(:first_cells_array) { [['R', 'R', 'R', 'Y', 'R', 'Y'], ['Y', 'Y', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      it 'returns false' do
        expect(board.check_if_game_drawn?(first_cells_array, 0, 5)).to eq(false)
      end
    end

    context 'the board is full' do
      let(:first_cells_array) { [['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y']] }
      it 'returns true' do
        expect(board.check_if_game_drawn?(first_cells_array, 1, 5)).to eq(true)
      end
    end
  end

  describe '#top_half' do
    context 'giving default value for first_cells_array' do
      let(:first_cells_array) { Array.new(7) { Array.new(6)} }
      it 'gives seven white spaces for nil' do
        expect(board.top_half(nil)).to eq('       '.colorize(:background => :white))
      end

      it 'gives seven red spaces for R' do
        expect(board.top_half('R')).to eq('       '.colorize(:background => :red))
      end

      it 'gives seven light yellow spaces for Y' do
        expect(board.top_half('Y')).to eq('       '.colorize(:background => :light_yellow))
      end
    end
  end
  
  describe '#low_half' do
    context 'giving default value for first_cells_array' do
      let(:first_cells_array) { Array.new(7) { Array.new(6)} }
      it 'gives seven black underscores on white for nil' do
        expect(board.low_half(nil)).to eq('_______'.colorize(:color => :black, :background => :white))
      end

      it 'gives seven black underscores on red for R' do
       expect(board.low_half('R')).to eq('_______'.colorize(:color => :black, :background => :red))
      end

      it 'gives seven black underscores on light yellow for Y' do
        expect(board.low_half('Y')).to eq('_______'.colorize(:color => :black, :background => :light_yellow))
      end
    end
  end
end





