# frozen_string_literal: true

module Decidim
  module Kids
    module NeedsTutorAuthorization
      extend ActiveSupport::Concern

      included do
        before_action do
          if tutor_adapter.blank?
            flash[:alert] = t("user_minors.no_tutor_authorization", scope: "decidim.kids")
            redirect_to decidim.account_path
          end
        end

        before_action except: [:unverified] do
          enforce_permission_to :index, :minor_accounts
          redirect_to unverified_user_minors_path unless tutor_verified?
        end

        helper_method :minors, :tutor_adapter

        def permission_class_chain
          [::Decidim::Kids::Permissions] + super
        end

        private

        def tutor_verified?
          @tutor_verified ||= tutor_authorization.present? && !tutor_authorization.expired?
        end

        def tutor_adapter
          @tutor_adapter ||= Decidim::Verifications::Adapter.from_element(current_organization.tutors_authorization)
        rescue Decidim::Verifications::UnregisteredVerificationManifest
          nil
        end

        def tutor_authorization
          @tutor_authorization ||= granted_authorizations(current_user).find_by(name: current_organization.tutors_authorization)
        end

        def minor_authorization(user)
          granted_authorizations(user).find_by(name: current_organization.minors_authorization)
        end

        def granted_authorizations(user)
          Decidim::Verifications::Authorizations.new(organization: current_organization, user:, granted: true).query
        end

        def minors
          current_user.minors
        end
      end
    end
  end
end
