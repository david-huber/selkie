require 'selkie/dice'

module Selkie
  module Attacker
    #attackers must implement the following methods:
    #level - returns the attacker's level.  It has to be set before

    def self.included(base)
      base.extend ClassMethods
    end

    def attacks
      @attacks ||= self.class.attacks.map { |a| a.at_level(level) }
    end

    module ClassMethods

      def attacks
        @attacks ||= []
      end

      def versus(target)
        return target
      end

      def attack(defense)
        attack = Attack.new
        attack.defense = defense
        attacks << attack
        attack
      end

      def basic(attack)
        attack.make_basic
        attack
      end

      def melee(attack)
        attack.type = :melee
        attack
      end

      def ranged(attack)
        attack.type = :ranged
        attack
      end

      def area(attack)
        attack.type = :area
        attack
      end

      def close(attack)
        attack.type = :close
        attack
      end
    end

    class Attack

      attr_accessor :defense, :type, :level

      def at_level(lvl)
        leveled = Attack.new()
        leveled.defense = @defense
        leveled.type = @type
        leveled.level = lvl
        leveled.make_basic if is_basic?
        leveled
      end

      def initialize
        @is_basic = false
      end

      def is_basic?
        @is_basic
      end

      def make_basic
        @is_basic = true
      end

      def modifier
        return @level + (@defense == :ac ? 5 : 3) - ((@type == :area or @type == :close) ? 2 : 0)
      end

      def damage
        case @level
        when 1..3
          dice = 1
          sides = 8
          bonus = @level + 3
        when 4..10
          dice = 2
          sides = @level > 6 ? 8 : 6
          bonus = @level - sides + 7
        when 11..20
          dice = 3
          sides = @level > 15 ? 8 : 6
          bonus = @level > 15 ? level - 5 : level - 2
        else
          dice = 4
          sides = @level > 25 ? 8 : 6
          bonus = @level > 25 ? level - 10 : level - 6
        end
        return dice.d(sides).plus(bonus)
      end

    end

  end
end