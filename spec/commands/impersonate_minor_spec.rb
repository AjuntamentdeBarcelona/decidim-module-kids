# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe ImpersonateMinor do
    describe "call" do
      let(:organization) { create :organization }
      let(:user) { create(:user, :confirmed, organization:) }
      let(:minor) { create(:minor, tutor: user, organization:) }
      let(:command) { described_class.new(minor, user) }

      context "when a minor is verified and has logged in" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "creates a impersonation minor log" do
          expect do
            command.call
          end.to change(Decidim::Kids::ImpersonationMinorLog, :count).by(1)
        end

        it "creates a action minor log" do
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
  end
end
