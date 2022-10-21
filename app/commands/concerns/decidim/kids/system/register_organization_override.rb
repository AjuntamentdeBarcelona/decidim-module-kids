# frozen_string_literal: true

module Decidim
  module Kids
    module System
      module RegisterOrganizationOverride
        extend ActiveSupport::Concern

        included do
          alias_method :original_create_organization, :create_organization

          def create_organization
            organization = original_create_organization

            Decidim::Kids::OrganizationConfig.find_or_create_by({
                                                                  organization:
                                                                }) do |conf|
              conf.enable_minors_participation = form.enable_minors_participation
              conf.minimum_minor_age = form.minimum_minor_age
              conf.minimum_adult_age = form.minimum_adult_age
              conf.authorization = form.minors_authorization
            end

            organization
          end
        end
      end
    end
  end
end
