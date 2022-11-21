# frozen_string_literal: true

module Decidim
  module Kids
    class InviteMinorAgain < Decidim::Command
      def initialize(minor_user)
        @minor_user = minor_user
      end

      def call
        resend_email

        broadcast(:ok)
      end

      private

      attr_reader :minor_user, :instructions

      def resend_email
        Decidim::Kids::MinorNotificationsMailer.confirmation(minor_user).deliver_later
      end
    end
  end
end
