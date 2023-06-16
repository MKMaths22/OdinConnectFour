# frozen-string-literal: true

# Player class takes care of names and disc colours 
class Player
  
  attr_accessor :name, :disc
  
  def initialize(name)
    @name = name
    @disc = nil
  end

  def set_red
    @disc = 'R'
  end

  def set_yellow
    @disc = 'Y'
  end
end