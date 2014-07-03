require 'rails/generators/base'

module Notifications
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a Notifications initializer and copy locale files to your application."
      class_option :orm

      def copy_initializer
        template "notifications.rb", "config/initializers/notifications.rb"
      end

      def copy_mailer
        template "mailer.rb", "app/mailers/notifications/mailer.rb"
      end

      def copy_locale
        copy_file "../../../config/locales/en.yml", "config/locales/notifications.en.yml"
      end

      def rails_4?
        Rails::VERSION::MAJOR == 4
      end
    end
  end
end
