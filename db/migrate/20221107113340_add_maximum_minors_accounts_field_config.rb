class AddMaximumMinorsAccountsField < ActiveRecord::Migration[6.1]
  def change
    change_table :decidim_kids_organization_configs do |t|
      t.integer :maximum_minors_accounts, null: false, default: 3
    end
  end
end
