# frozen_string_literal: true

shared_examples "user minors CRUD" do
  it "create a new minor" do
    click_link("Add a minor")

    within "form.new_minor_account" do
      fill_in "Name", with: "John Tesla"
      fill_in "Email", with: "john@example.org"
      page.find("#minor_account_birthday").click
      fill_in "Birthday", with: "01/01/2010"
      fill_in "Password", match: :first, with: "mallorca123123123"
      fill_in "Password confirmation", with: "mallorca123123123"
      page.find("#minor_tos_agreement").click
      find("*[type=submit]").click
    end

    within_flash_messages do
      expect(page).to have_content("successfully created")
    end

  end

  it "updates the minors's data" do
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
  end
end
