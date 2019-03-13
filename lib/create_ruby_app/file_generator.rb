# frozen_string_literal: true

require "erb"
require "pathname"

module CreateRubyApp
  class FileGenerator
    def initialize(app: App.new)
      @app = app
    end

    def generate_gem_file
      handle_erb_file(file: "Gemfile.erb", locals: { gems: app.gems.sort })
    end

    def generate_ruby_version_file
      handle_erb_file(
        file: ".ruby-version.erb",
        locals: { version: app.version }
      )
    end

    def generate_lib_file
      handle_erb_file(file: "lib_file.erb", locals: { app: app.name_to_class })
    end

    def generate_spec_helper_file
      handle_erb_file(file: "spec_helper.erb", locals: { app: app.name })
    end

    def generate_projections_file
      read_template(file: "projections.json")
    end

    def generate_readme_file
      read_template(file: "README.md")
    end

    def generate_script_file
      read_template(file: "script_file")
    end

    def create_file(path:, content:)
      File.write("#{app.name}/#{path}", content)
    end

    private

    attr_accessor :app

    def handle_erb_file(file:, locals: [])
      ERB
        .new(read_file("templates/#{file}"), trim_mode: TRIM_MODE)
        .result_with_hash(locals: locals)
    end

    def read_template(file:)
      read_file(Pathname.new("templates/#{file}"))
    end

    def read_file(file)
      Pathname.new(__FILE__).dirname.join(file).read
    end

    TRIM_MODE = ">"
  end
end
