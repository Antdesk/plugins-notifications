require 'rails'
require 'active_support/dependencies'
require 'orm_adapter'
require 'set'

module Notifications

  module Mailers
    autoload :Helpers, 'notifications/mailers/helpers'
  end

  # Constants which holds devise configuration for extensions. Those should
  # not be modified by the "end user" (this is why they are constants).
  ALL         = []

  # Address which sends Notification e-mails.
  mattr_accessor :mailer_sender
  @@mailer_sender = nil

  # The parent controller all Notification controllers inherits from.
  # Defaults to ApplicationController. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_controller
  @@parent_controller = "ApplicationController"

  # The parent mailer all Notification mailers inherit from.
  # Defaults to ActionMailer::Base. This should be set early
  # in the initialization process and should be set to a string.
  mattr_accessor :parent_mailer
  @@parent_mailer = "ActionMailer::Base"

  # Default way to setup Notification. Run rails generate notifications_install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end

  class Getter
    def initialize name
      @name = name
    end

    def get
      ActiveSupport::Dependencies.constantize(@name)
    end
  end

  def self.ref(arg)
    if defined?(ActiveSupport::Dependencies::ClassCache)
      ActiveSupport::Dependencies::reference(arg)
      Getter.new(arg)
    else
      ActiveSupport::Dependencies.ref(arg)
    end
  end

  def self.available_router_name
    router_name || :main_app
  end

  # Get the mailer class from the mailer reference object.
  def self.mailer
    @@mailer_ref.get
  end

  # Set the mailer reference object to access the mailer.
  def self.mailer=(class_name)
    @@mailer_ref = ref(class_name)
  end
  self.mailer = "Notifications::Mailer"

end

require 'notifications/models'
require 'notifications/modules'