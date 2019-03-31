# frozen_string_literal: true

module CreateRubyApp
  module Actions
    class InstallGems
      def self.call(app)
        Dir.chdir(app.name) { system("bundle", "install") }
      end
    end
  end
end
