# frozen_string_literal: true

module Decidim
  module Kids
    module HasMinorActivitiesAsOwn
      extend ActiveSupport::Concern

      included do
        alias_method :user_own_activities?, :own_activities?

        def own_activities?
          user_own_activities? || current_user&.minors&.include?(user)
        end
      end
    end
  end
end
