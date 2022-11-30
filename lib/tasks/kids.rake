# frozen_string_literal: true

namespace :kids do
  desc "Destroy the minor relational table if the user is no longer a minor"
  task promote_minor_accounts: :environment do
    Decidim::Kids::MinorAccount.find_each do |minor_account|
      minor_account.destroy if minor_account.minor.minor_age >= (minor_account.minor&.organization&.maximum_minor_age || Decidim::Kids.maximum_minor_age)
    end
  end
end
