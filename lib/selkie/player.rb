module Selkie
 
  module Player
    def self.included(base)
      base.extend ClassMethods
    end
   
    def zones
      @zones ||= {}
    end

    def has_zone(key, zone=BaseZone.new)
      raise TypeError, 'key must be a Symbol or Class' unless (key.kind_of? Symbol) || (key.kind_of? Class)
      if key.kind_of? Class
        zone = key.new
        zone.extend Zone unless zone.kind_of? Zone
        zones[key.to_s.to_sym] = zone
      else
        zones[key] = zone
        zone.extend Zone unless zone.kind_of? Zone
      end
      return zone
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
