# frozen_string_literal: true

module Decidim
  module Kids
    # This is the engine that runs on the public interface of `Kids`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Kids::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :kids do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "kids#index"
      end

      def load_seed
        nil
      end
    end
  end
end
