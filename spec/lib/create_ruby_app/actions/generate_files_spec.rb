# frozen_string_literal: true

require_relative "../../../spec_helper"

RSpec.describe CreateRubyApp::Actions::GenerateFiles do
  describe "#generate_gemfile" do
    context "when no additional gems are added" do
      let(:app) { instance_double("app", gems: []) }
      let(:action) { described_class.new(app) }
      let(:gemfile) do
        <<~GEMFILE
          # frozen_string_literal: true

          source "https://rubygems.org"

          group :test, :development do
            gem "rspec"
          end
        GEMFILE
      end

      it "produces a Gemfile without any additional gems" do
        expect(action.gemfile).to eq(gemfile)
      end
    end

    context "when additional gems are added" do
      let(:app) { instance_double("app", gems: %w[sinatra sqlite]) }
      let(:action) { described_class.new(app) }
      let(:gemfile) do
        <<~GEMFILE
          # frozen_string_literal: true

          source "https://rubygems.org"

          group :test, :development do
            gem "rspec"
          end

          gem "sinatra"
          gem "sqlite"
        GEMFILE
      end

      it "produces a Gemfile with the gems" do
        expect(action.gemfile).to eq(gemfile)
      end
    end
  end

  describe "#generate_ruby_version_file" do
    context "when no version is specified" do
      let(:app) do
        instance_double("app", version: CreateRubyApp::App::RUBY_VERSION)
      end
      let(:action) { described_class.new(app) }

      it { expect(action.ruby_version_file).to eq("ruby-2.7.1") }
    end

    context "when a version is specified" do
      let(:app) { instance_double("app", version: "ruby-2.5.0") }
      let(:action) { described_class.new(app) }

      it { expect(action.ruby_version_file).to eq("ruby-2.5.0") }
    end
  end

  describe "#generate_lib_file" do
    context "when generating a lib file" do
      let(:app) { instance_double("app") }
      let(:action) { described_class.new(app) }
      let(:lib_file) do
        <<~LIB_FILE
          # frozen_string_literal: true

          module ThisIsAnApp
            class ThisIsAnApp
            end
          end
        LIB_FILE
      end

      it "fills out a lib file with the correct module and class name" do
        allow(app).to receive(:classify_name).and_return("ThisIsAnApp")

        expect(action.lib_file).to eq(lib_file)
      end
    end
  end

  describe "#generate_spec_helper_file" do
    context "when generating a spec helper file" do
      let(:app) { instance_double("app", name: "this_is_an_app") }
      let(:action) { described_class.new(app) }
      let(:spec_helper) do
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
      end

      it "fills out the file and references the app" do
        expect(action.spec_helper_file).to eq(spec_helper)
      end
    end
  end

  describe "#generate_script_file" do
    context "when generating an executable script file" do
      let(:app) { instance_double("app") }
      let(:action) { described_class.new(app) }
      let(:script_file) do
        <<~SCRIPT_FILE
          #!/usr/bin/env ruby

          # frozen_string_literal: true
        SCRIPT_FILE
      end

      it "fills out a default script file template" do
        expect(action.script_file).to eq(script_file)
      end
    end
  end
end
