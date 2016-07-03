require 'rails'
require 'rails/generators'
require 'active_record'
require 'strscan'


module Mi
  module Generators
    class CreateGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

    end
  end
end
