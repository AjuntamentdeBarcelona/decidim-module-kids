# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, organization:) }
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

    context "when destroy action" do
      let(:action_name) { :delete }
      let(:minor_account) { Decidim::Kids::MinorAccount.where(decidim_minor_id: minor.id) }

      let(:context) do
        {
          minor_user: minor,
          minor_account:
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
  end
end
