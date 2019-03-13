# frozen_string_literal: true

require_relative "../../spec_helper"

describe CreateRubyApp::FileGenerator do
  describe "#generate_gem_file" do
    context "when no additional gems are added" do
      let(:file_generator) { described_class.new }

      it "produces a Gemfile without any additional gems" do
        expect(file_generator.generate_gem_file).to eq(
          <<~GEMFILE
            # frozen_string_literal: true

            source "https://rubygems.org"

            group :test, :development do
              gem "rspec"
            end
          GEMFILE
        )
      end
    end

    context "when providing additional gems" do
      let(:app) { CreateRubyApp::App.new(gems: %w[sinatra sqlite]) }
      let(:file_generator) { described_class.new(app: app) }

      it "produces a Gemfile with the gems" do
        expect(file_generator.generate_gem_file).to eq(
          <<~GEMFILE
            # frozen_string_literal: true

            source "https://rubygems.org"

            group :test, :development do
              gem "rspec"
            end

            gem "sinatra"
            gem "sqlite"
          GEMFILE
        )
      end
    end
  end

  describe "#generate_ruby_version_file" do
    context "when no version is specified" do
      let(:app) { CreateRubyApp::App.new }
      let(:file_generator) { described_class.new(app: app) }

      it "uses version 2.6.0 as default" do
        expect(file_generator.generate_ruby_version_file).to eq("ruby-2.6.0")
      end
    end

    context "when a version is specified" do
      let(:app) { CreateRubyApp::App.new(version: "ruby-2.5.0") }
      let(:file_generator) { described_class.new(app: app) }

      it "uses the version in the .ruby-version file" do
        expect(file_generator.generate_ruby_version_file).to eq("ruby-2.5.0")
      end
    end
  end

  describe "#generate_lib_file" do
    context "when generating a lib file" do
      let(:app) { CreateRubyApp::App.new(name: "this_is_an_app") }
      let(:file_generator) { described_class.new(app: app) }

      it "fills out a lib file with the correct module and class name" do
        expect(file_generator.generate_lib_file).to eq(
          <<~LIB_FILE
            # frozen_string_literal: true

            module ThisIsAnApp
              class ThisIsAnApp
              end
            end
          LIB_FILE
        )
      end
    end
  end

  describe "#generate_spec_helper_file" do
    context "when generating a spec helper file" do
      let(:app) { CreateRubyApp::App.new(name: "this_is_an_app") }
      let(:file_generator) { described_class.new(app: app) }

      it "fills out the file and references the app" do
        expect(file_generator.generate_spec_helper_file).to eq(
          <<~SPEC_HELPER
            # frozen_string_literal: true

            require "rspec"
            require_relative "../lib/this_is_an_app"

            RSpec.configure do |config|
              config.expect_with(:rspec) do |c|
                c.syntax = :expect
              end
            end
          SPEC_HELPER
        )
      end
    end
  end

  describe "#generate_projections_file" do
    context "when generating a projections file" do
      let(:file_generator) { described_class.new }

      it "fills out a default .projections.json template" do
        expect(file_generator.generate_projections_file).to eq(
          <<~PROJECTIONS_FILE
            {
              "*.rb": {
                "type": "source",
                "alternate": "spec/{}_spec.rb",
                "template": [
                  "# frozen_string_literal: true",
                  "",
                  "module {dirname|basename|camelcase|capitalize|colons}",
                  "  class {basename|camelcase|capitalize|colons}",
                  "    <`0`>",
                  "  end",
                  "end"
                ]
              },
              "spec/*_spec.rb": {
                "type": "test",
                "alternate": "{}.rb",
                "template": [
                  "# frozen_string_literal: true",
                  "",
                  "require_relative \\"../../spec_helper\\"",
                  "",
                  "describe {dirname|basename|camelcase|capitalize|colons}::{basename|camelcase|capitalize|colons} do",
                  "  let(:<`0`>) do",
                  "    <`1`>",
                  "  end",
                  "",
                  "  describe \\"#<`2`>\\" do",
                  "    it \\"<`3`>\\" do",
                  "      <`4`>",
                  "    end",
                  "  end",
                  "end"
                ]
              },
              "README.md": {
                "type": "doc"
              },
              "*": {
                "console": "pry"
              }
            }
          PROJECTIONS_FILE
        )
      end
    end
  end

  describe "#generate_readme_file" do
    context "when generating a README file" do
      let(:file_generator) { described_class.new }

      it "fills out a default README file template" do
        expect(file_generator.generate_readme_file).to eq(
          <<~README_FILE
            # <`0`>

            <`1`>
          README_FILE
        )
      end
    end
  end

  describe "#generate_script_file" do
    context "when generating an executable script file" do
      let(:file_generator) { described_class.new }

      it "fills out a default script file template" do
        expect(file_generator.generate_script_file).to eq(
          <<~SCRIPT_FILE
            #!/usr/bin/env ruby

            # frozen_string_literal: true
          SCRIPT_FILE
        )
      end
    end
  end
end
