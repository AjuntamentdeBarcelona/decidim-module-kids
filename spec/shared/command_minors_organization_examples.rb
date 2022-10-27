# frozen_string_literal: true

shared_examples "valid command" do
  it "returns a valid response" do
    expect { command.call }.to broadcast(:ok)
  end

  context "when invalid minor age" do
    let(:minimum_minor_age) { 0 }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when invalid adult age" do
    let(:minimum_adult_age) { 0 }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when incorrect age" do
    let(:minimum_minor_age) { 11 }
    let(:minimum_adult_age) { 10 }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when missing minor authorization" do
    let(:minors_authorization) { "" }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when missing tutor authorization" do
    let(:tutors_authorization) { "" }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when incorrect minor authorization" do
    let(:minors_authorization) { "funny_verificator" }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when incorrect tutor authorization" do
    let(:tutors_authorization) { "funny_verificator" }

    it "returns a invalid response" do
      expect { command.call }.to broadcast(:invalid)
    end
  end

  context "when minors is not enabled" do
    let(:enable_minors_participation) { false }
    let(:minimum_minor_age) { 11 }
    let(:minimum_adult_age) { 10 }
    let(:minors_authorization) { "" }
    let(:tutors_authorization) { "" }

    it "returns a valid response on incorrect ages" do
      expect { command.call }.to broadcast(:ok)
    end
  end
end

shared_examples "saves minors configuration" do
  let(:minimum_minor_age) { 11 }
  let(:minimum_adult_age) { 15 }
  let(:minors_authorization) { "dummy_authorization_workflow" }
  let(:tutors_authorization) { "postal_letter" }

  it "saves the enabled status" do
    expect(organization).not_to be_minors_participation_enabled
    command.call
    organization.reload_minors_config
    expect(organization).to be_minors_participation_enabled
  end

  it "saves the minor age" do
    expect(organization.minimum_minor_age).not_to eq(minimum_minor_age)
    command.call
    organization.reload_minors_config
    expect(organization.minimum_minor_age).to eq(minimum_minor_age)
  end

  it "saves the adult age" do
    expect(organization.minimum_adult_age).not_to eq(minimum_adult_age)
    command.call
    organization.reload_minors_config
    expect(organization.minimum_adult_age).to eq(minimum_adult_age)
  end

  it "saves the minor authorization" do
    expect(organization.minors_authorization).not_to eq(minors_authorization)
    command.call
    organization.reload_minors_config
    expect(organization.minors_authorization).to eq(minors_authorization)
  end

  it "saves the tutor authorization" do
    expect(organization.tutors_authorization).not_to eq(tutors_authorization)
    command.call
    organization.reload_minors_config
    expect(organization.tutors_authorization).to eq(tutors_authorization)
  end
end

shared_examples "creates minors configuration" do
  let(:minimum_minor_age) { 11 }
  let(:minimum_adult_age) { 15 }
  let(:minors_authorization) { "dummy_authorization_workflow" }
  let(:tutors_authorization) { "postal_letter" }
  let(:organization) { Decidim::Organization.last }

  it "saves the enabled status" do
    command.call
    organization.reload_minors_config
    expect(organization).to be_minors_participation_enabled
  end

  it "saves the minor age" do
    command.call
    expect(organization.minimum_minor_age).to eq(minimum_minor_age)
  end

  it "saves the adult age" do
    command.call
    expect(organization.minimum_adult_age).to eq(minimum_adult_age)
  end

  it "saves the minor authorization" do
    command.call
    expect(organization.minors_authorization).to eq(minors_authorization)
  end

  it "saves the tutor authorization" do
    command.call
    expect(organization.tutors_authorization).to eq(tutors_authorization)
  end
end
