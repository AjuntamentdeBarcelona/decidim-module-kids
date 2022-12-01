# frozen_string_literal: true

module Decidim
  module Kids
    module ImpersonateMinors
      extend ActiveSupport::Concern

      included do
        helper_method :impersonation_log_minor

        def current_user
          @current_user ||= managed_minor || managed_user || real_user
        end

        def impersonation_session_ends_at
          @impersonation_session_ends_at ||= minor_session_ends_at || user_session_ends_at
        end

        private

        # Returns the minor user impersonated by an tutor if exists
        def managed_minor
          return if impersonation_log_minor.blank?

          @managed_minor ||= impersonation_log_minor.minor
        end

        def impersonation_log_minor
          @impersonation_log_minor ||= Decidim::Kids::ImpersonationMinorLog.where(tutor: real_user).active.first
        end

        def current_user_impersonated?
          current_user && (impersonation_log_minor.present? || impersonation_log.present?)
        end

        def minor_session_ends_at
          return if impersonation_log_minor.blank?

          impersonation_log_minor.started_at + Decidim::Kids::ImpersonationMinorLog::SESSION_TIME_IN_MINUTES.minutes
        end

        def user_session_ends_at
          return if impersonation_log.blank?

          impersonation_log.started_at + Decidim::ImpersonationLog::SESSION_TIME_IN_MINUTES.minutes
        end
      end
    end
  end
end
