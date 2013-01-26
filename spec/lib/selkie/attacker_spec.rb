require 'spec_helper'
require 'selkie/attacker'
require 'selkie/dice'




def verify_attack_modifier_and_damage(target, damage_table, multi_target=false, attack_index = 0)
  modifier = target == :ac ? 5 : 3
  modifier -= 2 if multi_target

  [(1..30).to_a, damage_table].transpose.each do |lvl, dmg|
      context "level #{lvl}" do
        before :each do 
          @attacker.level = lvl
          @attack = @attacker.attacks[attack_index]
        end

        it 'has the correct attack modifier' do
          @attack.modifier.should be (lvl + modifier)
        end

        it 'has the correct damage dice' do
          @attack.damage.should eq(dmg)
        end
      end
    end
end

def medium_damage_table
      [1.d(8).plus(4),
      1.d(8).plus(5),
      1.d(8).plus(6),
      2.d(6).plus(5),
      2.d(6).plus(6),
      2.d(6).plus(7),
      2.d(8).plus(6),
      2.d(8).plus(7),
      2.d(8).plus(8),
      2.d(8).plus(9),
      3.d(6).plus(9),
      3.d(6).plus(10),
      3.d(6).plus(11),
      3.d(6).plus(12),
      3.d(6).plus(13),
      3.d(8).plus(11),
      3.d(8).plus(12),
      3.d(8).plus(13),
      3.d(8).plus(14),
      3.d(8).plus(15),
      4.d(6).plus(15),
      4.d(6).plus(16),
      4.d(6).plus(17),
      4.d(6).plus(18),
      4.d(6).plus(19),
      4.d(8).plus(16),
      4.d(8).plus(17),
      4.d(8).plus(18),
      4.d(8).plus(19),
      4.d(8).plus(20)]
  end

describe 'Attacker' do

  context 'has a basic melee attack versus ac' do

    class DumbGuard
      include Selkie::Attacker
      attr_accessor :level
      basic melee attack versus :ac
    end

    before :each do
      @attacker = DumbGuard.new
    end

    it 'should have one basic melee attack versus ac' do
      @attacker.attacks.length.should be 1
      attack = @attacker.attacks[0]
      attack.is_basic?.should be true
      attack.defense.should be :ac
      attack.type.should be :melee
    end

    verify_attack_modifier_and_damage :ac, medium_damage_table
  end

  context 'has an area attack versus will and close attack versus fortitude' do
    class TwoTrickAttacker
      include Selkie::Attacker
      attr_accessor :level
      area attack versus :will
      close attack versus :fortitude
    end

    before :each do
      @attacker = TwoTrickAttacker.new
    end

    it 'should have two attacks' do
      @attacker.attacks.length.should be 2
    end

    verify_attack_modifier_and_damage :will, medium_damage_table,  true, 0
    verify_attack_modifier_and_damage :fortitude, medium_damage_table, true, 1
  end

  context 'has a ranged attack versus reflex' do

    class SlyArcher
      include Selkie::Attacker
      attr_accessor :level
      ranged attack versus :reflex
    end

    before :each do
      @attacker = SlyArcher.new
    end

    it 'should have one non-basic ranged attack versus reflex' do
      @attacker.attacks.length.should be 1
      attack = @attacker.attacks[0]
      attack.is_basic?.should be false
      attack.defense.should be :reflex
      attack.type.should be :ranged
    end

    verify_attack_modifier_and_damage :reflex, medium_damage_table
  end
end