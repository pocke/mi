require 'rails'

class MiGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def doing
    require 'pry'
    binding.pry
  end


  private

  def arg_groups
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
  end
end
