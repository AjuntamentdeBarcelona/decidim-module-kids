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

      def confirmed(user)
        if minor_confirmed?(user)
          content_tag(:span, t("confirmed_user", scope: "decidim.kids.user_minors.index"), class: "text-success")
        else
          content_tag(:span, t("unconfirmed", scope: "decidim.kids.user_minors.index"), class: "text-alert")
        end
      end
    end
  end
end
