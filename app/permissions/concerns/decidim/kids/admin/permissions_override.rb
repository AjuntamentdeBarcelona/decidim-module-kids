# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      module PermissionsOverride
        extend ActiveSupport::Concern

        included do
          def static_page_action?
            return unless permission_action.subject == :static_page

            static_page = context.fetch(:static_page, nil)

            case permission_action.action
            when :update
              static_page.present?
            when :update_slug, :destroy
              static_page.present? && !StaticPage.default?(static_page.slug) && !StaticPage.minors_default?(static_page.slug, user.organization)
            when :update_notable_changes
              static_page.slug == "terms-and-conditions" && static_page.persisted?
            else
              true
            end
          end
        end
      end
    end
  end
end
