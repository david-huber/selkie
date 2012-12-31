require 'spec_helper'
require 'selkie/attacker'

def verify_attack_modifier_and_damage(target, multi_target=false, attack_index = 0)
  modifier = target == :ac ? 5 : 3
  modifier -= 2 if multi_target

  (1..30).each do |lvl| 
      context "level #{lvl}" do
        before :each do 
          @attacker.level = lvl
          @attack = @attacker.attacks[attack_index]
        end

        it 'has the correct attack modifier' do
          @attack.modifier.should be (lvl + modifier)
        end
      end
    end
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

    verify_attack_modifier_and_damage :ac
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

    it 'should have one two attacks' do
      @attacker.attacks.length.should be 2
    end

    verify_attack_modifier_and_damage :will, true, 0
    verify_attack_modifier_and_damage :fortitude, true, 1
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

    verify_attack_modifier_and_damage :reflex
  end
end