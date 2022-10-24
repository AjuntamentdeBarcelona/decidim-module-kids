# frozen_string_literal: true

module Decidim
  module Kids
    module UserOverride
      extend ActiveSupport::Concern

      included do
        has_many :minor_accounts, class_name: "Decidim::Kids::MinorAccount", foreign_key: :decidim_tutor_id
        has_many :tutor_accounts, class_name: "Decidim::Kids::MinorAccount", foreign_key: :decidim_minor_id
        has_many :minors, through: :minor_accounts, class_name: "Decidim::User", foreign_key: :decidim_minor_id
        has_many :tutors, through: :tutor_accounts, class_name: "Decidim::User", foreign_key: :decidim_tutor_id

        def minor?
          tutor_accounts.exists?
        end

        def tutor?
          minor_accounts.exists?
        end
      end
    end
  end
end
