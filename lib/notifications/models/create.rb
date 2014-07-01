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



      module ClassMethods
        # Attempt to find a user by its email. If a record is found, send new
        # confirmation instructions to it. If not, try searching for a user by unconfirmed_email
        # field. If no user is found, returns a new user with an email not found error.
        # Options must contain the user email
        def send_confirmation_instructions(attributes={})
          ActiveSupport::Deprecation.warn "send_confirmation_instructions"
          confirmable = find_by_unconfirmed_email_with_errors(attributes) if reconfirmable
          ActiveSupport::Deprecation.warn "#{confirmable}{"
          unless confirmable.try(:persisted?)
            ActiveSupport::Deprecation.warn "attributes #{attributes}"
            confirmable = find_or_initialize_with_errors(confirmation_keys, attributes, :not_found)
          end
          ActiveSupport::Deprecation.warn "resend"
          confirmable.resend_confirmation_instructions if confirmable.persisted?
          confirmable
        end

        # Find a user by its confirmation token and try to confirm it.
        # If no user is found, returns a new user with an error.
        # If the user is already confirmed, create an error for the user
        # Options must have the confirmation_token
        def confirm_by_token(confirmation_token)
          original_token     = confirmation_token
          confirmation_token = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)

          confirmable = find_or_initialize_with_error_by(:confirmation_token, confirmation_token)
          confirmable.confirm! if confirmable.persisted?
          confirmable.confirmation_token = original_token
          confirmable
        end

        # Find a record for confirmation by unconfirmed email field
        def find_by_unconfirmed_email_with_errors(attributes = {})
          ActiveSupport::Deprecation.warn "find_by_unconfirmed_email_with_errors"
          unconfirmed_required_attributes = confirmation_keys.map { |k| k == :email ? :unconfirmed_email : k }
          unconfirmed_attributes = attributes.symbolize_keys
          unconfirmed_attributes[:unconfirmed_email] = unconfirmed_attributes.delete(:email)
          find_or_initialize_with_errors(unconfirmed_required_attributes, unconfirmed_attributes, :not_found)
        end

        Devise::Models.config(self, :allow_unconfirmed_access_for, :confirmation_keys, :reconfirmable, :confirm_within)
      end
    end
  end
end
