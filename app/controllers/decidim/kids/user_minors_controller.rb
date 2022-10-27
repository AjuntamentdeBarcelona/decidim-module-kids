# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile
      include AuthorizationMethods

      before_action except: [:unverified] do
        enforce_permission_to :index, :minor_accounts
        redirect_to unverified_user_minors_path unless tutor_verified?
      end

      helper_method :minors, :tutor_adapter

      def index; end

      def unverified
        redirect_to user_minors_path if tutor_verified?
      end

      private

      def minors
        current_user.minors
      end
    end
  end
end
