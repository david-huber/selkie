module Selkie
  class DieSet

    attr_accessor :number, :sides

    def initialize(number, sides)
      @number = number
      @sides = sides
    end

    def modifiers
      @modifiers ||= []
    end

    def plus(modifier)
      modifiers << modifier
      self
    end

    def ==(other)
      @number == other.number && @sides == other.sides && [modifiers, other.modifiers].transpose.all? {|m, o| m == o}
    end

    def +(other)
      self.plus other
    end

    def add_randomness
      self
    end

    def average_roll
      @number * ((@sides + 1) / 2.0) + modifiers.reduce(0) do |sum, modifier|
        bonus = (modifier.respond_to? :average_roll) ? modifier.average_roll : modifier
        sum + bonus
      end
    end

  end
end

class Integer

  def d(side)
    Selkie::DieSet.new(self, side)
  end

end