# frozen_string_literal: true

require 'rails_helper'

# The purpose of testing the CteQueryBuilder is to make it more difficult
# to introduce regressions into the code. The SQL can be very sensitive
# and if it fails, difficult to debug. The tests here enforce consistency
# between the class and the test, and have nothing to do with the validity
# of the SQL, which is tested elsewhere.
RSpec.describe CteQueryBuilder do
  let(:label) { 'platypus' }
  let(:cte) do
    <<-SQL.squish
      WITH RECURSIVE tree AS (
        select t.id, t.parent_id, t.label from tasks t where label = \'#{label}\'
        UNION ALL
        select t1.id, t1.parent_id, t1.label from tree
        join tasks t1 ON t1.parent_id = tree.id
      )
    SQL
  end

  describe '.descendants' do
    it 'builds the base CTE' do
      expect(described_class.descendants(label)).to eq cte
    end
  end

  describe '.descendants_cte' do
    it 'selects the descendants from base CTE' do
      expected = "#{cte} select id, parent_id, label from tree"
      expect(described_class.descendants_cte(label)).to eq expected
    end
  end

  describe '.descendants_count' do
    it 'counts the descendants using the base CTE' do
      expected = "#{cte} SELECT count(*) FROM tree where parent_id IS NOT NULL"
      expect(described_class.descendants_count(label)).to eq expected
    end
  end

  describe '.descendants_delete' do
    it 'deletes the descendants from base CTE' do
      expected = "#{cte} delete from tasks where id in (select id from tree)"
      expect(described_class.descendants_delete(label)).to eq expected
    end
  end
end
