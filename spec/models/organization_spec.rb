# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe Organization do
    subject { organization }
    let(:organization) { create :organization }

    let(:default_minors_participation) { false }
    let(:enable_minors_participation) { false }
    let(:default_minimum_minor_age) { 10 }
    let(:default_maximum_minor_age) { 13 }
    let(:minimum_minor_age) { 11 }
    let(:maximum_minor_age) { 14 }

    before do
      allow(Decidim::Kids).to receive(:enable_minors_participation).and_return(default_minors_participation)
      allow(Decidim::Kids).to receive(:minimum_minor_age).and_return(default_minimum_minor_age)
      allow(Decidim::Kids).to receive(:maximum_minor_age).and_return(default_maximum_minor_age)
    end

    shared_examples "minors disabled" do |min, max|
      it "minors participation is disabled" do
        expect(subject).not_to be_minors_participation_enabled
      end

      it "minors age is the default" do
        expect(subject.minimum_minor_age).to eq(min)
      end

      it "adult age is the default" do
        expect(subject.maximum_minor_age).to eq(max)
      end
    end

    shared_examples "minors enabled" do |min, max|
      it "minors participation is enabled" do
        expect(subject).to be_minors_participation_enabled
      end

      it "minors age is the configured" do
        expect(subject.minimum_minor_age).to eq(min)
      end

      it "adult age is the configured" do
        expect(subject.maximum_minor_age).to eq(max)
      end
    end

    context "when not organization configuration exists" do
      it { is_expected.to be_valid }

      it_behaves_like "minors disabled", 10, 13

      context "when minors participation is enabled as default" do
        let(:default_minors_participation) { true }
        let(:default_minimum_minor_age) { 9 }
        let(:default_maximum_minor_age) { 14 }

        it_behaves_like "minors enabled", 9, 14
      end
    end

    context "when organization configuration exists" do
      let(:minimum_minor_age) { 12 }
      let(:maximum_minor_age) { 16 }
      let!(:config) do
        create :minors_organization_config,
               organization: organization,
               enable_minors_participation: enable_minors_participation,
               minimum_minor_age: minimum_minor_age,
               maximum_minor_age: maximum_minor_age
      end

      it { is_expected.to be_valid }

      it_behaves_like "minors disabled", 12, 16

      context "when minors participation is enabled as default" do
        let(:default_minors_participation) { true }

        it_behaves_like "minors disabled", 12, 16

        context "and enabled in config" do
          let(:enable_minors_participation) { true }

          it_behaves_like "minors enabled", 12, 16
        end
      end
    end
  end
end
