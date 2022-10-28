# frozen_string_literal: true

module Decidim
  module Kids
    # A command to authorize a user with an authorization handler.
    class AuthorizeUser < Decidim::Verifications::AuthorizeUser
      def call
        return broadcast(:invalid_age) unless valid_age?

        super
      end

      private

      def valid_age?
        return true unless handler.valid?
        return true if Decidim::Kids.minor_authorization_age_attributes.blank?

        Decidim::Kids.minor_authorization_age_attributes.detect do |attr|
          begin
            age = Time.zone.today.year - Date.parse(handler.try(attr).to_s).year
          rescue TypeError, ::Date::Error
            next
          end
          age.between? handler.user.organization.minimum_minor_age, handler.user.organization.minimum_adult_age
        end
      end
    end
  end
end
