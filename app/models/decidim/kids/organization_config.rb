# frozen_string_literal: true

module Decidim
  module Kids
    # Abstract class from which all models in this engine inherit.
    class OrganizationConfig < ApplicationRecord
      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"
    end
  end
end
