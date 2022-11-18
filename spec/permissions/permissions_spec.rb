# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:user) { create :user, :confirmed, organization: }
    let(:other_user) { create :user, :confirmed, organization: }
    let(:another_user) { create :user, :confirmed, organization: }
    let(:organization) { create :organization }
    let(:minor) { create(:minor, tutor: user, organization:) }
    let(:context) do
      {}
    end
    let(:permission_action) { Decidim::PermissionAction.new(**action) }
    let(:action_name) { :index }
    let(:action_subject) { :minor_accounts }
    let(:action) do
      { scope: :public, action: action_name, subject: action_subject }
    end
    let(:minors_enabled) { true }
    let(:is_minor) { false }

    before do
      allow(organization).to receive(:minors_participation_enabled?).and_return(minors_enabled)
      allow(user).to receive(:minor?).and_return(is_minor)
    end

    it { is_expected.to be true }

    context "when scope is admin" do
      let(:action) do
        { scope: :admin, action: action_name, subject: action_subject }
      end

      it_behaves_like "permission is not set"
    end

    context "when create action" do
      let(:max_minors) { Decidim::Kids.maximum_minor_accounts }
      let(:action_name) { :create }

      context "when the maximum number of minors has been reached" do
        let!(:minors) { create_list(:minor, max_minors, tutor: user, organization:) }

        it { is_expected.to be false }
      end

      context "when the maximum number of minors hasn't been reached" do
        let!(:minors) { create_list(:minor, max_minors - 1, tutor: user, organization:) }

        it { is_expected.to be true }
      end
    end

    context "when edit action" do
      let(:action_name) { :edit }

      let(:context) do
        {
          minor_user: minor
        }
      end

      let(:action) do
        { scope: :public, action: action_name, subject: action_subject }
      end

      it { is_expected.to be true }
    end

    context "when other action" do
      let(:action_name) { :other_action }

      it_behaves_like "permission is not set"
    end

    context "when no user" do
      let(:user) { nil }

      it_behaves_like "permission is not set"
    end

    context "when user is not confirmed" do
      let(:user) { create :user, organization: }

      it { is_expected.to be false }
    end

    context "when organization has minors disabled" do
      let(:minors_enabled) { false }

      it { is_expected.to be false }
    end

    context "when user is a minor" do
      let(:is_minor) { true }

      it { is_expected.to be false }
    end

    context "when user is trying to access authorizations" do
      let(:action_name) { :all }
      let(:action_subject) { :authorizations }

      context "when user is not a minor" do
        it { is_expected.to be true }
      end

      context "when user is a minor" do
        let(:is_minor) { true }

        it { is_expected.to be false }
      end
    end

    context "when user is trying to create a conversation with other users" do
      let(:action_name) { :create }
      let(:action_subject) { :conversation }
      let(:context) { { conversation: } }
      let(:conversation) do
        Decidim::Messaging::Conversation.create(participants: [user, other_user, another_user])
      end

      context "when participants are minors" do
        before do
          allow(other_user).to receive(:minor?).and_return(true)
          allow(another_user).to receive(:minor?).and_return(true)
        end

        context "when user is an adult" do
          it { is_expected.to be false }
        end

        context "when user is a minor" do
          before do
            allow(user).to receive(:minor?).and_return(true)
          end

          it { is_expected.to be true }
        end
      end

      context "when participants are adults" do
        context "when user is an adult" do
          it { is_expected.to be true }
        end

        context "when user is a minor" do
          before do
            allow(user).to receive(:minor?).and_return(true)
          end

          it { is_expected.to be false }
        end
      end

      context "when participants are a mix of adults and minors" do
        before do
          allow(another_user).to receive(:minor?).and_return(true)
        end

        context "when user is an adult" do
          it { is_expected.to be false }
        end

        context "when user is a minor" do
          before do
            allow(user).to receive(:minor?).and_return(true)
          end

          it { is_expected.to be false }
        end
      end

      context "when participants are a group of users" do
        let(:user_group) { create(:user_group, :verified) }
        let(:conversation) do
          Decidim::Messaging::Conversation.create(participants: [user, user_group])
        end

        before do
          create(:user_group_membership, user: other_user, user_group:)
          create(:user_group_membership, user: another_user, user_group:, role: :member)
        end

        context "when the group of user are minors" do
          before do
            user_group.users.each do |u|
              allow(u).to receive(:minor?).and_return(true)
            end
          end

          context "when user is an adult" do
            it { is_expected.to be false }
          end

          context "when user is a minor" do
            before do
              allow(user).to receive(:minor?).and_return(true)
            end

            it { is_expected.to be true }
          end
        end

        context "when the group of user are adults" do
          context "when user is an adult" do
            it { is_expected.to be true }
          end

          context "when user is a minor" do
            before do
              allow(user).to receive(:minor?).and_return(true)
            end

            it { is_expected.to be false }
          end
        end

        context "when the group of user is a mix of adults and minors" do
          before do
            user_group.users.each do |u|
              allow(u).to receive(:minor?).and_return(true) if u.id == other_user.id
            end
          end

          context "when user is an adult" do
            it { is_expected.to be false }
          end

          context "when user is a minor" do
            before do
              allow(user).to receive(:minor?).and_return(true)
            end

            it { is_expected.to be false }
          end
        end
      end
    end
  end
end
