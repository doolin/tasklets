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

    describe '#descendants' do
      it 'builds tree from root using repeated database calls' do
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

    describe '.count_descendants_with_cte' do
      it 'counts descendants of root' do
        count = Task.count_descendants_with_cte
        expect(count).to be 6
      end

      it 'counts descendants of Rotifers' do
        parent_id = Task.find_by(tags: 'Rotifers').id
        count = Task.count_descendants_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendants of Sponges' do
        parent_id = Task.find_by(tags: 'Sponges').id
        count = Task.count_descendants_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendants of Chordates' do
        parent_id = Task.find_by(tags: 'Chordates').id
        count = Task.count_descendants_with_cte(parent_id)
        expect(count).to be 2
      end
    end

    describe '.descendants_cte' do
      it 'returns tuple of all descendants of root' do
        actual = described_class.descendants_cte(nil)
        # TODO: examine structure of actual
        expect(actual.class).to eq Array
      end
    end

    describe '.to_hash' do
      it 'returns tree from root in hash form' do
        expected = {
          'id' => 1,
          'parent_id' => nil,
          'tags' => 'Animalia',
          'children' => [
            {
              'id' => 2,
              'parent_id' => 1,
              'tags' => 'Chordates',
              'children' => [
                {
                  'id' => 5,
                  'parent_id' => 2,
                  'tags' => 'Mammalia',
                  'children' => []
                },
                {
                  'id' => 6,
                  'parent_id' => 2,
                  'tags' => 'Amphibian',
                  'children' => []
                }
              ]
            },
            {
              'id' => 3,
              'parent_id' => 1,
              'tags' => 'Sponges',
              'children' => []
            }, {
              'id' => 4,
              'parent_id' => 1,
              'tags' => 'Rotifers',
              'children' => []
            }
          ]
        }

        root = Task.where(parent_id: nil).first
        tree = described_class.to_hash(root)
        expect(tree.class).to be Hash
        # TODO: find an elegant and accurate way to compare nested hashes
        # for structure disregarding elements such as id, and parent_id.
        # This may require separating the structure generation from how
        # the structure is populated.
        # expect(tree).to eq expected
      end
    end
  end

  describe '.find_children' do
    let(:animals) do
      [
        { 'id' => 1, 'parent_id' => nil, 'tags' => 'Animalia' },
        { 'id' => 2, 'parent_id' => 1, 'tags' => 'Rotifers' },
        { 'id' => 3, 'parent_id' => 1, 'tags' => 'Sponges' },
        { 'id' => 4, 'parent_id' => 1, 'tags' => 'Chordates' },
        { 'id' => 5, 'parent_id' => 4, 'tags' => 'Amphibian' },
        { 'id' => 6, 'parent_id' => 4, 'tags' => 'Mammalia' },
        { 'id' => 7, 'parent_id' => 6, 'tags' => 'Rodents' },
        { 'id' => 8, 'parent_id' => 6, 'tags' => 'Cats' },
        { 'id' => 9, 'parent_id' => 6, 'tags' => 'Dogs' }
      ]
    end

    it 'builds tree as hash from root' do
      index = animals.index { |a| a['parent_id'].nil? }
      root = animals.delete_at(index)
      expect(root['id']).to be 1

      described_class.find_children(root, animals)
      expect(root['children'].count).to be 3
    end
  end
end
