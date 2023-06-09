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

      describe "#one_turn" do
        context 'player_one has had a turn, so player_two should be next' do
          before do
            # current_player = game.instance_variable_get(:@current_player)
            # peter = game.instance_variable_get(:@player_one)
            # current_player = peter
            # chris = game.instance_variable_get(:@player_two)
          end

          it 'changes the value of current_player' do
            current_player = game.instance_variable_get(:@current_player)
            peter = game.instance_variable_get(:@player_one)
            current_player = peter
            chris = game.instance_variable_get(:@player_two)
            game.one_turn
            expect(game.instance_variable_get(:@current_player)).to eq(chris)
          end
        end
      end

      describe "#ask_second_disc" do
        context 'Second player chooses yellow' do
            let(:chris) { instance_double(Player, 'Chris') }
            let(:peter) { instance_double(Player, 'Peter') }
            it 'sends the second player message to set disc to yellow' do
              allow(game).to receive(:disc_input).and_return('Y')
              allow(game).to receive(:@player_two).and_return(chris)
              expect(chris).to receive(:set_yellow)
              game.ask_second_disc
            end

            it 'sends the first player message to set disc to red' do
              allow(game).to receive(:disc_input).and_return('Y')
              allow(game).to receive(:@player_one).and_return(peter)
              expect(peter).to receive(:set_red)
              game.ask_second_disc
            end


        end

      end




      
  end





