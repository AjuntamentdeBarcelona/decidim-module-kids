# frozen_string_literal: true

module Decidim
  module Kids
    class UpdateMinorAccount < Decidim::Command
      def initialize(form, minor_user)
        @form = form
        @minor_user = minor_user
      end

      def call
        return broadcast(:invalid) if form.invalid?

        transaction do
          update_minor
          send_email_minor
        end

        broadcast(:ok)
      end

      private

      attr_reader :form

      def update_minor
        @minor_user.update!(attributes_user)
        @minor_user.minor_data.update!(attributes_data)
      end

      def attributes_user
        {
          email: form.email,
          password: form.password,
          name: form.name
        }
      end

      def attributes_data
        {
          birthday: form.birthday,
          email: form.email,
          name: form.name,
          password: form.password
        }
      end

      def send_email_minor
        Decidim::Kids::MinorNotificationsMailer.confirmation(@minor_user).deliver_later
      end
    end
  end
end
