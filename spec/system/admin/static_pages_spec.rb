# frozen_string_literal: true

require "spec_helper"

describe "Static pages" do
  include ActionView::Helpers::SanitizeHelper

  let(:admin) { create(:user, :admin, :confirmed) }
  let(:organization) { admin.organization }
  let!(:minors_static_page) { create(:static_page, organization:, slug: "minors") }

  before do
    switch_to_host(organization.host)
  end

  describe "Managing pages" do
    before do
      login_as admin, scope: :user
      visit decidim_admin.root_path
      click_on "Pages"
    end

    context "with minors configuration enabled" do
      let!(:minors_organization_config) { create(:minors_organization_config, organization:) }

      before do
        visit current_path
      end

      it "can edit it" do
        within "tr", text: translated(minors_static_page.title) do
          find("button[data-controller='dropdown']").click
          click_on "Edit"
        end

        within ".edit_static_page" do
          fill_in_i18n(
            :static_page_title,
            "#static_page-title-tabs",
            en: "Not welcomed anymore"
          )
          fill_in_i18n_editor(
            :static_page_content,
            "#static_page-content-tabs",
            en: "This is the new <strong>content</strong>"
          )
          find("*[type=submit]").click
        end

        expect(page).to have_admin_callout("successfully")
      end

      it "can't delete it" do
        within "tr", text: translated(minors_static_page.title) do
          expect(page).to have_no_css(".action-icon--remove")
        end
      end

      it "can visit it" do
        within "tr", text: translated(minors_static_page.title) do
          find("button[data-controller='dropdown']").click
          expect(page).to have_link("View", href: "/pages/#{minors_static_page.slug}")
        end

        visit "/pages/#{minors_static_page.slug}"

        expect(page).to have_content(translated(minors_static_page.title))
        expect(page).to have_content(strip_tags(translated(minors_static_page.content)))
        expect(page).to have_current_path(/#{minors_static_page.slug}/)
      end
    end

    context "without minors configuration enabled" do
      before do
        visit current_path
      end

      it "can delete it" do
        accept_confirm do
          within "tr", text: translated(minors_static_page.title) do
            find("button[data-controller='dropdown']").click
            click_on "Delete"
          end
        end

        expect(page).to have_admin_callout("successfully")

        within "table" do
          expect(page).to have_no_content(translated(minors_static_page.title))
        end
      end
    end
  end
end
