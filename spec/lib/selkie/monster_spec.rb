require 'spec_helper'
require 'selkie/monster'

describe 'Monster' do

  context 'skirmisher' do
    class Skirmisher
      include Selkie::Monster
      skirmisher
    end

    it 'has role of skirmisher' do
      monster = Skirmisher.new
      monster.role.should be :skirmisher
    end
  end

  context 'artillery level 5' do
    class MyMonster
      include Selkie::Monster
      artillery level 5
    end

    before :each do
      @monster = MyMonster.new
    end

    it 'has a level of 5' do
      @monster.level.should be 5
    end

    it 'is a standard threat' do
      @monster.threat.should be :standard
    end

    it 'has role of artillery' do
      @monster.role.should be :artillery
    end
  end

  context 'soldier level 15' do
    class LevelFifteenSoldier
      include Selkie::Monster
      soldier level 15
    end

    before :each do
      @monster = LevelFifteenSoldier.new
    end

    it 'has a level of 15' do
      @monster.level.should be 15
    end

    it 'has a role of soldier' do
      @monster.role.should be :soldier
    end
  end

  context 'elite level 8 lurker' do
    class LevelEightEliteLurker
      include Selkie::Monster
      elite level 8, lurker
    end

    before :each do
      @monster = LevelEightEliteLurker.new
    end

    it 'has a level of 8' do
      @monster.level.should be 8
    end

    it 'is an elite threat' do
      @monster.threat.should be :elite
    end

    it 'has a role of lurker' do
      @monster.role.should be :lurker
    end
  end

  context 'controller level 4 solo' do
    class LevelFourSolo
      include Selkie::Monster
      controller level 4, solo
    end

    before :each do
      @monster = LevelFourSolo.new
    end 

    it 'is a solo threat' do
      @monster.threat.should be :solo
    end

    it 'has a level of 4' do
      @monster.level.should be 4
    end

    it 'has a role of controller' do
      @monster.role.should be :controller
    end
  end

  context 'level 22 minion' do
    class LevelTwentyTwoMinion
      include Selkie::Monster
      level 22, minion
    end

    before :each do
      @monster = LevelTwentyTwoMinion.new
    end

    it 'is a minion' do
      @monster.threat.should be :minion
    end

    it 'has no role' do
      @monster.role.should be nil
    end

  end

  context 'standard brute level 17' do
    class StandardBruteLevelSeventeen
      include Selkie::Monster
      standard brute level 17
    end

    before :each do
      @monster = StandardBruteLevelSeventeen.new
    end 

    it 'is a standard threat' do
      @monster.threat.should be :standard
    end

    it 'has a role of brute' do
      @monster.role.should be :brute
    end
  end

  it 'does not allow multiple base definitions' do
    expect do
      class BadMonster
        include Selkie::Monster
        standard soldier level 1
        standard lurker level 15
      end
    end.to raise_error
  end

end