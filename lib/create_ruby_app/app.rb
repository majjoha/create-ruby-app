# frozen_string_literal: true

require "logger"

module CreateRubyApp
  class App
    def initialize(
      name: "app",
      gems: [],
      version: RUBY_VERSION,
      logger: Logger.new(STDOUT)
    )
      @name = name
      @gems = gems
      @version = version
      @logger = logger
    end

    def run!
      with_logger("Creating directories...", :create_directories)
      with_logger("Generating files...", :generate_files)
      with_logger("Making script executable...", :make_script_executable)
      with_logger("Installing gems...", :install_gems)
      with_logger("Happy hacking!")
    end

    def classify_name
      name.split("_").collect(&:capitalize).join
    end

    attr_accessor :name, :gems, :version, :logger

    RUBY_VERSION = "ruby-2.6.2"

    private

    def with_logger(text, callable = false)
      logger.info(text)
      file_generator.method(callable).call if callable
    end

    def file_generator
      @file_generator ||= FileGenerator.new(app: self)
    end
  end
end
