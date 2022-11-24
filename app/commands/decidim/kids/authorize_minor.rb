# frozen_string_literal: true

module Decidim
  module Kids
    # A command to authorize a user with an authorization handler.
    class AuthorizeMinor < Decidim::Command
      # Public: Initializes the command.
      #
      # handler - An AuthorizationHandler object.
      def initialize(handler)
        @handler = handler
      end

      def call
        return broadcast(:invalid_age) unless valid_age?

        Decidim::Verifications::AuthorizeUser.call(handler, handler.user.organization) do
          on(:ok) do
            handler.user.blocked = false

            handler.user.invite!(handler.user, invitation_instructions: "invite_minor")
          end
        end
      end

      private

      attr_reader :handler

      def valid_age?
        return true unless handler.valid?
        return true if Decidim::Kids.minor_authorization_age_attributes.blank?

        Decidim::Kids.minor_authorization_age_attributes.detect do |attr|
          begin
            age = ((Time.zone.now - Date.parse(handler.try(attr).to_s).to_time) / 1.year.seconds).floor
          rescue TypeError, ::Date::Error
            next
          end
          age.between? handler.user.organization.minimum_minor_age, handler.user.organization.maximum_minor_age
        end
      end
    end
  end
end
