# frozen_string_literal: true

shared_examples "requires authorization" do
  it "requires user to verify himself as a tutor" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("You need to verify your identity as a tutor to access this page")
  end
end

shared_examples "user minors enabled" do
  it "has a link to minors accounts" do
    expect(page).to have_content("My account")
    expect(page).to have_content("My minor accounts")
  end

  it_behaves_like "requires authorization"

  context "when tutor's verification is pending" do
    let!(:authorization) { create(:authorization, :pending, user:, name: organization.tutors_authorization) }

    it_behaves_like "requires authorization"
  end

  context "when tutor's verification is granted" do
    let!(:authorization) { create(:authorization, user:, name: organization.tutors_authorization) }

    it "minors path can be accessed" do
      visit decidim_kids.user_minors_path
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
  end
end

shared_examples "user minors disabled" do
  it "doesn't have a link to minors accounts" do
    expect(page).to have_content("My account")
    expect(page).not_to have_content("My minor accounts")
  end

  it "minors path cannot be accessed" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("You are not authorized to perform this action")
    expect(page).not_to have_content("list my kids")
  end
end
