# frozen_string_literal: true

shared_examples "updates organization" do |uncheck_minors|
  it "edits the data" do
    fill_in :update_organization_name_en, with: "Citizens Rule!"
    fill_in "Host", with: "www.example.org"
    fill_in "Secondary hosts", with: "foobar.example.org\n\rbar.example.org"
    choose "Do not allow participants to create an account, but allow existing participants to log in"

    click_on "Show advanced settings"

    if uncheck_minors
      expect(page).to have_checked_field "Enable minors participation"
      uncheck "Enable minors participation"
    else
      expect(page).to have_no_checked_field "Enable minors participation"
      check "Enable minors participation"
    end
    fill_in "Minimum age allowed to create a minor account", with: "11"
    fill_in "Maximum age for a person to be considered a minor", with: "14"
    fill_in "Maximum number of minors that can be assigned to a tutor", with: "2"

    within_fieldset("Available authorizations") do
      check "Another example authorization (Direct)"
    end

    click_on "Save"

    expect(page).to have_css("div.flash.success")
    expect(page).to have_content("Citizens Rule!")

    organization.reload_minors_config

    if uncheck_minors
      expect(organization).not_to be_minors_participation_enabled
    else
      expect(organization).to be_minors_participation_enabled
    end
    expect(organization.minimum_minor_age).to eq(11)
    expect(organization.maximum_minor_age).to eq(14)
    expect(organization.maximum_minor_accounts).to eq(2)
    expect(organization.minors_authorization).to eq("dummy_age_authorization_handler")
  end
end

shared_examples "creates organization" do
  it "creates a new organization" do
    fill_in "Name", with: "Citizen Corp"
    fill_in "Host", with: "www.example.org"
    fill_in "Secondary hosts", with: "foo.example.org\n\rbar.example.org"
    fill_in "Reference prefix", with: "CCORP"
    fill_in "Organization admin name", with: "City Mayor"
    fill_in "Organization admin email", with: "mayor@example.org"
    check "organization_available_locales_en"
    choose "organization_default_locale_en"

    click_on "Show advanced settings"

    check "Enable minors participation"
    fill_in "Minimum age allowed to create a minor account", with: "11"
    fill_in "Maximum age for a person to be considered a minor", with: "14"
    fill_in "Maximum number of minors that can be assigned to a tutor", with: "5"

    within_fieldset("Available authorizations") do
      check "Another example authorization (Direct)"
    end

    click_on "Create organization & invite admin"

    expect(page).to have_css("div.flash.success")
    expect(page).to have_content("Citizen Corp")

    organization = Decidim::Organization.last
    expect(organization).to be_minors_participation_enabled
    expect(organization.minimum_minor_age).to eq(11)
    expect(organization.maximum_minor_age).to eq(14)
    expect(organization.maximum_minor_accounts).to eq(5)
    expect(organization.minors_authorization).to eq("dummy_age_authorization_handler")
  end
end
