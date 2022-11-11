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

      def can_add_minor_account?
        return if current_user.minors.count >= Decidim::Kids.maximum_minor_accounts

        true
      end
    end
  end
end
