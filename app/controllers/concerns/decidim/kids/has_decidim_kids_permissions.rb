# frozen_string_literal: true

module Decidim
  module Kids
    module HasDecidimKidsPermissions
      extend ActiveSupport::Concern

      included do
        def permission_class_chain
          super + [::Decidim::Kids::Permissions]
        end
      end
    end
  end
end
