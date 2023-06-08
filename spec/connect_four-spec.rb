# frozen-string-literal: true
require '../lib/game'

  describe Game do
    subject(:game) { described_class.new }
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
            # let(:Peter) { double(Player) }
            # let(:Chris) { double(Player) }
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


      
  end





