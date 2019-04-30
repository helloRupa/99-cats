class AddImageToCats < ActiveRecord::Migration[5.2]
  def change
    add_column :cats, :image_url, :string, default: 'http://placekitten.com/g/230/230', null: false
  end
end
