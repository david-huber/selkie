module Selkie
 
  module Player
    def self.included(base)
      base.extend ClassMethods
    end
   
    def zones
      @zones ||= {}
    end

    def has_zone(key, zone=nil)
      raise TypeError, 'key must be a Symbol or Class' unless (key.kind_of? Symbol) || (key.kind_of? Class)
      if key.kind_of? Class
        zones[key.to_s.to_sym] = key.new
      else
        zones[key] = zone
      end
    end

    module ClassMethods
      def takes_turns
        include TurnMethods
      end
    end
    

    module TurnMethods
   
      def order
        return @order
      end

      def order=(value)
        raise TypeError, 'order must be a Fixnum' unless value.kind_of? Fixnum
        @order = value
      end
    end
  end
end
