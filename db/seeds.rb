# frozen_string_literal: true

# rake db:reset will drop the at least the testing and development databases,
# and run db:seed to create the following in the development database. Running
# tasklets_development=# select label, id, parent_id from tasks where parent_id IS NULL;
# at the psql command line should return the Animalia record.
user = User.create(email: 'foo@bar.com')

root1 = Task.create!(label: 'Animalia', description: 'Top level root of tree', user: user)

# Leverage the built in associations methods:
# https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
root1.children.create(label: 'Rotifers', description: 'second level of tree', user: user)
root1.children.create(label: 'Sponges', description: 'second level of tree', user: user)
chordates = root1.children.create(label: 'Chordates', description: 'second level of tree', user: user)

chordates.children.create(label: 'Amphibian', description: 'third level of tree', user: user)
mammalia = chordates.children.create(label: 'Mammalia', description: 'third level of tree', user: user)

mammalia.children.create(label: 'Rodents', description: '4th level', user: user)
mammalia.children.create(label: 'Cats', description: '4th level', user: user)
mammalia.children.create(label: 'Dogs', description: '4th level', user: user)

root2 = Task.create!(label: 'Plants', description: 'Top level root of tree', user: user)
root2.children.create(label: 'Forbes', description: 'second level of tree', user: user)
trees = root2.children.create(label: 'Trees', description: 'second level of tree', user: user)
trees.children.create(label: 'Evergreen', description: 'third level of tree', user: user)
trees.children.create(label: 'Deciduous', description: 'third level of tree', user: user)
