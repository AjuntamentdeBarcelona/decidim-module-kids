# frozen_string_literal: true

shared_context "when accessing activity page" do
  before do
    visit decidim.profile_activity_path(nickname: person.nickname)
  end
end

shared_examples "displays private link" do
  it "displays private link" do
    expect(page).to have_content("Order")
  end
end

shared_examples "doesn't display private link" do
  it "doesn't display private link" do
    expect(page).to have_no_content("Order")
  end
end
