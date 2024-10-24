# frozen_string_literal: true

require "spec_helper"
require "shared/user_minor_activity_examples"

describe "Test private activity of my minors" do
  let(:authorization_handler) { "dummy_age_authorization_handler" }
  let(:organization) { create(:organization, available_authorizations: [authorization_handler]) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:authorization) { create(:authorization, user:, name: authorization_handler) }
  let(:other_user) { create(:user, :admin, :confirmed, organization:) }
  let(:minor) { create(:minor, tutor: user, organization:) }
  let(:other_minor) { create(:minor, tutor: other_user, organization:) }
  let(:enable_minors_participation) { false }
  let!(:minors_organization_config) { create(:minors_organization_config, organization:, enable_minors_participation:) }
  let(:component) { create(:component, :published, organization:) }
  let(:commentable) { create(:dummy_resource, component:) }
  let(:comment) { create(:comment, commentable:, author: user) }
  let(:another_comment) { create(:comment, commentable:, author: minor) }
  let!(:action_log) { create(:action_log, created_at: 1.day.ago, action: "create", visibility: "public-only", resource: comment, organization:, user: comment.author) }
  let!(:another_action_log) { create(:action_log, created_at: 2.days.ago, action: "create", visibility: "public-only", resource: another_comment, organization:, user: another_comment.author) }

  before do
    minor.confirm
    other_minor.confirm
    switch_to_host(organization.host)
  end

  context "when minors participation enabled" do
    let(:enable_minors_participation) { true }

    context "when you are not logged in" do
      context "and visiting any user activity page" do
        include_context "when accessing activity page", let(:person) { user }
        it_behaves_like "doesn't display private link"
      end
    end

    context "when the user is an adult" do
      before do
        login_as user, scope: :user
      end

      context "when accessing my minor accounts" do
        before do
          visit decidim_kids.user_minors_path
        end

        it "shows activity icon" do
          expect(page).to have_css("svg [href*='#ri-bill-line']")
        end

        context "when accessing my first minor activity" do
          before do
            page.find(".action-icon--activity").click
          end

          it "renders minor activity page" do
            expect(page).to have_content("@#{user.minors[0].nickname}")
          end
        end
      end

      context "when accessing own activity page" do
        include_context "when accessing activity page", let(:person) { user }
        it_behaves_like "displays private link"
      end

      context "when accessing other adult activity page" do
        include_context "when accessing activity page", let(:person) { other_user }
        it_behaves_like "doesn't display private link"
      end

      context "when visiting one of my minor activity page" do
        include_context "when accessing activity page", let(:person) { minor }
        it_behaves_like "displays private link"
      end

      context "when visiting a minor who is not mine" do
        include_context "when accessing activity page", let(:person) { other_minor }
        it_behaves_like "doesn't display private link"
      end
    end

    context "when the user is an minor" do
      before do
        login_as minor, scope: :user
      end

      context "when accessing own activity page" do
        include_context "when accessing activity page", let(:person) { minor }
        it_behaves_like "displays private link"
      end

      context "when accessing an adult activity page" do
        include_context "when accessing activity page", let(:person) { other_user }
        it_behaves_like "doesn't display private link"
      end

      context "when visiting other minor activity page" do
        include_context "when accessing activity page", let(:person) { other_minor }
        it_behaves_like "doesn't display private link"
      end
    end
  end

  context "when minors participation disabled" do
    let(:enable_minors_participation) { false }

    context "when the user is an adult" do
      before do
        login_as user, scope: :user
      end

      context "when visiting one of my minor activity page" do
        include_context "when accessing activity page", let(:person) { minor }
        it_behaves_like "doesn't display private link"
      end
    end
  end
end
