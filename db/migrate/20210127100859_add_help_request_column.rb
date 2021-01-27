class AddHelpRequestColumn < ActiveRecord::Migration[6.0]
  def change
    add_column :help_requests, :help_count, :integer, default:0
  end
end
