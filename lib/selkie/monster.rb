module Selkie
  module Monster
    attr_accessor :level, :role, :threat    
    attr_accessor :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize
      self.class.maker.generate(self)
    end

    def abilities
      @abilities ||= {}
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
        make_monster(maker) { |m| m.set_threat(:elite) }
      end

      def solo(maker = nil)
        make_monster(maker) { |m| m.set_threat(:solo) }
      end

      def standard(maker = nil)
        make_monster(maker) { |m| m.set_threat(:standard) }
      end

      def minion(maker = nil)
        make_monster(maker) { |m| m.set_threat(:minion) }
      end

      #role setters
      def brute(maker = nil)
        make_monster(maker) { |m| m.set_role(:brute) }
      end

      def skirmisher(maker = nil)
        make_monster(maker) { |m| m.set_role(:skirmisher) }
      end

      def soldier(maker = nil)
        make_monster(maker) { |m| m.set_role(:soldier) }
      end

      def lurker(maker = nil)
        make_monster(maker) { |m| m.set_role(:lurker) }
      end

      def controller(maker = nil)
        make_monster(maker) { |m| m.set_role(:controller) }
      end

      def artillery(maker = nil)
        make_monster(maker) { |m| m.set_role(:artillery) }
      end

      #ability support
      def primary_ability(ability)
        modify_monster { |m| m.primary_ability = ability }
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



    module InstanceMethods
    end

    class MonsterMaker
      attr_accessor :level, :role, :threat
      attr_accessor :primary_ability

      def generate(monster)
        if not (@level and @threat and (@role or @threat == :minion))
          raise "Cannot instantiate monsters without a level, role, and threat."
        end
        monster.level = @level
        monster.role = @role
        monster.threat = @threat

        [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma].each do |ability|
          monster.abilities[ability] = 13 + @level / 2 + get_ability_bonus(ability)
        end
      end

      def set_threat(threat)
        @threat = threat
        if @threat == :minion and not @primary_ability
          @primary_ability = :strength
        end
      end

      def set_role(role)
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

      def get_ability_bonus(ability)
        return 3 if @primary_ability == ability
        0
      end
    end

  end
end