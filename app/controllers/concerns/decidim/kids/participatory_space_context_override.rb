# frozen_string_literal: true

module Decidim
  module Kids
    # This module contains all the domain logic associated to restrict operations depending on the user's age/minors configuration.
    module ParticipatorySpaceContextOverride
      extend ActiveSupport::Concern
      include AgeMethods

      included do
        class ::Decidim::Kids::ActionForbidden < ::Decidim::ActionForbidden; end

        rescue_from Decidim::Kids::ActionForbidden, with: :no_minor_user_has_no_permission

        def no_minor_user_has_no_permission
          flash[:alert] = if !current_user
                            t("devise.failure.unauthenticated")
                          elsif space_authorization
                            t("actions.unauthorized", scope: "decidim.kids")
                          else
                            t("actions.missing", scope: "decidim.kids",
                                                 authorization: t("#{space_minors_config.try(:authorization)}.name",
                                                                  scope: "decidim.authorization_handlers")).html_safe
                          end
          redirect_to(user_has_no_permission_referer || user_has_no_permission_path)
        end

        before_action do
          enforce_space_for_minors! if space_minors_config.try(:access_type) == "minors"
        end
      end

      def space_minors_config
        @space_minors_config ||= MinorsSpaceConfig.for(current_participatory_space)
      rescue ActiveRecord::RecordNotFound
        nil
      end

      private

      def enforce_space_for_minors!
        return unless current_organization.minors_participation_enabled?

        if current_user
          # Allow admins and any other role with access to the admin dashboard
          return if allowed_to?(:read, :admin_dashboard, current_participatory_space:)
          # Allow minors
          return if current_user.minor?

          return if current_user_is_a_valid_tutor?
          # users with authorization to access minors spaces, check the age if possible
          return if current_user_has_a_valid_authorization?
        end

        raise Decidim::Kids::ActionForbidden
      end

      def current_user_is_a_valid_tutor?
        return false unless current_user.tutor?
        return false unless current_user.confirmed?

        # only tutors with readonly access are allowed
        return false if request.post? || request.patch? || request.put? || request.delete?

        # check for having at least one minor confirmed
        current_user.minors.detect(&:confirmed?)
      end

      def current_user_has_a_valid_authorization?
        return false unless space_authorization

        return true if space_minors_config.max_age.blank? || space_minors_config.max_age.zero?

        authorization_has_a_valid_age?
      end

      def authorization_has_a_valid_age?
        Decidim::Kids.minor_authorization_age_attributes.detect do |attr|
          age = age_from_date(space_authorization.metadata[attr.to_s])
          next unless age

          age <= space_minors_config.max_age
        end
      end

      def space_authorization
        @space_authorization ||= current_user_authorizations.find_by(name: space_minors_config.try(:authorization))
      end

      def current_user_authorizations
        Decidim::Verifications::Authorizations.new(organization: current_organization, user: current_user, granted: true).query
      end
    end
  end
end
