require 'rails'

class MiGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def doing
    template 'migration.rb.erb', 'db/migrate/hogehoge.rb'
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

  def migration_class_name
    'TODO'
  end

  def parse_column(col)
    name, type, options = *col.split(':')
    require 'pry'
    binding.pry
    kind = name[0]
    name = name[1..-1]
    {name: name, type: type, options: options, kind: kind}
  end
end
