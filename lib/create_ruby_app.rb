# frozen_string_literal: true

require_relative "create_ruby_app/app"
require_relative "create_ruby_app/cli"
require_relative "create_ruby_app/version"
require_relative "create_ruby_app/actions/create_directories"
require_relative "create_ruby_app/actions/generate_files"
require_relative "create_ruby_app/actions/install_gems"
require_relative "create_ruby_app/actions/make_script_executable"
require_relative "create_ruby_app/actions/null_action"

module CreateRubyApp
  class CreateRubyApp
  end
end
