# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile
      include NeedsTutorAuthorization

      helper UserMinorsHelper

      helper_method :minor_user, :minor_account_form, :minor_authorized?

      def index; end

      def unverified
        redirect_to user_minors_path if tutor_verified?
      end

      def new
        enforce_permission_to :create, :minor_accounts

        @form = form(Decidim::Kids::MinorAccountForm).instance
      end

      def edit
        enforce_permission_to(:edit, :minor_accounts, minor_user:)

        @form = minor_account_form
      end

      def create
        enforce_permission_to :create, :minor_accounts

        @form = form(Decidim::Kids::MinorAccountForm).from_params(params)

        CreateMinorAccount.call(@form, current_user) do
          on(:ok) do |minor_user|
            flash[:notice] = I18n.t("user_minors.create.success", scope: "decidim.kids")
            redirect_to decidim_kids.new_user_minor_authorization_path(user_minor_id: minor_user.id)
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("user_minors.create.error", scope: "decidim.kids")
            render :new
          end
        end
      end

      def update
        enforce_permission_to(:edit, :minor_accounts, minor_user:)

        @form = form(Decidim::Kids::MinorAccountForm).from_params(params)

        UpdateMinorAccount.call(@form, minor_user) do
          on(:ok) do
            flash[:notice] = I18n.t("user_minors.update.success", scope: "decidim.kids")
            redirect_to user_minors_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("user_minors.update.error", scope: "decidim.kids")
            render :edit
          end
        end
      end

      def destroy
        enforce_permission_to(:delete, :minor_accounts, minor_user:)

        DestroyMinorAccount.call(minor_user, minor_account) do
          on(:ok) do
            # rubocop:disable Rails/ActionControllerFlashBeforeRender
            flash[:notice] = I18n.t("user_minors.destroy.success", scope: "decidim.kids")
            # rubocop:enable Rails/ActionControllerFlashBeforeRender
          end
        end

        redirect_to user_minors_path
      end

      def resend_invitation_to_minor
        Decidim::InviteUserAgain.call(minor_user, "invite_minor") do
          on(:ok) do
            # rubocop:disable Rails/ActionControllerFlashBeforeRender
            flash[:notice] = I18n.t("user_minors.resend.success", scope: "decidim.kids")
            # rubocop:enable Rails/ActionControllerFlashBeforeRender
          end
        end

        redirect_to user_minors_path
      end

      private

      def minor_account_form
        @form ||= form(Decidim::Kids::MinorAccountForm).from_model(minor_user.minor_data)
      end

      def minor_user
        @minor_user ||= minors.find_by(id: params[:id])
      end

      def minor_account
        @minor_account ||= Decidim::Kids::MinorAccount.where(decidim_minor_id: minor_user.id)
      end

      def minor_authorized?(user)
        minor_authorization(user).present?
      end
    end
  end
end
