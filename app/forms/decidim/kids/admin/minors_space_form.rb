# frozen_string_literal: true

module Decidim
  module Kids
    module Admin
      class MinorsSpaceForm < Decidim::Form
        mimic :minors_space_config

        attribute :access_type, String, default: "all"
        attribute :authorization, String
        attribute :max_age, Integer, default: 16
      end
    end
  end
end
