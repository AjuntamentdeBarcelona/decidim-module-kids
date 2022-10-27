# frozen_string_literal: true

module Decidim
  module Kids
    class AuthorizationsController < Decidim::Verifications::AuthorizationsController
      include AuthorizationMethods

      helper_method :authorizations_path

      def authorizations_path(prs = {})
        decidim_kids.user_minor_authorizations_path(prs)
      end

      def index
        if minors_authorizations(minor_user).any?
          flash[:notice] = "minor authorized"
        else
          flash[:alert] = "minor not authorized"
        end
        redirect_to decidim_kids.user_minors_path
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
    end
  end
end
