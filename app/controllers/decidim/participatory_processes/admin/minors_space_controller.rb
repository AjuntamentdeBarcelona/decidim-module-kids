# frozen_string_literal: true

module Decidim
  module ParticipatoryProcesses
    module Admin
      # Controller that allows managing minors limited access for participatory processes.
      class MinorsSpaceController < Decidim::Kids::Admin::MinorsSpaceController
        include Concerns::ParticipatoryProcessAdmin
      end
    end
  end
end
