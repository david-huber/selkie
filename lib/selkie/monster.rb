require 'selkie/attacker'

module Selkie
  module Monster
    include Selkie::Attacker

    attr_accessor :level, :role, :threat    

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize
      self.class.maker.generate(self)
    end

    def abilities
      @abilities ||= {}
    end

    def hp
      if @threat == :minion
        1
      else
        multiplier = 8
        if @threat != :solo
          multiplier = 10 if @role == :brute
          multiplier = 6 if @role == :lurker || @role == :artillery
        end
        base = multiplier * (1 + @level) + abilities[:constitution]
        if @threat == :solo
          base * 4
        elsif @threat == :elite
          base * 2
        else
          base
        end
      end
    end

    def ac
      case @role
      when :brute, :artillery
        12 + @level
      when :soldier
        16 + @level
      else
        14 + @level
      end 
    end

    def fortitude
      defense(:strength, :constitution)
    end

    def reflex
      defense(:dexterity, :intelligence)
    end

    def will
      defense(:wisdom, :charisma)
    end

    def defense(*abs)
      12 + @level + (abs.map { |a| abilities[a] }.max - (13 + @level / 2)) / 2
    end

    module ClassMethods
      def level(l, maker=nil)
        make_monster(maker) do |m|
          m.level = l
          m.threat ||= :standard
        end
      end

      #threat setters
      def elite(maker = nil)
        make_monster(maker) { |m| m.set_threat!(:elite) }
      end

      def solo(maker = nil)
        make_monster(maker) { |m| m.set_threat!(:solo) }
      end

      def standard(maker = nil)
        make_monster(maker) { |m| m.set_threat!(:standard) }
      end

      def minion(maker = nil)
        make_monster(maker) { |m| m.set_threat!(:minion) }
      end

      #role setters
      def brute(maker = nil)
        make_monster(maker) { |m| m.set_role!(:brute) }
      end

      def skirmisher(maker = nil)
        make_monster(maker) { |m| m.set_role!(:skirmisher) }
      end

      def soldier(maker = nil)
        make_monster(maker) { |m| m.set_role!(:soldier) }
      end

      def lurker(maker = nil)
        make_monster(maker) { |m| m.set_role!(:lurker) }
      end

      def controller(maker = nil)
        make_monster(maker) { |m| m.set_role!(:controller) }
      end

      def artillery(maker = nil)
        make_monster(maker) { |m| m.set_role!(:artillery) }
      end

      #ability support
      def primary_ability(ability)
        modify_monster { |m| m.primary_ability = ability }
      end

      def randomize_abilities
        modify_monster { |m| m.random_ability_modifiers = true }
      end

      def pump(attribute, times=nil)
        times = 1.times if not times          
        times.each do
          modify_monster { |m| m.ability_mods[attribute] = (m.ability_mods[attribute] or 0) +1 }
        end
      end

      def dump(attribute, times=nil)
        times = 1.times if not times          
        times.each do
          modify_monster { |m| m.ability_mods[attribute] = (m.ability_mods[attribute] or 0) -1 }
        end
      end

      #maker support
      def maker
        @maker
      end

      private

      def make_monster(maker)
        if not maker
          if @maker
            raise "Cannot define baseline monster statistics"
          else
            @maker = MonsterMaker.new
          end
          maker = @maker
        end
        yield maker
        @maker
      end

      def modify_monster
        raise "Cannot modify monster without a baseline." if not @maker
        yield @maker
      end
    end

    class MonsterMaker
      attr_accessor :level, :role, :threat
      attr_accessor :primary_ability
      attr_accessor :random_ability_modifiers

      def ability_mods
        @ability_mods ||= {}
      end


      def generate(monster)
        if not (@level and @threat and (@role or @threat == :minion))
          raise "Cannot instantiate monsters without a level, role, and threat."
        end
        monster.level = @level
        monster.role = @role
        monster.threat = @threat

        generate_abilities monster
      end

      def generate_abilities(monster)
        abilities = [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma]
        primary_index = abilities.index(@primary_ability)
        spread = [0, 0, 0, 0, 0]
        if @random_ability_modifiers
          spread = [[2, 0, 0, 0, -2], [1, 0, 0, 0, -1], 
              [1, 1, 0, 0, -2], [2, 0, 0, -1, -1], 
              [1, 1, 1, -1, -2], [4, 0, 0, -2, -2],
              [1, 1, 0, -1, -1], [2, 1, 0, -1, -2],
              [3, 2, 0, -2, -3], [2, 2, 0, -2, -2],
              [3, 2, 0, -2, -3], [4, 3, 0, -3, -4],
              [4, 2, 2, -3, -5], [3, 3, -3, -2, -1],
              [4, 3, 3, -5, -5], [4, 4, 3, -6, -5],
              [5, 4, -4, -3, -2], [5, 5, -2, -3, -5],
              [6, 4, -2, -4, -4], [6, 5, -3, -4, -4]].shuffle()[0].shuffle()
        end
        spread = spread.insert(primary_index, 3)
        ability_mods.each { |k, v| spread[abilities.index(k)] += v }
        abilities.each_index do |index|
          ability = abilities[index]
          monster.abilities[ability] = 13 + @level / 2 + spread[index]
        end
      end

      def set_threat!(threat)
        @threat = threat
        if @threat == :minion and not @primary_ability
          @primary_ability = :strength
        end
      end

      def set_role!(role)
        @role = role
        if not @primary_ability
          case role
          when :soldier
            @primary_ability = :strength
          when :skirmisher
            @primary_ability = :dexterity
          when :brute
            @primary_ability = :constitution
          when :artillery
            @primary_ability = :intelligence
          when :lurker
            @primary_ability = :wisdom
          when :controller
            @primary_ability = :charisma
          else
            raise "Invalid role value."
          end
        end
      end

      private
    end

  end
end