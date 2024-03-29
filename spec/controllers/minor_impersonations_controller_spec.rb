# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Kids
    describe MinorImpersonationsController do
      routes { Decidim::Kids::Engine.routes }

      let(:organization) { create(:organization) }

      let(:enable_minors_participation) { true }
      let!(:minors_organization_config) do
        create(:minors_organization_config,
               organization:,
               enable_minors_participation:)
      end

      let(:valid_password) { "password123456" }
      let(:invalid_password) { "password12345" }

      let(:user) { create(:user, :confirmed, password: valid_password, organization:) }
      let(:minor) { create(:minor, tutor: user, organization:, sign_in_count: 1) }

      let(:params) do
        {
          user_minor_id: minor.id,
          impersonate_minor: {
            password:
          }
        }
      end

      before do
        request.env["decidim.current_organization"] = user.organization
        sign_in user, scope: :user
      end

      describe "creating a new impersonation" do
        context "when valid password" do
          let(:password) { valid_password }

          it "successfully creates a new impersonation minor log entry and redirects to home" do
            post(:create, params:)

            expect(Decidim::Kids::ImpersonationMinorLog.active.where(
              tutor: user,
              minor:
            ).count).to eq(1)

            expect(flash[:notice]).to be_present
            expect(subject).to redirect_to("/")
          end
        end

        context "when invalid password" do
          let(:password) { invalid_password }

          it "does not create a new impersonation minor log entry and renders new" do
            post(:create, params:)

            expect(Decidim::Kids::ImpersonationMinorLog.active.where(
              tutor: user,
              minor:
            ).count).to eq(0)

            expect(flash[:alert]).to be_present
            expect(subject).to render_template(:new)
          end
        end
      end

      context "when user closes the session" do
        let!(:impersonation_minor_log) { create(:impersonation_minor_log, tutor: user, minor:) }

        it "successfully closes minor session" do
          post :close_session, params: {
            user_minor_id: minor.id
          }

          expect(Decidim::Kids::ImpersonationMinorLog.active.where(
            tutor: user,
            minor:
          ).count).to eq(0)

          expect(flash[:notice]).to be_present
          expect(subject).to redirect_to("/")
        end
      end
    end
  end
end
