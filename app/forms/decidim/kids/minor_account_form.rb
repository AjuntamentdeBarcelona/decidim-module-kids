# frozen_string_literal: true

module Decidim
  module Kids
    class MinorAccountForm < Decidim::Form
      mimic :minor_account

      attribute :name, String
      attribute :birthday, Decidim::Attributes::LocalizedDate
      attribute :email, String
      attribute :password, String
      attribute :password_confirmation, String
      attribute :tos_agreement, Boolean

      validates :name, presence: true
      validates :birthday, presence: true
      validates :email, presence: true, "valid_email_2/email": { disposable: true }
      validates :password, presence: true, password: { name: :name, email: :email, username: :nickname }
      validates :password_confirmation, presence: true, if: :password_present
      validates :tos_agreement, acceptance: true

      validate :valid_minor_age
      validate :agreement, on: :create

      private

      def agreement
        return if tos_agreement.present?

        errors.add(:tos_agreement, :invalid)
      end

      def password_present
        password.present?
      end

      def valid_minor_age
        min_minor_age = Decidim::Kids.minimum_minor_age
        minimum_adult_age = Decidim::Kids.minimum_adult_age

        if birthday.present?
          minor_age = ((Time.zone.now - birthday.to_time) / 1.year.seconds).floor
          errors.add(:birthday, I18n.t("decidim.kids.minor_account.form.invalid_age")) unless minor_age.between?(min_minor_age, minimum_adult_age - 1)
        end
      end
    end
  end
end
