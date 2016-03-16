# Postamt

[![Gem Version](https://badge.fury.io/rb/postamt.png)](http://rubygems.org/gems/postamt)

Postamt is a sane solution for performing database reads against a hot standby server with Rails.

For Rails 4.1 and above, the current Postamt version is `0.10.0`.
If you use Rails 3.2 or 4.0, use Postamt version `0.9.2`.

Choose per model and/or controller&action whether a read-only query
should be sent to master or a hot standby.<br />
Inside a transaction reads always happen against master.

Care has been taken to avoid [common performance
pitfalls](http://charlie.bz/blog/things-that-clear-rubys-method-cache).
It's been battle tested in production at
[sauspiel.de](https://www.sauspiel.de/).

Monkey-patching is kept to an absolute minimum, the hard work happens
through [officially-supported Rails
APIs](https://github.com/rails/rails/commit/ba1544d71628abff2777c9c514142d7e9a159111#commitcomment-2106059).
That's why there's so little code compared to similar gems.

## Installation

Add this line to your application's Gemfile:

    gem 'postamt'

## Example usage

```yaml
# database.yml
development:
  adapter: postgresql
  database: app
  username: app
  password:
  host: master.db.internal
  encoding: utf8
  slave:
    host: slave.db.internal
    username: app_readonly
```

```ruby
class UserController < ApplicationController
  use_db_connection :slave, for: ['User'], only: [:search]

  def search
    # SELECTs here are sent to slave
    # User#save and User.create would be sent to master anyways.
    # Everything in a transaction block too.
    @users = User.where(...) # sent to slave
    @something_else = SomethingElse.first # sent to master
  end

  def create
    @user = User.new(params[:user])
    @user.save! # sent to master
  end

  def invoice
    transaction do
      @user = User.where(...) # sent to master
      @invoices = Invoice.create(...) # sent to master
    end
  end
end
```

```ruby
class ArchivedItem < ActiveRecord::Base
  # default_connection can be overwritten with 
  # * Postamt.on(...) { ... },
  # * ActiveRecord::Base.transaction { ... }, and
  # * use_db_connection :other_connection, for: ['ArchivedItem'] in a controller.
  self.default_connection = :slave
end

User.where(...) # sent to master
item = ArchivedItem.where(...) # sent to slave
item.title = "changed title"
item.save! # sent to master
item.reload # sent to slave, beware of replication lag here!

ActiveRecord::Base.transaction do
  ArchivedItem.where(...) # sent to master, since we're in a transaction
  User.where(...) # sent to master
end

Postamt.on(:master) do
  ArchivedItem.where(...) # sent to master
  User.where(...) # sent to master
end
```

```ruby
# If you don't want to test with a slave DB put this in config/environments/test.rb
Postamt.force_connection = :master
```

## Tests

Create the DB `postamt_test` and ensure the users `master` and
`slave` exist:

```
$ createdb postamt_test
$ createuser -s master # -s => superuser
$ createuser -s slave # better to restrict slave to be read-only
```

Migrate the DB in the Rails 4 app:

```
$ cd testapp41 # Rails 4.1
$ RAILS_ENV=test bundle exec rake db:migrate
$ bundle exec ruby -Itest test/integration/postamt_test.rb
```

You can't run the tests via a simple `rake` because Postamt deactivates
itself when it detects that a task starting with 'db' is run (like
`db:test:prepare`)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

