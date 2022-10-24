# frozen_string_literal: true

# create some seeds for the admin@example and the user@example
if !Rails.env.production? || ENV.fetch("SEED", nil)
  print "Creating seeds for decidim_kids...\n" unless Rails.env.test?

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
    end
  end
end
