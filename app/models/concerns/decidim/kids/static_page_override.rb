# frozen_string_literal: true

module Decidim
  module Kids
    module StaticPageOverride
      extend ActiveSupport::Concern

      included do
        MINORS_DEFAULT_PAGES = %w(minors minors-terms).freeze

        def self.minors_default?(slug, organization)
          (organization&.enable_minors_participation && MINORS_DEFAULT_PAGES.include?(slug))
        end
      end
    end
  end
end
