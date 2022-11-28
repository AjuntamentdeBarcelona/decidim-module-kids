# frozen_string_literal: true

module Decidim
  module Kids
    # A command with all the business logic to impersonate a minor.
    class ImpersonateMinor < Decidim::Command
      # Public: Initializes the command.
      #
      # current_user       - The user impersonating a minor
      # minor_user         - The user to impersonate
      def initialize(current_user, minor_user)
        @current_user = current_user
        @minor_user = minor_user
      end

      def call
        transaction do
          impersonation_log = create_impersonation_log
          create_action_log(impersonation_log)
        end

        broadcast(:ok)
      end

      private

      attr_reader :minor_user, :current_user

      def create_impersonation_log
        Decidim::Kids::ImpersonationMinorLog.create!(
          tutor: current_user,
          minor: minor_user,
          started_at: Time.current,
          expired_at: Time.current + ImpersonationMinorLog::SESSION_TIME_IN_MINUTES.minutes
        )
      end

      def create_action_log(impersonation_log)
        Decidim.traceability.perform_action!(
          "manage",
          impersonation_log,
          current_user,
          resource: {
            name: minor_user.name,
            id: minor_user.id,
            nickname: minor_user.nickname
          },
          visibility: "public-only"
        )
      end
    end
  end
end
