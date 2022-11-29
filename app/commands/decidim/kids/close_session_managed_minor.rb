# frozen_string_literal: true

module Decidim
  module Kids
    # A command with all the business logic to close a current impersonation session.
    class CloseSessionManagedMinor < Decidim::Command
      # Public: Initializes the command.
      #
      # current_user       - The user impersonating a minor
      # minor_user         - The user to impersonate
      def initialize(minor_user, current_user)
        @minor_user = minor_user
        @current_user = current_user
      end

      def call
        return broadcast(:invalid) if impersonation_log.blank?

        close_session

        broadcast(:ok)
      end

      private

      attr_reader :current_user, :minor_user

      def impersonation_log
        @impersonation_log ||= Decidim::Kids::ImpersonationMinorLog.where(tutor: current_user, minor: minor_user).active.first
      end

      def close_session
        impersonation_log.ended_at = Time.current
        impersonation_log.save!
      end
    end
  end
end