# frozen_string_literal: true

module Decidim
  module Kids
    class KidsMailer < ApplicationMailer
      def promote_minor_account(user)
        @user = user
        @organization = user.organization
        subject = I18n.t("decidim.kids.minor_notifications_mailer.promote.subject")
        mail(to: user.email, subject: subject)
      end
    end
  end
end
