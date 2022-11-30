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

shared_context "when conversing to the user" do
  before do
    page.find("#start-conversation-dialog-button").click
    page.find("#add_conversation_users").set(person.name)
    page.find("#autoComplete_result_0").click
    click_button("Next")
  end
end
