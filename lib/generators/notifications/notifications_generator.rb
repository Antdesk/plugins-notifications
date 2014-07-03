require 'rails/generators/named_base'

module Notifications
  module Generators
    class DeviseGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace "notifications"
      source_root File.expand_path("../templates", __FILE__)

      desc "Edit a model with the given NAME (if one does exist) with notifications " <<
           "configuration."

      hook_for :orm

    end
  end
end
