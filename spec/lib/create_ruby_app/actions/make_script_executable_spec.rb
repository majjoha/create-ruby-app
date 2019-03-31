# frozen_string_literal: true

require_relative "../../../spec_helper"

RSpec.describe CreateRubyApp::Actions::MakeScriptExecutable do
  describe ".call" do
    let(:app) { instance_double("app", name: "foo_bar") }
    let(:action) { described_class }

    it "creates the directories" do
      allow(FileUtils).to receive(:chmod).with("+x", "foo_bar/bin/foo_bar")

      action.call(app)

      expect(FileUtils).to(
        have_received(:chmod).with("+x", "foo_bar/bin/foo_bar")
      )
    end
  end
end
