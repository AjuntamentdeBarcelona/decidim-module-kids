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
        return if current_user.admin?
        return if current_user.minor?

        # TODO: tutors with readonly access
        # TODO: users with authorization to access minors spaces, check the age if possible

        raise Decidim::Kids::ActionForbidden
      end
    end
  end
end
