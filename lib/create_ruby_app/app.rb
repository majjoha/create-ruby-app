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
      with_logger("Creating directories...", Actions::CreateDirectories)
      with_logger("Generating files...", Actions::GenerateFiles)
      with_logger("Making script executable...", Actions::MakeScriptExecutable)
      with_logger("Installing gems...", Actions::InstallGems)
      with_logger("Happy hacking!", Actions::NullAction)
    end

    def classify_name
      name.split("_").collect(&:capitalize).join
    end

    attr_reader :name, :gems, :version, :logger

    RUBY_VERSION = "ruby-2.6.2"

    private

    def with_logger(text, action)
      logger.info(text)
      action.call(self)
    end
  end
end
