# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

a = Bar.create!(message: 'a')
b = Bar.create!(message: 'b')
c = Bar.create!(message: 'c')

Foo.create!(bar: a)
Foo.create!(bar: a)
Foo.create!(bar: b)
