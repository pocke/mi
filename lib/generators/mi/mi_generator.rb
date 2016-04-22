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
      current = a unless %w[+ - %].include? a[0]
      current
    end

    res.each{|_key, val| val.shift}

    res
  end
end
