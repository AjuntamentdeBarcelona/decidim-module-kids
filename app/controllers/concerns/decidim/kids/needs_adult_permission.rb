# frozen_string_literal: true

module Decidim
  module Kids
    module NeedsAdultPermission
      extend ActiveSupport::Concern

      included do
        before_action do
          enforce_permission_to :all, :authorizations
        end

        def permission_class_chain
          [::Decidim::Kids::Permissions] + super
        end
      end
    end
  end
end
