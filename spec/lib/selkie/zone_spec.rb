require 'spec_helper'
require 'selkie/zone'

describe 'Zone' do
  context 'basic zone behavior' do
    before :all do
      class TypicalZone
        include Selkie::Zone
      end
      @zone = TypicalZone.new
    end

    it 'has occupants' do
      @zone.should respond_to(:occupants)
      @zone.occupants.should be_a_kind_of(Enumerable)
    end
  end
end
