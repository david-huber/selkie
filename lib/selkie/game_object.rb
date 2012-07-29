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
      action.perform unless action.nil?
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

    def perform
      effects.each { |k,v| @game_object.instance_eval(&v) }
    end

  end

end
