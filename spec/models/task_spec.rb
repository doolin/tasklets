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
        expect(build(:task, label: 'a' * 65).valid?).to be false
      end
    end
  end

  context 'extracting records' do
    before :all do
      user = User.create(email: 'foo@bar.com')
      root1 = Task.create!(label: 'Animalia', description: 'Top level root of tree', user: user)
      chordates = root1.children.create(label: 'Chordates', description: 'second level of tree', user: user)
      root1.children.create(label: 'Sponges', description: 'second level of tree', user: user)
      root1.children.create(label: 'Rotifers', description: 'second level of tree', user: user)
      chordates.children.create(label: 'Mammalia', description: 'third level of tree', user: user)
      chordates.children.create(label: 'Amphibian', description: 'third level of tree', user: user)
      chordates.children.create(label: 'Reptilia', description: 'third level of tree', user: user)

      root2 = Task.create!(label: 'Plants', description: 'Top level root of tree', user: user)
      forbes = root2.children.create(label: 'Forbes', description: 'second level of tree', user: user)
      trees = root2.children.create(label: 'Trees', description: 'second level of tree', user: user)
      trees.children.create(label: 'Evergreen', description: 'third level of tree', user: user)
      trees.children.create(label: 'Deciduous', description: 'third level of tree', user: user)
    end

    describe '#descendants' do
      it 'builds tree from root using repeated database calls' do
        # Note: Order matters in the JSON output as a result of order mattering in the
        # hash which is created in the method. The following test is fragile in so far as
        # it relies on hash order.
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
            }, {
              label: 'Reptilia',
              children: []
            }]
          }, {
            label: 'Sponges',
            children: []
          }, {
            label: 'Rotifers',
            children: []
          }]
        }
        actual = Task.find_by(label: 'Animalia').descendants
        expect(actual).to eq expected
      end
    end

    describe '.size_with_cte' do
      it 'at root' do
        # TODO: We're counting on an implicit nil here for parent_id TASKLETS-13
        count = Task.size_with_cte('Animalia')
        expect(count).to be 6
      end

      it 'at Rotifers' do
        parent_id = Task.find_by(label: 'Rotifers').id
        count = Task.size_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'at Sponges' do
        parent_id = Task.find_by(label: 'Sponges').id
        count = Task.size_with_cte(parent_id)
        expect(count).to be 0
      end

      it 'at Chordates' do
        parent_id = Task.find_by(label: 'Chordates').id
        count = Task.size_with_cte('Chordates')
        expect(count).to be 4
      end
    end

    describe '.count_descendants_with_cte' do
      it 'counts descendants of root' do
        # TODO: We're counting on an implicit nil here for parent_id TASKLETS-13
        count = Task.count_descendants_with_cte('Animalia')
        expect(count).to be 5
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
        count = Task.count_descendants_with_cte('Chordates')
        expect(count).to be 3
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

        root = Task.where(label: 'Animalia').first
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
        { 'id' => 1, 'parent_id' => nil, 'label' => 'Animalia' },
        { 'id' => 2, 'parent_id' => 1, 'label' => 'Rotifers' },
        { 'id' => 3, 'parent_id' => 1, 'label' => 'Sponges' },
        { 'id' => 4, 'parent_id' => 1, 'label' => 'Chordates' },
        { 'id' => 5, 'parent_id' => 4, 'label' => 'Amphibian' },
        { 'id' => 6, 'parent_id' => 4, 'label' => 'Mammalia' },
        { 'id' => 7, 'parent_id' => 6, 'label' => 'Rodents' },
        { 'id' => 8, 'parent_id' => 6, 'label' => 'Cats' },
        { 'id' => 9, 'parent_id' => 6, 'label' => 'Dogs' }
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
