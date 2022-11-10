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

        def enable_minors_participation
          return minors_config.enable_minors_participation if minors_config

          Decidim::Kids.enable_minors_participation
        end

        alias_method :minors_participation_enabled?, :enable_minors_participation

        def minimum_minor_age
          minors_config&.minimum_minor_age || Decidim::Kids.minimum_minor_age
        end

        def minimum_adult_age
          minors_config&.minimum_adult_age || Decidim::Kids.minimum_adult_age
        end

        def minors_authorization
          minors_config&.minors_authorization
        end

        def tutors_authorization
          minors_config&.tutors_authorization
        end

        def maximum_minor_accounts
          minors_config&.maximum_minor_accounts || Decidim::Kids.maximum_minor_accounts
        end
      end
    end
  end
end
