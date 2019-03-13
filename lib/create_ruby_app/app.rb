# frozen_string_literal: true

require "fileutils"

module CreateRubyApp
  class App
    def initialize(name: "app", gems: [], version: RUBY_VERSION)
      @name = name
      @gems = gems
      @version = version
    end

    def self.build_app_from_command_line_arguments(command_line_interface: CLI)
      options = command_line_interface.parse
      return NullApp.new if options.nil?

      new(
        name: options[:name],
        gems: options[:gems],
        version: options[:version]
      )
    end

    def self.build_app_from_command_line_arguments!(command_line_interface: CLI)
      build_app_from_command_line_arguments(
        command_line_interface: command_line_interface
      ).run!
    end

    def run!
      create_directories
      generate_files
      make_script_executable
    end

    def name_to_class
      name.split("_").collect(&:capitalize).join
    end

    attr_accessor :name, :gems, :version

    RUBY_VERSION = "ruby-2.6.0"

    private

    def file_generator
      @file_generator ||= FileGenerator.new(app: self)
    end

    def create_directories
      directories.each(&FileUtils.method(:mkdir_p))
    end

    def generate_files
      files.each do |path, content|
        file_generator.create_file(path: path, content: content)
      end
    end

    def make_script_executable
      FileUtils.chmod("+x", "#{name}/bin/#{name}")
    end

    def files
      {
        "Gemfile" => file_generator.generate_gem_file,
        ".ruby-version" => file_generator.generate_ruby_version_file,
        "lib/#{name}.rb" => file_generator.generate_lib_file,
        "spec/spec_helper.rb" => file_generator.generate_spec_helper_file,
        ".projections.json" => file_generator.generate_projections_file,
        "README.md" => file_generator.generate_readme_file,
        "bin/#{name}" => file_generator.generate_script_file
      }
    end

    def directories
      [
        Pathname.new("#{name}/bin"),
        Pathname.new("#{name}/lib/#{name}"),
        Pathname.new("#{name}/spec/lib/#{name}")
      ]
    end
  end
end
