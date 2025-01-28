# frozen_string_literal: true

require "spec_helper"

module Decidim::System
  describe UpdateOrganizationForm do
    subject do
      described_class.new(
        name: { en: "Gotham City" },
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
        maximum_minor_age:,
        minors_authorization:,
        tutors_authorization:,
        maximum_minor_accounts:
      )
    end

    let(:enable_minors_participation) { false }
    let(:minimum_minor_age) { 10 }
    let(:maximum_minor_age) { 13 }
    let(:maximum_minor_accounts) { 4 }
    let(:minors_authorization) { "dummy_authorization_handler" }
    let(:tutors_authorization) { "dummy_authorization_handler" }

    context "when minor participation is inactive" do
      it { is_expected.to be_valid }

      it "matches ages" do
        expect(subject.minimum_minor_age).to eq(minimum_minor_age)
        expect(subject.maximum_minor_age).to eq(maximum_minor_age)
      end

      context "and minor age is wrong" do
        let(:minimum_minor_age) { 0 }

        it { is_expected.to be_valid }
      end

      context "and adult age is wrong" do
        let(:maximum_minor_age) { 0 }

        it { is_expected.to be_valid }
      end

      context "and maximum number of accounts is wrong" do
        let(:maximum_minor_accounts) { 0 }

        it { is_expected.to be_valid }
      end

      context "and adult is lower than minor" do
        let(:maximum_minor_age) { 9 }

        it { is_expected.to be_valid }
      end

      context "and no minor verification is specified" do
        let(:minors_authorization) { "" }

        it { is_expected.to be_valid }
      end

      context "and no tutor verification is specified" do
        let(:tutors_authorization) { "" }

        it { is_expected.to be_valid }
      end
    end

    context "when minor participation is active" do
      let(:enable_minors_participation) { true }

      it { is_expected.to be_valid }

      it "matches ages" do
        expect(subject.minimum_minor_age).to eq(minimum_minor_age)
        expect(subject.maximum_minor_age).to eq(maximum_minor_age)
      end

      it "authorization is registered" do
        expect(Decidim.authorization_workflows.pluck(:name)).to include(subject.minors_authorization)
        expect(Decidim.authorization_workflows.pluck(:name)).to include(subject.tutors_authorization)
      end

      context "and minor age is wrong" do
        let(:minimum_minor_age) { 0 }

        it { is_expected.not_to be_valid }
      end

      context "and adult age is wrong" do
        let(:maximum_minor_age) { 0 }

        it { is_expected.not_to be_valid }
      end

      context "and adult is lower than minor" do
        let(:maximum_minor_age) { 9 }

        it { is_expected.not_to be_valid }
      end

      context "and no minor verification is specified" do
        let(:minors_authorization) { "" }

        it { is_expected.not_to be_valid }
      end

      context "and minor verification is not registered" do
        let(:minors_authorization) { "funny_verificator" }

        it { is_expected.not_to be_valid }
      end

      context "and no tutor verification is specified" do
        let(:tutors_authorization) { "" }

        it { is_expected.not_to be_valid }
      end

      context "and tutor verification is not registered" do
        let(:tutors_authorization) { "funny_verificator" }

        it { is_expected.not_to be_valid }
      end

      context "and tutor's verification is not Direct" do
        let(:tutors_authorization) { "id_documents" }

        it { is_expected.to be_valid }
      end

      context "and minor's verification is not Direct" do
        let(:minors_authorization) { "id_documents" }

        it { is_expected.not_to be_valid }
      end
    end
  end
end
