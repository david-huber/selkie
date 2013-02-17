module Selkie

  class RollUnit
    attr_accessor :sides, :number

    def initialize(number, sides=1)
      @number = number
      @sides = sides
    end

    def to_s
      "#{@number}d#{@sides}"
    end

    def ==(other)
      number == other.number && sides == other.sides
    end

    def <=>(other)
      if self == other
        0
      else
        if sides > other.sides
          1
        elsif sides == other.sides
          number <=> other.number
        else
          -1
        end
      end
    end

    def copy
      RollUnit.new(@number, @sides)
    end

    def average
      number * ((sides + 1) / 2.0)
    end

    def variance
      v = (1 + sides) * (1 + (2 * sides)) / 6.0
      v -= ( (1+ sides ) / 2.0 )**2
      v * number
    end

  end

  class DieSet

    def initialize(number=1, sides=6)
      return if number < 1
      roll_units << RollUnit.new(number, sides)
    end

    def roll_units
      @roll_units ||= []
    end

    def plus(modifier)
      units = (modifier.respond_to? :roll_units) ? modifier.roll_units : [RollUnit.new(modifier)]
      modified = copy
      units.each { |u| modified.roll_units << u }
      modified.flatten!
    end

    def ==(other)
      [roll_units.sort, other.roll_units.sort].transpose.all? { |u, o| u == o }
    end

    def +(modifier)
      plus modifier
    end

    def add_randomness
      more_random = copy
      first = more_random.roll_units.shift()
      last = more_random.roll_units.pop()  
      
      first.sides += 2

      last.number -= first.number

      more_random.roll_units.unshift(first)
      more_random.roll_units.push(last)

      more_random
    end

    def average_roll
      roll_units.reduce(0) do |sum, unit|
        sum + unit.average
      end
    end

    def variance
      roll_units.reduce(0) do |sum, unit|
        sum + unit.variance
      end
    end

    protected

    def flatten!
      new_units = []
      roll_units.group_by { |unit| unit.sides }.each do |s, units| 
        aggregate_unit = RollUnit.new(units.map { |unit| unit.number }.reduce { | sum, n| sum + n }, s)
        new_units << aggregate_unit        
      end
      @roll_units = new_units.sort { |unit| unit.sides * -1 }
      self
    end

    private 

    def copy
      c = DieSet.new(0, 0)
      roll_units.each do |unit|
        c.roll_units << unit.copy
      end
      c
    end

  end
end

class Integer

  def d(side)
    Selkie::DieSet.new(self, side)
  end

end