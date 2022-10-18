# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module Kids
    VERSION = "0.1.0"
    DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "develop" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.28.0.dev", "< 0.29"].freeze
  end
end
