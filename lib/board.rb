# frozen-string-literal: true

require 'colorize'
require 'pry-byebug'

# Board class keeps score of where the discs are and game ending conditions
class Board
  attr_accessor :cells_array

  def initialize(cells_array = Array.new(7) { Array.new(6) })
    @cells_array = cells_array
  end

  def try_adding_tile(column, disc)
    # The column is inputted as a STRING numbered from 1 to 7, which will have to be reinterpreted
    actual_column = column.to_i - 1
    return 'full' if cells_array[actual_column][5]

    cell_to_use = cells_array[actual_column].index(nil)
    cells_array[actual_column][cell_to_use] = disc
    return 'game_won' if check_if_game_won?(cells_array, actual_column, cell_to_use)

    'game_drawn' if check_if_game_drawn?(cells_array, cell_to_use)
  end

  def top_half(char)
    seven_spaces = '       '
    return seven_spaces.colorize(background: :white) unless char

    char == 'R' ? seven_spaces.colorize(background: :red) : seven_spaces.colorize(background: :light_yellow)
  end

  def low_half(char)
    seven_scores = '_______'
    return seven_scores.colorize(color: :black, background: :white) unless char

    if char == 'R'
      seven_scores.colorize(color: :black,
                            background: :red)
    else
      seven_scores.colorize(
        color: :black, background: :light_yellow
      )
    end
  end

  def display_board
    v = '|'.colorize(color: :black, background: :white)
    numbers = '    1       2       3       4       5       6       7'
    string = ''
    [5, 4, 3, 2, 1, 0].each do |i|
      [0, 1, 2, 3, 4, 5, 6].each do |j|
        string += (v + top_half(cells_array.dig(j, i)))
      end
      string += "#{v}\n"
      [0, 1, 2, 3, 4, 5, 6].each do |j|
        string += (v + low_half(cells_array.dig(j, i)))
      end
      string += "#{v}\n"
    end
    puts string + numbers
  end

  def check_if_game_won?(array, column, row)
    disc = array[column][row]
    return true if vertical_connect_four?(array, column, row, disc)
    return true if horizontal_connect_four?(array, row, disc)
    return true if north_east_connect_four?(array, column, row, disc)
    return true if north_west_connect_four?(array, column, row, disc)

    false
  end

  def vertical_connect_four?(array, column, row, disc)
    return true if array.dig(column,
                             row - 1) == disc && array.dig(column,
                                                           row - 2) == disc && array.dig(column, row - 3) == disc

    false
  end

  def horizontal_connect_four?(array, row, disc)
    [0, 1, 2, 3].each do |i|
      four_in_a_row = true
      [i, i + 1, i + 2, i + 3].each do |j|
        four_in_a_row = false unless array.dig(j, row) == disc
      end
      return true if four_in_a_row
    end
    false
  end

  def north_east_connect_four?(array, column, row, disc)
    diff = column - row
    [0, 1, 2, 3].each do |i|
      four_in_a_north_east_diagonal = true
      [i, i + 1, i + 2, i + 3].each do |j|
        four_in_a_north_east_diagonal = false unless array.dig(j, j - diff) == disc
      end
      return true if four_in_a_north_east_diagonal
    end
    false
  end

  def north_west_connect_four?(array, column, row, disc)
    sum = column + row
    [0, 1, 2, 3].each do |i|
      four_in_a_north_west_diagonal = true
      [i, i + 1, i + 2, i + 3].each do |j|
        four_in_a_north_west_diagonal = false unless array.dig(j, sum - j) == disc
      end
      return true if four_in_a_north_west_diagonal
    end
    false
  end

  def check_if_game_drawn?(array, row)
    return false unless row == 5

    return true unless [array.dig(0, 5), array.dig(1, 5), array.dig(2, 5), array.dig(3, 5), array.dig(4, 5),
                        array.dig(5, 5), array.dig(6, 5)].include?(nil)

    false
  end
end
