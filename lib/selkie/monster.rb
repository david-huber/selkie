module Selkie
  module Monster
    attr_accessor :level, :role, :threat

    def self.included(base)
      base.extend ClassMethods
    end

    def initialize
      @level = self.class.maker.level
      @role = self.class.maker.role
      @threat = self.class.maker.threat
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
        make_monster(maker) { |m| m.threat = :elite }
      end

      def solo(maker = nil)
        make_monster(maker) { |m| m.threat = :solo }
      end

      def standard(maker = nil)
        make_monster(maker) { |m| m.threat = :standard }
      end

      def minion(maker = nil)
        make_monster(maker) { |m| m.threat = :minion }
      end

      #role setters
      def brute(maker = nil)
        make_monster(maker) { |m| m.role = :brute }
      end

      def skirmisher(maker = nil)
        make_monster(maker) { |m| m.role = :skirmisher }
      end

      def soldier(maker = nil)
        make_monster(maker) { |m| m.role = :soldier }
      end

      def lurker(maker = nil)
        make_monster(maker) { |m| m.role = :lurker }
      end

      def controller(maker = nil)
        make_monster(maker) { |m| m.role = :controller }
      end

      def artillery(maker = nil)
        make_monster(maker) { |m| m.role = :artillery }
      end

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

    end

    module InstanceMethods
    end

    class MonsterMaker
      attr_accessor :level, :role, :threat
    end

  end
end