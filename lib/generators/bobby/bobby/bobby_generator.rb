require 'rails/generators/migration'

module Devise
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      include Rails::Generators::Migration

      source_root File.expand_path("../templates", __FILE__)
      #namespace "bobby"

      desc "Generates models with the given NAME (if one does not exist) with bobby " <<
           "configuration plus a migration file and bobby routes."

      def self.orm_has_migration?
        Rails::Generators.options[:rails][:orm] == :active_record
      end

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      class_option :orm
      class_option :migration, :type => :boolean, :default => orm_has_migration?

      def invoke_orm_model
        return unless behavior == :invoke

        if model_exists?
          say "* Model already exists. Adding Devise behavior."
        elsif options[:orm].present?
          invoke "model", [name], :migration => false, :orm => options[:orm]

          unless model_exists?
            abort "Tried to invoke the model generator for '#{options[:orm]}' but could not find it.\n" <<
              "Please create your model by hand before calling `rails g devise #{name}`."
          end
        else
          abort "Cannot create a devise model because config.generators.orm is blank.\n" <<
            "Please create your model by hand or configure your generators orm before calling `rails g devise #{name}`."
        end
      end

      def inject_devise_config_into_model
        devise_class_setup = <<-CONTENT

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

CONTENT

        case options[:orm].to_s
        when "mongoid"
          inject_into_file model_path, devise_class_setup, :after => "include Mongoid::Document\n"
        when "data_mapper"
          inject_into_file model_path, devise_class_setup, :after => "include DataMapper::Resource\n"
        when "active_record"
          inject_into_class model_path, class_name, devise_class_setup + <<-CONTENT
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
CONTENT
        end
      end

      def copy_migration_template
        return unless options.migration?
        migration_template "migration.rb", "db/migrate/bobby_create_tables"
      end

      def add_bobby_routes
        route "ressources :roles"
        route "ressources :permissions"
        route "ressources :group_users"
      end

    protected

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
