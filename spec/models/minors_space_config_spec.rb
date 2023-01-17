# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe MinorsSpaceConfig do
    subject { minors_space_config }
    let(:minors_space_config) { build(:minors_space_config) }

    it { is_expected.to be_valid }

    it "has an participatory_space association" do
      expect(subject.participatory_space).to be_a(Decidim::ParticipatoryProcess)
    end

    it "has a organization" do
      expect(subject.organization).to be_a(Decidim::Organization)
    end

    context "when a configuration already exists" do
      let!(:existing_config) { create(:minors_space_config) }

      it { is_expected.to be_valid }

      context "and is the same participatory space" do
        let!(:existing_config) { create(:minors_space_config, participatory_space: minors_space_config.participatory_space) }

        it { is_expected.to be_invalid }
      end
    end
  end
end
