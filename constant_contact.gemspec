require File.expand_path('../lib/constant_contact/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "constant_contact"
  s.version     = ConstantContact::Version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Case", "Ed Hickey", "Nathan Hyde", "Idris Mokhtarzada"]
  s.homepage    = "http://github.com/idris/constant_contact"
  s.summary     = "ActiveResource wrapper for the Constant Contact API."
  s.description = "This is a very ActiveResource-like ruby wrapper to the Constant Contact API."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency("activeresource")
  s.add_dependency("actionpack")
  s.add_dependency("builder", "~> 2.1.2")

  s.add_development_dependency("shoulda")
  s.add_development_dependency("matchy")
  s.add_development_dependency("mocha")
  s.add_development_dependency("fakeweb")

  s.files        = Dir.glob("{lib,test}/**/*") + %w(MIT-LICENSE README.md)
  s.require_path = 'lib'
end