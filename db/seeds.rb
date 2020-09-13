# frozen_string_literal: true

# rake db:reset will drop the at least the testing and development databases,
# and run db:seed to create the following in the development database. Running
# tasklets_development=# select tags, id, parent_id from tasks where parent_id IS NULL;
# at the psql command line should return the Animalia record.
user = User.create(email: 'foo@bar.com')
root = Task.create!(tags: 'Animalia', description: 'Top level root of tree', user: user)

# Leverage the built in associations methods:
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
root.children.create(tags: 'Rotifers', description: 'second level of tree', user: user)
root.children.create(tags: 'Sponges', description: 'second level of tree', user: user)
chordates = root.children.create(tags: 'Chordates', description: 'second level of tree', user: user)

chordates.children.create(tags: 'Amphibian', description: 'third level of tree', user: user)
mammalia = chordates.children.create(tags: 'Mammalia', description: 'third level of tree', user: user)

mammalia.children.create(tags: 'Rodents', description: '4th level', user: user)
mammalia.children.create(tags: 'Cats', description: '4th level', user: user)
mammalia.children.create(tags: 'Dogs', description: '4th level', user: user)
