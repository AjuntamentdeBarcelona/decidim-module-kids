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
          # send_email_to_minor_account
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
        @user = User.create!(
          email: form.email,
          name: form.name,
          blocked: true,
          organization: form.current_organization,
          password: form.password,
          nickname: form.name
        )
      end

      # def send_email_to_minor_account
      #
      # end
    end
  end
end
