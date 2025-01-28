# frozen_string_literal: true

# create some seeds for the admin@example and the user@example
if !Rails.env.production? || ENV.fetch("SEED", nil)
  print "Creating seeds for decidim_kids...\n" unless Rails.env.test?

  organization = Decidim::Organization.first
  organization.available_authorizations << "dummy_age_authorization_handler"
  organization.save!

  Decidim::Kids::OrganizationConfig.create!(
    organization:,
    enable_minors_participation: true,
    tutors_authorization: "dummy_age_authorization_handler",
    minors_authorization: "dummy_age_authorization_handler"
  )

  Decidim::User.where(email: ["admin@example.org", "user@example.org"]).each do |user|
    2.times do
      minor = Decidim::User.create!(
        name: "Minor - #{Faker::Name.name}",
        nickname: Faker::Twitter.unique.screen_name,
        organization: user.organization,
        email: Faker::Internet.email,
        confirmed_at: Time.current,
        locale: I18n.default_locale,
        tos_agreement: true,
        password: "decidim123456789",
        password_confirmation: "decidim123456789",
        accepted_tos_version: user.organization.tos_version + 1.hour
      )
      Decidim::Kids::MinorAccount.create!(minor:, tutor: user)
      Decidim::Kids::MinorData.create!(user: minor, name: minor.name, email: minor.email, birthday: Faker::Date.birthday(min_age: 11, max_age: 14))
    end
  end
end
