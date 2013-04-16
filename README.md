# Postamt

[![Gem Version](https://badge.fury.io/rb/postamt.png)](http://rubygems.org/gems/postamt)

Performs (some of) your read-only queries on a hot standby.

Choose per model and/or controller&action whether a read-only query
should be sent to master or a hot standby.<br />
Or just use `Postamt.on(:slave) { ... }`.

## Installation

Add this line to your application's Gemfile:

    gem 'pg_charmer'

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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
