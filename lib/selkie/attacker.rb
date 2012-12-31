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
        return @level + (@defense == :ac ? 5 : 3)
      end

    end

  end
end