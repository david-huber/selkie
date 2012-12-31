module Selkie
  module Attacker

    def self.included(base)
      base.extend ClassMethods
    end

    def attacks
      self.class.attacks
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

      attr_accessor :defense, :type

      def initialize
        @is_basic = false
      end

      def is_basic?
        @is_basic
      end

      def make_basic
        @is_basic = true
      end

    end

  end
end