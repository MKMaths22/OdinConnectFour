#frozen-string-literal: true

require 'colorize'

puts "This is light yellow".colorize(:light_yellow)
    puts "This is light blue".colorize(:light_blue)
  puts "This is also blue".colorize(:color => :blue)
  puts "This is bold green".colorize(:color => :green, :mode => :bold)
  puts "This is light blue with red background".colorize(:color => :light_blue, :background => :red)
puts "This is light blue with red background".colorize(:light_blue ).colorize( :background => :red)
puts "This is blue text on red".blue.on_red
puts "This is red on blue".colorize(:red).on_blue
puts "This is red on blue and underline".colorize(:red).on_blue.underline
puts "This is blinking blue text on red".blue.on_red.blink
puts "This is uncolorized".blue.on_red.uncolorize
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :white)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :white)
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :red)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :red)
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :red)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :red)
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :red)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :red)
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :red)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :red)
puts "|   |   |   |   |   |   |   |".colorize(:color => :black, :background => :light_yellow)
puts "|___|___|___|___|___|___|___|".colorize(:color => :black, :background => :light_yellow)
puts "  1   2   3   4   5   6   7  "

v = "|".colorize(:color => :black, :background => :white)
red_up = "       ".colorize(:background => :red)
red_lo = "_______".colorize(:color => :black, :background => :red)
yel_up = "       ".colorize(:background => :light_yellow)
yel_lo = "_______".colorize(:color => :black, :background => :light_yellow)
non_up = "       ".colorize(:background => :white)
non_lo = "_______".colorize(:color => :black, :background => :white)
numbers = "    1       2       3       4       5       6       7"

puts v + non_up + v + non_up + v + non_up + v + red_up + v + non_up + v + non_up + v + non_up + v
puts v + non_lo + v + non_lo + v + non_lo + v + red_lo + v + non_lo + v + non_lo + v + non_lo + v
puts v + non_up + v + non_up + v + non_up + v + yel_up + v + non_up + v + non_up + v + non_up + v
puts v + non_lo + v + non_lo + v + non_lo + v + yel_lo + v + non_lo + v + non_lo + v + non_lo + v
puts "    1       2       3       4       5       6       7"



