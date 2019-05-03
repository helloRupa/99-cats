class RemoveDefaultsFromCatsAndRentals < ActiveRecord::Migration[5.2]
  def change
    change_column_default :cats, :user_id, nil
    change_column_default :cat_rental_requests, :user_id, nil
  end
end
