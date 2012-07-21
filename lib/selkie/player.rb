module Selkie
 
  module Player
    def self.included(base)
      base.extend ClassMethods
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
        raise TypeError, "order must be a Fixnum" unless value.kind_of? Fixnum
        @order = value
      end
    end
  end
end
