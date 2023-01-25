# frozen_string_literal: true

module Decidim
  module Kids
    # This command destroys the minor's account.
    # If a minor user is not confirmed (never logged), the minor user is hard destroys.
    # If it has been confirmed, soft-destroys
    class DestroyMinorAccount < Decidim::Command
      def initialize(minor_user, minor_account)
        @minor_user = minor_user
        @minor_account = minor_account
      end

      def call
        transaction do
          destroy_minor_account
          destroy_minor_user
        end

        broadcast(:ok)
      end

      private

      attr_reader :minor_user, :minor_account

      def destroy_confirmed_minor_user!
        @minor_user.name = ""
        @minor_user.email = ""
        @minor_user.name = ""
        @minor_user.nickname = ""
        @minor_user.deleted_at = Time.current
        @minor_user.skip_reconfirmation!
        @minor_user.save!
      end

      def destroy_not_confirmed_minor_user
        @minor_user.destroy! unless minor_user.sign_in_count?
      end

      def destroy_minor_user
        minor_user.sign_in_count? ? destroy_confirmed_minor_user! : destroy_not_confirmed_minor_user
      end

      def destroy_minor_account
        @minor_account.destroy_all
      end
    end
  end
end
