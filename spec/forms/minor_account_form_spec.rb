# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe MinorAccountForm do
    subject { form }

    let(:user) { create(:user, :confirmed, organization:) }
    let(:organization) { user.organization }

    let(:name) { "Marco" }
    let(:email) { "marco@example.org" }
    let(:birthday) { "01/11/2010" }
    let(:password) { "password123456" }
    let(:password_confirmation) { password }
    let(:tos_agreement) { true }

    let(:params) do
      {
        name:,
        email:,
        birthday:,
        password:,
        password_confirmation:,
        tos_agreement:
      }
    end

    let(:form) do
      described_class.from_params(params)
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    describe "birthday" do
      context "when birthday is blank" do
        let(:birthday) { "" }

        it { is_expected.not_to be_valid }
      end

      context "when age more max minor's age" do
        let(:birthday) { "01/01/2000" }

        it { is_expected.not_to be_valid }
      end

      context "when age more less than minor's age" do
        let(:birthday) { "01/01/2022" }

        it { is_expected.not_to be_valid }
      end
    end

    context "when name is blank" do
      let(:name) { "" }

      it { is_expected.not_to be_valid }
    end

    describe "email" do
      context "when email is blank" do
        let(:email) { "" }

        it { is_expected.not_to be_valid }
      end
    end

    describe "password" do
      context "when password is blank" do
        let(:password) { "" }

        it { is_expected.to be_valid }
      end

      context "when the password is weak" do
        let(:password) { "aaasssdddfff" }

        it { is_expected.to be_invalid }
      end

      context "when the password confirmation is different" do
        let(:password_confirmation) { "another thing" }

        it { is_expected.to be_invalid }
      end
    end

    context "when tos_agreement is not accepted" do
      let(:tos_agreement) { false }

      it { is_expected.not_to be_valid }
    end
  end
end
