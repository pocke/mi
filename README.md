# Mi

[![Gem Version](https://badge.fury.io/rb/mi.svg)](https://badge.fury.io/rb/mi)
[![Build Status](https://travis-ci.org/pocke/mi.svg?branch=master)](https://travis-ci.org/pocke/mi)

`mi` is a generator of migration file instead of `rails generate migration`.

- Simple Syntax
- Automatically generate class name.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mi'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mi

## Usage

### add_column

```sh
$ bin/rails g mi users +email:string
      create  db/migrate/20160429062420_add_email_to_users.rb
```

`db/migrate/20160429062420_add_email_to_users.rb`

```ruby
class AddEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email, :string, null: false
  end
end
```

### remove_column

```sh
$ bin/rails g mi users -email
      create  db/migrate/20160429124502_remove_email_to_users.rb
```

`db/migrate/20160429124502_remove_email_to_users.rb`

```ruby
class RemoveEmailToUsers < ActiveRecord::Migration
  def change
    remove_column :users, :email
  end
end
```


### change_column

```sh
$ bin/rails g mi users %email:string:{null:true}
      create  db/migrate/20160429124852_change_email_to_users.rb
```

`db/migrate/20160429124852_change_email_to_users.rb`

```ruby
class ChangeEmailToUsers < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, null: true
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/mi.

