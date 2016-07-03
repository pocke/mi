require 'generators/mi'

module Mi
  module Generators
    class MiGenerator < Base
      source_root File.expand_path('../templates', __FILE__)
      namespace "mi"

      def doing
        migration_template('migration.rb.erb', "db/migrate/#{destination}.rb")
      end


      private


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
