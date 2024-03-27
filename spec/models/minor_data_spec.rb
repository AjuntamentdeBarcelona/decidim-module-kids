# frozen_string_literal: true

require "spec_helper"

module Decidim::Kids
  describe MinorData do
    subject { minor_data }

    let(:minor_data) { build(:minor_data, user:) }
    let(:user) { create(:minor) }
    let(:ae) { Decidim::AttributeEncryptor }

    it "is valid" do
      expect(subject).to be_valid
    end

    it "has an user association" do
      expect(subject.user).to be_a(Decidim::User)
    end

    context "when user is not a minor" do
      let(:user) { create(:user, :confirmed) }

      it "is invalid" do
        expect(subject).not_to be_valid
      end
    end

    describe "encrypted attributes" do
      let(:attributes) do
        {
          birthday: Date.new(2001, 1, 1),
          name: "Dany",
          email: "some@email.com"
        }
      end
      let(:minor_data) { create(:minor_data, **attributes) }

      it "encrypts attributes" do
        attributes.each do |attribute, value|
          encrypted = subject.attributes[attribute.to_s]

          expect(subject.send(attribute)).to eq(value)
          expect(ae.decrypt(encrypted)).to eq(value)
        end
      end
    end
  end
end
