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
        return false unless permission_action.subject == :minor_accounts

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
          when :delete
            can_destroy_minor_account?
          when :impersonate
            can_impersonate_minor_account?
          end
        end
      end

      def authorizations_action?
        return false unless permission_action.subject == :authorizations

        case permission_action.action
        when :all
          return allow! unless user.organization.minors_participation_enabled?

          toggle_allow(!user.minor?)
        end
      end

      def conversation_action?
        return false unless permission_action.subject == :conversation
        return false unless user.organization.minors_participation_enabled?
        return false unless [:create, :update].include?(permission_action.action)

        conversation = context.fetch(:conversation)
        interlocutor = context.fetch(:interlocutor, user)
        toggle_allow(conversation.participants.all? { |p| minor_conversation_participant?(interlocutor, p) })
      end

      private

      def minor_user
        @minor_user ||= context.fetch(:minor_user, nil)
      end

      def can_create_minor_account?
        toggle_allow(user.minors.count < Decidim::Kids.maximum_minor_accounts)
      end

      def can_edit_minor_account?
        toggle_allow(user.minors.include?(minor_user))
      end

      def can_destroy_minor_account?
        can_edit_minor_account?
      end

      def minor_conversation_participant?(interlocutor, participant)
        case participant.class.to_s
        when "Decidim::User"
          interlocutor.minor? ? participant.minor? : !participant.minor?
        when "Decidim::UserGroup"
          participant.users.all? { |p| minor_conversation_participant?(interlocutor, p) }
        else
          # :nocov:
          raise NotImplementedError
          # :nocov:
        end
      end

      def can_impersonate_minor_account?
        is_allowed = Decidim::Kids::ImpersonationMinorLog.active.where(tutor: user).empty? &&
                     Decidim::Kids.allow_impersonation &&
                     minor_user.sign_in_count.positive?

        toggle_allow(is_allowed)
      end
    end
  end
end
