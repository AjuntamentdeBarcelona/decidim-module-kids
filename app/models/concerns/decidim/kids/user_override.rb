# frozen_string_literal: true

module Decidim
  module Kids
    module UserOverride
      extend ActiveSupport::Concern
      include AgeMethods

      included do
        has_many :minor_accounts, class_name: "Decidim::Kids::MinorAccount", foreign_key: :decidim_tutor_id, dependent: :destroy
        has_many :tutor_accounts, class_name: "Decidim::Kids::MinorAccount", foreign_key: :decidim_minor_id, dependent: :destroy
        has_many :minors, through: :minor_accounts, class_name: "Decidim::User", foreign_key: :decidim_minor_id
        has_many :tutors, through: :tutor_accounts, class_name: "Decidim::User", foreign_key: :decidim_tutor_id
        has_many :authorizations, foreign_key: "decidim_user_id", class_name: "Decidim::Authorization", dependent: :destroy

        has_one :minor_data,
                foreign_key: "decidim_user_id",
                class_name: "Decidim::Kids::MinorData",
                inverse_of: :user,
                dependent: :destroy

        delegate :name, :email, :birthday, :extra_data, to: :minor_data, prefix: true, allow_nil: true

        def minor?
          tutor_accounts.exists?
        end

        def tutor?
          minor_accounts.exists?
        end

        def minor_age
          return unless minor?
          return if minor_data_birthday.blank?

          age_from_birthday(minor_data_birthday)
        end

        def password_required?
          return false if managed? || minor_data.present?

          super
        end
      end
    end
  end
end
