# frozen_string_literal: true

class CreateOrganizationMinorsConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_kids_organization_configs do |t|
      t.integer :decidim_organization_id, null: false, index: { name: "index_decidim_kids_organization" }
      t.boolean :enable_minors_participation, null: false, default: false
      t.integer :minimum_minor_age, null: false, default: 10
      t.integer :minimum_adult_age, null: false, default: 14
      t.timestamps
    end
  end
end
