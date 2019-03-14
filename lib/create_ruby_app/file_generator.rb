# frozen_string_literal: true

require "erb"
require "pathname"
require "fileutils"

module CreateRubyApp
  class FileGenerator
    def initialize(app: App.new)
      @app = app
    end

    def generate_gem_file
      handle_erb_file(file: "Gemfile.erb", locals: { gems: app.gems.sort })
    end

    def generate_lib_file
      handle_erb_file(file: "lib_file.erb", locals: { app: app.classify_name })
    end

    def generate_spec_helper_file
      handle_erb_file(file: "spec_helper.erb", locals: { app: app.name })
    end

    def generate_ruby_version_file
      handle_erb_file(
        file: "ruby-version.erb",
        locals: { version: app.version }
      )
    end

    def generate_script_file
      handle_erb_file(file: "script_file.erb", locals: {})
    end

    def create_directories
      directories.each(&FileUtils.method(:mkdir_p))
    end

    def generate_files
      files.each {|path, content| create_file(path: path, content: content) }
    end

    def make_script_executable
      FileUtils.chmod("+x", "#{app.name}/bin/#{app.name}")
    end

    def install_gems
      system("cd #{app.name} && bundle install")
    end

    private

    attr_accessor :app

    def handle_erb_file(file:, locals: [])
      ERB
        .new(read_file(file), nil, trim_mode: TRIM_MODE)
        .result_with_hash(locals: locals)
    end

    def read_file(file)
      Pathname.new(__FILE__).dirname.join("#{TEMPLATES_DIR}/#{file}").read
    end

    def create_file(path:, content:)
      File.write("#{app.name}/#{path}", content)
    end

    def files
      {
        "bin/#{app.name}" => generate_script_file,
        "lib/#{app.name}.rb" => generate_lib_file,
        "spec/spec_helper.rb" => generate_spec_helper_file,
        ".ruby-version" => generate_ruby_version_file,
        "Gemfile" => generate_gem_file
      }
    end

    def directories
      [
        Pathname.new("#{app.name}/bin"),
        Pathname.new("#{app.name}/lib/#{app.name}"),
        Pathname.new("#{app.name}/spec/lib/#{app.name}")
      ]
    end

    TEMPLATES_DIR = "templates"
    TRIM_MODE = "<>"
  end
end
