class AddConversationsFk < ActiveRecord::Migration[6.0]
  def change
    add_reference :conversations, :help_request, foreign_key: true
    add_reference :conversations, :owner_user, foreign_key: { to_table: :users}
    add_reference :conversations, :respondent_user, foreign_key: { to_table: :users}
  end
end
