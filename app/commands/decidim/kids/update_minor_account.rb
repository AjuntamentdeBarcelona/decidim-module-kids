# frozen_string_literal: true

module Decidim
  module Kids
    class UpdateMinorAccount < Decidim::Command
      def initialize(form, current_user, minor)
        @current_user = current_user
        @form = form
        @minor = minor
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
        Decidim::Kids::MinorData.traceability.update!({
                                                        birthday: form.birthday,
                                                        email: form.email,
                                                        name: form.name,
                                                        password: form.password
                                                      })
      end

      def send_email_minor
        Decidim::Kids::MinorNotificationsMailer.confirmation(@minor).deliver_later
      end
    end
  end
end
