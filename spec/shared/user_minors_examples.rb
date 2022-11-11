# frozen_string_literal: true

shared_examples "requires authorization" do
  it "requires user to verify himself as a tutor" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("Participant settings - My minor accounts")
    expect(page).to have_content('In order to create a minor account, you must be verified using the "Example authorization (Direct)" method')
  end
end

shared_examples "user minors enabled" do
  it "has menu items" do
    within "#user-settings-tabs" do
      expect(page).to have_content("Account")
      expect(page).to have_content("My minor accounts")
    end
  end

  it_behaves_like "requires authorization"

  context "when tutor's verification is pending" do
    let!(:authorization) { create(:authorization, :pending, user:, name: organization.tutors_authorization) }

    it_behaves_like "requires authorization"
  end

  context "when tutor's verification is expired", with_authorization_workflows: ["dummy_authorization_handler"] do
    let(:tutors_authorization) { "dummy_authorization_handler" }
    let!(:authorization) { create(:authorization, granted_at: 2.months.ago, user:, name: "dummy_authorization_handler") }

    it_behaves_like "requires authorization"
  end

  context "when tutor's verification is granted" do
    let!(:authorization) { create(:authorization, user:, name: organization.tutors_authorization) }

    it "minors path can be accessed" do
      visit decidim_kids.user_minors_path
      expect(page).to have_content("Participant settings - My minor accounts")
      expect(page).to have_content("list my kids")
    end

    context "when there is minors" do
      let!(:minor) { create(:minor, tutor: user, organization:) }
      let!(:another_minor) { create(:minor, tutor: user, organization:) }

      it "minors names are listed" do
        visit decidim_kids.user_minors_path
        expect(page).to have_content(minor.name)
        expect(page).to have_content(another_minor.name)
      end
    end

    context "and is another verification method" do
      let!(:authorization) { create(:authorization, user:) }

      it_behaves_like "requires authorization"
    end

    context "when the maximum number of accounts of minors has been reached" do
      let!(:minor) { create_list(:minor, maximum_minor_accounts, tutor: user, organization:) }

      it "button 'Add a minor' is disabled" do
        click_link "My minor accounts"

        expect(page).to have_css("a.disabled", text: "Add a minor", count: 1)
      end
    end
  end
end

shared_examples "user minors disabled" do
  it "doesn't have a link to minor accounts" do
    within "#user-settings-tabs" do
      expect(page).to have_content("Account")
      expect(page).not_to have_content("My minor accounts")
    end
  end

  it "minors path cannot be accessed" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("You are not authorized to perform this action")
    expect(page).not_to have_content("list my kids")
  end
end

shared_examples "user minors misconfigured" do
  it "minors path cannot be accessed" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("Minors module is misconfigured, please contact the administrator")

    within "#user-settings-tabs" do
      expect(page).to have_content("Account")
      expect(page).to have_content("My minor accounts")
    end

    expect(page).not_to have_content("list my kids")
  end
end
