# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    subject { user }
    let(:user) { create :user }

    it { is_expected.not_to be_minor }
    # TODO: check if a user is a minor or not depending on the configuration
  end
end
