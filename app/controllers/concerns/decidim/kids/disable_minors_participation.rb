# frozen_string_literal: true

module Decidim
  module Kids
    # Controllers implementing this concern will be able to restrict access to user's that are not minors.
    module DisableMinorsParticipation
      extend ActiveSupport::Concern
      include HasDecidimKidsPermissions

      included do
        before_action do
          enforce_permission_to :all, :authorizations
        end
      end
    end
  end
end
