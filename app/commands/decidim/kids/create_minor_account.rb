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
        end

        broadcast(:ok, minor_user)
      end

      private

      attr_reader :form, :minor_user

      def create_minor
        @minor_user = Decidim::User.new(email: form.email,
                                        name: I18n.t("minor_account.name", scope: "decidim.kids"),
                                        blocked: true,
                                        blocked_at: Time.current,
                                        organization: @current_user.organization,
                                        tos_agreement: true,
                                        nickname: Decidim::User.nicknamize(form.name, organization: @current_user.organization),
                                        minor_data: MinorData.new({
                                                                    birthday: form.birthday,
                                                                    email: form.email,
                                                                    name: form.name
                                                                  }))

        @minor_user.skip_confirmation!
        @minor_user.skip_invitation = true
        @minor_user.save!
        MinorAccount.create!(tutor: @current_user, minor: @minor_user)
        @minor_user.minor_data.save!
        Rails.logger.tagged("MINOR-CONSENT").info(log_params)
        @minor_user
      end

      def log_params
        {
          tutor_id: @current_user.id,
          minor_id: @minor_user.id
        }
      end
    end
  end
end
