# frozen_string_literal: true

shared_examples "has minor handler" do
  it "injects the minor_user" do
    controller.params[:user_minor_id] = minor.id
    expect(controller.send(:handler).user).to eq(minor)
  end
end

shared_examples "has minor helper methods" do
  it "injects the tutor adapter" do
    controller.params[:user_minor_id] = minor.id
    expect(controller.send(:tutor_adapter)).to be_present
  end
end

shared_examples "authorizes the minor" do
  it "creates an authorization and redirects the user" do
    expect do
      post :create, params: {
        user_minor_id: minor.id,
        authorization_handler: handler_params
      }
    end.to change(Decidim::Authorization, :count).by(1)

    expect(authorization).not_to be_blank
    expect(flash[:notice]).to eq("The minor account has been successfully authorized.")
    expect(response).to redirect_to(return_path)
  end
end

shared_examples "does not authorize the minor" do
  it "fails to create an authorization and renders the new action" do
    expect do
      post :create, params: {
        user_minor_id: minor.id,
        authorization_handler: handler_params
      }
    end.not_to change(Decidim::Authorization, :count)

    expect(authorization).to be_blank
    expect(flash[:alert]).to include("We could not verify the minor account")
    expect(response).to render_template(:new)
  end
end

shared_examples "checks tutor authorization" do
  context "when tutors's handler is not valid" do
    let(:tutor_authorization) { nil }

    it "redirects the user" do
      get view, params: params
      expect(response).to redirect_to(unverified_user_minors_path)
    end
  end
end

shared_examples "checks minor authorization" do
  context "when minor's handler is not valid" do
    let(:minors_authorization_name) { :foo }

    it "redirects the user" do
      get view, params: params
      expect(response).to redirect_to(return_path)
    end
  end
end
