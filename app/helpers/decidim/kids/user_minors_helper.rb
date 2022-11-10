# frozen_string_literal: true

module Decidim
  module Kids
    module UserMinorsHelper
      def button_to_add_minor_account
        link_to(
          t("add", scope: "decidim.kids.user_minors.index"),
          decidim_kids.new_user_minor_path,
          class: "button small #{button_klass}"
        )
      end

      def can_add_minor_account?
        return if current_user.minors.count > Decidim::Kids.maximum_minor_accounts

        true
      end

      private

      def button_klass
        return if can_add_minor_account?

        "disabled"
      end
    end
  end
end
