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


      
  end





