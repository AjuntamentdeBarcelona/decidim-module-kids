# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe Permissions do
    subject { described_class.new(user, permission_action, context).permissions.allowed? }

    let(:user) { create :user, :confirmed, organization: }
    let(:organization) { create :organization }
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
