# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing categories for participatory spaces.
      #
      class MinorsSpaceController < Decidim::Kids::Admin::MinorsSpaceController
        include Concerns::ParticipatoryProcessAdmin
      end
    end
  end
end
