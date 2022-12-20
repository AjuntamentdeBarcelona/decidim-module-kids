# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      class MinorsSpaceForm < Decidim::Form
        mimic :minors_space_config

        attribute :access_type, String, default: "all"
        attribute :authorization, String
        attribute :max_age, Integer, default: 16

        validates :access_type, presence: true, inclusion: { in: %w(all minors) }
        validates :max_age, numericality: { only_integer: true, greater_or_equal_than: 0 }, if: -> { access_type == "minors" }
        validates :authorization, inclusion: { in: Decidim::Kids.valid_minor_workflows.pluck(:name) }, allow_blank: false, if: -> { access_type == "minors" }
      end
    end
  end
end
