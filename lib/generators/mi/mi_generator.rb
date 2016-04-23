require 'rails'
require 'rails/generators/migration'

class MiGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  def self.next_migration_number(dirname)
    next_migration_number = current_migration_number(dirname) + 1
    ActiveRecord::Migration.next_migration_number(next_migration_number)
  end

  Methods = {
    '+' => 'add_column',
    '-' => 'remove_column',
    '%' => 'change_column',
  }.freeze

  source_root File.expand_path('../templates', __FILE__)

  def doing
    migration_template('migration.rb.erb', "db/migrate/#{destination}.rb")
  end


  private

  def arg_groups
    @arg_groups ||= (
      args = @_initializer[0..1].flatten

      current = nil
      res = args.group_by do |a|
        if %w[+ - %].include? a[0]
          current
        else
          current = a
          nil
        end
      end
      res.delete(nil)
      res
    )
  end

  # TODO: parse options
  # @param [String] col +COL_NAME:TYPE:{OPTIONS}
  def parse_column(col)
    name, type, options = *col.split(':')
    method = name[0]
    name = name[1..-1]
    {name: name, type: type, options: options, method: method}
  end

  # @param [String] col +COL_NAME:TYPE:{OPTIONS}
  def to_method(table, col)
    info = parse_column(col)
    res = "#{Methods[info[:method]]} :#{table}, :#{info[:name]}, :#{info[:type]}"
    res << info[:options] if info[:options]
    res
  end

  def to_dest(col)
    parsed = parse_column(col)
    verb =
      case parsed[:method]
      when '+'
        'add'
      when '-'
        'remove'
      when '%'
        'change'
      end
    [verb, parsed[:name]]
  end

  def destination
    table, columns = *arg_groups.first
    [
      columns.map{|c| to_dest(c)}.inject{|sum, x| sum.concat(['and', x].flatten)},
      'to',
      table.tableize,
    ].flatten.join('_')
  end
end
