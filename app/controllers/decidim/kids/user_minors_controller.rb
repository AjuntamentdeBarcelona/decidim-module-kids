# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile

      def index
        enforce_permission_to :index, :user_minors
      end
    end
  end
end
