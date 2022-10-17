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

  context "when minors is not enabled" do
    let(:enable_minors_participation) { false }
    let(:minimum_minor_age) { 11 }
    let(:minimum_adult_age) { 10 }

    it "returns a valid response on incorrect ages" do
      expect { command.call }.to broadcast(:ok)
    end
  end
end

shared_examples "saves minors configuration" do
  let(:minimum_minor_age) { 11 }
  let(:minimum_adult_age) { 15 }

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
    organization.instance_variable_set(:@minimum_minor_age, nil)
    expect(organization.minimum_minor_age).to eq(minimum_minor_age)
  end

  it "saves the adult age" do
    expect(organization.minimum_adult_age).not_to eq(minimum_adult_age)
    command.call
    organization.reload_minors_config
    organization.instance_variable_set(:@minimum_adult_age, nil)
    expect(organization.minimum_adult_age).to eq(minimum_adult_age)
  end
end

shared_examples "creates minors configuration" do
  let(:minimum_minor_age) { 11 }
  let(:minimum_adult_age) { 15 }
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
end
