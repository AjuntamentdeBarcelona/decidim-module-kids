# frozen_string_literal: true

shared_examples "user minors enabled" do
  it "has a link to minors accounts" do
    expect(page).to have_content("My account")
    expect(page).to have_content("My minor accounts")
  end

  it "minors path can be accessed" do
    visit decidim_kids.user_minors_path
    expect(page).to have_content("list my kids")
  end
end

shared_examples "user minors disabled" do
  it "doesn't have a link to minors accounts" do
    expect(page).to have_content("My account")
    expect(page).not_to have_content("My minor accounts")
  end

  it "minors path cannot be accessed" do
    visit decidim_kids.user_minors_path
    expect(page).not_to have_content("list my kids")
  end
end
