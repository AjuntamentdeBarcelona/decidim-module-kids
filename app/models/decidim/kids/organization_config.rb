# frozen_string_literal: true

module Decidim
  module Kids
    class OrganizationConfig < ApplicationRecord
      self.table_name = "decidim_kids_organization_configs"

      belongs_to :organization,
                 foreign_key: "decidim_organization_id",
                 class_name: "Decidim::Organization"
    end
  end
end
