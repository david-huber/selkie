require 'spec_helper'
require 'selkie/dice'

describe 'Dice' do 

  context '2d8+7' do

    before :each do
      @die = 2.d(8)+7
    end

    it 'has same average after adding randomness' do
      @die.add_randomness.average_roll.should eq(@die.average_roll)
    end

    it 'has different average than 2d8+6' do
      @die.average_roll.should_not eq((2.d(8)+6).average_roll)
    end

    it 'has same average as 4d6+2' do
      @die.average_roll.should eq((4.d(6)+2).average_roll)
    end
  end

  context '1d10+1d6+3' do

    before :each do
      @die = 1.d(10)+1.d(6)+3
    end

    it 'has an average of 12' do
      @die.average_roll.should eq(12.0)
    end

  end

end