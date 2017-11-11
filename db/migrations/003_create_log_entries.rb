Sequel.migration do
  up do
    create_table(:log_entries) do
      primary_key :id
      foreign_key :user_id, :users
      String :body, text: true, null: false
      DateTime :created_at, null: false
      DateTime :updated_at, null: false
    end
  end

  down do
    drop_table(:users)
  end
end
