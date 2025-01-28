# frozen_string_literal: true

module Decidim
  module Kids
    module System
      class CreateMinorsDefaultPages < Decidim::System::CreateDefaultPages
        def call
          Decidim::StaticPage::MINORS_DEFAULT_PAGES.map do |slug|
            Decidim::StaticPage.find_or_create_by!(organization:, slug:) do |page|
              page.title = localized_attribute(slug, :title)
              page.content = localized_attribute(slug, :content)
              page.allow_public_access = true
            end
          end
        end
      end
    end
  end
end
