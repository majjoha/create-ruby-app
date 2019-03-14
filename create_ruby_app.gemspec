# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("lib", __dir__))

require "create_ruby_app/version"

Gem::Specification.new do |s|
  s.name        = "create-ruby-app"
  s.version     = CreateRubyApp::VERSION
  s.date        = "2019-03-11"
  s.summary     = "Scaffold Ruby applications effortlessly"
  s.description = "create-ruby-app is an opinionated tool for scaffolding Ruby
  applications"
  s.author      = ["Mathias Jean Johansen"]
  s.email       = "mathias@mjj.io"
  s.files       = Dir["lib/**/*.rb", "lib/**/*.erb", "bin/*", "LICENSE", "*.md"]
  s.test_files  = Dir["spec/**/*.rb"]
  s.executables << "create-ruby-app"
  s.homepage    = "https://github.com/majjoha/create-ruby-app"
  s.license     = "MIT"

  s.add_runtime_dependency "thor", "~> 0.20.3"
  s.add_development_dependency "rake", "~> 12.3.2"
  s.add_development_dependency "rspec", "~> 3.8.0"
end
