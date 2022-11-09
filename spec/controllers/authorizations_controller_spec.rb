# frozen_string_literal: true

require "spec_helper"
require "shared/controller_examples"

module Decidim::Kids
  describe AuthorizationsController, type: :controller do
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
    it_behaves_like "has minor handler"

    describe "POST create" do
      context "when the handler is valid" do
        let(:handler_name) { "dummy_authorization_handler" }
        let(:document_number) { "12345678X" }
        let(:birthday) { 11.years.ago }
        let(:handler_params) { { document_number:, birthday: } }
        let(:authorization) { Decidim::Authorization.find_by(name: handler_name, user: minor) }
        let(:age_attributes) { [:birthday] }

        it_behaves_like "authorizes the minor"

        context "and wrong minor age" do
          before do
            allow(Decidim::Kids).to receive(:minor_authorization_age_attributes).and_return(age_attributes)
          end

          let(:birthday) { 18.years.ago }

          it_behaves_like "does not authorize the minor"

          context "and age check is not enabled" do
            let(:age_attributes) { [] }

            it_behaves_like "authorizes the minor"
          end
        end

        context "with a duplicate authorization" do
          let!(:duplicate_authorization) { create(:authorization, :granted, user: other_user, unique_id: document_number, name: handler_name) }
          let!(:other_user) { create(:user, organization: user.organization) }

          it "fails to create an authorization and renders the new action" do
            expect do
              post :create, params: {
                user_minor_id: minor.id,
                authorization_handler: handler_params
              }
            end.not_to change(Decidim::Authorization, :count)

            expect(authorization).to be_blank
            expect(flash[:alert]).to eq("There was an error authorizing the minor account.")
            expect(response).to render_template(:new)
          end

          context "when the duplicate authorization user is deleted" do
            let!(:other_user) { create(:user, :deleted, organization: user.organization) }

            it "transfers the authorization and redirects the user" do
              expect do
                post :create, params: {
                  user_minor_id: minor.id,
                  authorization_handler: handler_params
                }
              end.not_to change(Decidim::Authorization, :count)

              expect(authorization).not_to be_blank
              expect(flash[:notice]).to eq("The minor account has been successfully authorized.")
              expect(response).to redirect_to(return_path)
            end
          end
        end
      end

      context "when the handler is not valid" do
        it_behaves_like "checks tutor authorization" do
          let(:view) { :create }
          let(:params) { { user_minor_id: minor.id } }
        end

        it_behaves_like "checks minor authorization" do
          let(:view) { :create }
          let(:params) { { user_minor_id: minor.id } }
        end
      end
    end

    describe "GET new" do
      it "redirects the user" do
        get :new, params: { user_minor_id: minor.id }
        expect(response).to render_template(:new)
      end

      it_behaves_like "checks tutor authorization" do
        let(:view) { :new }
        let(:params) { { user_minor_id: minor.id } }
      end

      it_behaves_like "checks minor authorization" do
        let(:view) { :new }
        let(:params) { { user_minor_id: minor.id } }
      end
    end

    describe "GET index" do
      it_behaves_like "checks tutor authorization" do
        let(:return_path) { "/decidim_kids#{user_minors_path}" }
        let(:view) { :index }
        let(:params) { { user_minor_id: minor.id } }
      end

      it_behaves_like "checks minor authorization" do
        let(:return_path) { "/decidim_kids#{user_minors_path}" }
        let(:view) { :index }
        let(:params) { { user_minor_id: minor.id } }
      end
    end
  end
end
