# frozen_string_literal: true

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
