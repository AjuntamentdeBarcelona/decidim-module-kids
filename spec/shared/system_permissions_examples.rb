# frozen_string_literal: true

shared_examples "converse with user" do
  it "can converse with the user" do
    expect(page).to have_content("Conversation with")
  end
end

shared_examples "not authorized" do
  it "is not authorized to perform this action" do
    expect(page).to have_content("You are not authorized to perform this action")
  end
end

shared_examples "displays authorization" do
  it "displays authorization" do
    expect(page).to have_content("Authorizations")
  end
end

shared_examples "doesn't display authorization" do
  it "doesn't display authorization link" do
    expect(page).to have_no_content("Authorizations")
  end
end

shared_context "when conversing to the user" do
  before do
    visit decidim.new_conversation_path(recipient_id: person.id)
  end
end

shared_context "and visiting conversations page" do
  before do
    visit decidim.conversations_path
  end
end

shared_context "and visiting account page" do
  before do
    visit decidim.account_path
  end
end

shared_context "and visiting authorizations page" do
  before do
    visit decidim_verifications.authorizations_path
  end
end
