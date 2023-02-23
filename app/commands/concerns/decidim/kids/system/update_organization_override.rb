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

            conf = Decidim::Kids::OrganizationConfig.find_or_create_by({ organization: organization })
            conf.enable_minors_participation = form.enable_minors_participation
            conf.minimum_minor_age = form.minimum_minor_age
            conf.maximum_minor_age = form.maximum_minor_age
            conf.minors_authorization = form.minors_authorization
            conf.tutors_authorization = form.tutors_authorization
            conf.maximum_minor_accounts = form.maximum_minor_accounts
            conf.save!

            Decidim::Kids::System::CreateMinorsDefaultPages.call(organization) if form.enable_minors_participation
          end
        end
      end
    end
  end
end
