# This file houses the top-level code that executes the game, allowing RSpec 
# to do testing on game.rb, which may be later split up according to classes

require './game.rb'
game = Game.new
puts "Welcome to Connect Four!"
game.play_game
