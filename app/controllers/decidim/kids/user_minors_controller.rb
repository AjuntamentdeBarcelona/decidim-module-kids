# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile

      before_action except: [:unverified] do
        enforce_permission_to :index, :minor_accounts
        redirect_to unverified_user_minors_path unless tutor_verified?
      end

      helper_method :minors, :tutor_adapter

      def index; end

      def unverified
        redirect_to user_minors_path if tutor_verified?
      end

      private

      def minors
        current_user.minors
      end

      def tutor_verified?
        @tutor_verified ||= granted_authorizations(current_user).where(name: current_organization.tutors_authorization).any?
      end

      def tutor_adapter
        @tutor_adapter ||= Decidim::Verifications::Adapter.from_element(current_organization.tutors_authorization)
      end

      def granted_authorizations(user)
        Decidim::Verifications::Authorizations.new(organization: current_organization, user:, granted: true).query
      end
    end
  end
end
