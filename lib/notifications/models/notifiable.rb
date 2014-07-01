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
        tmp = *args
        ActiveSupport::Deprecation.warn "#{tmp}"
        notifications_mailer.send(notification, self, *args).deliver
      end

    end
  end
end
