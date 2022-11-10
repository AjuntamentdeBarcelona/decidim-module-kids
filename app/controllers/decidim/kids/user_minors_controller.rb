# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile
      include NeedsTutorAuthorization

      def index; end

      def unverified
        redirect_to user_minors_path if tutor_verified?
      end
    end
  end
end
