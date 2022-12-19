# frozen_string_literal: true

module Decidim
  module Assemblies
    module Admin
      # Controller that allows managing categories for assemblies.
      #
      class MinorsSpaceController < Decidim::Kids::Admin::MinorsSpaceController
        include Concerns::AssemblyAdmin
      end
    end
  end
end
