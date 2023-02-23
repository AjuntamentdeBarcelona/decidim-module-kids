# frozen_string_literal: true

require "spec_helper"
require "shared/authorization_examples"

module Decidim::Kids
  describe AuthorizeMinor do
    subject { described_class.new(handler) }

    let(:minor) { create(:minor, :blocked, name: "Verification pending minor", minor_data: minor_data) }
    let!(:minor_data) { create(:minor_data) }
    let(:document_number) { "12345678X" }
    let(:birthday) { 12.years.ago }
    let(:handler) do
      DummyAuthorizationHandler.new(
        document_number: document_number,
        birthday: birthday,
        user: minor
      )
    end

    let(:authorizations) { Decidim::Verifications::Authorizations.new(organization: minor.organization, user: minor, granted: true) }

    context "when the form is not authorized" do
      before do
        allow(handler).to receive(:valid?).and_return(false)
      end

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    it_behaves_like "everything is ok"

    context "when user is not a minor" do
      before do
        allow(minor).to receive(:minor?).and_return(false)
      end

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when age is to low" do
      let(:birthday) { 9.years.ago }

      it_behaves_like "additional age checks"
    end

    context "when age is to high" do
      let(:birthday) { 15.years.ago }

      it_behaves_like "additional age checks"
    end

    context "when age is tricky" do
      let(:birthday) { Time.zone.parse("2010-12-10") }
      let(:now) { Time.zone.parse("2020-12-09") }

      before do
        allow(Time.zone).to receive(:now).and_return(now)
      end

      it_behaves_like "additional age checks"

      context "and is in the range" do
        let(:now) { Time.zone.parse("2020-12-11") }

        it_behaves_like "everything is ok"
      end
    end
  end
end
