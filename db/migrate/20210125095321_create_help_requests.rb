class CreateHelpRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :help_requests do |t|
      t.string :title
      t.text :description
      t.integer :type
      t.integer :state
      t.datetime :pending_at
      t.string :address
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end
end
