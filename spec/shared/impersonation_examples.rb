# frozen_string_literal: true

shared_examples "user impersonate" do
  context "when a minor is verified and has never logged in" do
    let(:sign_in_count) { 0 }

    include_context "when minors verified"

    it "the 'Impersonate' button is missing" do
      expect(page).to have_no_css(".action-icon--impersonate")
    end
  end

  context "when a minor is not verified" do
    let(:sign_in_count) { 0 }

    it "the 'Impersonate' button is missing" do
      expect(page).to have_no_css(".action-icon--impersonate")
    end
  end

  context "when a minor is verified and has logged in" do
    let(:sign_in_count) { 1 }

    include_context "when minors verified"

    it "the 'Impersonate' button is present" do
      expect(page).to have_css(".action-icon--impersonate", count: 1)
    end

    context "when valid password" do
      it "user can impersonate a minor" do
        find(".action-icon--impersonate").click

        fill_in "Password", match: :first, with: "mallorca123123123"

        click_on "Impersonate"

        expect(page).to have_content("You are managing the participant")
        expect(page).to have_content("Close session")
      end

      it "closes the minor's session" do
        find(".action-icon--impersonate").click

        fill_in "Password", match: :first, with: "mallorca123123123"

        click_on "Impersonate"
        click_on "Close session"

        expect(page).to have_content("The current impersonation session has been successfully ended")
      end

      context "and session expires" do
        it "user is logged out" do
          find(".action-icon--impersonate").click

          fill_in "Password", match: :first, with: "mallorca123123123"

          click_on "Impersonate"

          Decidim::Kids::ImpersonationMinorLog.last.update!(started_at: 1.hour.ago)

          visit decidim.account_path
          expect(page).to have_field("Your name", with: user.name)
        end
      end
    end

    context "when invalid password" do
      it "user can not impersonate a minor" do
        find(".action-icon--impersonate").click

        fill_in "Password", match: :first, with: "mallorca123123"

        click_on "Impersonate"

        expect(page).to have_css(".alert")
      end
    end

    context "when empty password" do
      it "user can not impersonate a minor" do
        find(".action-icon--impersonate").click

        fill_in "Password", match: :first, with: ""

        click_on "Impersonate"

        expect(page).to have_content("error in this field")
      end
    end
  end
end
