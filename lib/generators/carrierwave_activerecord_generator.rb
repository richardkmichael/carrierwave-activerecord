require 'rails/generators/base'
require 'rails/generators/migration'
require 'rails/generators/active_record'

class CarrierwaveActiverecordGenerator < Rails::Generators::Base

  desc 'Generate a migration to create a database table suitable for file data storage.'
  include Rails::Generators::Migration

  def self.next_migration_number dirname
    ActiveRecord::Generators::Base.next_migration_number dirname
  end

  source_root File.expand_path('templates', File.dirname(__FILE__))

  def create_migration_file
    migration_template 'create_carrierwave_files.rb', 'db/migrate/create_carrierwave_files.rb'
  end

end
