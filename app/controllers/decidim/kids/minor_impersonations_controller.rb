# frozen_string_literal: true

module Decidim
  module Kids
    # Controller that allows impersonating managed minors.
    class MinorImpersonationsController < ApplicationController
      include Decidim::UserProfile

      layout "layouts/decidim/user_profile"

      helper_method :minor_user, :current_user, :current_user_impersonated?

      def create
        ImpersonateMinor.call(current_user, minor_user) do
          on(:ok) do
            flash[:notice] = I18n.t("impersonations.create.success", scope: "decidim.kids")
            redirect_to decidim.root_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("impersonations.create.error", scope: "decidim.kids")
            render user_minors_path
          end
        end
      end

      def close_session
        CloseSessionManagedMinor.call(current_user, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("impersonations.close_session.success", scope: "decidim.kids")
            redirect_to minor_users_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("impersonations.close_session.error", scope: "decidim.kids")
            redirect_to decidim.root_path
          end
        end
      end

      private

      def minor_user
        current_user.minors.find(params[:user_minor_id])
      end

      def real_user
        @real_user ||= warden.authenticate(scope: :user)
      end

      def managed_user
        return unless can_impersonate_users?
        return if impersonation_log.blank?

        @managed_user ||= begin
                            impersonation_log.ensure_not_expired!
                            impersonation_log.minor
                          end
      end

      def current_user
        @current_user ||= managed_user || real_user
      end

      def impersonation_log
        @impersonation_log ||= Decidim::Kids::ImpersonationMinorLog.where(tutor: real_user).active.first
      end

      def current_user_impersonated?
        current_user && impersonation_log.present?
      end
    end
  end
end
