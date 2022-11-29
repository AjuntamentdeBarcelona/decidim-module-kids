# frozen_string_literal: true

require "spec_helper"

describe "Enable minors participation permissions", type: :system do
  let(:organization) { create(:organization, available_authorizations: %w(dummy_authorization_handler)) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:other_user) { create(:user, :admin, :confirmed, organization:) }
  let(:minor) { create(:minor, tutor: user, organization:) }
  let(:other_minor) { create(:minor, tutor: user, organization:) }
  let(:enable_minors_participation) { false }
  let!(:minors_organization_config) { create(:minors_organization_config, organization:, enable_minors_participation:) }

  before do
    minor.confirm
    other_minor.confirm
    switch_to_host(organization.host)
  end

  context "when minors participation enabled" do
    let(:enable_minors_participation) { true }

    context "when the user is minor" do
      before do
        login_as minor, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it "doesn't display authorization link" do
          expect(page).not_to have_content("Authorizations")
        end
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it "can't access the page" do
          expect(page).to have_content("You are not authorized to perform this action")
        end
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing to other minor" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(other_minor.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with a minor" do
            expect(page).to have_content("Conversation with")
          end
        end

        context "when conversing to an adult" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(user.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can't converse with an adult" do
            expect(page).to have_content("You are not authorized to perform this action")
          end
        end
      end
    end

    context "when the user is adult" do
      before do
        login_as user, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it "display authorization link" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end
        it "can access the page" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing to a minor" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(minor.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can't converse with a minor" do
            expect(page).to have_content("You are not authorized to perform this action")
          end
        end

        context "when conversing with other adult" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(other_user.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with other adult" do
            expect(page).to have_content("Conversation with")
          end
        end
      end
    end
  end

  context "when minors participation disabled" do
    let(:enable_minors_participation) { false }

    context "when the user is a minor" do
      before do
        login_as minor, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it "display authorization link" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it "can access the authorizations page" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing conversation page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing with other minor" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(other_minor.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with other minor" do
            expect(page).to have_content("Conversation with")
          end
        end

        context "when conversing with an adult" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(user.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with other adult" do
            expect(page).to have_content("Conversation with")
          end
        end
      end
    end

    context "when user is an adult" do
      before do
        login_as user, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it "display authorizations link" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it "can access the page" do
          expect(page).to have_content("Authorizations")
        end
      end

      context "when accessing conversation page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing with a minor" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(minor.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with a minor" do
            expect(page).to have_content("Conversation with")
          end
        end

        context "when conversing with other adult" do
          before do
            page.find("#start-conversation-dialog-button").click
            page.find("#add_conversation_users").set(other_user.name)
            page.find("#autoComplete_result_0").click
            click_button("Next")
          end

          it "can converse with other adult" do
            expect(page).to have_content("Conversation with")
          end
        end
      end
    end
  end
end
