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
  self.mailer = "Notifications::Mailer "

  # == Options:
  #
  #   +model+      - String representing the load path to a custom *model* for this module (to autoload.)
  #   +controller+ - Symbol representing the name of an existing or custom *controller* for this module.
  #   +route+      - Symbol representing the named *route* helper for this module.
  #
  # All values, except :model, accept also a boolean and will have the same name as the given module
  # name.
  #
  # == Examples:
  #
  #   Notifications.add_module(:party_module)
  #   Notifications.add_module(:party_module, controller: :sessions)
  #   Notifications.add_module(:party_module, model: 'party_module/model')
  #
  def self.add_module(module_name, options = {})
    ALL << module_name
    options.assert_valid_keys(:model)

    if options[:model]
      path = (options[:model] == true ? "devise/models/#{module_name}" : options[:model])
      camelized = ActiveSupport::Inflector.camelize(module_name.to_s)
      Notifications::Models.send(:autoload, camelized.to_sym, path)
    end

    Notifications::Mapping.add_module module_name
  end

end

require 'notifications/mapping'
require 'notifications/models'
require 'notifications/modules'