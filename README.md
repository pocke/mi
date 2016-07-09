# Mi

[![Gem Version](https://badge.fury.io/rb/mi.svg)](https://badge.fury.io/rb/mi)
[![Build Status](https://travis-ci.org/pocke/mi.svg?branch=master)](https://travis-ci.org/pocke/mi)
[![Coverage Status](https://coveralls.io/repos/github/pocke/mi/badge.svg?branch=master)](https://coveralls.io/github/pocke/mi?branch=master)
[![Stories in Ready](https://badge.waffle.io/pocke/mi.svg?label=ready&title=Ready)](http://waffle.io/pocke/mi)

`mi` is a generator of migration file instead of `rails generate migration`.

- Simple Syntax
- Automatically generate class name.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'mi'
end
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
    add_column :users, :email, :string
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

### create_table

```sh
$ bin/rails g mi:create users +email:string:{null:false} +name:string
      create  db/migrate/20160704144601_create_users_table.rb
```

`db/migrate/20160704144601_create_users_table.rb`

```ruby
class CreateUsersTable < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :name

      t.timestamps null: false
    end
  end
end
```


### Open with editor

Put a `--edit` option, mi opens the migration file after generated.

```sh
$ bin/rails g mi users +email:string --edit
```

## Dependencies

- Ruby 2.2 or higher
- Rails 4



## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/mi.


## Links

- [もっと便利に rails g migration する - pockestrap](http://pocke.hatenablog.com/entry/2016/05/01/132228)
- [Railsのマイグレーション生成をもっともっとImprovementする! mi gem version 1.0.0 をリリースしました! - pockestrap](http://pocke.hatenablog.com/entry/2016/07/09/180706)
