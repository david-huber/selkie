module Selkie
  module GameObject

    def actions
      @actions ||= Hash.new()
    end
    
    def action(name, &block)
      actions[name] = GameAction.new(self, &block) 
    end

    def method_missing(name, *args) 
      action = actions[name]
      action.perform *args unless action.nil?
    end

  end

  class GameAction

    def initialize(game_object, &configuration)
      @game_object = game_object
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

    def perform(*args)
      if (!args.nil?) then
        raise ArgumentError unless @number_of_targets.nil? || args.count == @number_of_targets
        raise ArgumentError unless args.all?(&@target_constraint)
      end
      effects.each { |k,v| @game_object.instance_exec(*args, &v) }
    end

  end

end
