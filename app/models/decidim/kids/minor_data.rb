# frozen_string_literal: true

module Decidim
  module Kids
    class MinorData < ApplicationRecord
      include Decidim::RecordEncryptor
      self.table_name = "decidim_kids_minor_data"

      belongs_to :user,
                 foreign_key: "decidim_user_id",
                 class_name: "Decidim::User"

      encrypt_attribute :name, type: :string
      encrypt_attribute :email, type: :string
      encrypt_attribute :birthday, type: :string
      encrypt_attribute :password, type: :string

      validate :user_is_minor

      private

      def user_is_minor
        return if user.minor?

        errors.add(:user, :invalid)
      end
    end
  end
end
