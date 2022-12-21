# frozen_string_literal: true

module Decidim
  module Kids
    # This module contains all the domain logic associated to restrict operations depending on the user's age/minors configuration.
    module ParticipatorySpaceContextOverride
      extend ActiveSupport::Concern

      included do
        class ::Decidim::Kids::ActionForbidden < ::Decidim::ActionForbidden
        end

        rescue_from Decidim::Kids::ActionForbidden, with: :no_minor_user_has_no_permission

        def no_minor_user_has_no_permission
          flash[:alert] = t("actions.unauthorized", scope: "decidim.kids")
          redirect_to(user_has_no_permission_referer || user_has_no_permission_path)
        end

        before_action do
          enforce_space_for_minors! if space_minors_config.access_type == "minors"
        end
      end

      def space_minors_config
        @space_minors_config ||= MinorsSpaceConfig.for(current_participatory_space)
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
          # TODO: users with authorization to access minors spaces, check the age if possible
        end

        raise Decidim::Kids::ActionForbidden
      end

      def current_user_is_a_valid_tutor?
        return unless current_user.tutor?
        return unless current_user.confirmed?

        # only tutors with readonly access are allowed
        return if request.post? || request.patch? || request.put? || request.delete?

        # check for having at least one minor confirmed
        current_user.minors.detect(&:confirmed?)
      end
    end
  end
end
