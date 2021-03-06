module Notifications
  module Models

    # Include the chosen notifications modules in your model:
    #
    #   notifications :create :update :destroy etc.
    #

    def notifications(*modules)

      selected_modules = modules.map(&:to_sym).uniq.sort_by do |s|
        Notifications::ALL.index(s) || -1  # follow Notifications::ALL order
      end

      notifications_modules_hook! do
        include Notifications::Models::Notifiable
        ActiveSupport::Deprecation.warn "after include notifiable!"
        selected_modules.each do |m|
          mod = Notifications::Models.const_get(m.to_s.classify)
          ActiveSupport::Deprecation.warn "after mod = #{mod}!"
          if mod.const_defined?("ClassMethods")
            class_mod = mod.const_get("ClassMethods")
            extend class_mod
          end

          include mod
        end

        self.notifications_modules |= selected_modules

      end
    end

    # The hook which is called inside notifications.
    # So your ORM can include notifications compatibility stuff.
    def notifications_modules_hook!
      yield
    end
  end
end

require 'notifications/models/notifiable'
require 'notifications/models/create'
require 'notifications/models/update'
require 'notifications/models/destroy'
