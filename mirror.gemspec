$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "mirror/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "mirror"
  s.version     = Mirror::VERSION
  s.authors     = ["Pablo Höfke"]
  s.email       = ["pablohofke@gmail.com"]
  s.summary     = "Unit test your models as you write."
  s.description = "TODO: Description of Mirror."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.3"

  s.add_development_dependency "sqlite3"
end
