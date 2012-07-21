require 'spec_helper'
require 'selkie/player'



describe "Player" do
  context "takes turns" do
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
