# frozen_string_literal: true

require 'rails_helper'
require 'json'
require 'pry'

RSpec.describe Task do
  context 'basic validations' do
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

  context 'extracting records' do
    before :all do
      user = User.create(email: 'foo@bar.com')
      root = Task.create!(tags: 'Animalia', description: 'Top level root of tree', user: user)
      chordates = root.children.create(tags: 'Chordates', description: 'second level of tree', user: user)
      root.children.create(tags: 'Sponges', description: 'second level of tree', user: user)
      root.children.create(tags: 'Rotifers', description: 'second level of tree', user: user)
      chordates.children.create(tags: 'Mammalia', description: 'third level of tree', user: user)
      chordates.children.create(tags: 'Amphibian', description: 'third level of tree', user: user)
    end

    describe 'descendants' do
      it 'descendants' do
        expected = {
          tags: 'Animalia',
          children: [{
            tags: 'Chordates',
            children: [{
              tags: 'Mammalia',
              children: []
            }, {
              tags: 'Amphibian',
              children: []
            }]
          }, {
            tags: 'Sponges',
            children: []
          }, {
            tags: 'Rotifers',
            children: []
          }]
        }.to_json
        actual = Task.find_by(tags: 'Animalia').descendants.to_json
        expect(actual).to eq expected
      end
    end

    describe '.count_descendents_with_cte' do
      it 'counts descendents of root' do
        count = Task.count_descendents_with_cte
        expect(count).to be 6
      end

      it 'counts descendents of Rotifers' do
        parent_id = Task.find_by(tags: 'Rotifers').id
        count = Task.count_descendents_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendents of Sponges' do
        parent_id = Task.find_by(tags: 'Sponges').id
        count = Task.count_descendents_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendents of Chordates' do
        parent_id = Task.find_by(tags: 'Chordates').id
        count = Task.count_descendents_with_cte(parent_id)
        expect(count).to be 2
      end
    end
  end
end
