module Notifications
  module Models
    module Create
      extend ActiveSupport::Concern
      include ActionView::Helpers::DateHelper

      included do
        after_create  :send_on_create_instructions
      end

      def initialize(*args, &block)
        super
      end

      # Send confirmation instructions by email
      def send_create_instructions

        ActiveSupport::Deprecation.warn "send_create_instructions"
        opts =  { }
        send_devise_notification(:create, opts)
      end

      protected

      # A callback method used to deliver
      # instructions on creation.
      def send_on_create_instructions
        send_create_instructions
      end

    end
  end
end
