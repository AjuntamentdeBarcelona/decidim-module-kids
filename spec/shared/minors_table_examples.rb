# frozen_string_literal: true

shared_examples "minors table" do
  context "when minor is verified and his email is confirmed" do
    let(:sign_in_count) { 1 }

    include_context "when minors verified"

    it "has email status 'Yes', verify status 'Yes'" do
      expect(page).to have_content("Yes", count: 2)
    end
  end

  context "when minor is verified and his email is not confirmed" do
    let(:sign_in_count) { 0 }

    include_context "when minors verified"

    it "has email status 'Pending'" do
      expect(page).to have_content("Pending", count: 1)
      expect(page).to have_css("svg [href*='#ri-arrow-go-back-line']", count: 1)
    end
  end

  context "when minor is not verified" do
    let(:sign_in_count) { 0 }

    it "has email status 'No'" do
      expect(page).to have_css("td span", text: "No", count: 1)
    end

    it "shows button Verify" do
      expect(page).to have_link("Verify", count: 1)
    end
  end
end

shared_context "when minors verified" do
  let(:minor) { create(:minor, tutor: user, organization:, sign_in_count:, name: "John") }

  before do
    click_on "Verify"
    fill_in "Document number", with: "1224X"
    fill_in "Postal code", with: "1234X"
    fill_in_datepicker :authorization_handler_birthday_date, with: "01/11/#{Time.current.year - 12}"

    find(".form__wrapper-block *[type=submit]").click
  end
end

shared_examples "resend email" do
  let(:sign_in_count) { 0 }

  include_context "when minors verified"

  it "resends the invitation to the minor" do
    click_on "Resend email"

    expect(page).to have_content("email have been sent")
  end
end
