require 'spec_helper'
require 'selkie/player'

describe 'Player' do
  before :all do
    class TypicalPlayer
      include Selkie::Player    
    end
  end
  
  it 'responds to zones' do
    player = TypicalPlayer.new
    player.should respond_to :zones
  end
  
  context 'has zone' do
    before :each do
      @player = TypicalPlayer.new
      class NotAZoneYet
      end
    end
  
    it 'can handle a  symbol zone' do
      zone = @player.has_zone :hand
      @player.zones.should have_key :hand
      @player.zones[:hand].should be zone
      @player.zones[:hand].should be_a_kind_of(Selkie::Zone)
    end

    it 'ends up owning zone' do
      zone = @player.has_zone :hand
      zone.owner.should be @player
    end

    it 'can handle a class zone' do
      zone = @player.has_zone NotAZoneYet
      @player.zones.should have_key :NotAZoneYet
      @player.zones[:NotAZoneYet].should be_a_kind_of(Selkie::Zone)
      @player.zones[:NotAZoneYet].should be_a_kind_of(NotAZoneYet)
      @player.zones[:NotAZoneYet].should be zone
    end

    it 'can handle an instance zone' do
      zone = NotAZoneYet.new
      @player.has_zone :grave_yard, zone 
      @player.zones.should have_key :grave_yard
      @player.zones[:grave_yard].should be_an_instance_of(NotAZoneYet)
      @player.zones[:grave_yard].should be_a_kind_of(Selkie::Zone)
      @player.zones[:grave_yard].should be zone
    end
  
    it 'raises an error when key is neither a symbol or class' do
      expect do
        @player.has_zone 1, NotAZoneYet.new
      end.to raise_error(TypeError, "key must be a Symbol or Class")
      expect do
        @player.has_zone [], NotAZoneYet.new
      end.to raise_error(TypeError, "key must be a Symbol or Class")
    end
  
  end
  
  context 'takes turns' do
    before :all do
      class TurnTaker
        include Selkie::Player
        takes_turns
      end
    end

    before :each do
      @player = TurnTaker.new
    end

    it 'responds to order' do
      @player.should respond_to :order
    end

    it 'can set order to 1' do
      @player.order = 1
      @player.order.should eq(1)
    end

    it 'can set order to 10' do
      @player.order = 10
      @player.order.should eq(10)
    end

    it 'requires Fixnums' do
      expect do
        @player.order = nil
      end.to raise_error(TypeError, "order must be a Fixnum")
      expect do
        @player.order = '1'
      end.to raise_error(TypeError, "order must be a Fixnum")
    end

  end
end
