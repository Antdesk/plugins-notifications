if defined?(ActionMailer)
  class Notifications::Mailer < Notifications.parent_mailer.constantize
    include Notifications::Mailers::Helpers
  end
end
#extend