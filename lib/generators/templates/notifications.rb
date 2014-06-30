# Use this hook to configure notifications mailer and so forth.
Notifications.setup do |config|

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Notifications::Mailer,
  # note that it will be overwritten if you use your own mailer class
  # with default "from" parameter.
  config.mailer_sender = 'please-change-me-at-config-initializers-notifications@example.com'

  # Configure the class responsible to send e-mails.
  # config.mailer = 'Notifications::Mailer'

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) by default.
  require 'notifications/orm/<%= options[:orm] %>'


end
