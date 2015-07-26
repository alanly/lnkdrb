class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :slug
      t.string :url, null: false
      t.integer :hits, limit: 8, default: 0
      t.string :client_ip, null: false
    end

    add_index :links, :slug, unique: true
  end
end
