require 'active_support/inflector/inflections'
require 'active_support/callbacks'

module Notifications
  module Models
    # Notifiable module. Holds common settings for notifications.
    module Notifiable
      extend ActiveSupport::Concern

      included do
        class_attribute :notifications_modules, instance_writer: false
        self.notifications_modules ||= []
        include ActiveSupport::Callbacks
        define_callbacks :custom_callback

        set_callback :custom_callback, :after, :custom
      end

      protected

      def notifications_mailer
        Notifications.mailer
      end

      def custom
        send_devise_notification(:random, @default_value)
      end

      def notification(para)
        run_callbacks :custom_callback do
          @default_value = para
        end
      end

      # This is an internal method called every time Notifications needs
      # to send a notification/mail.
      def send_devise_notification(notification, *args)
        ActiveSupport::Deprecation.warn "send_devise_notification"
=begin
        ActiveSupport::Deprecation.warn "#{notification}"
        ActiveSupport::Deprecation.warn "#{self}"
        ActiveSupport::Deprecation.warn "po zmianach"
=end
        method = self.class.name.underscore + "_#{notification}"
        method = method.to_sym
        ActiveSupport::Deprecation.warn "#{method}"
        tmp = *args
        ActiveSupport::Deprecation.warn "#{tmp}"
        if tmp != {}
          ActiveSupport::Deprecation.warn "tmp rozne {} #{tmp} is_a? #{self.is_a?(Class)}"
          notifications_mailer.send(notification, self, tmp).deliver
        else

          notifications_mailer.send(method, self, *args).deliver
        end

      end

    end
  end
end
