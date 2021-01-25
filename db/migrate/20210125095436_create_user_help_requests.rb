class CreateUserHelpRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :user_help_requests do |t|
      t.integer :type
      t.belongs_to :user
      t.belongs_to :help_request

      t.timestamps
    end
  end
end
