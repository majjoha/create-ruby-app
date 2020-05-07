# frozen_string_literal: true

require "erb"
require "pathname"

module CreateRubyApp
  module Actions
    class GenerateFiles
      def initialize(app)
        @app = app
      end

      def self.call(...)
        new(...).call
      end

      def call
        generate_files
      end

      def script_file
        generate_file(file: "script_file.erb", locals: {})
      end

      def lib_file
        generate_file(file: "lib_file.erb", locals: { app: app.classify_name })
      end

      def spec_helper_file
        generate_file(file: "spec_helper.erb", locals: { app: app.name })
      end

      def ruby_version_file
        generate_file(
          file: "ruby-version.erb",
          locals: { version: app.version }
        )
      end

      def gemfile
        generate_file(file: "Gemfile.erb", locals: { gems: app.gems.sort })
      end

      private

      attr_reader :app

      def generate_files
        files.each {|path, content| create_file(path: path, content: content) }
      end

      def create_file(path:, content:)
        File.write("#{app.name}/#{path}", content)
      end

      def generate_file(file:, locals: [])
        ERB
          .new(read_file(file), trim_mode: TRIM_MODE)
          .result_with_hash(locals: locals)
      end

      def read_file(file)
        Pathname.new(__FILE__)
          .dirname
          .join("#{TEMPLATES_DIR}/#{file}")
          .read
      end

      def files
        {
          "bin/#{app.name}" => script_file,
          "lib/#{app.name}.rb" => lib_file,
          "spec/spec_helper.rb" => spec_helper_file,
          ".ruby-version" => ruby_version_file,
          "Gemfile" => gemfile
        }
      end

      TRIM_MODE = "<>"
      TEMPLATES_DIR = "../templates"
    end
  end
end
