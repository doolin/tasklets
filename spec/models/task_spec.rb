# frozen_string_literal: true

require 'spec_helper'

describe Task do
  it "doesn't save an invalid model" do
    expect(Task.create).not_to be_valid
  end

  it 'saves a valid task' do
    task = create :task
    expect(task).to be_valid
  end
end
