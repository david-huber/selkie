require 'spec_helper'
require 'selkie/attacker'

def verify_attack_modifier_and_damage(target)
  modifier = target == :ac ? 5 : 3

  (1..30).each do |lvl| 
      context "level #{lvl}" do
        before :each do 
          @attacker.level = lvl
          @attack = @attacker.attacks[0]
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