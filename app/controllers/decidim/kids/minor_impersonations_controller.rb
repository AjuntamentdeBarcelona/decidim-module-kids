# frozen_string_literal: true

module Decidim
  module Kids
    # Controller that allows impersonating managed minors.
    class MinorImpersonationsController < ApplicationController
      include Decidim::UserProfile

      layout "layouts/decidim/user_profile"

      helper_method :minor_user

      def permission_class_chain
        [::Decidim::Kids::Permissions] + super
      end

      def new
        enforce_permission_to(:impersonate, :minor_accounts, minor_user:)

        @form = form(ImpersonateMinorForm).from_params(params)
      end

      def create
        enforce_permission_to(:impersonate, :minor_accounts, minor_user:)

        @form = form(ImpersonateMinorForm).from_params(params)

        ImpersonateMinor.call(minor_user, current_user, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("impersonations.create.success", scope: "decidim.kids")
            redirect_to decidim.root_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("impersonations.create.error", scope: "decidim.kids")
            render :new
          end
        end
      end

      def close_session
        CloseSessionManagedMinor.call(current_user, real_user) do
          on(:ok) do
            flash[:notice] = I18n.t("impersonations.close_session.success", scope: "decidim.kids")
            redirect_to decidim.root_path
          end
        end
      end

      private

      def minor_user
        current_user.minors.find(params[:user_minor_id])
      end
    end
  end
end
