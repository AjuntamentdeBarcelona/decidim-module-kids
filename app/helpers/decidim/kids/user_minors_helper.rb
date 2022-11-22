# frozen_string_literal: true

module Decidim
  module Kids
    module UserMinorsHelper
      def button_to_add_minor_account
        if can_add_minor_account?
          link_to(
            t(".add"),
            decidim_kids.new_user_minor_path,
            class: "button small"
          )
        else
          content_tag(:a, t(".add"), class: "button small disabled")
        end
      end

      def minor_tos
        content_tag(:a, t(".tos_agreement"), href: "/pages/#{Decidim::StaticPage::MINORS_DEFAULT_PAGES.last}")
      end

      def can_add_minor_account?
        current_user.minors.count < Decidim::Kids.maximum_minor_accounts
      end

      def minor_confirmed?(user)
        return unless user.sign_in_count?

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
                    href: decidim_kids.new_user_minor_authorization_path(user_minor_id: user.id),
                    class: "button pt-xs pb-xs mt-none mb-none")
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
