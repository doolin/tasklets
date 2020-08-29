# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  it "doesn't save an invalid model" do
    expect(Task.create).not_to be_valid
  end

  it 'saves a valid task' do
    task = create :task
    expect(task).to be_valid
  end

  it 'creates a child' do
    task = create :task
    task.children << create(:task)
    expect(Task.count).to be 2
  end
end
