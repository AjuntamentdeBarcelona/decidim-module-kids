# frozen_string_literal: true

module Decidim
  module Kids
    class Permissions < Decidim::DefaultPermissions
      def permissions
        # return Decidim::Kids::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
        return permission_action if permission_action.scope == :admin

        return permission_action unless user

        case permission_action.subject
        when :minor_accounts
          if !user.organization.minors_participation_enabled? || user.minor? || !user.confirmed?
            disallow!
          else
            case permission_action.action
            when :index
              allow!
            end
          end
        when :authorizations
          if !user.organization.minors_participation_enabled? || user.minor?
            disallow!
          else
            allow!
          end
        end

        permission_action
      end
    end
  end
end
