# frozen_string_literal: true

require "spec_helper"
require "shared/controller_examples"

module Decidim::Kids
  describe UserMinorsController, type: :controller do
    routes { Decidim::Kids::Engine.routes }

    let(:organization) { create :organization }
    let(:enable_minors_participation) { true }
    let(:minimum_minor_age) { 10 }
    let(:minimum_adult_age) { 14 }
    let(:tutors_authorization_name) { "dummy_authorization_handler" }
    let(:minors_authorization_name) { "dummy_authorization_handler" }
    let!(:minors_organization_config) do
      create(:minors_organization_config,
             organization:,
             enable_minors_participation:,
             minimum_minor_age:,
             minimum_adult_age:,
             tutors_authorization: tutors_authorization_name,
             minors_authorization: minors_authorization_name)
    end
    let(:user) { create(:user, :confirmed, organization:) }
    let(:minor) { create(:minor, tutor: user, organization:) }
    let!(:tutor_authorization) { create(:authorization, user:, name: organization.tutors_authorization) }
    let(:return_path) { "/decidim_kids#{user_minor_authorizations_path}" }

    before do
      request.env["decidim.current_organization"] = user.organization
      sign_in user, scope: :user
    end

    it_behaves_like "has minor helper methods"

    describe "GET index" do
      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "/decidim_kids#{user_minors_path}" }
        let(:view) { :index }
        let(:params) { { user_minor_id: minor.id } }
      end
    end
  end
end
