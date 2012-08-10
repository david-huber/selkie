require 'spec_helper'
require 'selkie/game_object'

describe 'game object actions' do
  

  before :each do
  end

  context 'with just an effect' do
  
    class DummyClass
      include Selkie::GameObject
    
      attr_accessor :attacked
      
      def initialize
        @attacked = false
      end

      action :attack do
        effect :attacks do
          @attacked = true
        end
      end
    
    end
    
    
    before :each do
      @game_object = DummyClass.new()
    end

    it 'can be performed to effect' do
      @game_object.attack
      @game_object.attacked.should == true
    end

  end

  context 'with a targeted effect' do
    
    class SmarterClass
      include Selkie::GameObject
    
      attr_accessor :attacked

      def initialize
        @attacked = false
      end

      action :command do
        targets 1 do |t| 
          t.is_a? SmarterClass 
        end  

        effect :commands do |target|
          target.attacked = true
        end      
      end
    end
    
    before :each do
      @game_object = SmarterClass.new()
      @minion = SmarterClass.new()
    end

    it 'can target the minion' do
      @game_object.command @minion
      @minion.attacked.should == true
    end
  
    it 'cannot target the minion twice' do
      expect do
        @game_object.command @minion, @minion
      end.to raise_error(ArgumentError)
    end
  
    it 'cannot target a number' do
      expect do
        @game_object.command 1000
      end.to raise_error(ArgumentError)
    end
  
  end
end
