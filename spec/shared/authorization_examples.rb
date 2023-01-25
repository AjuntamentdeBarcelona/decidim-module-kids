# frozen_string_literal: true

shared_examples "everything is ok" do
  it "creates an authorization for the minor" do
    expect { subject.call }.to change(authorizations, :count).by(1)
  end

  it "stores the metadata" do
    expect { subject.call }.to broadcast(:ok)

    expect(authorizations.first.metadata["document_number"]).to eq("12345678X")
  end

  it "sets the authorization as granted" do
    expect { subject.call }.to broadcast(:ok)

    expect(authorizations.first).to be_granted
  end

  it "sends a confirmation email and unlocks the minor" do
    expect(minor).to be_blocked
    expect(minor.name).to eq("Verification pending minor")
    expect do
      perform_enqueued_jobs { subject.call }
    end.to broadcast(:ok).and change(minor, :name).to eq(minor.minor_data.name)

    minor.reload
    expect(last_email.to).to include(minor.email)

    expect(minor).not_to be_blocked
    expect(minor.name).not_to eq("Verification pending minor")
  end

  context "when authorization goes wrong" do
    before do
      allow(handler).to receive(:valid?).and_return(false)
    end

    it "is not valid" do
      expect { subject.call }.to broadcast(:invalid)
    end

    it "does not create an authorization for the minor" do
      expect { subject.call }.not_to change(authorizations, :count)
      expect(minor.reload).to be_blocked
    end

    it "does not send any email" do
      expect do
        perform_enqueued_jobs { subject.call }
      end.to broadcast(:invalid)
      expect(last_email).to be_nil
    end
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
