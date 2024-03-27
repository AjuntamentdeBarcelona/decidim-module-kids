# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe ImpersonateMinor do
    include ActiveSupport::Testing::TimeHelpers

    describe "call" do
      let(:organization) { create(:organization) }
      let!(:current_user) { create(:user, :confirmed, password: valid_password, organization:) }
      let!(:minor) { create(:minor, tutor: current_user, organization:) }
      let!(:form) do
        ImpersonateMinorForm.from_params(params).with_context(
          current_organization: organization,
          current_user:
        )
      end

      let(:valid_password) { "password123456" }
      let(:invalid_password) { "password12345" }

      let(:params) do
        {
          user_minor_id: minor.id,
          impersonate_minor: {
            password:
          }
        }
      end

      let(:command) { described_class.new(minor, current_user, form) }

      describe "when everything is ok" do
        context "when a minor is verified and has logged in" do
          let(:password) { valid_password }

          it "broadcasts ok" do
            expect { command.call }.to broadcast(:ok)
          end

          it "creates an impersonation minor log" do
            expect do
              command.call
            end.to change(Decidim::Kids::ImpersonationMinorLog, :count).by(1)
          end

          it "creates an action minor log" do
            expect do
              command.call
            end.to change(Decidim::ActionLog, :count).by(1)
          end

          it "expires the impersonation minor session automatically" do
            perform_enqueued_jobs { command.call }
            travel Decidim::Kids::ImpersonationMinorLog::SESSION_TIME_IN_MINUTES.minutes
            expect(Decidim::Kids::ImpersonationMinorLog.last).to be_expired
          end
        end
      end

      describe "when password is invalid" do
        let(:password) { invalid_password }

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end

        it "does not create an impersonation minor log" do
          expect do
            command.call
          end.not_to change(Decidim::Kids::ImpersonationMinorLog, :count)
        end

        it "does not create an action minor log" do
          expect do
            command.call
          end.not_to change(Decidim::ActionLog, :count)
        end
      end
    end
  end
end
