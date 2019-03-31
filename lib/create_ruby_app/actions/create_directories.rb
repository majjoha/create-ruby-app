# frozen_string_literal: true

require "fileutils"
require "pathname"

module CreateRubyApp
  module Actions
    class CreateDirectories
      def self.call(app)
        [
          Pathname.new("#{app.name}/bin"),
          Pathname.new("#{app.name}/lib/#{app.name}"),
          Pathname.new("#{app.name}/spec/lib/#{app.name}")
        ].each(&FileUtils.method(:mkdir_p))
      end
    end
  end
end
