# frozen_string_literal: true

shared_examples "creates minor accounts" do
  context "when the limit is not reached" do
    it "create a new minor" do
      click_link("Add a minor")

      within "form.new_minor_account" do
        fill_in "Name", with: "John Tesla"
        fill_in "Email", with: "john@example.org"
        page.find("#minor_account_birthday").click
        fill_in "Birthday", with: "01/01/2010"
        fill_in "Password", match: :first, with: "mallorca123123123"
        fill_in "Password confirmation", with: "mallorca123123123"
        find("*[type=submit]").click

        expect(page).to have_content("must be accepted")

        page.find("#minor_tos_agreement").click
        fill_in "Password", match: :first, with: "mallorca123123123"
        fill_in "Password confirmation", with: "mallorca123123123"
        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully created")
      end

      expect(page).to have_content("John Tesla")
    end
  end

  context "when the limit is reached" do
    let!(:minor) { create_list(:minor, maximum_minor_accounts, tutor: user, organization:) }

    it "cannot add a minor" do
      click_link "My minor accounts"

      expect(page).to have_css("a.disabled", text: "Add a minor", count: 1)
    end
  end
end

shared_examples "updates minor accounts" do
  it "can edit a minor" do
    click_link "Edit"

    within "form.edit_minor_account" do
      fill_in "Name", with: "Nikola Tesla"
      fill_in "Email", with: "test@example.org"
      page.find("#minor_account_birthday").click
      fill_in "Birthday", with: "01/11/2010"
      fill_in "Password", match: :first, with: "mallorca123123123"
      fill_in "Password confirmation", with: "mallorca123123123"
      find("*[type=submit]").click
    end

    within_flash_messages do
      expect(page).to have_content("successfully updated")
    end

    expect(page).to have_content("Nikola Tesla")
  end
end
