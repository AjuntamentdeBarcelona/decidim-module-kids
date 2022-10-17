# frozen_string_literal: true

require "spec_helper"

module Decidim::System
  describe UpdateOrganizationForm do
    subject do
      described_class.new(
        name: "Gotham City",
        host: "decide.gotham.gov",
        secondary_hosts: "foo.gotham.gov\r\n\r\nbar.gotham.gov",
        reference_prefix: "JKR",
        organization_admin_name: "Fiorello Henry La Guardia",
        organization_admin_email: "f.laguardia@gotham.gov",
        available_locales: ["en"],
        default_locale: "en",
        users_registration_mode: "enabled",
        enable_minors_participation:,
        minimum_minor_age:,
        minimum_adult_age:
      )
    end

    let(:enable_minors_participation) { false }
    let(:minimum_minor_age) { 10 }
    let(:minimum_adult_age) { 14 }

    context "when minor participation is inactive" do
      it { is_expected.to be_valid }

      it "matches ages" do
        expect(subject.minimum_minor_age).to eq(minimum_minor_age)
        expect(subject.minimum_adult_age).to eq(minimum_adult_age)
      end

      context "and minor age is wrong" do
        let(:minimum_minor_age) { 0 }

        it { is_expected.to be_valid }
      end

      context "and adult age is wrong" do
        let(:minimum_adult_age) { 0 }

        it { is_expected.to be_valid }
      end

      context "and adult is lower than minor" do
        let(:minimum_adult_age) { 9 }

        it { is_expected.to be_valid }
      end
    end

    context "when minor participation is active" do
      let(:enable_minors_participation) { true }

      it { is_expected.to be_valid }

      it "matches ages" do
        expect(subject.minimum_minor_age).to eq(minimum_minor_age)
        expect(subject.minimum_adult_age).to eq(minimum_adult_age)
      end

      context "and minor age is wrong" do
        let(:minimum_minor_age) { 0 }

        it { is_expected.to be_invalid }
      end

      context "and adult age is wrong" do
        let(:minimum_adult_age) { 0 }

        it { is_expected.to be_invalid }
      end

      context "and adult is lower than minor" do
        let(:minimum_adult_age) { 9 }

        it { is_expected.to be_invalid }
      end
    end
  end
end
