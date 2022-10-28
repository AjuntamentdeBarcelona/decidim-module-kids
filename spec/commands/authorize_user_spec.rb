# frozen_string_literal: true

require "spec_helper"

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

    shared_examples "everything is ok" do
      it "creates an authorization for the user" do
        expect { subject.call }.to change(authorizations, :count).by(1)
      end

      it "stores the metadata" do
        subject.call

        expect(authorizations.first.metadata["document_number"]).to eq("12345678X")
      end

      it "sets the authorization as granted" do
        subject.call

        expect(authorizations.first).to be_granted
      end
    end

    it_behaves_like "everything is ok"

    shared_examples "additional age checks" do
      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid_age)
      end

      context "when age checking is disabled" do
        before do
          allow(Decidim::Kids).to receive(:minor_authorization_age_attributes).and_return(nil)
        end

        it_behaves_like "everything is ok"
      end

      context "when age checking does not have the parameter" do
        before do
          allow(Decidim::Kids).to receive(:minor_authorization_age_attributes).and_return([:birth_day, :birth_date])
        end

        it "is not valid" do
          expect { subject.call }.to broadcast(:invalid_age)
        end
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
  end
end
