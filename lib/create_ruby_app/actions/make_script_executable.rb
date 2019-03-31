# frozen_string_literal: true

require "fileutils"

module CreateRubyApp
  module Actions
    class MakeScriptExecutable
      def self.call(app)
        FileUtils.chmod("+x", "#{app.name}/bin/#{app.name}")
      end
    end
  end
end
