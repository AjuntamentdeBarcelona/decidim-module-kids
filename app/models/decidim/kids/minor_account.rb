# frozen_string_literal: true

module Decidim
  module Kids
    # Abstract class from which all models in this engine inherit.
    class MinorAccount < ApplicationRecord
      self.table_name = "decidim_kids_minor_accounts"

      belongs_to :user,
                 foreign_key: "decidim_user_id",
                 class_name: "Decidim::User"
      belongs_to :minor,
                 foreign_key: "decidim_minor_id",
                 class_name: "Decidim::User"
    end
  end
end
