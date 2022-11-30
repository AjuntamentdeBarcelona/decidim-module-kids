# frozen_string_literal: true

require "spec_helper"
require "shared/system_permissions_examples"

describe "Enable minors participation permissions", type: :system do
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
    switch_to_host(organization.host)
  end

  context "when minors participation enabled" do
    let(:enable_minors_participation) { true }

    context "when the user is minor" do
      before do
        login_as minor, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it "doesn't displays authorization link" do
          expect(page).not_to have_content("Authorizations")
        end
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it_behaves_like "not authorized"
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing to other minor" do
          include_context "when conversing to the user" do
            let(:person) { other_minor }
          end
          it_behaves_like "converse with user"
        end

        context "when conversing to an adult" do
          include_context "when conversing to the user" do
            let(:person) { user }
          end

          it_behaves_like "not authorized"
        end
      end
    end

    context "when the user is adult" do
      before do
        login_as user, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing to a minor" do
          include_context "when conversing to the user" do
            let(:person) { minor }
          end

          it_behaves_like "not authorized"
        end

        context "when conversing with other adult" do
          include_context "when conversing to the user" do
            let(:person) { other_user }
          end

          it_behaves_like "converse with user"
        end
      end
    end
  end

  context "when minors participation disabled" do
    let(:enable_minors_participation) { false }

    context "when the user is a minor" do
      before do
        login_as minor, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing with other minor" do
          include_context "when conversing to the user" do
            let(:person) { other_minor }
          end

          it_behaves_like "converse with user"
        end

        context "when conversing with an adult" do
          include_context "when conversing to the user" do
            let(:person) { user }
          end

          it_behaves_like "converse with user"
        end
      end
    end

    context "when user is an adult" do
      before do
        login_as user, scope: :user
      end

      context "when accessing account page" do
        before do
          visit decidim.account_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing authorizations page" do
        before do
          visit decidim_verifications.authorizations_path
        end

        it_behaves_like "displays authorization"
      end

      context "when accessing conversations page" do
        before do
          visit decidim.conversations_path
        end

        context "when conversing with a minor" do
          include_context "when conversing to the user" do
            let(:person) { minor }
          end

          it_behaves_like "converse with user"
        end

        context "when conversing with other adult" do
          include_context "when conversing to the user" do
            let(:person) { other_user }
          end

          it_behaves_like "converse with user"
        end
      end
    end
  end
end
