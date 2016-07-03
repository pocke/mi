require 'generators/mi'

module Mi
  module Generators
    class CreateGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)
    end
  end
end
