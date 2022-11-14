# frozen_string_literal: true

module Decidim
  module Kids
    class Permissions < Decidim::DefaultPermissions
      def permissions
        # return Decidim::Kids::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
        return permission_action if permission_action.scope == :admin

        return permission_action unless user

        if permission_action.subject == :minor_accounts
          if !user.organization.minors_participation_enabled? || user.minor? || !user.confirmed?
            disallow!
          else
            case permission_action.action
            when :index
              allow!
            when :create
              can_create_minor_account?
            when :edit
              can_edit_minor_account?
            end
          end
        end

        permission_action
      end

      private

      def can_create_minor_account?
        allow! if user.minors.count <= Decidim::Kids.maximum_minor_accounts
      end

      def can_edit_minor_account?
        allow! if minor_user.tutors.include?(tutor)
      end
    end
  end
end
