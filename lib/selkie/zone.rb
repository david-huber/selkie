module Selkie
  module Zone
    def occupants
      @occupants ||= []
    end
  end

  class BaseZone
    include Zone
  end
end
