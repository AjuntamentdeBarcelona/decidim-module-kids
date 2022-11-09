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

      def new
        @form = minor_account_form.instance
      end

      def create
        @form = minor_account_form.from_params(params)

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

      private

      def minors
        current_user.minors
      end

      def minor_account_form
        form(Decidim::Kids::MinorAccountForm)
      end
    end
  end
end
