# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      # Controller that allows managing categories for assemblies.
      #
      class MinorsSpaceController < Decidim::Admin::ApplicationController
        include Decidim::Admin::ParticipatorySpaceAdminContext
        participatory_space_admin_layout

        def index
          render :index
        end
      end
    end
  end
end
