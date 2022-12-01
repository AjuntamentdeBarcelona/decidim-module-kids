# frozen_string_literal: true

module Decidim
  module Kids
    # A command with all the business logic to impersonate a minor.
    class ImpersonateMinor < Decidim::Command
      # Public: Initializes the command.
      #
      # current_user       - The user impersonating a minor
      # minor_user         - The user to impersonate
      def initialize(minor_user, current_user)
        @current_user = current_user
        @minor_user = minor_user
      end

      def call
        transaction do
          impersonation_log = create_impersonation_log
          create_action_log(impersonation_log)
        end

        enqueue_expire_job

        broadcast(:ok)
      end

      private

      attr :minor_user, :current_user

      def create_impersonation_log
        Decidim::Kids::ImpersonationMinorLog.create!(
          tutor: current_user,
          minor: minor_user,
          started_at: Time.current
        )
      end

      def create_action_log(impersonation_log)
        Decidim.traceability.perform_action!(
          "manage",
          impersonation_log,
          current_user,
          resource: {
            id: minor_user.id,
            name: minor_user.name,
            nickname: minor_user.nickname
          },
          visibility: "public-only"
        )
      end

      def enqueue_expire_job
        Decidim::Kids::ExpireImpersonationJob
          .set(wait: Decidim::Kids::ImpersonationMinorLog::SESSION_TIME_IN_MINUTES.minutes)
          .perform_later(minor_user, current_user)
      end
    end
  end
end
