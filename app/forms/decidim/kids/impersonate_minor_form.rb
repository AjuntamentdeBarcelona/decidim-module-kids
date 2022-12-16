# frozen_string_literal: true

module Decidim
  module Kids
    class ImpersonateMinorForm < Decidim::Form
      mimic :impersonate_minor

      attribute :password, String

      validates :password, presence: true

      validate :password_valid?

      private

      def password_valid?
        errors.add(:password, :invalid) unless current_user.valid_password?(password)

        true
      end
    end
  end
end
