# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Kids
    describe ExpireImpersonationJob do
      let(:organization) { create :organization }
      let(:user) { create(:user, :confirmed, organization:) }
      let(:minor) { create(:minor, :managed, tutor: user, organization:) }
      let!(:impersonation_log) { create(:impersonation_minor_log, tutor: user, minor:) }

      it "marks the impersonation as expired" do
        ExpireImpersonationJob.perform_now(minor, user)
        expect(impersonation_log.reload).to be_expired
      end

      context "when the impersonation is already ended" do
        before do
          impersonation_log.update!(ended_at: Time.current)
        end

        it "doesn't expires it" do
          ExpireImpersonationJob.perform_now(minor, user)
          expect(impersonation_log.reload).not_to be_expired
        end
      end
    end
  end
end
