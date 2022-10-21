# frozen_string_literal: true

module Decidim
  module Kids
    module System
      module UpdateOrganizationOverride
        extend ActiveSupport::Concern

        included do
          alias_method :original_save_organization, :save_organization

          def save_organization
            original_save_organization

            conf = Decidim::Kids::OrganizationConfig.find_or_create_by({ organization: })
            conf.enable_minors_participation = form.enable_minors_participation
            conf.minimum_minor_age = form.minimum_minor_age
            conf.minimum_adult_age = form.minimum_adult_age
            conf.authorization = form.minors_authorization
            conf.save!
          end
        end
      end
    end
  end
end
