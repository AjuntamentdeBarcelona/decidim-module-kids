# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Kids
    describe MinorImpersonationsController, type: :controller do
      routes { Decidim::Kids::Engine.routes }

      let(:organization) { create :organization }

      let(:enable_minors_participation) { true }
      let(:minimum_minor_age) { 10 }
      let(:maximum_minor_age) { 13 }
      let!(:minors_organization_config) do
        create(:minors_organization_config,
               organization:,
               enable_minors_participation:,
               minimum_minor_age:,
               maximum_minor_age:)
      end

      let(:user) { create(:user, :confirmed, organization:) }
      let(:minor) { create(:minor, tutor: user, organization:, sign_in_count: 1) }

      before do
        request.env["decidim.current_organization"] = user.organization
        sign_in user, scope: :user
      end

      context "when creating a new impersonation" do
        it "successfully creates a new impersonation minor log entry and redirects to home" do
          post :create, params: { user_minor_id: minor.id }

          expect(Decidim::Kids::ImpersonationMinorLog.active.where(
            tutor: user,
            minor:
          ).count).to eq(1)

          expect(flash[:notice]).to be_present
          expect(subject).to redirect_to("/")
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
