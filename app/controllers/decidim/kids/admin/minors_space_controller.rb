# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      # Base Controller that specific participatory spaces should inherit from.
      #
      class MinorsSpaceController < Decidim::Admin::ApplicationController
        before_action do
          enforce_permission_to :manage, :space_minors_configuration
        end

        def index
          render :index
        end
      end
    end
  end
end
