# frozen_string_literal: true

module Decidim
  module Kids
    class MinorNotificationsMailer < Decidim::ApplicationMailer
      helper Decidim::TranslationsHelper

      def confirmation(user)
        with_user(user) do
          @user = user
          @organization = user.organization

          subject = I18n.t("decidim.kids.minor_notifications_mailer.confirmation.subject")

          mail(to: user.email, subject:)
        end
      end
    end
  end
end
