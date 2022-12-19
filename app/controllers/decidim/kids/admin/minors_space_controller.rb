# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      # Base Controller that specific participatory spaces should inherit from.
      #
      class MinorsSpaceController < Decidim::Admin::ApplicationController
        def index
          render :index
        end
      end
    end
  end
end
