# frozen_string_literal: true

shared_examples "user impersonate" do
  context "when a minor is verified and has never logged in" do
    let(:sign_in_count) { 0 }

    include_context "when minors verified"

    it "the 'Impersonate' button is missing" do
      expect(page).not_to have_css(".action-icon--impersonate")
    end
  end

  context "when a minor is not verified" do
    let(:sign_in_count) { 0 }

    it "the 'Impersonate' button is missing" do
      expect(page).not_to have_css(".action-icon--impersonate")
    end
  end

  context "when a minor is verified and has logged in" do
    let(:sign_in_count) { 1 }

    include_context "when minors verified"

    it "the 'Impersonate' button is present" do
      expect(page).to have_css(".action-icon--impersonate", count: 1)
    end

    it "user can impersonate a minor" do
      find(".action-icon--impersonate").click

      expect(page).to have_content(minor.minor_data.name)
      expect(page).to have_content("Close session")
    end

    it "closes the minor's session" do
      find(".action-icon--impersonate").click
      click_button("Close session")

      expect(page).to have_content(user.name)
    end
  end
end
