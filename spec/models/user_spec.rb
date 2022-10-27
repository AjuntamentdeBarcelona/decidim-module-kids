# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    subject { user }
    let(:user) { create :user }
    let(:minor) { create :minor }
    let(:tutor) { create :tutor }

    it { is_expected.not_to be_minor }

    context "when user is a minor" do
      subject { minor }
      it { is_expected.to be_minor }

      it "has a tutor" do
        expect(subject.tutors.first).to be_tutor
      end

      it "has personal data" do
        expect(subject.minor_data).to be_a(Decidim::Kids::MinorData)
      end

      it "has a name" do
        expect(subject.minor_data_name).to eq(minor.minor_data.name)
      end

      it "has a birthday" do
        expect(subject.minor_data_birthday).to eq(minor.minor_data.birthday)
      end

      it "has a email" do
        expect(subject.minor_data_email).to eq(minor.minor_data.email)
      end
    end

    context "when user is a tutor" do
      subject { tutor }
      it { is_expected.to be_tutor }

      it "has a minor" do
        expect(subject.minors.first).to be_minor
      end
    end
  end
end
