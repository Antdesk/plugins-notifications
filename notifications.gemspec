$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "notifications/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "notifications"
  s.version     = Notifications::VERSION
  s.authors     = ["Adrian Toczydłowski"]
  s.email       = ["adrian.toczydlowski@gmail.com"]
  s.homepage    = "http://www.atndesk.com"
  s.summary     = "Notifications system."
  s.description = "Notifications system for Rails with Observer"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.1"
  s.add_dependency("orm_adapter", "~> 0.1")

  s.add_development_dependency "sqlite3"
end
