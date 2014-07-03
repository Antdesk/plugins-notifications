require 'active_support/inflector/inflections'

module Notifications
  module Models
    # Notifiable module. Holds common settings for notifications.
    module Notifiable
      extend ActiveSupport::Concern

      included do
        class_attribute :notifications_modules, instance_writer: false
        self.notifications_modules ||= []

      end

      protected

      def notifications_mailer
        Notifications.mailer
      end

      # This is an internal method called every time Notifications needs
      # to send a notification/mail.
      def send_devise_notification(notification, *args)
        ActiveSupport::Deprecation.warn "send_devise_notification"
        ActiveSupport::Deprecation.warn "#{notification}"
        ActiveSupport::Deprecation.warn "#{self}"
        ActiveSupport::Deprecation.warn "po zmianach"
        method = self.class.name.underscore + "_#{notification}"
        method = method.to_sym
        ActiveSupport::Deprecation.warn "#{method}"
        tmp = *args
        ActiveSupport::Deprecation.warn "#{tmp}"
        notifications_mailer.send(method, self, *args).deliver
      end

    end
  end
end
