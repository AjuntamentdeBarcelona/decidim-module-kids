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

        helper_method :access_types

        def index
          @form = form(MinorsSpaceForm).instance
          render :index
        end

        def create
          byebug
        end

        private

        def access_types
          {
            t("minors_space.form.all", scope: "decidim.kids.admin") => "all",
            t("minors_space.form.minors", scope: "decidim.kids.admin") => "minors"
          }
        end
      end
    end
  end
end
