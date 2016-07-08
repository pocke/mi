require 'rails'
require 'rails/generators'
require 'active_record'
require 'strscan'


module Mi
  module Generators
    class Base < Rails::Generators::Base
      include Rails::Generators::Migration

      attr_reader :arguments

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        ActiveRecord::Migration.next_migration_number(next_migration_number)
      end

      def self.editable
        define_method :edit do
          if @edit
            editor = ENV['EDITOR'] || 'vim'
            fname = File.join('db/migrate', "#{@migration_number}_#{destination}.rb")
            system(editor, fname)
          end
        end
      end

      Methods = {
        '+' => 'add_column',
        '-' => 'remove_column',
        '%' => 'change_column',
      }.freeze

      def parse_args
        @arguments = @_initializer[0..1].flatten

        if @arguments.delete('--version')
          @version = true
        end

        if @arguments.delete('--edit')
          @edit = true
        end
      end

      def version
        if @version
          puts Mi::VERSION
          exit 0 # XXX:
        end
      end


      private


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
    end
  end
end
