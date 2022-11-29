# frozen_string_literal: true

module Decidim
  module Kids
    module ImpersonateUsersOverride
      extend ActiveSupport::Concern

      included do

        def current_user
          @current_user ||=  managed_minor || managed_user || real_user
        end

        private

        # def impersonate_minor?
        #   impersonation_log_minor.minor.present?
        # end

        def impersonation_log_minor
          @impersonation_log_minor ||= Decidim::Kids::ImpersonationMinorLog.where(tutor: real_user).active.first
        end

        def managed_minor
          return if impersonation_log_minor.blank?

          @managed_minor ||= impersonation_log_minor.minor
        end
      end
    end
  end
end
