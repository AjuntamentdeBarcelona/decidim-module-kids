# frozen_string_literal: true

class AddDecidimKidsMinorAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :decidim_kids_minor_accounts do |t|
      t.references :decidim_user, null: false, index: true, foreign_key: { to_table: "decidim_users" }
      t.references :decidim_minor, null: false, index: true, foreign_key: { to_table: "decidim_users" }

      t.timestamps
    end

    add_index :decidim_kids_minor_accounts, [:decidim_user_id, :decidim_minor_id], unique: true, name: "decidim_kids_minor_accounts_unique_user_and_minor_ids"
  end
end
