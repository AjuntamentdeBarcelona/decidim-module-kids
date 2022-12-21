# frozen_string_literal: true

shared_context "when admin managing a participatory space" do
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
  let(:user) { create(:user, :admin, :confirmed, organization:) }

  before do
    request.env["decidim.current_organization"] = user.organization
    sign_in user, scope: :user
  end
end

shared_examples "controls the minor configuration" do
  it "renders the index template" do
    get :index, params: params

    expect(subject).to render_template(:index)
  end

  it "has the current_participatory_space set" do
    get :index, params: params

    expect(controller.current_participatory_space).to eq(participatory_space)
  end

  it "has the access_type helper" do
    get :index, params: params

    expect(controller.helpers.access_types.values).to eq(%w(all minors))
  end

  it "creates config and redirects" do
    expect do
      post :create, params: params.merge(minors_space_config: { access_type: "all" })
    end.to change(Decidim::Kids::MinorsSpaceConfig, :count).by(1)

    expect(flash[:notice]).to eq("Configuration saved successfully.")
    expect(response).to redirect_to(minors_space_index_path)
  end

  it "does not create config if error" do
    expect do
      post :create, params: params.merge(minors_space_config: { access_type: "minors" })
    end.not_to change(Decidim::Kids::MinorsSpaceConfig, :count)

    expect(flash[:alert]).to include("Error saving configuration!")
  end

  context "when config already exists" do
    let!(:minors_space_config) { create(:minors_space_config, participatory_space:) }

    it "updates config and redirects" do
      expect do
        post :create, params: params.merge(minors_space_config: { access_type: "all" })
      end.not_to change(Decidim::Kids::MinorsSpaceConfig, :count)

      expect(flash[:notice]).to eq("Configuration saved successfully.")
      expect(response).to redirect_to(minors_space_index_path)
    end
  end

  context "when minors disabled" do
    let(:enable_minors_participation) { false }

    it "redirects to the participatory space admin" do
      get :index, params: params

      expect(response).to redirect_to(Decidim::Admin::Engine.routes.url_helpers.root_path)
    end
  end
end
