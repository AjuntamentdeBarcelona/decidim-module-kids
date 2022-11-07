# frozen_string_literal: true

module Decidim
  module Kids
    # A command to authorize a user with an authorization handler.
    class CreateMinorAccount < Decidim::Command
      def initialize(form)
        @form = form
      end

      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          create_minor_account
          create_user
          send_email_minor
        end

        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_minor_account
        @minor_account_data = Decidim::Kids::MinorData.create(
          name: form.name,
          birthday: form.birthday,
          email: form.email
        )
      end

      def create_user
        @user = Decidim::User.new(email: form.email,
                                  name: form.name,
                                  blocked: true,
                                  organization: form.current_organization,
                                  password: form.password,
                                  tos_agreement: form.tos_agreement,
                                  nickname: form.name)
        @user.skip_confirmation!
        @user.skip_invitation = true
        @user.save!
      end

      def send_email_minor
        Decidim::Kids::MinorNotificationsMailer.confirmation(@user).deliver_later
      end
    end
  end
end
