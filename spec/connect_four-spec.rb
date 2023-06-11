# frozen-string-literal: true
require '../lib/game'

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
      end
    end

    describe "#toggle_player" do
      context 'player_one has had a turn, so player_two should be next' do

        it 'changes the value of current_player' do
          current_player = game.instance_variable_get(:@current_player)
          peter = game.instance_variable_get(:@player_one)
          current_player = peter
          chris = game.instance_variable_get(:@player_two)
          game.toggle_player
          expect(game.instance_variable_get(:@current_player)).to eq(chris)
        end
      end
    end

    describe "#ask_second_disc" do
      context 'Second player chooses yellow' do
          let(:game) { Game.new }
          let(:player_one) { instance_double(Player) }
          let(:player_two) { instance_double(Player) }
          before do
            allow(game).to receive(:player_one).and_return(player_one)
            allow(game).to receive(:player_two).and_return(player_two)
          end
            
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

      describe '#tell_player_to_choose' do
        context 'it is Peter with the Yellow discs' do
          let(:peter) { instance_double(Player) }
          before do
            allow(peter).to receive(:disc).and_return('Yellow')
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
            allow(chris).to receive(:disc).and_return('Red')
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
            allow(game).to receive(:game_over?).with(board).exactly(8).times.and_return(false, false, false, false, false, false, false, true)
            expect(game).to receive(:one_turn).exactly(7).times
            game.turn_loop(board)
          end
        end
      
    
      end
      
      
      
      describe '#player_places_disc' do
        context 'valid column entered first time' do
          valid_input = '5'
          let(:board) { instance_double(Board) }
            it 'sends message to the board' do
              allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(valid_input)
              expect(board).to receive(:try_adding_tile).with('5', 'Yellow')
              game.player_places_disc(board, 'Yellow')
            end
        end

        context 'full column entered first time, then possible column' do
          full_column = '4'
          possible_column = '5'
          column_error = 'That column is full. Please choose another.'
          let(:board) { instance_double(Board) }
            it 'sends two messages to the board' do
              allow(game).to receive(:valid_input).with(['1', '2', '3', '4', '5', '6', '7']).and_return(full_column, possible_column)
              allow(board).to receive(:try_adding_tile).with('4', 'Yellow').and_return('full')
              allow(board).to receive(:try_adding_tile).with('5', 'Yellow').and_return(nil)
              allow(game).to receive(:puts).with(column_error)
              expect(board).to receive(:try_adding_tile).with('5', 'Yellow')
              game.player_places_disc(board, 'Yellow')
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
end

describe Board do
  subject(:board) { described_class.new }

  describe '#try_adding_tile' do
    context 'the column has space' do
      let(:current_cells_array) { [['Red', 'Red', 'Yellow', 'Red', 'empty', 'empty'],['Yellow', 'Yellow', 'Red', 'Yellow', 'empty', 'empty'], Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty')] }
      let(:result_array) { [['Red', 'Red', 'Yellow', 'Red', 'Red', 'empty'], ['Yellow', 'Yellow', 'Red', 'Yellow', 'empty', 'empty'], Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty')] }
      before do 
        allow(board).to receive(:cells_array).and_return(current_cells_array)
      end
        it 'adds a red tile to the first column' do
          expect(board).to receive(:cells_array).and_return(result_array)
          board.try_adding_tile('1', 'Red')
        end
    end

    context 'the column is full' do
      let(:current_cells_array) { [['Red', 'Red', 'Yellow', 'Red', 'empty', 'empty'],['Yellow', 'Yellow', 'Red', 'Yellow', 'Yellow', 'Red'], Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty'), Array.new(6, 'empty')] }
      before do
        allow(board).to receive(:cells_array).and_return current_cells_array
      end
        it "returns 'full' " do
          expect(board.try_adding_tile('2', 'Yellow')).to eq('full')
        end

        it 'does not change the cells_array' do
          board.try_adding_tile('2', 'Yellow')
          expect(board.cells_array).to eq(current_cells_array)
        end
      end
  end
end





