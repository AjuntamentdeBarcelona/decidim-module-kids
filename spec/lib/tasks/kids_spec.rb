# frozen_string_literal: true

require "spec_helper"

describe "kids:promote_minor_accounts", type: :task do
  let(:organization) { create(:organization, available_authorizations: %w(dummy_authorization_handler)) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:other_user) { create(:user, :admin, :confirmed, organization:) }
  let(:minor) { create(:minor, tutor: user, organization:) }
  let(:minor_to_promote) { create(:minor_to_promote, tutor: user, organization:) }
  let(:enable_minors_participation) { false }
  let!(:minors_organization_config) { create(:minors_organization_config, organization:, enable_minors_participation:) }

  before do
    minor.confirm
    minor_to_promote.confirm
  end

  context "when minors turn the maximum minor age" do
    it "run gracefully" do
      expect(Decidim::Kids::MinorAccount.where(minor:)).to be_present
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote)).to be_present
      expect { task.execute }.not_to raise_error
    end

    context "when removing minor account relation" do
      it "removes no longer minor accounts relations" do
        expect(organization.maximum_minor_age).to eq(13)
        expect(minor_to_promote.minor_age).to eq(15)
        task.execute
        expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote)).to be_empty
        expect(Decidim::Kids::MinorAccount.where(minor:)).not_to be_empty
      end

      it "sends mails to the new regular users" do
        expect { task.execute }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end

      it "decreases the count of minor accounts" do
        expect { task.execute }.to change { Decidim::Kids::MinorAccount.count }.by(-1)
      end
    end
  end
end
