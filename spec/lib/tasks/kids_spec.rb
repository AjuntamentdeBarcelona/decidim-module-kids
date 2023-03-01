# frozen_string_literal: true

require "spec_helper"

describe "kids:promote_minor_accounts", type: :task do
  let(:organization) { create(:organization, available_authorizations: %w(dummy_authorization_handler)) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:other_user) { create(:user, :admin, :confirmed, organization: organization) }
  let(:minor_to_promote15) { create(:user, :confirmed, organization: organization) }
  let(:minor_to_promote14) { create(:user, :confirmed, organization: organization) }
  let(:minor_to_promote13) { create(:user, :confirmed, organization: organization) }
  let(:minor_to_promote12) { create(:user, :confirmed, organization: organization) }
  let!(:minor_to_promote_account15) { create :minor_account, tutor: user, minor: minor_to_promote15 }
  let!(:minor_to_promote_account14) { create :minor_account, tutor: user, minor: minor_to_promote14 }
  let!(:minor_to_promote_account13) { create :minor_account, tutor: user, minor: minor_to_promote13 }
  let!(:minor_to_promote_account12) { create :minor_account, tutor: user, minor: minor_to_promote12 }
  let!(:minor_data_to_promote15) { create :minor_data, user: minor_to_promote15, birthday: 15.years.ago - 1.day }
  let!(:minor_data_to_promote14) { create :minor_data, user: minor_to_promote14, birthday: 14.years.ago - 1.day }
  let!(:minor_data_to_promote13) { create :minor_data, user: minor_to_promote13, birthday: 13.years.ago - 1.day }
  let!(:minor_data_to_promote12) { create :minor_data, user: minor_to_promote12, birthday: 12.years.ago - 1.day }
  let(:enable_minors_participation) { false }
  let!(:minors_organization_config) { create(:minors_organization_config, organization: organization, enable_minors_participation: enable_minors_participation) }

  context "when minors turn the maximum minor age" do
    it "run gracefully" do
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote15)).to be_present
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote14)).to be_present
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote13)).to be_present
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote12)).to be_present
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote15)).to be_present
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote14)).to be_present
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote13)).to be_present
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote12)).to be_present
      expect { task.execute }.not_to raise_error
    end

    context "when removing minor account relation" do
      context "and the minor reached the maximum minor age" do
        it "removes no longer minor accounts relations" do
          expect(organization.maximum_minor_age).to eq(13)
          expect(minor_to_promote15.reload.minor_age).to eq(15)
          expect(minor_to_promote14.reload.minor_age).to eq(14)
          task.execute
          expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote15)).to be_empty
          expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote14)).to be_empty
          expect(Decidim::Kids::MinorData.where(user: minor_to_promote15)).to be_empty
          expect(Decidim::Kids::MinorData.where(user: minor_to_promote14)).to be_empty
        end

        it "sends mails to the new regular users" do
          expect { task.execute }.to change { ActionMailer::Base.deliveries.count }.by(2)
        end

        it "decreases the count of minor accounts" do
          expect { task.execute }.to change(Decidim::Kids::MinorAccount, :count).by(-2).and change(Decidim::Kids::MinorData, :count).by(-2)
        end
      end
    end
  end

  context "when the minor is exactly the maximum minor age" do
    it "doesn't remove minor accounts relations" do
      expect(organization.maximum_minor_age).to eq(13)
      expect(minor_to_promote13.reload.minor_age).to eq(13)
      task.execute
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote13)).not_to be_empty
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote13)).not_to be_empty
    end
  end

  context "when the minor is under the maximum minor age" do
    it "doesn't remove minor accounts relations" do
      expect(organization.maximum_minor_age).to eq(13)
      expect(minor_to_promote12.reload.minor_age).to eq(12)
      task.execute
      expect(Decidim::Kids::MinorAccount.where(minor: minor_to_promote12)).not_to be_empty
      expect(Decidim::Kids::MinorData.where(user: minor_to_promote12)).not_to be_empty
    end
  end
end
