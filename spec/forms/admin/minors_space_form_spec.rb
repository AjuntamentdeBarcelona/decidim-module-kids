# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids::Admin
  describe MinorsSpaceForm do
    subject { form }

    let(:access_type) { "all" }
    let(:max_age) { 16 }
    let(:authorization) { "dummy_authorization_handler" }

    let(:params) do
      {
        access_type:,
        max_age:,
        authorization:
      }
    end

    let(:form) do
      described_class.from_params(params)
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when max_age is blank" do
      let(:max_age) { "" }

      it { is_expected.to be_valid }

      context "when access_type is minors" do
        let(:access_type) { "minors" }

        it { is_expected.not_to be_valid }

        context "and max age is ok" do
          let(:max_age) { 18 }

          it { is_expected.to be_valid }
        end

        context "and max age is zero" do
          let(:max_age) { 0 }

          it { is_expected.to be_valid }
        end
      end
    end

    context "when authorization is blank" do
      let(:authorization) { "" }

      it { is_expected.to be_valid }

      context "when access_type is minors" do
        let(:access_type) { "minors" }

        it { is_expected.to be_valid }

        context "and authorization is not registered" do
          let(:authorization) { "not_registered" }

          it { is_expected.not_to be_valid }
        end

        context "and authorization is ok" do
          let(:authorization) { "dummy_authorization_handler" }

          it { is_expected.to be_valid }
        end
      end
    end

    context "when access_type is blank" do
      let(:access_type) { "" }

      it { is_expected.not_to be_valid }
    end

    context "when access_type is nonsense" do
      let(:access_type) { "nonsense" }

      it { is_expected.not_to be_valid }
    end
  end
end
