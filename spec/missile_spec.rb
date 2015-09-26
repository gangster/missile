require 'spec_helper'

describe Missile do
  it 'has a version number' do
    expect(Missile::VERSION).not_to be nil
  end

  it 'loads the Command class' do
    expect(Missile::Command).not_to be nil
  end
end
