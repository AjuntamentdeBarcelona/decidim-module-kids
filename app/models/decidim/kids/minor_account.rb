# frozen_string_literal: true

module Decidim
  module Kids
    class MinorAccount < ApplicationRecord
      self.table_name = "decidim_kids_minor_accounts"

      belongs_to :tutor,
                 foreign_key: "decidim_tutor_id",
                 class_name: "Decidim::User"
      belongs_to :minor,
                 foreign_key: "decidim_minor_id",
                 class_name: "Decidim::User"

      validate :same_organization
      validate :can_be_tutor
      validate :can_be_minor

      private

      def same_organization
        return if tutor.try(:organization) == minor.try(:organization)

        errors.add(:tutor, :invalid)
        errors.add(:minor, :invalid)
      end

      def can_be_tutor
        return unless tutor.minor? || !tutor.confirmed?

        errors.add(:tutor, :invalid)
      end

      def can_be_minor
        return unless minor.tutor? || minor.admin?

        errors.add(:minor, :invalid)
      end
    end
  end
end
