# frozen_string_literal: true

require "spec_helper"

describe "Registration", type: :system do
  let(:organization) { create(:organization) }

  before do
    switch_to_host(organization.host)
  end

  context "when signing up in an organization without minors configuration" do
    before do
      visit decidim.new_user_registration_path
    end

    describe "on first sight" do
      it "shows minors url" do
        expect(page).not_to have_content("Are you under")
      end
    end
  end

  context "when signing up in an organization with minors configuration" do
    let!(:minors_organization_config) { create(:minors_organization_config, organization:) }

    before do
      visit decidim.new_user_registration_path
    end

    describe "on first sight" do
      it "shows minors url" do
        expect(page).to have_content("Are you under #{minors_organization_config.minimum_adult_age}")
        expect(page).to have_link(href: "/pages/minors")
      end
    end
  end
end
