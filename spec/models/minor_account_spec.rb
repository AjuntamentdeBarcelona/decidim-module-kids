# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe MinorAccount do
    subject { minor_account }
    let(:minor_account) { create(:minor_account) }

    it "is valid" do
      expect(subject).to be_valid
    end

    it "has an association tutor" do
      expect(subject.tutor).to be_a(Decidim::User)
    end

    it "has an association minor" do
      expect(subject.minor).to be_a(Decidim::User)
    end

    it "belongs to the same organization" do
      expect(subject.tutor.organization).to eq(subject.minor.organization)
    end

    context "when tutor and minor are not in the same organization" do
      let(:minor_account) { build(:minor_account, minor: create(:user), tutor: create(:user)) }

      it "is invalid" do
        expect(subject).not_to be_valid
      end
    end

    describe "validations" do
      subject { build(:minor_account, tutor:, minor:) }
      let(:organization) { create(:organization) }
      let(:minor) { create(:user, organization:) }
      let(:tutor) { create(:user, :confirmed, organization:) }

      context "when tutor is already a minor" do
        let(:another_minor) { create(:minor, organization:) }

        subject { build(:minor_account, tutor: another_minor, minor:) }

        it "both minors have the same organization" do
          expect(another_minor.organization).to eq minor.organization
        end

        it "cannot have minors on its own" do
          expect(subject).not_to be_valid
        end
      end

      context "when minor is already a tutor" do
        let(:another_tutor) { create(:tutor, organization:) }

        subject { build(:minor_account, tutor:, minor: another_tutor) }

        it "both tutors have the same organization" do
          expect(another_tutor.organization).to eq tutor.organization
        end

        it "cannot have tutors on its own" do
          expect(subject).not_to be_valid
        end
      end

      context "when user is an admin" do
        let(:minor) { create(:user, :admin, organization:) }

        it "cannot be a minor" do
          expect(subject).not_to be_valid
        end
      end

      context "when user is unconfirmed" do
        let(:tutor) { create(:user, organization:) }

        it "cannot be a tutor" do
          expect(subject).not_to be_valid
        end
      end
    end
  end
end
