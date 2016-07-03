require 'rails'
require 'rails/generators'
require 'active_record'
require 'strscan'


module Mi
  module Generators
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
        if arguments.include?('--version')
          puts Mi::VERSION
          return
        end

        migration_template('migration.rb.erb', "db/migrate/#{destination}.rb")
      end


      private

      def arguments
        @_initializer[0..1].flatten
      end

      def arg_groups
        @arg_groups ||= (
          args = arguments.reject{|x| x.start_with?('--')}

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
        sc = StringScanner.new(col)
        name = sc.scan(/[^:]+/)
        sc.scan(/:/)
        type = sc.scan(/[^:]+/)
        sc.scan(/:/)
        options = sc.scan(/\{.+\}$/)

        method = name[0]
        name = name[1..-1]
        {name: name, type: type, options: options, method: method}
      end

      # @param [String] col +COL_NAME:TYPE:{OPTIONS}
      def to_method(table, col)
        info = parse_column(col)
        res = "#{Methods[info[:method]]} :#{table}, :#{info[:name]}"

        return res unless info[:type]
        res << ", :#{info[:type]}"

        return res unless info[:options]
        res << ", #{info[:options][1..-2].gsub(':', ': ').gsub(',', ', ')}"

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
        c = {
          '+' => 'to',
          '-' => 'from',
          '%' => 'of'
        }[parse_column(columns.last)[:method]]
        [
          columns.map{|c| to_dest(c)}.inject{|sum, x| sum.concat(['and', x].flatten)},
          c,
          table.tableize,
        ].flatten.join('_')
      end
    end
  end
end
