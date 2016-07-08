require 'generators/mi'

module Mi
  module Generators
    class CreateGenerator < Base
      class TypeIsRequired < StandardError; end
      class NotAllowMethod < StandardError; end

      source_root File.expand_path('../templates', __FILE__)

      def doing
        migration_template('create.rb.erb', "db/migrate/#{destination}.rb")
      end

      editable


      private


      # returns t.TYPE :NAME, OPTIONS: true
      # e.g.) t.string :email
      def to_method(col)
        info = parse_column(col)
        # TODO: when type is not specified, migration file would be created.
        raise TypeIsRequired, "When mi:create, type is required. Please specify type like `#{info[:name]}:TYPE`" unless info[:type]
        raise NotAllowMethod, "#{info[:method]} is not allowed. You can only use `+` when `mi:create`" unless info[:method] == '+'

        res = "t.#{info[:type]} :#{info[:name]}"

        return res unless info[:options]
        # TODO: DRY
        res << ", #{info[:options][1..-2].gsub(':', ': ').gsub(',', ', ')}"

        res
      end

      # when create table, table name is only one.
      def table_name
        @table_name ||= (
          table, = *arg_groups.first
          table.tableize
        )
      end

      def destination
        "create_#{table_name}_table"
      end
    end
  end
end
