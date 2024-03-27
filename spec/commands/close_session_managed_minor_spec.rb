# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe CloseSessionManagedMinor do
    describe "call" do
      let(:organization) { create(:organization) }
      let(:current_user) { create(:user, :confirmed, organization:) }
      let(:minor) { create(:minor, :managed, tutor: current_user, organization:) }
      let(:command) { described_class.new(minor, current_user) }

      let!(:impersonation_minor_log) { create(:impersonation_minor_log, tutor: current_user, minor:) }

      context "when everything is ok" do
        it "broadcasts ok" do
          expect { command.call }.to broadcast(:ok)
        end

        it "ends the impersonation log" do
          command.call
          expect(impersonation_minor_log.reload).to be_ended
        end
      end

      context "when there is no active session for tutor and minor" do
        before do
          impersonation_minor_log.update!(ended_at: Time.current)
        end

        it "broadcasts invalid" do
          expect { command.call }.to broadcast(:invalid)
        end
      end
    end
  end
end
