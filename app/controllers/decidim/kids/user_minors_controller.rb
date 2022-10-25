# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile

      helper_method :minors

      def index
        enforce_permission_to :index, :minor_accounts
      end

      private

      def minors
        current_user.minors
      end
    end
  end
end
