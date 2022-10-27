# frozen_string_literal: true

module Decidim
  module Kids
    class AuthorizationsController < Decidim::Verifications::AuthorizationsController
      include Decidim::UserProfile
      include AuthorizationMethods

      layout "layouts/decidim/user_profile"

      helper_method :authorizations_path, :minor_user

      def authorizations_path(prs = {})
        decidim_kids.user_minor_authorizations_path(prs)
      end

      def index
        if minor_user_authorized?
          # todo: unblock user, update personal data
          flash[:notice] = "minor authorized"
        else
          flash[:alert] = "minor not authorized"
        end
        redirect_to decidim_kids.user_minors_path
      end

      def new
        if minor_authorized?
          flash[:notice] = "minor already authorized"
          redirect_to decidim_kids.user_minors_path
        else
          super
        end
      end

      def handler_params
        (params[:authorization_handler] || {}).merge(user: minor_user)
      end

      def handler_name
        current_organization.minors_authorization
      end

      def minor_user
        current_user.minors.find(params[:user_minor_id])
      end

      def minor_authorized?
        minor_authorization(minor_user).present?
      end
    end
  end
end
