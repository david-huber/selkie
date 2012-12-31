require 'spec_helper'
require 'selkie/attacker'

describe 'Attacker' do
  context 'has a basic melee attack versus ac' do

    class DumbGuard
      include Selkie::Attacker
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
  end

  context 'has a ranged attack versus reflex' do

    class SlyArcher
      include Selkie::Attacker
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

  end
end