# frozen_string_literal: true

require "spec_helper"
require "shared/authorization_examples"

module Decidim::Kids
  describe AuthorizeUser do
    subject { described_class.new(handler, organization) }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed) }
    let(:document_number) { "12345678X" }
    let(:birthday) { 12.years.ago }
    let(:handler) do
      DummyAuthorizationHandler.new(
        document_number:,
        birthday:,
        user:
      )
    end

    let(:authorizations) { Decidim::Verifications::Authorizations.new(organization: user.organization, user:, granted: true) }

    context "when the form is not authorized" do
      before do
        allow(handler).to receive(:valid?).and_return(false)
      end

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    it_behaves_like "everything is ok"

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
