# frozen_string_literal: true

module Decidim
  module Kids
    class UserMinorsController < ApplicationController
      include Decidim::UserProfile
      include NeedsTutorAuthorization

      helper_method :minors, :minor_user, :minor_account_form

      before_action :minor_user, only: [:show, :edit, :update]

      def index; end

      def unverified
        redirect_to user_minors_path if tutor_verified?
      end

      def new
        @form = form(Decidim::Kids::MinorAccountForm).instance
      end

      def create
        @form = form(Decidim::Kids::MinorAccountForm).from_params(params)

        return unless tutor_verified?

        CreateMinorAccount.call(@form, current_user) do
          on(:ok) do
            flash[:notice] = t("user_minors.create.success", scope: "decidim.kids")
            redirect_to user_minors_path
          end

          on(:invalid) do
            flash.now[:alert] = t("user_minors.create.error", scope: "decidim.kids")
            render :new
          end
        end
      end

      def show; end

      def edit
        @form = minor_account_form
      end

      def update
        @form = form(Decidim::Kids::MinorAccountForm).from_params(params)

        return unless tutor_verified?

        UpdateMinorAccount.call(@form, current_user, minor_user) do
          on(:ok) do
            flash[:notice] = t("user_minors.update.success", scope: "decidim.kids")
            redirect_to user_minors_path
          end

          on(:invalid) do
            flash.now[:alert] = t("user_minors.update.error", scope: "decidim.kids")
            render :edit
          end
        end
      end

      private

      def minors
        current_user.minors
      end

      def minor_account_form
        @form = form(Decidim::Kids::MinorAccountForm).from_model(@minor_user)
      end

      def minor_user
        @minor_user = minors.find_by(id: params[:id])
      end
    end
  end
end
