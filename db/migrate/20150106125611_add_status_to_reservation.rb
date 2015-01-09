class AddStatusToReservation < ActiveRecord::Migration

  def change
    remove_index :reservations, :start_date if index_exists?(:reservations, :start_date)
  end
  
  def change  
    add_column :reservations, :status, :string, default: ""
    add_index :reservations, :status, name: "index_reservations_on_status" 
    add_index :reservations, :email, name: "index_reservations_on_email" 
  end

end
