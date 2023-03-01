# frozen_string_literal: true

module Decidim
  module Kids
    class MinorsSpaceConfig < ApplicationRecord
      self.table_name = "decidim_kids_participatory_spaces_minors_configs"

      belongs_to :participatory_space, polymorphic: true
      delegate :organization, to: :participatory_space

      validate :one_config_per_participatory_space

      def self.for(participatory_space)
        find_or_initialize_by(participatory_space: participatory_space)
      end

      private

      def one_config_per_participatory_space
        return unless self.class.where.not(id: id).exists?(participatory_space: participatory_space)

        errors.add(:participatory_space, :invalid)
      end
    end
  end
end
