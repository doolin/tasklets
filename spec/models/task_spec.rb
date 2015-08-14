require 'spec_helper'

describe Task do

  it "doesn't save an invalid model" do
    t = Task.create
    t.should_not be_valid
  end

  it 'saves a valid task' do
    t = Task.create!(:description => 'jgshdlfjk')
    t.should be_valid
  end

end
