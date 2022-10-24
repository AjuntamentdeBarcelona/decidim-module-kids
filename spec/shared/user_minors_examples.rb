# frozen_string_literal: true

shared_examples "user minors enabled" do
  it "has a link to minors accounts" do
    expect(page).to have_content("Minor accounts")
  end
end

shared_examples "user minors disabled" do
  it "doesn't have a link to minors accounts" do
    expect(page).not_to have_content("Minor accounts")
  end
end
