module Selkie
  module Zone
    def occupants
      @occupants ||= []
    end

    def owned_by(owner) 
      @owner = owner
    end

    def owner
      @owner
    end
  end

  class BaseZone
    include Zone
  end
end
