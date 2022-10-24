# frozen_string_literal: true

module Decidim
  module Kids
    # Abstract class from which all models in this engine inherit.
    class MinorAccount < ApplicationRecord
      self.table_name = "decidim_kids_minor_accounts"

      belongs_to :tutor,
                 foreign_key: "decidim_tutor_id",
                 class_name: "Decidim::User"
      belongs_to :minor,
                 foreign_key: "decidim_minor_id",
                 class_name: "Decidim::User"

      validate :same_organization
      validate :tutor_is_not_a_minor
      validate :minor_is_not_a_tutor

      private

      def same_organization
        return if tutor.try(:organization) == minor.try(:organization)

        errors.add(:tutor, :invalid)
        errors.add(:minor, :invalid)
      end

      def tutor_is_not_a_minor
        return unless tutor.minor?

        errors.add(:tutor, :invalid)
      end

      def minor_is_not_a_tutor
        return unless minor.tutor?

        errors.add(:minor, :invalid)
      end
    end
  end
end
