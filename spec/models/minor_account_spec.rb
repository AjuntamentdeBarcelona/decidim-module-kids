# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe MinorAccount do
    subject { minor_account }

    let(:minor_account) { create(:minor_account) }

    it "is valid" do
      expect(subject).to be_valid
    end

    it "has an association user" do
      expect(subject.user).to be_a(Decidim::User)
    end

    it "has an association minor" do
      expect(subject.minor).to be_a(Decidim::User)
    end

    # TODO: check that the minor relation is a minor user only
    # describe "validations" do
    # end
  end
end
