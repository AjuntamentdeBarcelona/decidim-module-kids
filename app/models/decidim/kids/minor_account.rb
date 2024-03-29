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

      def promote_account!
        return if minor.minor_age <= (minor&.organization&.maximum_minor_age || Decidim::Kids.maximum_minor_age)

        ActiveRecord::Base.transaction do
          minor.tutors.destroy_all
          minor.minor_data.destroy
        end
        Decidim::Kids::KidsMailer.promote_minor_account(minor).deliver_now
      end

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
