require "spec_helper"

describe "kids:promote_minor_accounts", type: :task do
  let(:organization) { create(:organization, available_authorizations: %w(dummy_authorization_handler)) }
  let(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:other_user) { create(:user, :admin, :confirmed, organization:) }
  let(:minor) { create(:minor, tutor: user, organization:) }
  let(:other_minor) { create(:minor, tutor: user, organization:) }
  let(:enable_minors_participation) { false }
  let!(:minors_organization_config) { create(:minors_organization_config, organization:, enable_minors_participation:) }

  before do
    minor.confirm
    other_minor.confirm
  end

  context "when minors turn the maximum minor age" do

    it "run gracefully" do
      expect(Decidim::Kids::MinorAccount.where(minor: minor)).to be_present
      expect(Decidim::Kids::MinorAccount.where(minor: other_minor)).to be_present
      expect { task.execute }.not_to raise_error
    end

    context "when removing minor account relation" do
      it "remove no longer minor accounts relations" do
        task.execute
        expect(Decidim::Kids::MinorAccount.where(minor: minor)).to be_empty
        expect(Decidim::Kids::MinorAccount.where(minor: other_minor)).to be_empty
      end

      it "sends mails to the new regular users" do
        expect { task.execute }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end
    end
  end
end
