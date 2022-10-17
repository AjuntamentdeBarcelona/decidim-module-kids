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

        def minimum_minor_age
          @minimum_minor_age ||= minors_config&.minimum_minor_age || Decidim::Kids.minimum_minor_age
        end

        def minimum_adult_age
          @minimum_adult_age ||= minors_config&.minimum_adult_age || Decidim::Kids.minimum_adult_age
        end
      end
    end
  end
end
