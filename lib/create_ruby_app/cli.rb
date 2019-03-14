# frozen_string_literal: true

require "thor"

module CreateRubyApp
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "version", "Print the current version and exit"
    map %w[--version -v] => :version
    def version
      say VERSION
    end

    desc "new [NAME] [--ruby RUBY] [--gems GEMS]", "Generate new app"
    long_desc <<~DESC
      `create-ruby-app new NAME` will generate an app with the provided name.

      Examples:
        \x5$ create-ruby-app new my_app
        \x5$ create-ruby-app new -g sinatra,sequel -r ruby-2.6.0 web_app
        \x5$ create-ruby-app new --ruby jruby-2.9.6.0 my_app
    DESC

    method_option(:ruby, default: App::RUBY_VERSION, aliases: "-r")
    method_option(:gems, type: :string, default: "", aliases: "-g")
    def new(name)
      App.new(
        name: replace_dashes_with_underscores(name),
        gems: options[:gems].split(","),
        version: options[:ruby]
      ).run!
    end

    private

    def replace_dashes_with_underscores(name)
      name.tr("-", "_")
    end
  end
end
