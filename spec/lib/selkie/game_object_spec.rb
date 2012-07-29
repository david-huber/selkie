require 'spec_helper'
require 'selkie/game_object'

describe 'game object actions' do
  
  class DummyClass
    include Selkie::GameObject
    attr_accessor :attacked
    def initialize
      @attacked = false
    end

  end

  before :each do
    @game_object = DummyClass.new()
  end

  context 'with just an effect' do
  
    before :each do
      @game_object.action :attack do
        effect :attacks do
          @attacked = true
        end
      end
    end

    it 'can be performed to effect' do
      @game_object.attack
      @game_object.attacked.should == true
    end

  end
end
