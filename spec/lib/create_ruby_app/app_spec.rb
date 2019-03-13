# frozen_string_literal: true

require_relative "../../spec_helper"

describe CreateRubyApp::App do
  describe ".build_app_from_command_line_arguments" do
    let(:cli) { instance_double("cli") }

    context "when no name is given" do
      it "returns a NullApp" do
        allow(cli).to receive(:parse).and_return(nil)

        expect(
          described_class.build_app_from_command_line_arguments(
            command_line_interface: cli
          )
        ).to be_a(CreateRubyApp::NullApp)
      end
    end

    context "when a name is provided" do
      let(:options) { { name: "new_app", gems: [] } }

      it "returns a new app with the given name" do
        allow(cli).to receive(:parse).and_return(options)

        expect(
          described_class.build_app_from_command_line_arguments(
            command_line_interface: cli
          ).name
        ).to eq("new_app")
      end
    end

    context "when one gem is provided" do
      let(:options) { { name: "new_app", gems: ["rspec"] } }

      it "returns a new app with a gem added" do
        allow(cli).to receive(:parse).and_return(options)

        expect(
          described_class.build_app_from_command_line_arguments(
            command_line_interface: cli
          ).gems
        ).to eq(["rspec"])
      end
    end

    context "when multiple gems are provided" do
      let(:options) { { name: "new_app", gems: ["rspec", "rubocop"] } }

      it "returns a new app with the gems added" do
        allow(cli).to receive(:parse).and_return(options)

        expect(
          described_class.build_app_from_command_line_arguments(
            command_line_interface: cli
          ).gems
        ).to eq(["rspec", "rubocop"])
      end
    end
  end

  describe "#app_name_to_class" do
    context "when the app name contains underscores" do
      let(:app) { described_class.new(name: "foo_bar_baz") }

      it "removes the underscores and capitalizes each word" do
        expect(app.name_to_class).to eq("FooBarBaz")
      end
    end

    context "when the app name contains no underscores" do
      let(:app) { described_class.new(name: "foobar") }

      it "capitalizes the name" do
        expect(app.name_to_class).to eq("Foobar")
      end
    end
  end
end
