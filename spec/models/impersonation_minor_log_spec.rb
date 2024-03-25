# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe ImpersonationMinorLog do
    subject { impersonation_minor_log }
    let(:impersonation_minor_log) { build(:impersonation_minor_log) }

    it "is valid" do
      expect(subject).to be_valid
    end

    it "has an association tutor" do
      expect(subject.tutor).to be_a(Decidim::User)
    end

    it "has an association minor" do
      expect(subject.minor).to be_a(Decidim::User)
    end

    describe "ended?" do
      subject { impersonation_minor_log.ended? }

      context "when the log time has ended" do
        let(:impersonation_minor_log) { build(:impersonation_minor_log, ended_at: 5.minutes.ago) }

        it { is_expected.to be_truthy }
      end

      context "when the log time has not ended" do
        let(:impersonation_minor_log) { build(:impersonation_minor_log, ended_at: nil) }

        it { is_expected.to be_falsey }
      end
    end

    describe "expired?" do
      subject { impersonation_minor_log.expired? }

      context "when the log time has expired_at" do
        let(:impersonation_minor_log) { build(:impersonation_minor_log, expired_at: 5.minutes.ago) }

        it { is_expected.to be_truthy }
      end

      context "when the log time has not expired_at" do
        let(:impersonation_minor_log) { build(:impersonation_minor_log, expired_at: nil) }

        it { is_expected.to be_falsey }
      end
    end

    describe "ensure_not_expired!" do
      subject { impersonation_minor_log.ensure_not_expired! }

      context "when expired" do
        let(:started_at) { 1.hour.ago }

        let(:impersonation_minor_log) do
          build(:impersonation_minor_log, started_at:)
        end

        it { is_expected.to be_truthy }
      end

      context "when not expired" do
        let(:started_at) { 2.minutes.ago }

        let(:impersonation_minor_log) do
          build(:impersonation_minor_log, started_at:)
        end

        it { is_expected.to be_nil }
      end
    end

    describe "expire!" do
      subject { impersonation_minor_log.expire! }

      context "when the log time has not expired_at" do
        let(:started_at) { 2.hours.ago }

        let(:impersonation_minor_log) do
          build(:impersonation_minor_log, started_at:)
        end

        it { is_expected.to be_truthy }
      end
    end
  end
end
