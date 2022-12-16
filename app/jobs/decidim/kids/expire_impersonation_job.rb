# frozen_string_literal: true

module Decidim
  module Kids
    class ExpireImpersonationJob < ApplicationJob
      queue_as :default

      def perform(user, current_user)
        impersonation_log = Decidim::Kids::ImpersonationMinorLog.where(tutor: current_user, minor: user).active.first
        return unless impersonation_log

        impersonation_log.expire!
      end
    end
  end
end
