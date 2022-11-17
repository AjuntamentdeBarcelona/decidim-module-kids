# frozen_string_literal: true

module Decidim
  module Kids
    class Permissions < Decidim::DefaultPermissions
      def permissions
        # return Decidim::Kids::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
        return permission_action if permission_action.scope == :admin
        return permission_action unless user

        minor_accounts_action?
        authorizations_action?
        conversation_action?

        permission_action
      end

      def minor_accounts_action?
        return unless permission_action.subject == :minor_accounts

        if !user.organization.minors_participation_enabled? || user.minor? || !user.confirmed?
          disallow!
        else
          case permission_action.action
          when :index
            allow!
          end
        end
      end

      def authorizations_action?
        return unless permission_action.subject == :authorizations

        toggle_allow(user.organization.minors_participation_enabled? && !user.minor?)
      end

      def conversation_action?
        return unless permission_action.subject == :conversation
        return unless [:create, :update].include?(permission_action.action)

        conversation = context.fetch(:conversation)
        interlocutor = context.fetch(:interlocutor, user)
        toggle_allow(conversation.participants.all? { |p| minor_conversation_participant?(interlocutor, p) })
      end

      def minor_conversation_participant?(interlocutor, participant)
        case participant.class.to_s
        when "Decidim::User"
          interlocutor.minor? ? participant.minor? : !participant.minor?
        when "Decidim::UserGroup"
          participant.users.all? { |p| minor_conversation_participant?(interlocutor, p) }
        else
          raise NotImplementedError
        end
      end
    end
  end
end
