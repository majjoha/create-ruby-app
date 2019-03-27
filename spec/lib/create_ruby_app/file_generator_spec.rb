# frozen_string_literal: true

require_relative "../../spec_helper"

RSpec.describe CreateRubyApp::FileGenerator do
  describe "#generate_gemfile" do
    context "when no additional gems are added" do
      let(:file_generator) { described_class.new }

      it "produces a Gemfile without any additional gems" do
        expect(file_generator.generate_gemfile).to eq(
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

    context "when additional gems are added" do
      let(:app) { instance_double("app") }
      let(:file_generator) { described_class.new(app: app) }

      it "produces a Gemfile with the gems" do
        allow(app).to receive(:gems).and_return(%w[sinatra sqlite])

        expect(file_generator.generate_gemfile).to eq(
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
      let(:app) do
        instance_double("app", version: CreateRubyApp::App::RUBY_VERSION)
      end
      let(:file_generator) { described_class.new(app: app) }

      it "uses version 2.6.2 as default" do
        expect(file_generator.generate_ruby_version_file).to eq("ruby-2.6.2")
      end
    end

    context "when a version is specified" do
      let(:app) { instance_double("app", version: "ruby-2.5.0") }
      let(:file_generator) { described_class.new(app: app) }

      it "uses the version in the .ruby-version file" do
        expect(file_generator.generate_ruby_version_file).to eq("ruby-2.5.0")
      end
    end
  end

  describe "#generate_lib_file" do
    context "when generating a lib file" do
      let(:app) { instance_double("app") }
      let(:file_generator) { described_class.new(app: app) }

      it "fills out a lib file with the correct module and class name" do
        allow(app).to receive(:classify_name).and_return("ThisIsAnApp")

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
      let(:app) { instance_double("app") }
      let(:file_generator) { described_class.new(app: app) }

      it "fills out the file and references the app" do
        allow(app).to receive(:name).and_return("this_is_an_app")

        expect(file_generator.generate_spec_helper_file).to eq(
          <<~SPEC_HELPER
            # frozen_string_literal: true

            require "rspec"
            require_relative "../lib/this_is_an_app"

            RSpec.configure do |config|
              config.expect_with(:rspec) do |c|
                c.syntax = :expect
              end

              config.disable_monkey_patching!
            end
          SPEC_HELPER
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
