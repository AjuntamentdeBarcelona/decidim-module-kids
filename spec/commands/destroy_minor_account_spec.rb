# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe DestroyMinorAccount do
    let(:command) { described_class.new(minor, minor_account) }
    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, organization:) }
    let(:minor) { create(:minor, tutor: user, organization:) }
    let(:minor_account) { MinorAccount.where(decidim_minor_id: minor.id) }

    it "broadcasts ok" do
      expect { command.call }.to broadcast(:ok)
    end

    it "set name, nickname and email to blank string" do
      command.call
      expect(minor.reload.name).to eq("")
      expect(minor.reload.nickname).to eq("")
      expect(minor.reload.email).to eq("")
    end
  end
end
