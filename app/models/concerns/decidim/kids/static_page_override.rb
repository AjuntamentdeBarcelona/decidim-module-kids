# frozen_string_literal: true

module Decidim
  module Kids
    module StaticPageOverride
      extend ActiveSupport::Concern

      included do
        MINORS_DEFAULT_PAGES = %w(minors-account).freeze
        Decidim::StaticPage::DEFAULT_PAGES = (Decidim::StaticPage::DEFAULT_PAGES + MINORS_DEFAULT_PAGES).uniq.freeze
      end
    end
  end
end
