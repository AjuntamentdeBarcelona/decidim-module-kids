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
end