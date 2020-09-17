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

    context 'label' do
      it 'rejects log strings' do
        expect(build(:task, label: 'a'*65).valid?).to be false
      end
    end
  end

  context 'extracting records' do
    before :all do
      user = User.create(email: 'foo@bar.com')
      root = Task.create!(label: 'Animalia', description: 'Top level root of tree', user: user)
      chordates = root.children.create(label: 'Chordates', description: 'second level of tree', user: user)
      root.children.create(label: 'Sponges', description: 'second level of tree', user: user)
      root.children.create(label: 'Rotifers', description: 'second level of tree', user: user)
      chordates.children.create(label: 'Mammalia', description: 'third level of tree', user: user)
      chordates.children.create(label: 'Amphibian', description: 'third level of tree', user: user)
    end

    describe '#descendants' do
      it 'builds tree from root using repeated database calls' do
        expected = {
          label: 'Animalia',
          children: [{
            label: 'Chordates',
            children: [{
              label: 'Mammalia',
              children: []
            }, {
              label: 'Amphibian',
              children: []
            }]
          }, {
            label: 'Sponges',
            children: []
          }, {
            label: 'Rotifers',
            children: []
          }]
        }.to_json
        actual = Task.find_by(label: 'Animalia').descendants.to_json
        expect(actual).to eq expected
      end
    end

    describe '.count_descendants_with_cte' do
      it 'counts descendants of root' do
        count = Task.count_descendants_with_cte
        expect(count).to be 6
      end

      it 'counts descendants of Rotifers' do
        parent_id = Task.find_by(label: 'Rotifers').id
        count = Task.count_descendants_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendants of Sponges' do
        parent_id = Task.find_by(label: 'Sponges').id
        count = Task.count_descendants_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'counts descendants of Chordates' do
        parent_id = Task.find_by(label: 'Chordates').id
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
          'label' => 'Animalia',
          'children' => [
            {
              'id' => 2,
              'parent_id' => 1,
              'label' => 'Chordates',
              'children' => [
                {
                  'id' => 5,
                  'parent_id' => 2,
                  'label' => 'Mammalia',
                  'children' => []
                },
                {
                  'id' => 6,
                  'parent_id' => 2,
                  'label' => 'Amphibian',
                  'children' => []
                }
              ]
            },
            {
              'id' => 3,
              'parent_id' => 1,
              'label' => 'Sponges',
              'children' => []
            }, {
              'id' => 4,
              'parent_id' => 1,
              'label' => 'Rotifers',
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
