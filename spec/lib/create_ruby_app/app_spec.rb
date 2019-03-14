# frozen_string_literal: true

require_relative "../../spec_helper"

describe CreateRubyApp::App do
  describe "#classify_name" do
    context "when the name of the app contains underscores" do
      let(:app) { described_class.new(name: "foo_bar_baz") }

      it "removes the underscores and capitalizes each word" do
        expect(app.classify_name).to eq("FooBarBaz")
      end
    end

    context "when the name of the app contains no underscores" do
      let(:app) { described_class.new(name: "foobar") }

      it "capitalizes the name" do
        expect(app.classify_name).to eq("Foobar")
      end
    end
  end
end
