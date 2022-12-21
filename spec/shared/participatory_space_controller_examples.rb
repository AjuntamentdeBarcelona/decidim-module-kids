# frozen_string_literal: true

shared_context "when participating in a minor's participatory space" do
  let(:organization) { create :organization }
  let(:enable_minors_participation) { true }
  let(:minimum_minor_age) { 10 }
  let(:maximum_minor_age) { 13 }
  let(:tutors_authorization_name) { "dummy_authorization_handler" }
  let(:minors_authorization_name) { "dummy_authorization_handler" }
  let!(:minors_organization_config) do
    create(:minors_organization_config,
           organization:,
           enable_minors_participation:,
           minimum_minor_age:,
           maximum_minor_age:,
           tutors_authorization: tutors_authorization_name,
           minors_authorization: minors_authorization_name)
  end
  let(:access_type) { "minors" }
  let(:max_age) { 16 }
  let(:authorization) { "dummy_authorization_handler" }

  let!(:component) { create :proposal_component, participatory_space: }
  let!(:space_config) { create :minors_space_config, access_type:, max_age:, authorization:, participatory_space: }

  let(:admin) { create(:user, :admin, :confirmed, organization:) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:minor) { create(:minor, :confirmed, organization:) }
  let(:valuator) { create(:user, :confirmed, organization:) }

  before do
    request.env["decidim.current_organization"] = user.organization
    sign_in user, scope: :user
  end
end

shared_examples "cannot access to action" do |action|
  it "redirects to the participatory space admin" do
    get action, params: params

    expect(flash[:alert]).to include("You cannot access this space because you do not meet the requirements")
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end
end

shared_examples "can access to action" do |action|
  it "renders view" do
    get action, params: params

    expect(flash[:alert]).to be_blank
    expect(subject).to render_template(:index)
  end
end

shared_examples "cannot access to a component" do
  describe ::Decidim::Proposals::ProposalsController, type: :controller do
    routes { Decidim::Proposals::Engine.routes }
    before do
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
    end

    it "redirects to the participatory space admin" do
      get :index

      expect(flash[:alert]).to include("You cannot access this space because you do not meet the requirements")
      expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
    end
  end
end

shared_examples "can access to a component" do
  describe ::Decidim::Proposals::ProposalsController, type: :controller do
    routes { Decidim::Proposals::Engine.routes }
    before do
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
    end

    it "renders view" do
      get :index

      expect(flash[:alert]).to be_blank
      expect(subject).to render_template(:index)
    end
  end
end

shared_examples "access participatory space and components" do
  it_behaves_like "cannot access to action", :index
  it_behaves_like "cannot access to a component"

  context "when minors is disabled" do
    let(:enable_minors_participation) { false }

    it_behaves_like "can access to action", :index
    it_behaves_like "can access to a component"
  end

  context "when the user is a minor" do
    let(:user) { minor }

    it_behaves_like "can access to action", :index
    it_behaves_like "can access to a component"
  end

  context "when the user is an admin" do
    let(:user) { admin }

    it_behaves_like "can access to action", :index
    it_behaves_like "can access to a component"
  end

  context "when the user has and admin role" do
    allowed_roles.each do |role, space_name|
      let(:user) { create role, :confirmed, space_name => participatory_space }

      it_behaves_like "can access to action", :index
      it_behaves_like "can access to a component"
    end
  end
end
