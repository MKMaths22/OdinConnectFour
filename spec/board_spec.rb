# frozen-string-literal: true

require '../lib/game'
require '../lib/board'
require 'pry-byebug'

describe Board do
  subject(:board) { described_class.new(first_cells_array) }

  describe '#try_adding_tile' do
    context 'the column has space' do
      let(:first_cells_array) { [['R', 'R', 'Y', 'R', nil, nil],['Y', 'Y', 'R', 'Y', nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
      let(:result_array) { [['R', 'R', 'Y', 'R', 'R', nil], ['Y', 'Y', 'R', 'Y', nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
        it 'adds a red tile to the first column' do
          allow(board).to receive(:check_if_game_won?).with(result_array, 0, 4).and_return(false)
          allow(board).to receive(:check_if_game_drawn?).with(result_array, 4).and_return(false)
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
        allow(board).to receive(:check_if_game_drawn?).with(next_cells_array, 5).and_return(true)
        expect(board.try_adding_tile('7', 'Y')).to eq('game_drawn')
      end
    end
  end

  describe '#vertical_connect_four?' do
    let(:first_cells_array) { [['R', 'R', 'R', 'R', nil, nil], ['Y', 'Y', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6), Array.new(6), Array.new(6)] }
    it 'returns true' do
      expect(board.vertical_connect_four?(first_cells_array, 0, 3, 'R')).to eq(true)
    end
  end

  describe '#horizontal_connect_four?' do
    let(:first_cells_array) { [['R', 'Y', 'Y', 'R', nil, nil], ['Y', 'Y', 'Y', nil, nil, nil], ['R', 'R', 'Y', 'Y', nil, nil], ['Y', 'R', 'Y', nil, nil, nil], Array.new(6), Array.new(6), Array.new(6)] }
    it 'returns true' do
      expect(board.horizontal_connect_four?(first_cells_array, 2, 'Y')).to eq(true)
    end
  end

  describe '#north_east_connect_four?' do
    let(:first_cells_array) { [['Y', 'Y', 'R', nil, nil, nil], ['Y', 'R', nil, nil, nil, nil], ['R', 'R', 'R', nil, nil, nil], ['Y', 'Y', 'Y', 'R', nil, nil], ['Y', 'R', 'Y', 'R', 'R', nil], ['R', 'Y', 'Y', 'R', 'Y', nil], ['R', 'Y', 'R', 'Y', 'R', nil]] }
    it 'returns true' do
      expect(board.north_east_connect_four?(first_cells_array, 3, 3, 'R')).to eq(true)
    end
  end

  describe '#north_west_connect_four?' do
    let(:first_cells_array) { [['R', 'Y', 'R', 'Y', 'R', nil], ['R', 'Y', 'Y', 'R', 'Y', nil], ['Y', 'R', 'Y', 'R', 'R', nil], ['Y', 'Y', 'Y', 'R', nil, nil], ['R', 'R', 'R', nil, nil, nil], ['Y', 'R', nil, nil, nil, nil], ['Y', 'Y', 'Y', nil, nil, nil]] }
    it 'returns true' do
      expect(board.north_west_connect_four?(first_cells_array, 3, 3, 'R')).to eq(true)
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
        expect(board.check_if_game_drawn?(first_cells_array, 5)).to eq(false)
      end
    end

    context 'the board is full' do
      let(:first_cells_array) { [['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y'], ['R', 'Y', 'R', 'R', 'Y', 'R'], ['Y', 'R', 'Y', 'Y', 'R', 'Y']] }
      it 'returns true' do
        expect(board.check_if_game_drawn?(first_cells_array, 5)).to eq(true)
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

