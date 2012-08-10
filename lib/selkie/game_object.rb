module Selkie
  module GameObject

    def self.included(base)
      base.extend ClassMethods
    end

    def method_missing(name, *args) 
      action = self.class.actions[name]
      action.perform(self, *args) unless action.nil?
    end
   
    module ClassMethods
   
      def actions
        @@actions ||= Hash.new()
      end

      def action(name, &block)
        actions[name] = GameAction.new(&block) 
      end
    end
  end

  class GameAction

    def initialize(&configuration)
      instance_eval(&configuration)  
    end

    def effects
      @effects ||= Hash.new()
    end

    def effect(name, &block)
      effects[name] = block
    end

    def targets(number, &block) 
      @number_of_targets = number
      @target_constraint = block
    end

    def perform(game_object, *args)
      if (!args.nil?) then
        raise ArgumentError unless @number_of_targets.nil? || args.count == @number_of_targets
        raise ArgumentError unless args.all?(&@target_constraint)
      end
      effects.each { |k,v| game_object.instance_exec(*args, &v) }
    end

  end

end
