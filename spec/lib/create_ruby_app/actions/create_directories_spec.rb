# frozen_string_literal: true

require_relative "../../../spec_helper"

RSpec.describe CreateRubyApp::Actions::CreateDirectories do
  describe ".call" do
    let(:app) { instance_double("app", name: "foo_bar") }
    let(:action) { described_class }

    it "creates the directories" do
      allow(FileUtils).to receive(:mkdir_p)

      action.call(app)

      expect(FileUtils).to have_received(:mkdir_p).exactly(3).times
    end
  end
end
