require 'rails'
require 'rails/generators/active_record/migration/migration_generator'

class MiGenerator < ActiveRecord::Generators::MigrationGenerator
  ar_root = Bundler.load.specs.find{|s|s.name =='activerecord'}.full_gem_path
  source_root Pathname.new(ar_root).join('lib/rails/generators/active_record/migration/templates/')
end
