# frozen_string_literal: true

module Decidim
  module Kids
    class AuthorizationsController < Decidim::Verifications::AuthorizationsController
      include Decidim::UserProfile
      include NeedsTutorAuthorization

      layout "layouts/decidim/user_profile"

      helper_method :authorizations_path, :minor_user

      def authorizations_path(prs = {})
        decidim_kids.user_minor_authorizations_path(prs)
      end

      def index
        if minor_authorized?
          # TODO: unblock user, update personal data
          flash[:notice] = t("authorizations.authorize.success", scope: "decidim.kids")
        else
          flash[:alert] = t("authorizations.authorize.error", scope: "decidim.kids")
        end
        redirect_to decidim_kids.user_minors_path
      end

      def new
        if minor_authorized?
          flash[:notice] = t("authorizations.authorize.already_authorized", scope: "decidim.kids")
          redirect_to decidim_kids.user_minors_path
        else
          super
        end
      end

      def create
        if minor_authorized?
          flash[:notice] = t("authorizations.authorize.already_authorized", scope: "decidim.kids")
          return redirect_to decidim_kids.user_minors_path
        end

        AuthorizeMinor.call(handler) do
          on(:ok) do
            flash[:notice] = t("authorizations.authorize.success", scope: "decidim.kids")
            redirect_to redirect_url || authorizations_path
          end

          on(:transferred) do
            flash[:notice] = t("authorizations.authorize.success", scope: "decidim.kids")
            redirect_to redirect_url || authorizations_path
          end

          on(:invalid_age) do
            flash[:alert] = t("authorizations.create.invalid_age", scope: "decidim.kids")
            render action: :new
          end

          on(:invalid) do
            flash[:alert] = t("authorizations.authorize.error", scope: "decidim.kids")
            render action: :new
          end
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
