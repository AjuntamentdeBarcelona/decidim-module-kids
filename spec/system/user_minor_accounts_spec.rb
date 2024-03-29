# frozen_string_literal: true

require "spec_helper"
require "shared/user_minors_examples"
require "shared/user_minors_crud_examples"
require "shared/minors_table_examples"
require "shared/impersonation_examples"

describe "User manages minor accounts" do
  let(:organization) { user.organization }
  let(:user) { create(:user, :admin, :confirmed) }
  let(:enable_minors_participation) { false }
  let(:minimum_minor_age) { 10 }
  let(:maximum_minor_age) { 13 }
  let(:maximum_minor_accounts) { 3 }
  let(:tutors_authorization) { "dummy_authorization_handler" }
  let(:minors_authorization) { "dummy_authorization_handler" }
  let!(:minors_organization_config) do
    create(:minors_organization_config,
           organization:,
           enable_minors_participation:,
           minimum_minor_age:,
           maximum_minor_age:,
           maximum_minor_accounts:,
           tutors_authorization:,
           minors_authorization:)
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim.account_path
  end

  it_behaves_like "user minors disabled"

  context "when minors participation enabled" do
    let(:enable_minors_participation) { true }

    before do
      visit decidim.account_path
    end

    it_behaves_like "user minors enabled"

    describe "user minors CRUD" do
      let!(:authorization) { create(:authorization, user:, name: organization.tutors_authorization) }
      let!(:minor) { create(:minor, :blocked, name: "Pending verification minor account", tutor: user, organization:) }

      before do
        click_on "My minor account"
      end

      it_behaves_like "creates minor accounts"
      it_behaves_like "updates minor accounts"
      it_behaves_like "deletes minor accounts"
      it_behaves_like "authorizes minor accounts"
    end

    describe "List my kids" do
      let!(:authorization) { create(:authorization, user:, name: organization.tutors_authorization) }
      let!(:minor) { create(:minor, tutor: user, organization:, sign_in_count:) }

      before do
        click_on "My minor account"
      end

      it_behaves_like "minors table"
      it_behaves_like "resend email"
    end

    describe "User impersonates a minor" do
      let!(:authorization) { create(:authorization, user:, name: organization.tutors_authorization) }
      let!(:user) { create(:user, :confirmed, password: valid_password) }
      let(:valid_password) { "mallorca123123123" }
      let!(:minor) { create(:minor, tutor: user, organization:, sign_in_count:) }

      before do
        click_on "My minor account"
      end

      it_behaves_like "user impersonate"
    end

    context "when the user is a minor" do
      let(:user) { create(:minor, :confirmed) }

      it_behaves_like "user minors disabled"
    end

    context "when organization has no tutors authorization" do
      let(:tutors_authorization) { "" }

      it_behaves_like "user minors misconfigured"
    end
  end
end
