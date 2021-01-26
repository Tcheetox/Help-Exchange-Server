class ChangingColumnNames < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :status, :integer
    add_column :help_requests, :help_type, :integer
    remove_column :help_requests, :type
    remove_column :help_requests, :state

    add_column :user_help_requests, :user_type, :integer
    remove_column :user_help_requests, :type
  end
end
