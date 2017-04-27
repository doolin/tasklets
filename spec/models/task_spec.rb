# frozen_string_literal: true

require 'spec_helper'

describe Task do
  it "doesn't save an invalid model" do
    expect(Task.create).not_to be_valid
  end

  it 'saves a valid task' do
    expect(Task.create!(description: 'jgshdlfjk')).to be_valid
  end
end
