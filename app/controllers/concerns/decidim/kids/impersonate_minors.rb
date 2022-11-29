# frozen_string_literal: true

module Decidim
  module Kids
    module ImpersonateMinors
      extend ActiveSupport::Concern

      included do
        def current_user
          @current_user ||= managed_minor || managed_user || real_user
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

        def expired_log_minor
          @expired_log ||= Decidim::Kids::ImpersonationMinorLog.where(tutor: real_user).expired.first
        end
      end
    end
  end
end
