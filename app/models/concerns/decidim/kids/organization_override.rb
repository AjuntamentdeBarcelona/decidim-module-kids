# frozen_string_literal: true

module Decidim
  module Kids
    module OrganizationOverride
      extend ActiveSupport::Concern

      included do
        has_one :minors_config,
                foreign_key: "decidim_organization_id",
                class_name: "Decidim::Kids::OrganizationConfig",
                inverse_of: :organization,
                dependent: :destroy

        def minors_participation_enabled?
          @minors_participation_enabled ||= minors_config&.enable_minors_participation || Decidim::Kids.enable_minors_participation
        end
      end
    end
  end
end
