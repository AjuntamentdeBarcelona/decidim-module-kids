# frozen_string_literal: true

module Decidim
  module Kids
    # A command to authorize a user with an authorization handler.
    class CreateMinorAccount < Decidim::Command
      def initialize(form, current_user)
        @current_user = current_user
        @form = form
      end

      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          create_minor
          send_email_minor
        end

        broadcast(:ok)
      end

      private

      attr_reader :form

      def create_minor
        @minor = Decidim::User.new(email: form.email,
                                   name: "Pending Minor Account",
                                   blocked: true,
                                   organization: form.current_organization,
                                   password: form.password,
                                   tos_agreement: true,
                                   password_confirmation: form.password_confirmation,
                                   nickname: Decidim::User.nicknamize(form.name, organization: form.current_organization),
                                   minor_data: MinorData.new({
                                                               birthday: form.birthday,
                                                               email: form.email,
                                                               name: form.name,
                                                               password: form.password
                                                             }))

        @minor.skip_confirmation!
        @minor.skip_invitation = true
        @minor.save!
        MinorAccount.create!(tutor: @current_user, minor: @minor)
      end

      def send_email_minor
        Decidim::Kids::MinorNotificationsMailer.confirmation(@minor).deliver_later
      end
    end
  end
end
