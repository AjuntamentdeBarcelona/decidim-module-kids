# frozen_string_literal: true

module Decidim
  module Kids
    # ImpersonationLogs are created whenever an tutor impersonate a minor user
    class ImpersonationMinorLog < ApplicationRecord
      SESSION_TIME_IN_MINUTES = 10

      belongs_to :tutor,
                 foreign_key: "decidim_tutor_id",
                 class_name: "Decidim::User"
      belongs_to :minor,
                 foreign_key: "decidim_minor_id",
                 class_name: "Decidim::User"

      scope :active, -> { where(ended_at: nil, expired_at: nil) }
      scope :expired, -> { where(ended_at: nil).where.not(expired_at: nil) }

      def ended?
        ended_at.present?
      end

      def expired?
        expired_at.present?
      end

      def ensure_not_expired!
        expire! if started_at + SESSION_TIME_IN_MINUTES.minutes < Time.current
      end

      def expire!
        update!(expired_at: Time.current)
      end
    end
  end
end
