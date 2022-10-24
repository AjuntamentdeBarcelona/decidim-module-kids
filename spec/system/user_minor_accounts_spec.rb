# frozen_string_literal: true

require "spec_helper"
require "shared/user_minors_examples"

describe "User manages minor accounts", type: :system do
  let(:organization) { user.organization }
  let(:user) { create(:user, :confirmed) }
  let(:enable_minors_participation) { false }
  let(:minimum_minor_age) { 10 }
  let(:minimum_adult_age) { 14 }
  let!(:minors_organization_config) do
    create(:minors_organization_config,
           organization:,
           enable_minors_participation:,
           minimum_minor_age:,
           minimum_adult_age:)
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.account_path
  end

  it_behaves_like "user minors disabled"

  context "when minors participation enabled" do
    let(:enable_minors_participation) { true }

    before do
      visit decidim.account_path
    end

    it_behaves_like "user minors enabled"
  end

  # TODO: when the user itself is a minor, the link should not be shown
end
