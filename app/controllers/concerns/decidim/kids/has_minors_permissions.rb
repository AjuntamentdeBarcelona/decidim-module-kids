# frozen_string_literal: true

module Decidim
  module Kids
    module HasMinorsPermissions
      extend ActiveSupport::Concern

      included do
        def permission_class_chain
          super + [::Decidim::Kids::Permissions]
        end
      end
    end
  end
end
