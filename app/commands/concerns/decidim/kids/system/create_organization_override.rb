# frozen_string_literal: true

module Decidim
  module Kids
    module System
      module CreateOrganizationOverride
        extend ActiveSupport::Concern

        included do
          alias_method :original_create_organization, :create_organization

          def create_organization
            organization = original_create_organization

            Decidim::Kids::OrganizationConfig.find_or_create_by({ organization: }) do |conf|
              conf.enable_minors_participation = form.enable_minors_participation
              conf.minimum_minor_age = form.minimum_minor_age
              conf.maximum_minor_age = form.maximum_minor_age
              conf.minors_authorization = form.minors_authorization
              conf.tutors_authorization = form.tutors_authorization
              conf.maximum_minor_accounts = form.maximum_minor_accounts
            end

            Decidim::Kids::System::CreateMinorsDefaultPages.call(organization) if form.enable_minors_participation

            organization
          end
        end
      end
    end
  end
end
