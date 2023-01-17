# frozen_string_literal: true

shared_examples "handles the minors configuration" do |spaces|
  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.root_path
  end

  context "when minors enabled" do
    it "has the minors configuration link" do
      click_link spaces
      click_link participatory_space.title["en"]

      expect(page).to have_link("Minors configuration")
    end
  end

  context "when minors disabled" do
    let(:enable_minors_participation) { false }

    it "has not the minors configuration link" do
      click_link spaces
      click_link participatory_space.title["en"]

      expect(page).not_to have_link("Minors configuration")
    end
  end
end
