# frozen_string_literal: true

require "optparse"

module CreateRubyApp
  class CLI
    def initialize(
      name: "app",
      gems: [],
      version: App::RUBY_VERSION,
      parser: OptionParser
    )
      @name = name
      @gems = gems
      @version = version
      @parser = parser
    end

    def self.parse
      new.parse
    end

    def parse
      parser.new do |options|
        options.banner = USAGE_STRING

        options.on("-g", "--gems [GEMS]", GEMS_MESSAGE) do |added_gems|
          split_and_add_gems(added_gems)
        end

        options.on("-v", "--version", VERSION_MESSAGE) do
          print_and_exit(VERSION)
        end

        options.on("-h", "--help", HELP_MESSAGE) do
          print_and_exit(HELP_MESSAGE)
        end

        options.on("-rv", "--ruby-version", RUBY_VERSION_MESSAGE) do |v|
          @version = v
        end
      rescue OptionParser::InvalidOption
        print_and_exit(USAGE_STRING)
      end.parse!(ARGV)

      app_as_hash(name: ARGV.pop, gems: gems, version: version)
    rescue OptionParser::InvalidOption
      print_and_exit(USAGE_STRING)
    end

    private

    attr_accessor :name, :parser, :gems, :version

    def app_as_hash(name:, gems:, version:)
      {
        name: replace_dashes_with_underscores(name),
        gems: gems,
        version: version
      }
    end

    def split_and_add_gems(added_gems)
      gems.concat(added_gems.split(",")) unless added_gems.nil?
    end

    def replace_dashes_with_underscores(name)
      name.tr("-", "_")
    end

    def print_and_exit(message)
      puts message
      exit
    end

    USAGE_STRING = <<~USAGE
      Usage: create-ruby-app [--gems GEMS] [--version] [--help] [--ruby-version] NAME
    USAGE
    VERSION_MESSAGE = "Print the current version of create-ruby-app and exit"
    GEMS_MESSAGE = "Specify which gems to add"
    RUBY_VERSION_MESSAGE = "Specify which version of Ruby to use"
    HELP_MESSAGE = <<~HELP
      #{USAGE_STRING}
        Options:
          #{"-g, --gems".ljust(25)} #{GEMS_MESSAGE}
          #{"-rv, --ruby-version".ljust(25)} #{RUBY_VERSION_MESSAGE}
          #{"-v, --version".ljust(25)} #{VERSION_MESSAGE}
          #{"-h, --help".ljust(25)} Print this message and exit

        Examples:
          $ create-ruby-app my_app
          $ create-ruby-app -g sinatra,sequel -rv ruby-2.6.0 web_app
          $ create-ruby-app --ruby-version jruby-2.9.6.0 my_app
    HELP
  end
end
