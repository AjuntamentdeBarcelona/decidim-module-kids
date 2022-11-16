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

        update_minor

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
          password_confirmation: form.password,
          name: form.name
        }
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
