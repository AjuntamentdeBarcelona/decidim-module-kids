# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Kids
    # This is the engine that runs on the public interface of kids.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Kids

      routes do
        # Add engine routes here
        # resources :kids
        # root to: "kids#index"
      end

      initializer "Kids.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
