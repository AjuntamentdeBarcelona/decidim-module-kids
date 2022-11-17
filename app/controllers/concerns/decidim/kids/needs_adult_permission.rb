# frozen_string_literal: true

module Decidim
  module Kids
    module NeedsAdultPermission
      extend ActiveSupport::Concern
      include HasMinorsPermissions

      included do
        before_action do
          enforce_permission_to :all, :authorizations
        end
      end
    end
  end
end
