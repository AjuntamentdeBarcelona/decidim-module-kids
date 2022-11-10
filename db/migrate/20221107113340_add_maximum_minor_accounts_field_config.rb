# frozen_string_literal: true

class AddMaximumMinorAccountsFieldConfig < ActiveRecord::Migration[6.1]
  def change
    change_table :decidim_kids_organization_configs do |t|
      t.integer :maximum_minor_accounts, null: false, default: 3
    end
  end
end
