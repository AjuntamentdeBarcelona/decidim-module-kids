# frozen_string_literal: true

require "spec_helper"
require "shared/system_organization_examples"

describe "Updates an organization" do
  let(:admin) { create(:admin) }
  let!(:organization) { create(:organization, name: { en: "Citizen Group" }) }
  let!(:another_organization) { create(:organization) }
  let(:enable_minors_participation) { false }
  let(:minimum_minor_age) { 10 }
  let(:maximum_minor_age) { 13 }
  let!(:minors_organization_config) do
    create(:minors_organization_config,
           organization: another_organization,
           enable_minors_participation: false,
           minimum_minor_age:,
           maximum_minor_age:)
  end

  before do
    allow(Decidim::Kids).to receive_messages(enable_minors_participation:, minimum_minor_age:, maximum_minor_age:)
    login_as admin, scope: :admin
    visit decidim_system.root_path
    click_on "Organizations"
    within "table tbody" do
      first("tr").click_on "Edit"
    end
  end

  it "has default properties" do
    click_on "Show advanced settings"
    expect(page).to have_no_checked_field "Enable minors participation"
    expect(page).to have_field "Minimum age allowed to create a minor account", with: "10"
    expect(page).to have_field "Maximum age for a person to be considered a minor", with: "13"
  end

  it_behaves_like "updates organization"

  context "when minors config already exists" do
    let(:another_organization) { organization }
    let(:minimum_minor_age) { 9 }
    let(:maximum_minor_age) { 12 }

    it "has defined properties" do
      click_on "Show advanced settings"
      expect(page).to have_no_checked_field "Enable minors participation"
      expect(page).to have_field "Minimum age allowed to create a minor account", with: "9"
      expect(page).to have_field "Maximum age for a person to be considered a minor", with: "12"
    end

    it_behaves_like "updates organization"
  end

  context "when minors config is active by default" do
    let(:enable_minors_participation) { true }
    let(:minimum_minor_age) { 11 }
    let(:maximum_minor_age) { 14 }

    it "has defined properties" do
      click_on "Show advanced settings"
      expect(page).to have_checked_field "Enable minors participation"
      expect(page).to have_field "Minimum age allowed to create a minor account", with: "11"
      expect(page).to have_field "Maximum age for a person to be considered a minor", with: "14"
    end

    it_behaves_like "updates organization", true
  end
end
