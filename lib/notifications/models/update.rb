module Notifications
  module Models
    module Update
      extend ActiveSupport::Concern
      include ActionView::Helpers::DateHelper

      included do
        after_update :send_on_update_instructions
      end

      def initialize(*args, &block)
        super
      end

      # Send confirmation instructions by email
      def send_update_instructions

        ActiveSupport::Deprecation.warn "send_update_instructions"
        opts =  { }
        send_devise_notification(:update, opts)
      end

      protected

      # A callback method used to deliver
      # instructions on creation.
      def send_on_update_instructions
        send_update_instructions
      end

    end
  end
end
