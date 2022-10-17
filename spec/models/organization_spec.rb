# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Organization do
    subject { organization }
    let(:organization) { create :organization }

    let(:default_minors_participation) { false }
    let(:enable_minors_participation) { false }
    let(:minimum_minor_age) { 10 }
    let(:minimum_adult_age) { 14 }

    before do
      allow(Decidim::Kids).to receive(:enable_minors_participation).and_return(default_minors_participation)
    end

    shared_examples "minors disabled" do
      it "minors participation is disabled" do
        expect(subject).not_to be_minors_participation_enabled
      end
    end

    shared_examples "minors enabled" do
      it "minors participation is enabled" do
        expect(subject).to be_minors_participation_enabled
      end
    end

    context "when not organization configuration exists" do
      it { is_expected.to be_valid }

      it_behaves_like "minors disabled"

      context "when minors participation is enabled as default" do
        let(:default_minors_participation) { true }

        it_behaves_like "minors enabled"
      end
    end

    context "when organization configuration exists" do
      let!(:config) do
        create :minors_organization_config,
               organization:,
               enable_minors_participation:,
               minimum_minor_age:,
               minimum_adult_age:
      end

      it { is_expected.to be_valid }

      it_behaves_like "minors disabled"

      context "when minors participation is enabled as default" do
        let(:enable_minors_participation) { true }

        it_behaves_like "minors enabled"
      end
    end
  end
end
