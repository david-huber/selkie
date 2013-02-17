require 'spec_helper'
require 'selkie/dice'

describe 'Dice' do 

  context '2d8+7' do

    before :each do
      @die = 2.d(8)+7
    end

    it 'is equal to 2d8+3+4' do
      @die.should eq((2.d(8)+3)+4)
    end

    it 'is equal to 1d8+1d8+7' do
      @die.should eq(1.d(8)+1.d(8)+7)
    end

    it 'is not equal to 1d20+1' do
      @die.should_not eq(1.d(20)+1)
    end

    it 'has same average after adding randomness' do
      @die.add_randomness.average_roll.should eq(@die.average_roll)
    end

    it 'has a looser distribution after adding randomness' do
      randomer = @die.add_randomness
      puts(randomer.roll_units[0])
      puts(@die.roll_units[0])
      randomer.variance.should be > @die.variance
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
      @die.average_roll.should eq(12)
    end
  end

  context '2d6+6+1d8' do

    before :each do
      @die = (2.d(6)+6)+1.d(8)
    end

    it 'has an average of 17.5' do
      @die.average_roll.should eq(17.5)
    end

    it 'is equal to 1d8+2d6+6' do
      @die.should eq(1.d(8)+2.d(6)+6)
    end


  end

end