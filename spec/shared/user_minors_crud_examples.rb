# frozen_string_literal: true

shared_examples "creates minor accounts" do
  context "when the limit is not reached" do
    it "create a new minor" do
      click_link("Add a minor")

      within "form.new_minor_account" do
        fill_in "Name", with: "John Tesla"
        fill_in "Email", with: "john@example.org"
        find("#minor_account_birthday").click
        fill_in "Birthday", with: 12.years.ago.strftime("%d/%m/%Y")
        send_keys(:enter)
        find("button[type=submit]").click

        expect(page).to have_content("must be accepted")

        page.find("#minor_tos_agreement").click
        find("*[type=submit]").click
      end

      within_flash_messages do
        expect(page).to have_content("successfully created")
      end

      expect(page).to have_content("You are verifying the minor John Tesla")

      visit decidim_admin.officializations_path
      expect(page).to have_content("Pending verification minor account")
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
      page.find("#minor_account_birthday").click
      fill_in "Birthday", with: 12.years.ago.strftime("%d/%m/%Y")
      page.find("#minor_account_name").click # remove datepicker modal
      fill_in "Email", with: "test@example.org"
      find("*[type=submit]").click
    end

    within_flash_messages do
      expect(page).to have_content("successfully updated")
    end

    expect(page).to have_content("Nikola Tesla")
  end
end

shared_examples "deletes minor accounts" do
  it "can delete a minor" do
    page.find("a.action-icon--remove").click

    expect(page).to have_content("Are you sure you want to delete minor's account?")

    click_link("OK")

    within_flash_messages do
      expect(page).to have_content("successfully deleted")
    end

    expect(page).not_to have_content("Tesla")
  end
end

shared_examples "authorizes minor accounts" do
  it "can edit a minor" do
    expect(minor.name).to eq("Pending verification minor account")
    click_link "Verify"

    within "form.new_authorization_handler" do
      fill_in "Document number", with: "12345X"
      fill_in "Birthday", with: 12.years.ago.strftime("%d/%m/%Y")
      find("*[type=submit]").click
    end

    within_flash_messages do
      expect(page).to have_content("The minor account has been successfully authorized")
    end

    minor.reload

    expect(minor.name).not_to eq("Pending verification minor account")
    expect(page).to have_content(minor.name)

    visit decidim_admin.officializations_path

    expect(page).not_to have_content("Pending verification minor account")
    expect(page).to have_content(minor.name)
  end
end
