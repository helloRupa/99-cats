class AddUserIdToCatRentalRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :cat_rental_requests, :user_id, :integer, null: false, default: '5'
    add_index :cat_rental_requests, :user_id
  end
end
