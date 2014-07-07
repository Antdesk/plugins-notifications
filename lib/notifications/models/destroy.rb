module Notifications
  module Models
    module Destroy
      extend ActiveSupport::Concern
      include ActionView::Helpers::DateHelper

      included do
        before_destroy :send_on_destroy_instructions
      end

      def initialize(*args, &block)
        super
      end

      # Send confirmation instructions by email
      def send_destroy_instructions

        ActiveSupport::Deprecation.warn "send_destroy_instructions"
        opts =  { }
        send_devise_notification(:destroy, opts)
      end

      protected

      # A callback method used to deliver
      # instructions on creation.
      def send_on_destroy_instructions
        send_destroy_instructions
      end

    end
  end
end
