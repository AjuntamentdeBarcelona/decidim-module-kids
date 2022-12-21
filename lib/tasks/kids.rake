# frozen_string_literal: true

namespace :kids do
  desc "Destroy the minor relational table if the user is no longer a minor"
  task promote_minor_accounts: :environment do
    Decidim::Kids::MinorAccount.find_each(&:promote_account)
  end
end
