# frozen_string_literal: true

require_relative "../../../spec_helper"

RSpec.describe CreateRubyApp::Actions::InstallGems do
  describe ".call" do
    let(:app) { instance_double("app", name: "foo_bar") }
    let(:action) { described_class }

    it "installs the gems" do
      allow(Dir).to receive(:chdir).with("foo_bar")

      action.call(app)

      expect(Dir).to have_received(:chdir).with("foo_bar")
    end
  end
end
