# frozen_string_literal: true

# rake db:reset will drop the at least the testing and development databases,
# and run db:seed to create the following in the development database. Running
# tasklets_development=# select label, id, parent_id from tasks where parent_id IS NULL;
# at the psql command line should return the Animalia record.
user = User.create(email: 'foo@bar.com')
root = Task.create!(label: 'Animalia', description: 'Top level root of tree', user: user)

# Leverage the built in associations methods:
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
root.children.create(label: 'Rotifers', description: 'second level of tree', user: user)
root.children.create(label: 'Sponges', description: 'second level of tree', user: user)
chordates = root.children.create(label: 'Chordates', description: 'second level of tree', user: user)

chordates.children.create(label: 'Amphibian', description: 'third level of tree', user: user)
mammalia = chordates.children.create(label: 'Mammalia', description: 'third level of tree', user: user)

mammalia.children.create(label: 'Rodents', description: '4th level', user: user)
mammalia.children.create(label: 'Cats', description: '4th level', user: user)
mammalia.children.create(label: 'Dogs', description: '4th level', user: user)
