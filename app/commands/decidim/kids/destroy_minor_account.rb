# frozen_string_literal: true

module Decidim
  module Kids
    # This command destroys the minor's account.
    class DestroyMinorAccount < Decidim::Command
      def initialize(minor_user, minor_account)
        @minor_user = minor_user
        @minor_account = minor_account
      end

      def call
        transaction do
          delete_minor_user!
          destroy_minor_data
          destroy_minor_account
        end

        broadcast(:ok)
      end

      private

      attr_reader :minor_user, :minor_account

      def delete_minor_user!
        @minor_user.name = ""
        @minor_user.email = ""
        @minor_user.name = ""
        @minor_user.nickname = ""
        @minor_user.deleted_at = Time.current
        @minor_user.skip_reconfirmation!
        @minor_user.save!
      end

      def destroy_minor_data
        @minor_user.minor_data.destroy!
      end

      def destroy_minor_account
        @minor_account.destroy_all
      end
    end
  end
end
