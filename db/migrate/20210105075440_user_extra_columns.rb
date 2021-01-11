class UserExtraColumns < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :first_name, :string, null:true
    add_column :users, :last_name, :string, null:true
    add_column :users, :phone, :string, null:true
    add_column :users, :gender, :string, null:true
    add_column :users, :address, :string, null:true
    add_column :users, :country, :string, null:true
    add_column :users, :completed, :boolean, null:false, default:false
  end
end
