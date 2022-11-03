# frozen_string_literal: true

module Decidim
  module Kids
    module System
      class CreateMinorsDefaultPages < Decidim::Command
        def initialize(organization)
          @organization = organization
        end

        def call
          Decidim::StaticPage::MINORS_DEFAULT_PAGES.map do |slug|
            Decidim::StaticPage.find_or_create_by!(organization:, slug:) do |page|
              page.title = localized_attribute(slug, :title)
              page.content = localized_attribute(slug, :content)
              page.show_in_footer = true
              page.allow_public_access = true
            end
          end
        end

        private

        attr_reader :organization

        def localized_attribute(slug, attribute)
          Decidim.available_locales.inject({}) do |result, locale|
            text = I18n.with_locale(locale) do
              I18n.t(attribute, scope: "decidim.system.default_pages.placeholders", page: slug)
            end

            result.update(locale => text)
          end
        end
      end
    end
  end
end
