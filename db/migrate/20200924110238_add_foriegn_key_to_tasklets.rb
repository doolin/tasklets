class AddForiegnKeyToTasklets < ActiveRecord::Migration[6.0]
  def up
    # https://stackoverflow.com/questions/3711580/how-does-one-write-a-delete-cascade-for-postgres
    # https://stackoverflow.com/questions/3711580/how-does-one-write-a-delete-cascade-for-postgres
    # https://pawelurbanek.com/rails-postgresql-data-integrity
    # Note: using cascade will bypass any AR destroy callbacks defined on the deleted models.
    #
    # TODO: tinker with the dependent destroy on the Rails model and watch the postgres logs to
    # see how that interacts with the foreign key cascade.
    sql = 'ALTER TABLE ONLY tasks ADD CONSTRAINT tasks_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES tasks (id) ON DELETE CASCADE'
    ActiveRecord::Base.connection.execute sql
  end

  def down
    sql = 'ALTER TABLE tasks DROP CONSTRAINT tasks_parent_id_fkey'
    ActiveRecord::Base.connection.execute sql
  end
end
