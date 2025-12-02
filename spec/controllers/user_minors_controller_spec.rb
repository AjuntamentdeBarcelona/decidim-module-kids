# frozen_string_literal: true

require "spec_helper"
require "shared/controller_examples"

module Decidim::Kids
  describe UserMinorsController do
    routes { Decidim::Kids::Engine.routes }

    let(:organization) { create(:organization) }
    let(:enable_minors_participation) { true }
    let(:minimum_minor_age) { 10 }
    let(:maximum_minor_age) { 13 }
    let(:tutors_authorization_name) { "dummy_authorization_handler" }
    let(:minors_authorization_name) { "dummy_authorization_handler" }
    let!(:minors_organization_config) do
      create(:minors_organization_config,
             organization:,
             enable_minors_participation:,
             minimum_minor_age:,
             maximum_minor_age:,
             tutors_authorization: tutors_authorization_name,
             minors_authorization: minors_authorization_name)
    end
    let(:user) { create(:user, :confirmed, organization:) }
    let(:minor) { create(:minor, tutor: user, organization:) }
    let!(:tutor_authorization) { create(:authorization, user:, name: organization.tutors_authorization) }
    let(:return_path) { user_minor_authorizations_path }
    let(:after_create_path) { new_user_minor_authorization_path(user_minor_id: Decidim::User.last.id) }

    let(:name) { "Marco" }
    let(:email) { "marco@example.org" }
    let(:birthday) { "01/11/#{Time.current.year - 12}" }
    let(:password) { "password123456" }
    let(:password_confirmation) { password }
    let(:tos_agreement) { true }

    let(:params) do
      {
        name:,
        email:,
        birthday:,
        password:,
        password_confirmation:,
        tos_agreement:
      }
    end

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user, scope: :user
    end

    it_behaves_like "has minor helper methods"

    describe "GET index" do
      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "user_minors_path" }
        let(:view) { :index }
        let(:params) { { user_minor_id: minor.id } }
      end
    end

    def send_form_and_expect_rendering_the_new_template_again
      post(:create, params:)
      expect(controller).to render_template "new"
    end

    describe "GET new" do
      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "user_minors_path" }
        let(:view) { :new }
        let(:params) { { user_minor_id: minor.id } }
      end

      context "when creation" do
        it "renders the empty form" do
          get(:new, params:)

          expect(response).to have_http_status(:ok)
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "POST create" do
      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "user_minors_path" }
        let(:view) { :create }
      end

      context "when the form is valid" do
        it "creates a minor" do
          expect do
            post :create, params:
          end.to change(MinorAccount, :count).by(1)

          expect(flash[:notice]).to eq("Minor's account has been successfully created")
          expect(response).to redirect_to(after_create_path)
        end
      end

      context "when the form is invalid" do
        let(:email) { nil }

        it "renders the new template" do
          send_form_and_expect_rendering_the_new_template_again
        end
      end
    end

    describe "PATCH update" do
      let(:minor_params) do
        {
          name: "Katty",
          email:,
          birthday:,
          password:,
          password_confirmation:
        }
      end

      let(:params) do
        {
          id: minor.id,
          minor_user: minor_params
        }
      end

      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "user_minors_path" }
        let(:view) { :update }
      end

      context "when the form is valid" do
        it "updates the minor" do
          patch(:update, params:)

          expect(flash[:notice]).not_to eq("Minor's account has been successfully updated")
        end
      end

      context "when the form is invalid" do
        let(:email) { nil }

        it "renders the edit template" do
          patch(:update, params:)
          expect(controller).to render_template "edit"
        end
      end
    end

    describe "DELETE destroy" do
      it "deletes the minor" do
        delete :destroy, params: { id: minor.id }

        expect(flash[:notice]).to eq("Minor's account has been successfully deleted")
        expect(MinorAccount.count).to eq(0)
      end
    end

    describe "POST resend_invitation_to_minor" do
      it "resends the email to the minor" do
        post :resend_invitation_to_minor, params: { id: minor.id }

        expect(flash[:notice]).to have_content("An email have been sent to the minor's email address")
      end
    end
  end
end
