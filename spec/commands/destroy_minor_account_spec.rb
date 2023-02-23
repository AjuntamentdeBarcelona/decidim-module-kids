# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe DestroyMinorAccount do
    let(:command) { described_class.new(minor, minor_account) }
    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, organization: organization) }
    let(:minor) { create(:minor, tutor: user, organization: organization, sign_in_count: sign_in_count) }
    let!(:minor_account) { Decidim::Kids::MinorAccount.where(decidim_minor_id: minor.id) }
    let(:sign_in_count) { 1 }

    context "when a minor user is confirmed" do
      it "broadcasts ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "set name, nickname and email to blank string" do
        command.call
        expect(minor.reload.name).to eq("")
        expect(minor.reload.nickname).to eq("")
        expect(minor.reload.email).to eq("")
      end

      it "deletes minor's account" do
        expect do
          command.call
        end.to change(Decidim::Kids::MinorAccount, :count).by(-1)
      end
    end

    context "when a minor user is not confirmed" do
      let(:sign_in_count) { 0 }

      it "broadcasts ok" do
        expect { command.call }.to broadcast(:ok)
      end

      it "deletes minor" do
        expect do
          command.call
        end.to change(Decidim::User, :count).by(-1)
      end

      it "deletes minor's account" do
        expect do
          command.call
        end.to change(Decidim::Kids::MinorAccount, :count).by(-1)
      end
    end
  end
end
