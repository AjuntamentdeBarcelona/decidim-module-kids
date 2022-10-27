# frozen_string_literal: true

module Decidim
  module Kids
    module AuthorizationMethods
      def tutor_verified?
        @tutor_verified ||= granted_authorizations(current_user).where(name: current_organization.tutors_authorization).any?
      end

      def tutor_adapter
        @tutor_adapter ||= Decidim::Verifications::Adapter.from_element(current_organization.tutors_authorization)
      end

      def minors_authorizations(user)
        granted_authorizations(user).where(name: current_organization.minors_authorization)
      end

      def granted_authorizations(user)
        Decidim::Verifications::Authorizations.new(organization: current_organization, user:, granted: true).query
      end
    end
  end
end
