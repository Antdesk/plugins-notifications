require 'active_support/inflector/inflections'

module Notifications
  module Mailers
    module Helpers
      extend ActiveSupport::Concern

      included do
        #include Devise::Controllers::ScopedViews
        attr_reader :scope_name, :resource
      end

      protected

      # Configure default email options
      def devise_mail(record, action, opts={})
        ActiveSupport::Deprecation.warn "Devise mail"
        ActiveSupport::Deprecation.warn "#{record}"
        ActiveSupport::Deprecation.warn "#{action}"
        initialize_from_record(record)
        mail headers_for(action, opts)
      end

      def initialize_from_record(record)
        @scope_name = record.class.name.underscore
        @resource   = record
        @resource.email = "adrian.toczydlowski@gmail.com"
        ActiveSupport::Deprecation.warn "initialize_from_record"
        ActiveSupport::Deprecation.warn "#{@scope_name}"
        ActiveSupport::Deprecation.warn "#{@resource}"
      end

      def headers_for(action, opts)
        ActiveSupport::Deprecation.warn "headers_for"
        headers = {
            subject: subject_for,
            to: resource.email,
            from: mailer_sender(scope_name),
            reply_to: mailer_reply_to(scope_name),
            template_path: template_paths,
            template_name: action
        }.merge(opts)

        ActiveSupport::Deprecation.warn "headers_for"
        ActiveSupport::Deprecation.warn "#{headers}"

        @email = headers[:to]
        headers
      end

      def mailer_reply_to(scope_name)
        mailer_sender(scope_name, :reply_to)
      end

      def mailer_from(scope_name)
        mailer_sender(scope_name, :from)
      end

      def mailer_sender(scope_name, sender = :from)
        default_sender = default_params[sender]
        if default_sender.present?
          default_sender.respond_to?(:to_proc) ? instance_eval(&default_sender) : default_sender
        elsif Notifications.mailer_sender.is_a?(Proc)
          Notifications.mailer_sender.call(scope_name)
        else
          Notifications.mailer_sender
        end
      end

      def template_paths
        ActiveSupport::Deprecation.warn "template_paths"
        template_path = _prefixes.dup
        template_path.unshift "notifications/mailer"
        template_path
      end

      # Setup a subject doing an I18n lookup. At first, it attempts to set a subject
      # based on the current mapping:
      #
      #   en:
      #     devise:
      #       mailer:
      #         confirmation_instructions:
      #           user_subject: '...'
      #
      # If one does not exist, it fallbacks to ActionMailer default:
      #
      #   en:
      #     devise:
      #       mailer:
      #         confirmation_instructions:
      #           subject: '...'
      #
      def subject_for
        ActiveSupport::Deprecation.warn "subject_for"
        I18n.t(:"subject", scope: [:devise, :mailer],
               default: [:subject])
      end
    end
  end
end