# frozen_string_literal: true

shared_context "when participating in a minor's participatory space" do
  let(:organization) { create(:organization) }
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
  let(:max_age) { 0 }
  let(:authorization) { "dummy_age_authorization_handler" }

  let!(:component) { create(:proposal_component, participatory_space:) }
  let!(:space_config) { create(:minors_space_config, access_type:, max_age:, authorization:, participatory_space:) }

  let(:admin) { create(:user, :admin, :confirmed, organization:) }
  let(:user) { create(:user, :confirmed, organization:) }
  let(:minor) { create(:minor, :confirmed, organization:) }
  let(:tutor) { create(:tutor, :confirmed, organization:) }
  let(:valuator) { create(:user, :confirmed, organization:) }

  before do
    allow(Devise).to receive(:allow_unconfirmed_access_for).and_return(1.day)
    request.env["decidim.current_organization"] = organization
    sign_in user, scope: :user
  end
end

shared_examples "cannot GET" do |action, flash_text|
  it "redirects to the participatory space admin" do
    get(action, params:)
    expect(flash[:alert]).to include(flash_text)
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end
end

shared_examples "can GET" do |action|
  it "renders view" do
    get(action, params:)

    expect(flash[:alert]).to be_blank
    expect(subject).to render_template(:index)
  end
end

shared_examples "cannot POST" do |action, flash_text|
  it "redirects on post" do
    post(action, params:)

    expect(flash[:alert]).to include(flash_text)
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end

  it "redirects on put" do
    put(action, params:)

    expect(flash[:alert]).to include(flash_text)
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end

  it "redirects on patch" do
    patch(action, params:)

    expect(flash[:alert]).to include(flash_text)
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end

  it "redirects on delete" do
    delete(action, params:)

    expect(flash[:alert]).to include(flash_text)
    expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
  end
end

shared_examples "can POST" do |action|
  it "renders view" do
    post(action, params:)

    expect(flash[:alert]).to be_blank
    expect(subject).to render_template(:index)
  end
end

shared_examples "cannot GET to a component" do |flash_text|
  describe Decidim::Proposals::ProposalsController, type: :controller do
    routes { Decidim::Proposals::Engine.routes }
    before do
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
    end

    it "redirects to the participatory space admin" do
      get :index

      expect(flash[:alert]).to include(flash_text)
      expect(response).to redirect_to(Decidim::Core::Engine.routes.url_helpers.root_path)
    end
  end
end

shared_examples "can GET to a component" do
  describe Decidim::Proposals::ProposalsController, type: :controller do
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
  it_behaves_like "cannot GET", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
  it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
  it_behaves_like "cannot GET to a component", I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))

  context "when config is for all" do
    let(:access_type) { "all" }

    it_behaves_like "can GET", :index
    it_behaves_like "can POST", :index
    it_behaves_like "can GET to a component"
  end

  context "when minors is disabled" do
    let(:enable_minors_participation) { false }

    it_behaves_like "can GET", :index
    it_behaves_like "can POST", :index
    it_behaves_like "can GET to a component"
  end

  context "when the user is a minor" do
    let(:user) { minor }

    it_behaves_like "can GET", :index
    it_behaves_like "can POST", :index
    it_behaves_like "can GET to a component"
  end

  context "when the user is an admin" do
    let(:user) { admin }

    it_behaves_like "can GET", :index
    it_behaves_like "can POST", :index
    it_behaves_like "can GET to a component"
  end

  context "when the user has and admin role" do
    allowed_roles.each do |role, space_name|
      let(:user) { create(role, :confirmed, space_name => participatory_space) }

      it_behaves_like "can GET", :index
      it_behaves_like "can POST", :index
      it_behaves_like "can GET to a component"
    end
  end

  context "when the user is a tutor" do
    let(:user) { tutor }

    it_behaves_like "can GET", :index
    it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
    it_behaves_like "can GET to a component"

    context "and tutor is not confirmed" do
      before do
        tutor.update(confirmed_at: nil)
      end

      it_behaves_like "cannot GET", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
      it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
      it_behaves_like "cannot GET to a component", I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
    end

    context "and tutor does not have any minor confirmed" do
      let!(:minor_account) { create(:minor_account, tutor:, minor:) }
      let(:tutor) { create(:user, :confirmed, organization:) }
      let(:minor) { create(:user, organization:) }

      it_behaves_like "cannot GET", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
      it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
      it_behaves_like "cannot GET to a component", I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
    end
  end

  context "when the space has an authorization" do
    let(:birthday) { 18 }
    let!(:user_authorization) { create(:authorization, user:, name: "dummy_age_authorization_handler", metadata: { birthday: }) }

    it_behaves_like "can GET", :index
    it_behaves_like "can POST", :index
    it_behaves_like "can GET to a component"

    context "and age is required" do
      let(:max_age) { 16 }

      it_behaves_like "cannot GET", :index, I18n.t("decidim.kids.actions.unauthorized")
      it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.unauthorized")
      it_behaves_like "cannot GET to a component", I18n.t("decidim.kids.actions.unauthorized")

      context "and the user has the age" do
        let(:birthday) { 15.years.ago }

        it_behaves_like "can GET", :index
        it_behaves_like "can POST", :index
        it_behaves_like "can GET to a component"

        context "and another authorization is required" do
          let(:authorization) { "dummy_authorization_handler" }

          it_behaves_like "cannot GET", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
          it_behaves_like "cannot POST", :index, I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
          it_behaves_like "cannot GET to a component", I18n.t("decidim.kids.actions.missing", authorization: I18n.t("decidim.authorization_handlers.dummy_age_authorization_handler.name"))
        end
      end
    end
  end
end
