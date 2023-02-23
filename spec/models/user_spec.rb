# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    subject { user }
    let(:user) { create :user }
    let(:minor) { create :minor, minor_data: minor_data }
    let(:tutor) { create :tutor }
    let(:minor_data) { create :minor_data, birthday: birthday }
    let(:birthday) { 12.years.ago }

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

      it "has an age" do
        expect(subject.minor_age).to eq(12)
      end

      context "when age is tricky" do
        let(:birthday) { Time.zone.parse("2010-12-10") }
        let(:now) { Time.zone.parse("2020-12-09") }

        before do
          allow(Time.zone).to receive(:now).and_return(now)
        end

        it "has the correct age" do
          expect(subject.minor_age).to eq(9)
        end
      end
    end

    context "when user is a tutor" do
      subject { tutor }
      it { is_expected.to be_tutor }

      it "has a minor" do
        expect(subject.minors.first).to be_minor
      end

      it "does not return an age" do
        expect(subject.minor_age).to be_nil
      end
    end
  end
end
