# frozen_string_literal: true

require "spec_helper"
require "shared/system_organization_examples"

describe "Updates an organization", type: :system do
  let(:admin) { create(:admin) }
  let!(:organization) { create(:organization, name: "Citizen Corp") }
  let!(:another_organization) { create(:organization) }
  let(:enable_minors_participation) { false }
  let(:minimum_minor_age) { 10 }
  let(:maximum_minor_age) { 13 }
  let!(:minors_organization_config) do
    create(:minors_organization_config,
           organization: another_organization,
           enable_minors_participation: false,
           minimum_minor_age: 9,
           maximum_minor_age: 12)
  end

  before do
    allow(Decidim::Kids).to receive(:enable_minors_participation).and_return(enable_minors_participation)
    allow(Decidim::Kids).to receive(:minimum_minor_age).and_return(minimum_minor_age)
    allow(Decidim::Kids).to receive(:maximum_minor_age).and_return(maximum_minor_age)
    login_as admin, scope: :admin
    visit decidim_system.root_path
    click_link "Organizations"
    within "table tbody" do
      first("tr").click_link "Edit"
    end
  end

  it "has default properties" do
    click_button "Show advanced settings"
    expect(page).not_to have_checked_field "organization_enable_minors_participation"
    expect(page).to have_field "Minimum age allowed to create a minor account", with: "10"
    expect(page).to have_field "Maximum age for a person to be considered a minor", with: "13"
  end

  it_behaves_like "updates organization"

  context "when minors config already exists" do
    let(:another_organization) { organization }

    it "has defined properties" do
      click_button "Show advanced settings"
      expect(page).not_to have_checked_field "organization_enable_minors_participation"
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
      click_button "Show advanced settings"
      expect(page).to have_checked_field "organization_enable_minors_participation"
      expect(page).to have_field "Minimum age allowed to create a minor account", with: "11"
      expect(page).to have_field "Maximum age for a person to be considered a minor", with: "14"
    end

    it_behaves_like "updates organization", true
  end
end
