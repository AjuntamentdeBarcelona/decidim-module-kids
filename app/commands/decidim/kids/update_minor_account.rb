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

        old_minor_email = minor_user.email

        update_minor

        minor_user.save!

        minor_user.minor_data.update!(attributes_data)

        minor_user.invite!(invited_by, invitation_instructions: "invite_minor") unless old_minor_email == form.email

        broadcast(:ok)
      end

      private

      attr_reader :form, :minor_user, :invited_by

      def update_minor
        minor_user.skip_reconfirmation!
        minor_user.email = form.email
      end

      def attributes_data
        {
          birthday: form.birthday,
          email: form.email,
          name: form.name
        }
      end
    end
  end
end
