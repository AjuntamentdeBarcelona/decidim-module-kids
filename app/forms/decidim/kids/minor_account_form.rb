# frozen_string_literal: true

module Decidim
  module Kids
    class MinorAccountForm < Decidim::Form
      mimic :minor_account

      attribute :name, String
      attribute :birthday, Decidim::Attributes::LocalizedDate
      attribute :email, String
      attribute :password, String
      attribute :tos_agreement, Boolean

      validates :name, presence: true
      validates :birthday, presence: true # format: { with: /\A\d{8}\z/ }
      validates :email, presence: true, "valid_email_2/email": { disposable: true }
      validates :password, presence: true, password: { name: :name, email: :email, username: :nickname }
    end
  end
end
