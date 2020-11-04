require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    config.load_defaults 5.2

    config.generators do |g|
      g.assets false
      g.test_framework false

      g.test_framework :rspec,
        controller_specs: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false
    end

    config.action_view.embed_authenticity_token_in_remote_forms = true
  end
end
