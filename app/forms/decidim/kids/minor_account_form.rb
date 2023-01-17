# frozen_string_literal: true

module Decidim
  module Kids
    class MinorAccountForm < Decidim::Form
      include AgeMethods

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
      validates :password, confirmation: true
      validates :password, presence: true, password: { name: :name, email: :email, username: :nickname }, if: :password_present
      validates :password_confirmation, presence: true, if: :password_present
      validates :tos_agreement, acceptance: true

      validate :valid_minor_age

      private

      def password_present
        password.present?
      end

      def valid_minor_age
        min_minor_age = Decidim::Kids.minimum_minor_age
        maximum_minor_age = Decidim::Kids.maximum_minor_age

        if birthday.present?
          minor_age = age_from_birthday(birthday)
          errors.add(:birthday, I18n.t("decidim.kids.minor_account.form.invalid_age")) unless minor_age.between?(min_minor_age, maximum_minor_age)
        end
      end
    end
  end
end
