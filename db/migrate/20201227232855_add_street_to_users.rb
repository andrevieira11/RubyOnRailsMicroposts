class AddStreetToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :street, :string
  end
end
