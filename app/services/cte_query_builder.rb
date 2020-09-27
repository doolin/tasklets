# frozen-string-literal: true

# Common Table Expressions are not yet handled natively in Rails,
# so here is a service class for building such queries. The class
# does not do any database access at, it simply builds a SQL statement
# which is handed off to the caller.
class CteQueryBuilder
  def self.descendants(label)
    <<-SQL.squish
        WITH RECURSIVE tree AS (
          select t.id, t.parent_id, t.label from tasks t where label = \'#{label}\'
          UNION ALL
          select t1.id, t1.parent_id, t1.label from tree
          join tasks t1 ON t1.parent_id = tree.id
        )
    SQL
  end

  def self.descendants_cte(label)
    "#{descendants(label)} select id, parent_id, label from tree"
  end

  def self.descendants_count(label)
    "#{descendants(label)} SELECT count(*) FROM tree where parent_id IS NOT NULL"
  end

  def self.descendants_delete(label)
    "#{descendants(label)} delete from tasks where id in (select id from tree)"
  end
end
