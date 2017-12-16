Sequel.migration do
  up do
    drop_table(:paypal_subscriptions)
  end

  down do
    create_table(:paypal_subscriptions) do
      primary_key :id
      foreign_key :user_id, :users
      String :status, null: false, default: "pending"
      String :token, null: false
      String :plan, null: false
      String :execute_url, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end
end
