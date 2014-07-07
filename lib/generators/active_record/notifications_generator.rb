require 'rails/generators/active_record'
require 'generators/notifications/orm_helpers'

module ActiveRecord
  module Generators
    class NotificationsGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      include Notifications::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

=begin
      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end
=end

      def inject_notifications_content

        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
=begin
        raise <<-ERROR
class_path #{class_path} class_name #{class_name} model_path #{model_path} class_path.last #{class_path.last} indent_depth #{indent_depth}.

        ERROR
=end
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"
        inject_into_class(model_path, class_path.last, content) if model_exists?

        inject_into_file 'app/mailers/notifications/mailer.rb', after: "#extend" do <<-CONTENT

Notifications::Mailer.class_eval do
  def #{file_path}_create(record, token, opts={})
      devise_mail(record, :#{file_path}_create, opts)
  end
  def #{file_path}_update(record, token, opts={})
      devise_mail(record, :#{file_path}_update, opts)
  end
  def #{file_path}_destroy(record, token, opts={})
      devise_mail(record, :#{file_path}_destroy, opts)
  end
end
        CONTENT
        end
      end

      def copy_views
        template "template_mail.html.erb", "app/views/notifications/mailer/#{file_path}_create.html.erb"
        template "template_mail.html.erb", "app/views/notifications/mailer/#{file_path}_update.html.erb"
        template "template_mail.html.erb", "app/views/notifications/mailer/#{file_path}_destroy.html.erb"
      end

      def postgresql?
        ActiveRecord::Base.connection.adapter_name.downcase == "postgresql"
      end
    end
  end
end
