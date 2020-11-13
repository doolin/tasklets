# frozen_string_literal: true

require 'rails_helper'
require 'json'
require 'pry'

RSpec.describe Task do
  def parent_id_exists
    'Validation failed: Parent id must reference a valid task or be nil'
  end

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
        expect do
          create(:task, label: 'a' * 65)
        end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Label length 64 or less')
      end
    end

    context 'parent_id' do
      it 'rejects unless parent is nil or exists' do
        expect do
          create(:task, parent_id: 42)
        end.to raise_error(ActiveRecord::RecordInvalid, parent_id_exists)
      end
    end
  end

  describe 'destroy' do
    before :each do
      user = User.create(email: 'foo@bar.com')
      root1 = Task.create!(label: 'Animalia', description: 'Top level root of tree', user: user)
      chordates = root1.children.create(label: 'Chordates', description: 'second level of tree', user: user)
      root1.children.create(label: 'Sponges', description: 'second level of tree', user: user)
      root1.children.create(label: 'Rotifers', description: 'second level of tree', user: user)
      chordates.children.create(label: 'Mammalia', description: 'third level of tree', user: user)
      chordates.children.create(label: 'Amphibian', description: 'third level of tree', user: user)
      chordates.children.create(label: 'Reptilia', description: 'third level of tree', user: user)
    end

    it 'assert full tree' do
      expect(Task.count).to be 7
    end

    context 'dependent: :destroy' do
      # Using the destroy method is really expensive, Rails makes a db call for each record:
      #   Task Load (0.3ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."label" = $1 ORDER BY "tasks"."id" ASC LIMIT $2  [["label", "Chordates"], ["LIMIT", 1]]
      #  (0.2ms)  SAVEPOINT active_record_1
      #  Task Load (0.3ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."parent_id" = $1  [["parent_id", 2]]
      #  Task Load (0.2ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."parent_id" = $1  [["parent_id", 5]]
      #  Task Destroy (0.3ms)  DELETE FROM "tasks" WHERE "tasks"."id" = $1  [["id", 5]]
      #  Task Load (0.2ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."parent_id" = $1  [["parent_id", 6]]
      #  Task Destroy (0.2ms)  DELETE FROM "tasks" WHERE "tasks"."id" = $1  [["id", 6]]
      #  Task Load (0.2ms)  SELECT "tasks".* FROM "tasks" WHERE "tasks"."parent_id" = $1  [["parent_id", 7]]
      #  Task Destroy (0.4ms)  DELETE FROM "tasks" WHERE "tasks"."id" = $1  [["id", 7]]
      #  Task Destroy (0.2ms)  DELETE FROM "tasks" WHERE "tasks"."id" = $1  [["id", 2]]
      it 'from root destroys all children' do
        Task.where(label: 'Animalia').first.destroy
        expect(Task.count).to be 0
      end

      it 'from a subtree destroys children' do
        Task.where(label: 'Chordates').first.destroy
        expect(Task.count).to be 3
      end
    end

    context 'delete records from root via CTE' do
      it 'runs CTE for whole tress' do
        Task.descendants_delete('Animalia')
        expect(Task.count).to be 0
      end

      it 'runs CTE for subtree' do
        Task.descendants_delete('Chordates')
        expect(Task.count).to be 3
      end
    end
  end

  describe 'update' do
    context 'with valid parent_id' do
      it 'increases child count for parent' do
        task1 = create :task
        task2 = create :task
        expect do
          task2.update!(parent_id: task1.id)
        end.to change { task1.children.count }.from(0).to(1)
      end
    end

    context 'with nil parent_id' do
      def tree_count
        Task.where(parent_id: nil).count
      end

      it 'increases the number of roots in the table' do
        task1 = create :task
        task2 = create :task, parent_id: task1.id
        expect(tree_count).to be 1
        task2.update!(parent_id: nil)
        expect(tree_count).to be 2
      end
    end

    context 'with non-nil invalid parent_id' do
      it 'raises ActiveRecord::RecordInvalid when parent_id does reference an existing node' do
        expect do
          task = create :task
          task.update!(parent_id: 42)
        end.to raise_error(ActiveRecord::RecordInvalid, parent_id_exists)
      end

      it 'raises an error when updating would induce a cycle' do
        task1 = create :task, label: 'foo'
        task2 = task1.children.create(label: 'bar')
        # This is pretty interesting as Rails apparently manages the self-join
        # automatically, and won't allow a cycle to be induced.
        # TODO: write a snippet to test Rails in more detail.
        expect do
          task1.update!(parent_id: task2.id)
        end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Children is invalid')
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
      root2.children.create(label: 'Forbes', description: 'second level of tree', user: user)
      trees = root2.children.create(label: 'Trees', description: 'second level of tree', user: user)
      trees.children.create(label: 'Evergreen', description: 'third level of tree', user: user)
      trees.children.create(label: 'Deciduous', description: 'third level of tree', user: user)
    end

    describe '#descendants' do
      it 'builds tree from root using repeated database calls' do
        # NOTE: Order matters in the JSON output as a result of order mattering in the
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
        count = Task.size_with_cte('Chordates')
        expect(count).to be 4
      end
    end

    describe '.count_descendants_with_cte' do
      it 'counts descendants of root' do
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
        # TODO: find a way to test output structure TASKLETS-54
        _expected = {
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
