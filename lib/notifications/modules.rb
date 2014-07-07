require 'active_support/core_ext/object/with_options'

Notifications.with_options model: true do |d|
  d.add_module :create
  d.add_module :update
  d.add_module :destroy
end
