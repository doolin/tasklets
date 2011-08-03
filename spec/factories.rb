Factory.define :task do |t|
  t.description "Task description dummy text."
end

Factory.define :user do |u|
  u.email                 "david.doolin+3@example.com"
  u.password              "foobar"
  u.password_confirmation "foobar"
end
