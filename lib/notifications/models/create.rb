module Devise
  module Models
    # Confirmable is responsible to verify if an account is already confirmed to
    # sign in, and to send emails with confirmation instructions.
    # Confirmation instructions are sent to the user email after creating a
    # record and when manually requested by a new confirmation instruction request.
    #
    # == Examples
    #
    #   User.find(1).confirm!      # returns true unless it's already confirmed
    #   User.find(1).confirmed?    # true/false
    #   User.find(1).send_confirmation_instructions # manually send instructions
    #
    module Create
      extend ActiveSupport::Concern
      include ActionView::Helpers::DateHelper

      included do
        after_create  :send_on_create_confirmation_instructions
      end

      def initialize(*args, &block)
        super
      end

      # Send confirmation instructions by email
      def send_confirmation_instructions

        ActiveSupport::Deprecation.warn "send_confirmation_instructions"
        opts =  { }
        send_devise_notification(:confirmation_instructions, opts)
      end

      protected

      # A callback method used to deliver confirmation
      # instructions on creation. This can be overridden
      # in models to map to a nice sign up e-mail.
      def send_on_create_confirmation_instructions
        send_confirmation_instructions
      end

    end
  end
end
