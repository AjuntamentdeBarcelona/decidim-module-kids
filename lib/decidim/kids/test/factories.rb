# frozen_string_literal: true

require "decidim/core/test/factories"
require "decidim/system/test/factories"

FactoryBot.define do
  factory :minors_organization_config, class: "Decidim::Kids::OrganizationConfig" do
    organization
    enable_minors_participation { true }
    minimum_minor_age { 10 }
    maximum_minor_age { 13 }
    minors_authorization { "dummy_authorization_handler" }
    tutors_authorization { "dummy_authorization_handler" }
  end

  factory :minor, parent: :user do
    transient do
      tutor { create(:user, :confirmed, organization:) }
    end

    after(:create) do |user, evaluator|
      create(:minor_account, tutor: evaluator.tutor, minor: user)
      create(:minor_data, user:)
    end
  end

  factory :tutor, parent: :user do
    transient do
      minor { create(:user, :confirmed, organization:) }
    end

    confirmed_at { Time.current }

    after(:create) do |user, evaluator|
      create(:minor_account, minor: evaluator.minor, tutor: user)
    end
  end

  factory :minor_account, class: "Decidim::Kids::MinorAccount" do
    tutor { create(:user, :confirmed) }
    minor { create(:user, :confirmed, organization: tutor.organization) }
  end

  factory :minor_data, class: "Decidim::Kids::MinorData" do
    user { create(:minor) }
    name { Faker::Name.name }
    email { Faker::Internet.email }
    birthday { rand(10..14).years.ago }
  end
end
