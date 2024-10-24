# frozen_string_literal: true

require "spec_helper"

describe "Writes minor log" do
  let(:organization) { create(:organization) }
  let(:user) { create(:user, :confirmed) }
  let(:minor_user) { create(:minor, :confirmed) }

  before do
    switch_to_host(organization.host)
    allow(Rails.logger).to receive(:tagged).and_call_original
  end

  context "when visiting a page without an user logged in" do
    before do
      visit decidim.pages_path
    end

    it "doesn't write log in the minors log" do
      expect(Rails.logger).not_to have_received(:tagged).with(/MINOR-ACTIVITY/)
    end
  end

  context "when visiting a page with a non-minor user logged in" do
    before do
      login_as user, scope: :user
      visit decidim.pages_path
    end

    it "doesn't write log in the minors log" do
      expect(Rails.logger).not_to have_received(:tagged).with(/MINOR-ACTIVITY/)
    end
  end

  context "when visiting a page with a minor user logged in" do
    before do
      allow(user).to receive(:minor?).and_return(true)
      login_as user, scope: :user
      visit decidim.pages_path
    end

    it "writes log in the minors log" do
      expect(Rails.logger).to have_received(:tagged).with(/MINOR-ACTIVITY/)
    end
  end
end
