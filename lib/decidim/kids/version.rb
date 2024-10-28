# frozen_string_literal: true

module Decidim
  # This holds the decidim-meetings version.
  module Kids
    VERSION = "0.3.0"
    DECIDIM_VERSION = { git: "https://github.com/decidim/decidim", branch: "release/0.29-stable" }.freeze
    COMPAT_DECIDIM_VERSION = [">= 0.29", "< 0.30"].freeze
  end
end
