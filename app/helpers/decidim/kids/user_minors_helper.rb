# frozen_string_literal: true

module Decidim
  module Kids
    module UserMinorsHelper
      include Decidim::Admin::IconLinkHelper

      def button_to_add_minor_account
        if can_add_minor_account?
          link_to(
            t("add", scope: "decidim.kids.user_minors_helper.button_to_add_minor_account"),
            decidim_kids.new_user_minor_path,
            class: "button button__sm md:button__lg button__secondary mr-auto !ml-0"
          )
        else
          content_tag(:a, t("add", scope: "decidim.kids.user_minors_helper.button_to_add_minor_account"),
                      class: "button button__sm md:button__lg button__secondary mr-auto !ml-0 disabled")
        end
      end

      def minor_tos
        content_tag(:a, t("tos_agreement", scope: "decidim.kids.user_minors_helper.minor_tos"), href: "/pages/#{Decidim::StaticPage::MINORS_DEFAULT_PAGES.last}")
      end

      def can_add_minor_account?
        current_user.minors.count < Decidim::Kids.maximum_minor_accounts
      end

      def minor_confirmed?(user)
        return false unless user.sign_in_count?

        true
      end

      def confirm_email_status(user)
        if minor_confirmed?(user)
          content_tag(:span, t("confirmed_user", scope: "decidim.kids.user_minors.index"), class: "text-success")
        elsif !minor_authorized?(user)
          content_tag(:span, t("not_confirmed", scope: "decidim.kids.user_minors.index"), class: "text-alert")
        else
          content_tag(:span, t("pending", scope: "decidim.kids.user_minors.index"), class: "text-alert")
        end
      end

      def button_verify(user)
        content_tag(:a, t("button_verify", scope: "decidim.kids.user_minors.index"),
                    href: decidim_kids.new_user_minor_authorization_path(user_minor_id: user.id))
      end

      def verification_minor_status(user)
        if minor_authorized?(user)
          content_tag(:span, t("confirmed_user", scope: "decidim.kids.user_minors.index"), class: "text-success")
        else
          button_verify(user)
        end
      end
    end
  end
end
