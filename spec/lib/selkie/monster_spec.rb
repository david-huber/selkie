require 'spec_helper'
require 'selkie/monster'

describe 'Monster' do

  def verify_ability_scores(monster, strength, dexterity, constitution, intelligence, wisdom, charisma)
    monster.abilities[:strength].should be strength
    monster.abilities[:dexterity].should be dexterity
    monster.abilities[:constitution].should be constitution
    monster.abilities[:intelligence].should be intelligence
    monster.abilities[:wisdom].should be wisdom
    monster.abilities[:charisma].should be charisma
  end

  def verify_defenses(monster, fortitude, reflex, will)
    monster.fortitude.should be fortitude
    monster.reflex.should be reflex
    monster.will.should be will
  end

  def verifiy_ability_score_sums(monster)
      expectedSum = ((monster.level / 2 + 13) * 6) + 3
      abilitiesSum = 0
      [:strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma].each do |ability| 
        abilitiesSum += monster.abilities[ability]
      end
      abilitiesSum.should be expectedSum
  end

  context 'skirmisher' do
    class Skirmisher
      include Selkie::Monster
      skirmisher level 2
    end

    before :each do
      @monster = Skirmisher.new
    end

    it 'has role of skirmisher' do
      @monster.role.should be :skirmisher
    end

    it 'has the correct ability scores' do
      verify_ability_scores(@monster, 14, 17, 14, 14, 14, 14)
    end

    it 'has 38 hp' do
      @monster.hp.should be 38
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

    it 'has the correct ability scores' do
      verify_ability_scores(@monster, 15, 15, 15, 18, 15, 15)
    end

    it 'has 51 hp' do
      @monster.hp.should be 51
    end

    it 'has an ac of 17' do
      @monster.ac.should be 17
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

    it 'has an ac of 31' do
      @monster.ac.should be 31
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

    it 'has 142 hp' do
      @monster.hp.should be 142
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

    it 'has hp' do
      @monster.hp.should be 220
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

    it 'has the correct ability scores' do
      verify_ability_scores(@monster, 27, 24, 24, 24, 24, 24)
    end

    it 'has one hit point' do
      @monster.hp.should be 1
    end

    it 'has an ac of 36' do
      @monster.ac.should be 36
    end
  end

  context 'elite brute level 3' do
    class EliteBruteLevel3 
      include Selkie::Monster
      elite brute level 3
    end

    before :each do
      @monster = EliteBruteLevel3.new
    end

    it 'has an ac of 15' do
      @monster.ac.should be 15
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

    it 'has 204 hp' do
      @monster.hp.should be 204
    end

    it 'has an ac of 29' do
      @monster.ac.should be 29
    end

    it 'produces the correct defenses' do
      verify_defenses(@monster, 30, 29, 29)
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

  it 'will not construct without a level and role' do
    expect do
      class NoLevel
        include Selkie::Monster
        elite artillery
      end
      monster = NoLevel.new()
    end.to raise_error
    expect do
      class NoRole
        include Selkie::Monster
        level 13
      end
      monster = NoRole.new()
    end.to raise_error
  end

  context 'primary charisma skirmisher' do
    it 'has the correct ability scores' do
      class SuaveSkirmisher
        include Selkie::Monster
        skirmisher level 2
        primary_ability :charisma
      end
      monster = SuaveSkirmisher.new
      verify_ability_scores(monster, 14, 14, 14, 14, 14, 17)
    end
  end

  context 'randomizing abilities' do
    it 'sums to correct ammount' do
      class RandomGuy
        include Selkie::Monster
        soldier level 10
        randomize_abilities
      end
      verifiy_ability_score_sums RandomGuy.new
    end
  end

  context 'pumping and dumping ability scores' do
    class SmartGuy
      include Selkie::Monster
      controller level 28
      pump :intelligence, 2.times
      pump :dexterity
      dump :strength
      dump :wisdom, 2.times
    end

    before :each do
      @monster = SmartGuy.new
    end

    it 'sums to correct ammount and has right values' do
      verify_ability_scores(@monster, 26, 28, 27, 29, 25, 30)
    end

    it 'produces the correct defenses' do
      verify_defenses(@monster, 40, 41, 41)
    end
  end

end